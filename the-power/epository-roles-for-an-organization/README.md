### The Power: Explore repository roles for an organization 
Use the [`build-testcase-permissions`](https://github.com/gm3dmo/the-power/blob/main/build-testcase-permissions) script to learn about [repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization).

### Prerequisites
Prior to running `build-testcase-permissions`, edit `.gh-api-examples.conf` set the *team_members* to contain 5 members needed. 

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

At this point take a look at the screencast []()
