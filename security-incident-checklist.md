# Security Incident Checklist
These are common things asked about when a company has a security incident related to GitHub.com.

###
- [Enabling security features in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization)
- [Applying the GitHub-recommended security configuration to all repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-all-repositories-in-your-organization)
- [Applying the GitHub-recommended security configuration to specific repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-specific-repositories-in-your-organization)

### Audit log
- [Streaming the audit log for your enterprise](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise) This is probably the most useful thing you can do. GitHub announced [Enterprise Audit log streaming](https://github.blog/changelog/2022-01-20-audit-log-streaming-is-generally-available/) back in January 2022 so what are you waiting for.
- For API's to set up and manage the audit log stream [Programmatic audit log configuration and multi-endpoint streaming](https://github.blog/changelog/2024-11-21-programmatic-audit-log-configuration-and-multi-endpoint-streaming/)
- [Audit log examples with DuckDB](https://github.com/gm3dmo/gm3dmo/blob/master/duckdb-github-audit-log/README.md)

### Personal Access Tokens
#### Fine grained personal access tokens
GitHub announced fine grained personal access tokens [October 18 2022](https://github.blog/security/application-security/introducing-fine-grained-personal-access-tokens-for-github/) and made generally available [March 18 2025](https://github.blog/changelog/2025-03-18-fine-grained-pats-are-now-generally-available/)


#### Personal access tokens (classic)


### Dependabot

- [Configuring Dependabot security updates](https://docs.github.com/en/enterprise-cloud@latest/code-security/dependabot/dependabot-security-updates/configuring-dependabot-security-updates)

### GitHub IP Addresses
- [About GitHub's IP Addresses](https://docs.github.com/en/enterprise-cloud@latest/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses)

#### IP Allow List and Managing the IP Allow list with GraphQL API

- [Restricting network traffic to your enterprise with an IP allow list](https://docs.github.com/en/enterprise-cloud@latest/admin/configuring-settings/hardening-security-for-your-enterprise/restricting-network-traffic-to-your-enterprise-with-an-ip-allow-list)
- Organization IP Allow List
  - [graphql-list-ip-allow-list-entries.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-list-ip-allow-list-entries.sh)
  - [graphql-create-ip-allow-list-entry.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-create-ip-allow-list-entry.sh)
- Enterprise IP Allow List
  - [gh-graphql-list-enterprise-ip-allow-list.sh](https://github.com/gm3dmo/the-power/blob/main/gh-graphql-list-enterprise-ip-allow-list.sh)
  - [graphql-create-enterprise-ip-allow-list-entry.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-create-enterprise-ip-allow-list-entry.sh)

### Deploy Keys
- [Repository deploy keys are controlled by enterprise and organization policy](https://github.blog/changelog/2024-10-23-repository-deploy-keys-are-controlled-by-enterprise-and-organization-policy-ga/)
- [Restricting deploy keys in your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/restricting-deploy-keys-in-your-organization)
- [Detect deploy keys in organization](https://github.com/gm3dmo/gm3dmo/blob/master/snippets/detecting-deploy-keys.md)

### Actions

- [Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization)
- [Using third-party actions](https://docs.github.com/en/enterprise-cloud@latest/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions)
- [Identifying Actions used on a repository](https://github.com/gm3dmo/gm3dmo/blob/master/actions/identifying-actions-used-on-a-repository.md)

### GitHub Apps

- [Finding all github apps in an organization](https://github.com/gm3dmo/gm3dmo/blob/master/github-apps/finding-all-github-apps-in-an-organization.md)

