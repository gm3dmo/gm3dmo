## Detecting deploy keys

To detect deploy keys in a repository:

```shell
for repo in $(gh repo list --json nameWithOwner --jq '.[] .nameWithOwner')
do
    gh repo -R $repo deploy-key list;\
done
```
