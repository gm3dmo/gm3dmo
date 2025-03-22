# Revoke all fine grained personal access tokens on an organization

Use the [Update the access to organization resources via fine-grained personal access tokens](https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#update-the-access-to-organization-resources-via-fine-grained-personal-access-tokens) REST API endpoing to revoke tokens.  A GitHub App is needed to use this endpoint.

Example using the [`tiny-list-fine-grained-personal-access-tokens-with-access-to-organization-resources.sh`](https://github.com/gm3dmo/the-power/blob/main/tiny-revoke-all-fine-grained-access-tokens-on-organization.sh)

```bash
./tiny-revoke-all-fine-grained-access-tokens-on-organization.sh

```

Output:

```json
{
  "action": "revoke",
  "pat_ids": [
    522067,
    461741,
    435783,
    435724,
    318509
  ]
}
{

}
```
