<!-- markdownlint-disable -->
<div align="center">

<h1>CodeQL Bicep Extractor</h1>

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/GitHubSecurityLab/codeql-extractor-bicep)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/GitHubSecurityLab/codeql-extractor-bicep/build.yml?style=for-the-badge)](https://github.com/GitHubSecurityLab/codeql-extractor-bicep/actions/workflows/build.yml?query=branch%3Amain)
[![GitHub Issues](https://img.shields.io/github/issues/GitHubSecurityLab/codeql-extractor-bicep?style=for-the-badge)](https://github.com/GitHubSecurityLab/codeql-extractor-bicep/issues)
[![GitHub Stars](https://img.shields.io/github/stars/GitHubSecurityLab/codeql-extractor-bicep?style=for-the-badge)](https://github.com/GitHubSecurityLab/codeql-extractor-bicep)
[![License](https://img.shields.io/github/license/Ileriayo/markdown-badges?style=for-the-badge)](./LICENSE)

</div>
<!-- markdownlint-restore -->

[CodeQL][codeql] Extractor, Library, and Queries for Bicep configuations.

## Usage

```yaml
- name: Initialize and Analyze Bicep
  uses: GitHubSecurityLab/codeql-extractor-bicep@v0.2.1
```

## Features

### Coverage

<!-- COVERAGE-REPORT -->

![Coverage](https://img.shields.io/badge/Query_Coverage-0.0%25-red)

| Metric | Value |
|--------|-------|
| Total Queries | 43 |
| Covered Queries | 0 |
| Coverage Percentage | 0.0% |
| Categories | 3 |
| CWE Categories | 15 |

### Coverage by Category

| Category | Covered | Total | Percentage |
|----------|---------|-------|------------|
| Diagnostics | 0 | 2 | 0.0% |
| Security | 0 | 40 | 0.0% |
| Testing | 0 | 1 | 0.0% |

### Coverage by CWE

| CWE | Description | Covered | Total | Percentage |
|-----|-------------|---------|-------|------------|
| CWE-200 | Information Exposure | 0 | 2 | 0.0% |
| CWE-272 | Least Privilege Violation | 0 | 2 | 0.0% |
| CWE-284 | Improper Access Control | 0 | 4 | 0.0% |
| CWE-295 | Improper Certificate Validation | 0 | 1 | 0.0% |
| CWE-306 | Missing Authentication | 0 | 3 | 0.0% |
| CWE-311 | Missing Encryption | 0 | 2 | 0.0% |
| CWE-319 | Cleartext Transmission | 0 | 4 | 0.0% |
| CWE-327 | Broken/Risky Crypto Algorithm | 0 | 3 | 0.0% |
| CWE-352 | Cross-Site Request Forgery | 0 | 1 | 0.0% |
| CWE-400 | Resource Exhaustion | 0 | 2 | 0.0% |
| CWE-404 | Improper Resource Shutdown | 0 | 2 | 0.0% |
| CWE-668 | Security Vulnerability | 0 | 1 | 0.0% |
| CWE-693 | Protection Mechanism Failure | 0 | 1 | 0.0% |
| CWE-798 | Hard-coded Credentials | 0 | 2 | 0.0% |
| CWE-942 | Overly Permissive CORS | 0 | 4 | 0.0% |

*Last updated: 2025-06-25 14:04:04 UTC*

<!-- COVERAGE-REPORT:END -->

## License

This project is licensed under the terms of the MIT open source license.
Please refer to [MIT](./LICENSE.md) for the full terms.

To use this project for Infrastructure as Code, you will need to [use CodeQL][codeql] and follow all terms and conditions of the [CodeQL License][codeql-license].

For use in private repositories and code, you will need to [purchase a GitHub Advanced Security license][advanced-security].

## Contributors

Contributors are welcome! Please see the [Contributing Guide](CONTRIBUTING.md) for more information.

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="10%"><a href="https://geekmasher.dev"><img src="https://avatars.githubusercontent.com/u/2772944?v=3?s=100" width="100px;" alt="Mathew Payne"/><br /><sub><b>Mathew Payne</b></sub></a><br /><a href="https://github.com/GitHubSecurityLab/codeql-extractor-bicep/commits?author=geekmasher" title="Code">💻</a> <a href="#research-geekmasher" title="Research">🔬</a> <a href="#maintenance-geekmasher" title="Maintenance">🚧</a> <a href="#security-geekmasher" title="Security">🛡️</a> <a href="#ideas-geekmasher" title="Ideas, Planning, & Feedback">🤔</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## Support

Support is via [GitHub Issues][issues] or [GitHub Discussions][discussions].

<!-- Resources -->

[issues]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/issues
[discussions]: https://github.com/GitHubSecurityLab/codeql-extractor-bicep/discussions
[codeql]: https://codeql.github.com/
[codeql-license]: https://github.com/github/codeql-cli-binaries/blob/main/LICENSE.md
[advanced-security]: https://github.com/features/security
