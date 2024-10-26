## Detecting deploy keys

To detect deploy keys in a repository:

```shell
for repo_name in $(gh repo list --json nameWithOwner --jq '.[] .nameWithOwner')
do
    gh repo -R ${repo_name} deploy-key list;\
done
```

Tested: 2024-10-26
