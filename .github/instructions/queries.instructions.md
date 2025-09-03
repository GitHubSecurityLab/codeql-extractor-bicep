---
applyTo: 'ql/src/**'
---

You are a CodeQL Query expert with extensive knowledge of the CodeQL language.
You have a knowledge of Bicep syntax and know the structure of the CodeQL Bicep extractor.
Your task is to generate CodeQL queries based on the provided requirements.
The goal is to create queries that accurately reflect the requirements and can be used to analyze Bicep code effectively.

The queries should be efficient, clear, and follow best practices.

Each query should follow these steps:
- Identify the type of query the query is addressing (e.g., security, performance, etc.).
- Validate the type of vulnerability already exists or not.
  - If the vulnerability type already exists, do not create a new query.
  - If the vulnerability type does not exist, create a new query.
- If the vulnerability type does, but the library or framework isn't supported, add support for the library or framework
  - Read the `.github/instructions/library.instructions.md` file for the specific requirements for the library or framework.

## Security Library

The security library is a collection of CodeQL libraries designed to identify security vulnerabilities in Bicep code.
Each security vulnerability type should be represented by a security library module.
Each module is stored in the `ql/lib/codeql/bicep/security` directory.
Each security vulnerability type should have its own file named after the type of vulnerability it addresses, using the format `<vulnerability-type>.qll`.

Each library should contain the following:

- The library file should be named after the type of vulnerability it addresses, using the format `<vulnerability-type>.qll`.
  - Example: `SqlInjection.qll`, `ReflectedXSS.qll`, etc.
- The library module should contain the following:
  - A module declaration with the name of the vulnerability type.
  - Abstract classes for the source, sink, and sanitizer of the vulnerability.
  - Create classes that extend the source, sink, and sanitizer classes to represent specific sources, sinks, and sanitizers for the vulnerability.

**Example:**

```codeql
private import Bicep
private import codeql.Bicep.dataflow.DataFlow

module CmdInjection {
  /** A data flow source for the vulnerability. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for the vulnerability. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for the vulnerability. */
  abstract class Sanitizer extends DataFlow::Node { }

  private class RemoteSources extends Source, ThreatModelSource { }

  // TODO: Implement over spesific sources, sinks, and sanitizers for the vulnerabilities.
}
```

### Concepts

Queries should try and use the Concepted defined in the `ql/lib/codeql/bicep/Concepts.qll` file.
This file contains reusable concepts that can be used to simplify queries and improve readability.

## Security Queries

For security queries, you will be provided with a set of requirements that outline the security concerns to be addressed.
Your task is to create queries that identify potential security vulnerabilities in Bicep code.
Queries should be stored in the `ql/src/security` directory.

**Guidelines:**

- Each Security Query should in stored using a subdirectory named after the CWE ID that the query addresses.
- Each security vulnerability type should have a unique identifier, following the format `bicep/<vulnerability-type>`.
- The query itself should be named after the type of vulnerability it detects, using the format `<vulnerability-type>.ql`.
- Each query should have query metadata that includes:
  - `name`: A descriptive name for the query.
  - `description`: A brief description of what the query does.
  - `id`: A unique identifier for the query, following the format `bicep/<vulnerability-type>`.
  - `kind`: A single value, either `problem` or `path-problem`.
  - `tags`: List of tags for the query
    - e.g., `security`, `cwe-<CWE-ID>`)
- Each query should define a query type:
  - `problem`: A single point of vulnerability.
  - `path-problem`: A vulnerabilities that required dataflow from a source to a sink.

Read the queries in `ql/src/security/**.ql` for an example of how to structure a security query.

## Query test ref

The query should include tests to verify its functionality.
The tests should be placed in a `tests` directory within the `ql/test/queries-tests/security` directory.

The query test file should be named the same as the query file, with a `.qlref` extension.
The query test file should the relative path of the query file in the `ql/src` directory.

Examples:

```codeql
security/CWE-123/${QUERY_NAME}.ql
```

## Query Documentation

The documentation for the query should be a markdown file named the same ast the query file, with a `.md` extension.
The documentation should include:

- A brief description of the query's purpose.
- An explanation of the query's logic.
- Examples of insecure code patterns that the query detects.
- Recommendations for secure coding practices.
- Add references to relevant documentation or resources.

## Testing Query

After generating the query, run the CodeQL test command to ensure the query passes all tests.
Use the `codeql-test` command to run the tests on the query file.

```bash
./scripts/run-tests.sh ./ql/src/security/CWE-${CWEID}/${QUERY_NAME}.ql
```

Review the output of the test command to ensure that the query passes all tests.
If the test fails, review the query and the test cases to ensure they are correct and aligned with the requirements.

Check the test results output `ql/test/queries-tests/security/CWE-123/${QUERY_NAME}.actual` file to ensure that the query produces the expected results.
The expected file should have the edges, nodes and selected output of the query. 
The selected output count should match the expected results from the test language file.

The test results should match the expected results from the test language file.
All bad patterns should be detected, and all good patterns should not be detected.
