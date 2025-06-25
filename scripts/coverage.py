#!/usr/bin/env python3
"""
Coverage script to load .coverage.json and integrate CodeQL query resolution data.

This script:
1. Loads the existing .coverage.json file from the project root
2. Runs 'codeql resolve queries --format=json ./ql/src' to get available queries
3. Integrates the query data into the coverage file
"""

import json
import subprocess
import sys
import argparse
from pathlib import Path
from typing import Dict, List, Any


def find_project_root() -> Path:
    """Find the project root directory by looking for .coverage.json file."""
    current_dir = Path(__file__).parent
    
    # Look for .coverage.json in parent directories
    while current_dir != current_dir.parent:
        coverage_file = current_dir / ".coverage.json"
        if coverage_file.exists():
            return current_dir
        current_dir = current_dir.parent
    
    # If not found, assume project root is one level up from scripts directory
    return Path(__file__).parent.parent


def load_coverage_file(project_root: Path) -> Dict[str, Any]:
    """Load the existing .coverage.json file."""
    coverage_file = project_root / ".coverage.json"
    
    if not coverage_file.exists():
        print(f"Error: .coverage.json not found at {coverage_file}")
        sys.exit(1)
    
    try:
        with open(coverage_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in .coverage.json: {e}")
        sys.exit(1)


def run_codeql_resolve_queries(project_root: Path) -> List[str]:
    """Run codeql resolve queries command and return the list of query paths."""
    ql_src_path = project_root / "ql" / "src"
    
    if not ql_src_path.exists():
        print(f"Error: ql/src directory not found at {ql_src_path}")
        sys.exit(1)
    
    try:
        cmd = ["codeql", "resolve", "queries", "--format=json", str(ql_src_path)]
        result = subprocess.run(
            cmd,
            cwd=project_root,
            capture_output=True,
            text=True,
            check=True
        )
        
        # Parse the JSON output
        queries = json.loads(result.stdout)
        return queries
        
    except subprocess.CalledProcessError as e:
        print(f"Error running codeql command: {e}")
        print(f"stderr: {e.stderr}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing codeql output as JSON: {e}")
        sys.exit(1)


def process_query_paths(queries: List[str], project_root: Path) -> List[Dict[str, Any]]:
    """Process query paths to extract metadata and create coverage entries."""
    processed_queries = []
    
    for query_path in queries:
        # Convert absolute path to relative path from project root
        try:
            relative_path = Path(query_path).relative_to(project_root)
        except ValueError:
            # If the path is not relative to project root, use the full path
            relative_path = Path(query_path)
        
        # Extract query metadata
        query_info = {
            "path": str(relative_path),
            "name": Path(query_path).stem,
            "category": extract_category_from_path(relative_path),
            "cwe": extract_cwe_from_path(relative_path),
            "covered": False,  # Default to not covered
            "test_files": []   # Will be populated with test file paths if any
        }
        
        processed_queries.append(query_info)
    
    return processed_queries


def extract_category_from_path(path: Path) -> str:
    """Extract category from query path (e.g., 'security', 'diagnostics')."""
    parts = path.parts
    if len(parts) >= 3 and parts[0] == "ql" and parts[1] == "src":
        return parts[2]
    return "unknown"


def extract_cwe_from_path(path: Path) -> str:
    """Extract CWE number from query path if present."""
    parts = path.parts
    for part in parts:
        if part.startswith("CWE-"):
            return part
    return ""


def update_coverage_file(coverage_data: Dict[str, Any], queries: List[Dict[str, Any]]) -> Dict[str, Any]:
    """Update the coverage data with query information."""
    # Add queries to the coverage data
    coverage_data["queries"] = queries
    
    # Update metadata
    coverage_data["metadata"] = {
        "total_queries": len(queries),
        "covered_queries": sum(1 for q in queries if q["covered"]),
        "categories": list(set(q["category"] for q in queries)),
        "cwes": list(set(q["cwe"] for q in queries if q["cwe"]))
    }
    
    # Calculate coverage percentage
    total = coverage_data["metadata"]["total_queries"]
    covered = coverage_data["metadata"]["covered_queries"]
    coverage_data["metadata"]["coverage_percentage"] = (covered / total * 100) if total > 0 else 0
    
    return coverage_data


def save_coverage_file(coverage_data: Dict[str, Any], project_root: Path) -> None:
    """Save the updated coverage data back to .coverage.json."""
    coverage_file = project_root / ".coverage.json"
    
    try:
        with open(coverage_file, 'w', encoding='utf-8') as f:
            json.dump(coverage_data, f, indent=2, ensure_ascii=False)
        print(f"Successfully updated {coverage_file}")
    except Exception as e:
        print(f"Error saving coverage file: {e}")
        sys.exit(1)


def generate_coverage_markdown(coverage_data: Dict[str, Any]) -> str:
    """Generate markdown coverage report from coverage data."""
    metadata = coverage_data["metadata"]
    queries = coverage_data["queries"]
    
    # Calculate coverage percentage
    coverage_pct = metadata["coverage_percentage"]
    
    # Create coverage badge color based on percentage
    if coverage_pct >= 80:
        badge_color = "brightgreen"
    elif coverage_pct >= 60:
        badge_color = "yellow"
    elif coverage_pct >= 40:
        badge_color = "orange"
    else:
        badge_color = "red"
    
    # Generate markdown content
    md_content = []
    
    # Coverage badge
    md_content.append(f"![Coverage](https://img.shields.io/badge/Query_Coverage-{coverage_pct:.1f}%25-{badge_color})")
    md_content.append("")
    
    # Summary statistics
    md_content.append("| Metric | Value |")
    md_content.append("|--------|-------|")
    md_content.append(f"| Total Queries | {metadata['total_queries']} |")
    md_content.append(f"| Covered Queries | {metadata['covered_queries']} |")
    md_content.append(f"| Coverage Percentage | {coverage_pct:.1f}% |")
    md_content.append(f"| Categories | {len(metadata['categories'])} |")
    md_content.append(f"| CWE Categories | {len(metadata['cwes'])} |")
    md_content.append("")
    
    # Coverage by category
    if queries:
        category_stats = {}
        for query in queries:
            category = query["category"]
            if category not in category_stats:
                category_stats[category] = {"total": 0, "covered": 0}
            category_stats[category]["total"] += 1
            if query["covered"]:
                category_stats[category]["covered"] += 1
        
        md_content.append("### Coverage by Category")
        md_content.append("")
        md_content.append("| Category | Covered | Total | Percentage |")
        md_content.append("|----------|---------|-------|------------|")
        
        for category in sorted(category_stats.keys()):
            stats = category_stats[category]
            pct = (stats["covered"] / stats["total"] * 100) if stats["total"] > 0 else 0
            md_content.append(f"| {category.title()} | {stats['covered']} | {stats['total']} | {pct:.1f}% |")
        
        md_content.append("")
    
    # CWE coverage breakdown
    if metadata["cwes"]:
        cwe_stats = {}
        for query in queries:
            if query["cwe"]:
                cwe = query["cwe"]
                if cwe not in cwe_stats:
                    cwe_stats[cwe] = {"total": 0, "covered": 0}
                cwe_stats[cwe]["total"] += 1
                if query["covered"]:
                    cwe_stats[cwe]["covered"] += 1
        
        if cwe_stats:
            md_content.append("### Coverage by CWE")
            md_content.append("")
            md_content.append("| CWE | Description | Covered | Total | Percentage |")
            md_content.append("|-----|-------------|---------|-------|------------|")
            
            # CWE descriptions for common ones
            cwe_descriptions = {
                "CWE-200": "Information Exposure",
                "CWE-284": "Improper Access Control",
                "CWE-306": "Missing Authentication",
                "CWE-319": "Cleartext Transmission",
                "CWE-327": "Broken/Risky Crypto Algorithm",
                "CWE-352": "Cross-Site Request Forgery",
                "CWE-272": "Least Privilege Violation",
                "CWE-311": "Missing Encryption",
                "CWE-400": "Resource Exhaustion",
                "CWE-942": "Overly Permissive CORS",
                "CWE-693": "Protection Mechanism Failure",
                "CWE-295": "Improper Certificate Validation",
                "CWE-798": "Hard-coded Credentials",
                "CWE-404": "Improper Resource Shutdown"
            }
            
            for cwe in sorted(cwe_stats.keys()):
                stats = cwe_stats[cwe]
                pct = (stats["covered"] / stats["total"] * 100) if stats["total"] > 0 else 0
                description = cwe_descriptions.get(cwe, "Security Vulnerability")
                md_content.append(f"| {cwe} | {description} | {stats['covered']} | {stats['total']} | {pct:.1f}% |")
            
            md_content.append("")
    
    # Last updated timestamp
    from datetime import datetime
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")
    md_content.append(f"*Last updated: {timestamp}*")
    
    return "\n".join(md_content)


def update_readme_coverage(project_root: Path, coverage_markdown: str) -> None:
    """Update the README.md file with the coverage report."""
    readme_file = project_root / "README.md"
    
    if not readme_file.exists():
        print(f"Warning: README.md not found at {readme_file}")
        return
    
    try:
        with open(readme_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the coverage report markers
        start_marker = "<!-- COVERAGE-REPORT -->"
        end_marker = "<!-- COVERAGE-REPORT:END -->"
        
        start_idx = content.find(start_marker)
        end_idx = content.find(end_marker)
        
        if start_idx == -1 or end_idx == -1:
            print(f"Warning: Coverage report markers not found in {readme_file}")
            print("Please add the following markers to your README.md where you want the coverage report:")
            print(f"  {start_marker}")
            print(f"  {end_marker}")
            return
        
        # Replace the content between markers
        new_content = (
            content[:start_idx + len(start_marker)] +
            "\n\n" + coverage_markdown + "\n\n" +
            content[end_idx:]
        )
        
        with open(readme_file, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"Successfully updated coverage report in {readme_file}")
        
    except Exception as e:
        print(f"Error updating README.md: {e}")


def main():
    """Main function to orchestrate the coverage update process."""
    parser = argparse.ArgumentParser(description="Generate CodeQL query coverage report")
    parser.add_argument(
        "--markdown-only",
        action="store_true",
        help="Generate only the markdown report and print to stdout (don't update files)"
    )
    parser.add_argument(
        "--no-readme-update",
        action="store_true",
        help="Don't update the README.md file with the coverage report"
    )
    
    args = parser.parse_args()
    
    if not args.markdown_only:
        print("Loading CodeQL query coverage data...")
    
    # Find project root
    project_root = find_project_root()
    if not args.markdown_only:
        print(f"Project root: {project_root}")
    
    # Load existing coverage file
    coverage_data = load_coverage_file(project_root)
    if not args.markdown_only:
        print("Loaded existing coverage data")
    
    # Run codeql resolve queries
    if not args.markdown_only:
        print("Running codeql resolve queries...")
    query_paths = run_codeql_resolve_queries(project_root)
    if not args.markdown_only:
        print(f"Found {len(query_paths)} queries")
    
    # Process query paths
    processed_queries = process_query_paths(query_paths, project_root)
    
    # Update coverage data
    updated_coverage = update_coverage_file(coverage_data, processed_queries)
    
    # Generate markdown coverage report
    coverage_markdown = generate_coverage_markdown(updated_coverage)
    
    if args.markdown_only:
        # Just print the markdown and exit
        print(coverage_markdown)
        return
    
    # Save updated coverage file
    save_coverage_file(updated_coverage, project_root)
    
    # Update README if not disabled
    if not args.no_readme_update:
        print("Generating coverage report...")
        update_readme_coverage(project_root, coverage_markdown)
    
    # Print summary
    metadata = updated_coverage["metadata"]
    print(f"\nCoverage Summary:")
    print(f"  Total queries: {metadata['total_queries']}")
    print(f"  Covered queries: {metadata['covered_queries']}")
    print(f"  Coverage percentage: {metadata['coverage_percentage']:.1f}%")
    print(f"  Categories: {', '.join(metadata['categories'])}")
    print(f"  CWEs covered: {len(metadata['cwes'])}")


if __name__ == "__main__":
    main()