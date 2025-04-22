# Security Incident Checklist
These are common things asked about when a company has a security incident related to GitHub.com.

### GitHub
- [Enabling security features in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization)
- [Applying the GitHub-recommended security configuration to all repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-all-repositories-in-your-organization)
- [Applying the GitHub-recommended security configuration to specific repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-specific-repositories-in-your-organization)
- [About support for your IdP's Conditional Access Policy](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-iam/configuring-authentication-for-enterprise-managed-users/about-support-for-your-idps-conditional-access-policy)

### Audit log
- [Streaming the audit log for your enterprise](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise) This is probably the most useful thing you can do. GitHub announced [Enterprise Audit log streaming](https://github.blog/changelog/2022-01-20-audit-log-streaming-is-generally-available/) back in January 2022 so what are you waiting for.
- For API's to set up and manage the audit log stream [Programmatic audit log configuration and multi-endpoint streaming](https://github.blog/changelog/2024-11-21-programmatic-audit-log-configuration-and-multi-endpoint-streaming/)
- [Audit log examples with DuckDB](https://github.com/gm3dmo/gm3dmo/blob/master/duckdb-github-audit-log/README.md)
- [Exporting the audit log](https://docs.github.com/en/enterprise-cloud@latest/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/reviewing-the-audit-log-for-your-organization#exporting-the-audit-log)
- [Use the audit log api to get the last enterprise SSO response for a user](https://github.com/gm3dmo/the-power/blob/main/get-last-enterprise-sso-response-for-a-user.sh) (script)

### Personal Access Tokens

- [Enforcing policies for personal access tokens in your enterprise](https://docs.github.com/en/enterprise-cloud@latest/admin/enforcing-policies/enforcing-policies-for-your-enterprise/enforcing-policies-for-personal-access-tokens-in-your-enterprise)
- [Reviewing and revoking personal access tokens in your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-programmatic-access-to-your-organization/reviewing-and-revoking-personal-access-tokens-in-your-organization)

#### Fine grained personal access tokens
- GitHub announced fine grained personal access tokens [October 18 2022](https://github.blog/security/application-security/introducing-fine-grained-personal-access-tokens-for-github/) and made generally available [March 18 2025](https://github.blog/changelog/2025-03-18-fine-grained-pats-are-now-generally-available/)

- [List fine-grained personal access tokens with access to organization resources](https://github.com/gm3dmo/gm3dmo/blob/master/fine-grained-personal-acces-tokens/report-fine-grained-access-token-usage-across-organization/report-fine-grained-access-token-usage-across-organization.md) (script)
- [Revoke all fine grained personal access tokens on an organization](https://github.com/gm3dmo/gm3dmo/blob/master/fine-grained-personal-acces-tokens/revoke-all-fine-grained-access-tokens-on-organization/revoke-all-fine-grained-access-tokens-on-organization.md) (script)

#### Personal access tokens (classic)

- [Reporting a leaked secret](https://docs.github.com/en/enterprise-cloud@latest/code-security/secret-scanning/managing-alerts-from-secret-scanning/resolving-alerts#reporting-a-leaked-secret)
- [Secret scanning: on-demand revocation for GitHub PATs (Public Beta)](https://github.blog/changelog/2024-10-02-secret-scanning-on-demand-revocation-for-github-pats-public-beta/)
- [List SAML SSO authorizations for an organization](https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/orgs?apiVersion=2022-11-28#list-saml-sso-authorizations-for-an-organization) (script) Lists all credential authorizations for an organization that uses SAML single sign-on (SSO). The credentials are either personal access tokens or SSH keys that organization members have authorized for the organization. For more information, see [About authentication with SAML single sign-on](https://docs.github.com/enterprise-cloud@latest//articles/about-authentication-with-saml-single-sign-on).

### Dependabot

- [Configuring Dependabot security updates](https://docs.github.com/en/enterprise-cloud@latest/code-security/dependabot/dependabot-security-updates/configuring-dependabot-security-updates)

### GitHub IP Addresses
- [About GitHub's IP Addresses](https://docs.github.com/en/enterprise-cloud@latest/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses)

#### IP Allow List and Managing the IP Allow list with GraphQL API

- [Restricting network traffic to your enterprise with an IP allow list](https://docs.github.com/en/enterprise-cloud@latest/admin/configuring-settings/hardening-security-for-your-enterprise/restricting-network-traffic-to-your-enterprise-with-an-ip-allow-list)
- Organization IP Allow List
  - [graphql-list-ip-allow-list-entries.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-list-ip-allow-list-entries.sh) (script)
  - [graphql-create-ip-allow-list-entry.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-create-ip-allow-list-entry.sh) (script)
- Enterprise IP Allow List
  - [gh-graphql-list-enterprise-ip-allow-list.sh](https://github.com/gm3dmo/the-power/blob/main/gh-graphql-list-enterprise-ip-allow-list.sh) (script)
  - [graphql-create-enterprise-ip-allow-list-entry.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-create-enterprise-ip-allow-list-entry.sh) (script)

### Deploy Keys
- [Repository deploy keys are controlled by enterprise and organization policy](https://github.blog/changelog/2024-10-23-repository-deploy-keys-are-controlled-by-enterprise-and-organization-policy-ga/)
- [Restricting deploy keys in your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/restricting-deploy-keys-in-your-organization)
- [Detect deploy keys in organization](https://github.com/gm3dmo/gm3dmo/blob/master/snippets/detecting-deploy-keys.md) (script)

### Actions

- [Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization)
- [Get allowed actions for an organization](https://github.com/gm3dmo/the-power/blob/main/get-allowed-actions-for-an-organization.sh) (script) ([api](https://docs.github.com/en/rest/reference/actions#get-allowed-actions-for-an-organization))
- [Using third-party actions](https://docs.github.com/en/enterprise-cloud@latest/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions)
- [Identifying Actions used on a repository](https://github.com/gm3dmo/gm3dmo/blob/master/actions/identifying-actions-used-on-a-repository.md) (script)

### GitHub Apps
- [Managing private keys for GitHub Apps](https://docs.github.com/en/enterprise-cloud@latest/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps)
- [Finding all github apps in an organization](https://github.com/gm3dmo/gm3dmo/blob/master/github-apps/finding-all-github-apps-in-an-organization.md) (script)
- [Suspend a GitHub app installation](https://github.com/gm3dmo/the-power/blob/main/tiny-suspend-app-installation.sh) installation (script)
- [Unsuspend a GitHub app installation](https://github.com/gm3dmo/the-power/blob/main/tiny-unsuspend-app-installation.sh) (script)

