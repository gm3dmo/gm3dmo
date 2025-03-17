# Security Incident Checklist
These are common things asked about when a company has a security incident related to GitHub.com

###
- [Enabling security features in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization)
- [Applying the GitHub-recommended security configuration to all repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-all-repositories-in-your-organization)
- [Applying the GitHub-recommended security configuration to specific repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-specific-repositories-in-your-organization)

### Audit log
- [Streaming the audit log for your enterprise](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise) This is probably the most useful thing you can do. GitHub announced [Enterprise Audit log streaming](https://github.blog/changelog/2022-01-20-audit-log-streaming-is-generally-available/) back in January 2022 so what are you waiting for.
- [Programmatic audit log configuration and multi-endpoint streaming](https://github.blog/changelog/2024-11-21-programmatic-audit-log-configuration-and-multi-endpoint-streaming/)

### Dependabot

- [Configuring Dependabot security updates](https://docs.github.com/en/enterprise-cloud@latest/code-security/dependabot/dependabot-security-updates/configuring-dependabot-security-updates)

### IP Allow List

- [Restricting network traffic to your enterprise with an IP allow list](https://docs.github.com/en/enterprise-cloud@latest/admin/configuring-settings/hardening-security-for-your-enterprise/restricting-network-traffic-to-your-enterprise-with-an-ip-allow-list)
- Organization IP Allow List
  - [graphql-list-ip-allow-list-entries.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-list-ip-allow-list-entries.sh)
  - [graphql-create-ip-allow-list-entry.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-create-ip-allow-list-entry.sh)
- Enterprise IP Allow List
  - [gh-graphql-list-enterprise-ip-allow-list.sh](https://github.com/gm3dmo/the-power/blob/main/gh-graphql-list-enterprise-ip-allow-list.sh)
  - [graphql-create-enterprise-ip-allow-list-entry.sh)](https://github.com/gm3dmo/the-power/blob/main/graphql-create-enterprise-ip-allow-list-entry.sh)

### Deploy Keys
- [Repository deploy keys are controlled by enterprise and organization policy](https://github.blog/changelog/2024-10-23-repository-deploy-keys-are-controlled-by-enterprise-and-organization-policy-ga/)
- [Restricting deploy keys in your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/restricting-deploy-keys-in-your-organization)
- [Detect deploy keys in organization](https://github.com/gm3dmo/gm3dmo/blob/master/snippets/detecting-deploy-keys.md)

### Actions

- [Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization)

### GitHub Apps

- [Finding all github apps in an organization](https://github.com/gm3dmo/gm3dmo/blob/master/github-apps/finding-all-github-apps-in-an-organization.md)

