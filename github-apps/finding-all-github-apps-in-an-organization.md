### Finding All GitHub Apps in an Organization or all Enterprise Organizations

![gm3dmo](https://img.shields.io/badge/tested_by-gm3dmo-blue)



For audit purposes it may be desirable to have a list of the GitHub Apps installed in an organization. To get such a list for all organizations in an enterprise the GraphQL object [enterpriseorganizationmembershipconnection](https://docs.github.com/en/graphql/reference/objects#enterpriseorganizationmembershipconnection) may be used. The Power has a [graphql-list-enterprise-organizations.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-list-enterprise-organizations.sh) to get all the organizations in the enterprise and for each organization [list app installations for an organization]() endpoint to return details of the GitHub Apps installed in the organization.

```
./graphql-list-enterprise-organizations.sh | jq -r '.data.enterprise.organizations.nodes.[].name'
```

Returns:

```
forest-town
forest-test-org
gm3dmo-test6
crispy
owazu
pipcrispy12
pulepule
shedburgh
```

Use `list-app-installations-for-an-organization.sh` with an organization name to get the apps installed:

```
./list-app-installations-for-an-organization.sh owazu
```

Returns:

```
{
  "total_count": 3,
  "installations": [
    {
      "id": 39515288,
      "client_id": "Iv1.038089c420640751",
      "account": {
        "login": "owazu",
        "id": 113779563,
        "node_id": "O_kgDOBsgjaw",
        "avatar_url": "https://avatars.githubusercontent.com/u/113779563?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/owazu",
        "html_url": "https://github.com/owazu",
        "followers_url": "https://api.github.com/users/owazu/followers",
        "following_url": "https://api.github.com/users/owazu/following{/other_user}",
        "gists_url": "https://api.github.com/users/owazu/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/owazu/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/owazu/subscriptions",
        "organizations_url": "https://api.github.com/users/owazu/orgs",
        "repos_url": "https://api.github.com/users/owazu/repos",
        "events_url": "https://api.github.com/users/owazu/events{/privacy}",
        "received_events_url": "https://api.github.com/users/owazu/received_events",
        "type": "Organization",
        "user_view_type": "public",
        "site_admin": false
      },
      "repository_selection": "selected",
      "access_tokens_url": "https://api.github.com/app/installations/39515288/access_tokens",
      "repositories_url": "https://api.github.com/installation/repositories",
      "html_url": "https://github.com/organizations/owazu/settings/installations/39515288",
      "app_id": 359357,
      "app_slug": "owazu-app-001",
      "target_id": 113779563,
      "target_type": "Organization",
      "permissions": {
        "issues": "read",
        "actions": "write",
```

To have that in CSV format:

```
./list-app-installations-for-an-organization-csv.sh owazu
```
Returns:
```
"counter","id","app_id","app_slug","created_at","updated_at","suspended_by_login","suspended_at","html_url"
"1","39515288","359357","owazu-app-001","2023-07-11T10:06:47.000+01:00","2024-10-28T15:50:43.000+00:00",,,"https://github.com/organizations/owazu/settings/installations/39515288"
"2","53820020","887721","ft-no-app-permissions-enabled","2024-08-15T12:42:31.000+01:00","2024-11-13T14:14:47.000+00:00",,,"https://github.com/organizations/owazu/settings/installations/53820020"
"3","55900069","206262","ft-1644122","2024-10-12T20:50:27.000+01:00","2024-10-12T20:50:27.000+01:00",,,"https://github.com/organizations/owazu/settings/installations/55900069"
```

Round things off and make output pretty using csvlook from the [csvkit](https://csvkit.readthedocs.io/en/latest/): library:

```
./list-app-installations-for-an-organization-csv.sh | csvlook --no-inference
```

Returns:

```
| counter | id       | app_id  | app_slug                       | repository_selection | created_at                    | updated_at                    | suspended_by_login | suspended_at         | html_url                                                                     |
| ------- | -------- | ------- | ------------------------------ | -------------------- | ----------------------------- | ----------------------------- | ------------------ | -------------------- | ---------------------------------------------------------------------------- |
| 1       | 21761910 | 161537  | ft-testapp                     | all                  | 2021-12-29T12:48:55.000+00:00 | 2024-10-11T13:32:38.000+01:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/21761910 |
| 2       | 25970466 | 204382  | roger-de-app                   | all                  | 2022-05-25T11:52:14.000+01:00 | 2024-12-04T08:20:27.000+00:00 | pipcrispy          | 2023-11-09T13:50:07Z | https://github.com/organizations/forest-town/settings/installations/25970466 |
| 3       | 26149488 | 206262  | ft-1644122                     | selected             | 2022-06-01T12:49:32.000+01:00 | 2022-06-01T12:49:33.000+01:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/26149488 |
| 4       | 26760059 | 213497  | ft-all-app-permissions-enabled | all                  | 2022-06-22T14:07:47.000+01:00 | 2024-12-04T08:12:56.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/26760059 |
| 5       | 27350692 | 12526   | sonarcloud                     | selected             | 2022-07-13T13:30:45.000+01:00 | 2022-12-20T16:43:45.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/27350692 |
| 6       | 28161314 | 227512  | datadog-forest-town            | all                  | 2022-08-11T12:29:18.000+01:00 | 2024-12-04T08:12:56.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/28161314 |
| 7       | 33498161 | 219550  | ft-testdave2                   | selected             | 2023-01-25T14:05:03.000+00:00 | 2023-01-30T11:16:35.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/33498161 |
| 8       | 38287280 | 343156  | sc2082667                      | all                  | 2023-06-05T16:49:20.000+01:00 | 2024-12-04T08:12:56.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/38287280 |
| 9       | 50183253 | 887721  | ft-no-app-permissions-enabled  | all                  | 2024-04-29T18:33:14.000+01:00 | 2024-12-04T08:20:27.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/50183253 |
| 10      | 51754478 | 7100    | slack                          | all                  | 2024-06-11T20:34:28.000+01:00 | 2024-12-04T08:12:56.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/51754478 |
| 11      | 57114749 | 1056986 | ft-no-app-perms-private        | all                  | 2024-11-13T14:34:55.000+00:00 | 2024-12-04T08:12:56.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/57114749 |
| 12      | 57147719 | 1057981 | ft-app-private2                | all                  | 2024-11-14T09:37:00.000+00:00 | 2024-12-04T08:12:57.000+00:00 |                    |                      | https://github.com/organizations/forest-town/settings/installations/57147719 |
```


