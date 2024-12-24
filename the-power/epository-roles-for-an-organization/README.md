## The Power: Explore repository roles for an organization 
This note covers:

- Use the [`build-testcase-permissions`](https://github.com/gm3dmo/the-power/blob/main/build-testcase-permissions) script to learn about [repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization).
- Explore permission sources with [`gh-graphql-repo-users-with-permission-sources.sh`
](https://github.com/gm3dmo/the-power/blob/main/gh-graphql-repo-users-with-permission-sources.sh)

### Prerequisites
Prior to running `build-testcase-permissions`, edit `.gh-api-examples.conf` set the *team_members* to contain 5 members needed to cover the 5 possible roles. 

```bash
team_members="roger-de-courcey robin-of-loxley banned-from-urgent monty-bojangle grillpan-eddie"
```

These 5 users will be assigned to a team based on the privileges in order (least privilege first):

- read (pull)
- triage
- write (push)
- maintain
- admin

Users who are not organization members will be invited to join the organization.

| Privilege  | User                  |
|------------|-----------------------|
| read (pull)| roger-de-courcey      |
| triage     | robin-of-loxley       |
| write (push)| banned-from-urgent   |
| maintain   | monty-bojangle        |
| admin      | grillpan-eddie        |


#### Set the outside collaborator
Edit `.gh-api-examples.conf` set the *repo_collaborator* to contain a user to invite as an [outside collaborators to the repository](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-user-access-to-your-organizations-repositories/managing-outside-collaborators/adding-outside-collaborators-to-repositories-in-your-organization)

```bash
repo_collaborator="mona"
```

### Run build-testcase-permissions


```bash
 ./build-testcase-permissions 
```


### Explore permissions using 

[`gh-graphql-repo-users-with-permission-sources.sh`
](https://github.com/gm3dmo/the-power/blob/main/gh-graphql-repo-users-with-permission-sources.sh)


```bash
./gh-graphql-repo-users-with-permission-sources.sh | jq -r
```

```json
{
  "data": {
    "repository": {
      "nameWithOwner": "pulepule/repo-permissions",
      "visibility": "PRIVATE",
      "updatedAt": "2024-12-24T08:01:15Z",
      "pushedAt": "2024-12-24T08:01:23Z",
      "archivedAt": null,
      "collaborators": {
        "edges": [
          {
            "permission": "ADMIN",
            "node": {
              "login": "pipcrispy"
            },
            "permissionSources": [
              {
                "sourcePermission": "ADMIN",
                "source": {
                  "permissionSource": "Organization",
                  "orgName": "pulepule"
                }
              },
              {
                "sourcePermission": "ADMIN",
                "source": {
                  "permissionSource": "Repository",
                  "repoName": "repo-permissions"
                }
              }
            ]
          },
          {
            "permission": "WRITE",
            "node": {
              "login": "banned-from-urgent"
            },
            "permissionSources": [
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Organization",
                  "orgName": "pulepule"
                }
              },
              {
                "sourcePermission": "WRITE",
                "source": {
                  "permissionSource": "Team",
                  "teamName": "pwr-team-push"
                }
              }
            ]
          },
          {
            "permission": "TRIAGE",
            "node": {
              "login": "robin-of-loxley"
            },
            "permissionSources": [
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Organization",
                  "orgName": "pulepule"
                }
              },
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Team",
                  "teamName": "pwr-team-triage"
                }
              }
            ]
          },
          {
            "permission": "READ",
            "node": {
              "login": "roger-de-courcey"
            },
            "permissionSources": [
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Organization",
                  "orgName": "pulepule"
                }
              },
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Team",
                  "teamName": "pwr-team-pull"
                }
              }
            ]
          },
          {
            "permission": "ADMIN",
            "node": {
              "login": "grillpan-eddie"
            },
            "permissionSources": [
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Organization",
                  "orgName": "pulepule"
                }
              },
              {
                "sourcePermission": "ADMIN",
                "source": {
                  "permissionSource": "Team",
                  "teamName": "pwr-team-admin"
                }
              }
            ]
          },
          {
            "permission": "MAINTAIN",
            "node": {
              "login": "monty-bojangle"
            },
            "permissionSources": [
              {
                "sourcePermission": "READ",
                "source": {
                  "permissionSource": "Organization",
                  "orgName": "pulepule"
                }
              },
              {
                "sourcePermission": "WRITE",
                "source": {
                  "permissionSource": "Team",
                  "teamName": "pwr-team-maintain"
                }
              }
            ]
          }
        ]
      }
    }
  }
}
```


