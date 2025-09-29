# Trivy IaC and Secret Scanning Project

## What This Project Does

This project demonstrates how to use the **Trivy security scanner** within a **GitHub Actions workflow** to automatically detect security issues in Infrastructure as Code (IaC) files.

The primary focus is on identifying:
1.  **IaC Misconfigurations**: Poorly configured settings in files like `Dockerfile`.
2.  **Hardcoded Secrets**: Sensitive information (like API keys) accidentally left in source code.

This project intentionally avoids scanning application dependencies to highlight Trivy's powerful IaC and secret scanning capabilities.

## Intentional Misconfigurations in the `Dockerfile`

The `Dockerfile` in this project contains several deliberate security flaws, which Trivy is expected to find:

1.  **`FROM nginx:latest`**: Using the `latest` tag is risky because it's not deterministic. The underlying image can change unexpectedly, introducing breaking changes or vulnerabilities. Trivy flags this as a potential risk.
2.  **`USER root`**: Running a container as the `root` user is a major security risk. If an attacker compromises the application, they gain root privileges on the container, making it easier to escalate an attack.
3.  **`EXPOSE 22`**: Exposing the SSH port (22) is unnecessary for a web server and increases the container's attack surface.
4.  **`ENV SUPER_SECRET_API_KEY="..."`**: A hardcoded API key is embedded directly in the Dockerfile. Trivy's secret scanner is designed to detect exactly this type of critical vulnerability.

## GitHub Actions Workflow Automation

The `.github/workflows/security-scan.yml` file automates the security scanning process. Here’s what it does:

*   **Trigger**: The workflow runs automatically on every `push` to the `main` branch.
*   **Job**: It contains a single job named `Run Trivy Scanners` that executes on an `ubuntu-latest` runner.
*   **Steps**:
    1.  **Checkout Code**: It first checks out the repository's code.
    2.  **Scan for IaC Misconfigurations**: It uses the `aquasecurity/trivy-action` to scan the repository for configuration issues. It is configured to look for `HIGH` and `CRITICAL` severity issues and will fail the build (`exit-code: '1'`) if any are found.
    3.  **Scan for Hardcoded Secrets**: It runs a second scan, this time configured to *only* look for secrets (`scanners: 'secret'`). If Trivy finds any hardcoded secrets, this step will also fail the build.

By automating these checks, the workflow ensures that IaC misconfigurations and hardcoded secrets are caught early in the development process, preventing them from ever reaching a production environment.
