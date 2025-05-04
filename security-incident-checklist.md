# Security Incident Checklist

![Author](https://img.shields.io/badge/author-gm3dmo-blue)
![last update](https://img.shields.io/badge/last_update-2025--05--04-blue)

These are common things asked about when a company has a security incident related to GitHub.com. They are mostly a collection of links to appropriate GitHub documentation. Some links to examples scripts that excercise the GitHub API's are included.

### GitHub
- [Enabling security features in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization)
- [Applying the GitHub-recommended security configuration to all repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-all-repositories-in-your-organization)
- [Applying the GitHub-recommended security configuration to specific repositories in your organization](https://docs.github.com/en/enterprise-cloud@latest/code-security/securing-your-organization/enabling-security-features-in-your-organization/applying-the-github-recommended-security-configuration-in-your-organization#applying-the-github-recommended-security-configuration-to-specific-repositories-in-your-organization)
- [About support for your IdP's Conditional Access Policy](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-iam/configuring-authentication-for-enterprise-managed-users/about-support-for-your-idps-conditional-access-policy)
- [Best practices for preventing data leaks in your organization](https://docs.github.com/en/code-security/getting-started/best-practices-for-preventing-data-leaks-in-your-organization)

### Audit log
- [Streaming the audit log for your enterprise](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise) 
- For API's to set up and manage the audit log stream [Programmatic audit log configuration and multi-endpoint streaming](https://github.blog/changelog/2024-11-21-programmatic-audit-log-configuration-and-multi-endpoint-streaming/)
- [Audit log examples with DuckDB](https://github.com/gm3dmo/gm3dmo/blob/master/duckdb-github-audit-log/README.md)
- [Exporting the audit log](https://docs.github.com/en/enterprise-cloud@latest/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/reviewing-the-audit-log-for-your-organization#exporting-the-audit-log)
- [Use the audit log api to get the last enterprise SSO response for a user](https://github.com/gm3dmo/the-power/blob/main/get-last-enterprise-sso-response-for-a-user.sh) (script)
- [Identifying audit log events performed by an access token](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/identifying-audit-log-events-performed-by-an-access-token) 
- [Script (python) to generate hashed token from PAT](https://github.com/gm3dmo/the-power/blob/main/generate-hashed-token.py)

#### Audit Log Stream vs API

Streaming the audit log is probably the most useful security themed thing you can do. GitHub announced [Enterprise Audit log streaming](https://github.blog/changelog/2022-01-20-audit-log-streaming-is-generally-available/) back in January 2022 and some organizations now have all that data in their own logging system. [Multiple audit log streams](https://github.blog/changelog/2024-11-21-programmatic-audit-log-configuration-and-multi-endpoint-streaming/) were announced November 2024.

[Audit log API is rate limited](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/using-the-audit-log-api-for-your-enterprise#rate-limit). The rate limit was set to 1,750 in [this July 2023 announcement](https://github.blog/changelog/2023-07-03-new-rate-limit-is-coming-for-the-audit-log-api-endpoints/). Given that adjustment was significantly lowered it's probably a good idea to keep use of the API to a minimum such as for adhoc querying.

When using the streamed audit log, ensure that appropriate teams have access to the data. Some customers stream the data to a source that only a small security team have access to. In that case it is important that team are able to provide timely responses to your queries or grant appropriate access when investigating a security incident to prevent that team becoming a bottleneck in your investigations.


### User Accounts
- [Best practices for securing accounts](https://docs.github.com/en/enterprise-cloud@latest/code-security/supply-chain-security/end-to-end-supply-chain/securing-accounts)

### Personal Access Tokens

- [Enforcing policies for personal access tokens in your enterprise](https://docs.github.com/en/enterprise-cloud@latest/admin/enforcing-policies/enforcing-policies-for-your-enterprise/enforcing-policies-for-personal-access-tokens-in-your-enterprise)
- [Reviewing and revoking personal access tokens in your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-programmatic-access-to-your-organization/reviewing-and-revoking-personal-access-tokens-in-your-organization)
- [Revoke a list of credentials](https://docs.github.com/en/enterprise-cloud@latest/rest/credentials/revoke?apiVersion=2022-11-28#revoke-a-list-of-credentials) ([revoke-a-list-of-credentials.sh](https://github.com/gm3dmo/the-power/blob/main/revoke-a-list-of-credentials.sh))

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

### Repositories

- [Restricting repository visibility changes in your organization](https://docs.github.com/en/organizations/managing-organization-settings/restricting-repository-visibility-changes-in-your-organization)

####  Deploy Keys
- [Repository deploy keys are controlled by enterprise and organization policy](https://github.blog/changelog/2024-10-23-repository-deploy-keys-are-controlled-by-enterprise-and-organization-policy-ga/)
- [Restricting deploy keys in your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/restricting-deploy-keys-in-your-organization)
- [Deploy Keys REST API](https://docs.github.com/en/enterprise-cloud@latest/rest/deploy-keys/deploy-keys?apiVersion=2022-11-28)
- [Detect deploy keys in organization](https://github.com/gm3dmo/gm3dmo/blob/master/snippets/detecting-deploy-keys.md) (script)
- [Delete a deploy key](https://github.com/gm3dmo/the-power/blob/main/delete-a-deploy-key.sh) (script)

### Actions

- [Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization)
- [Get allowed actions for an organization](https://github.com/gm3dmo/the-power/blob/main/get-allowed-actions-for-an-organization.sh) (script) ([api](https://docs.github.com/en/rest/reference/actions#get-allowed-actions-for-an-organization))
- [Using third-party actions](https://docs.github.com/en/enterprise-cloud@latest/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions)
- [Identifying Actions used on a repository](https://github.com/gm3dmo/gm3dmo/blob/master/actions/identifying-actions-used-on-a-repository.md) (script)

### GitHub Apps
- [Managing private keys for GitHub Apps](https://docs.github.com/en/enterprise-cloud@latest/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps)
- [Finding all github apps in an organization](https://github.com/gm3dmo/gm3dmo/blob/master/github-apps/finding-all-github-apps-in-an-organization.md) (script)
- [Suspend a GitHub app installation](https://github.com/gm3dmo/the-power/blob/main/tiny-suspend-app-installation.sh) (script)
- [Unsuspend a GitHub app installation](https://github.com/gm3dmo/the-power/blob/main/tiny-unsuspend-app-installation.sh) (script)

### Removal of Information from GitHub
- [GitHub Private Information Removal Policy](https://docs.github.com/en/site-policy/content-removal-policies/github-private-information-removal-policy)
- [Guide to Submitting a DMCA Takedown Notice](https://docs.github.com/en/site-policy/content-removal-policies/guide-to-submitting-a-dmca-takedown-notice)

### Abuse
- [Reporting abuse or spam](https://docs.github.com/en/communities/maintaining-your-safety-on-github/reporting-abuse-or-spam)

