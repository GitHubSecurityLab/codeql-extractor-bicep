# Contributing

Hi there! We're thrilled that you'd like to contribute to this project. Your help is essential for keeping it great.

Contributions to this project are [released](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) to the public under the [project's open source license][license].

Please note that this project is released with a [Contributor Code of Conduct][code-of-conduct]. By participating in this project you agree to abide by its terms.

## Reporting Bugs

The best way to report a bug is to open an issue on GitHub. Please include as much information as possible, including:

- A clear description of the problem
- Steps to reproduce the problem
- The expected behavior
- The actual behavior

This will help us understand the issue and fix it more quickly.

## Suggesting Enhancements

If you have an idea for a new feature or enhancement, [please open an issue on GitHub][issues].

## Submitting Changes

1. [Fork][fork] and clone the repository
2. Create a new branch for your changes
3. Make your changes
4. Write tests for your changes (if applicable)
5. Run the tests to make sure everything is working
6. Submit a [pull request][pr] with a clear description of your changes

### Requirements

- [Rust](https://www.rust-lang.org/tools/install)
- [Cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html)
- [CodeQL](https://codeql.github.com/docs/codeql-cli/getting-started/)
  - `gh-codeql` is a great tool to help you with CodeQL CLI.

### Cloning the Repository

To clone the repository, run the following command:

```bash
git clone https://github.com/GitHubSecurityLab/codeql-extractor-bicep
git submodule update --init --recursive
```

> ![NOTE]
> This repository uses submodules to manage the Tree-Sitter grammar from the language.

### Building Extractor Pack

There is a script to build the extractor pack. You can run it from the root of the repository:

```bash
./scripts/create-extractor-pack.sh
```

### Testing CodeQL Libraries and Queries

To test the CodeQL libraries and queries, you can run the following command:

```bash
./scripts/run-tests.sh
```

### Coverage Reporting

The project includes a coverage script to track CodeQL query coverage and generate reports. The script analyzes all available queries and provides detailed coverage statistics.

#### Running the Coverage Script

To update coverage data and generate a report:

```bash
python scripts/coverage.py
```

This will:
- Load the existing `.coverage.json` file
- Run `codeql resolve queries` to discover all available queries
- Update the coverage data with query metadata
- Generate a markdown coverage report
- Update the README.md file with the latest coverage statistics

#### Coverage Script Options

The coverage script supports several command-line options:

```bash
# Generate only markdown output (useful for CI/CD)
python scripts/coverage.py --markdown-only

# Update coverage data but skip README.md update
python scripts/coverage.py --no-readme-update

# Show help and available options
python scripts/coverage.py --help
```

#### Coverage Report Features

The generated coverage report includes:

- **Coverage Badge**: Dynamically colored based on coverage percentage
- **Summary Statistics**: Total queries, covered queries, coverage percentage
- **Category Breakdown**: Coverage by query category (Security, Diagnostics)
- **CWE Analysis**: Coverage by Common Weakness Enumeration categories
- **Timestamp**: When the report was last generated

#### Understanding Coverage Data

The coverage script tracks:
- **Total Queries**: All queries discovered in `ql/src/`
- **Covered Queries**: Queries that have associated tests (initially 0, updated as tests are added)
- **Categories**: Query categories like `security` and `diagnostics`
- **CWE Categories**: Security queries mapped to Common Weakness Enumeration identifiers

To mark a query as "covered", you'll need to create corresponding test files in the `ql/test/` directory structure.

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)

[issues]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/issues
[fork]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/fork
[pr]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/compare
[license]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/tree/main/LICENSE
[code-of-conduct]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/tree/main?tab=coc-ov-file
