## Detecting deploy keys

![tested_by](https://img.shields.io/badge/tested_by-gm3dmo-blue)
![tested_on](https://img.shields.io/badge/tested_on-ghec-blue)
![tested_date](https://img.shields.io/badge/tested_date-2025--03--21-blue)


To detect deploy keys in a repository:


```shell
# Optional. Set the GH_TOKEN to an appropriately scoped token:
GH_TOKEN=ghs_***
export GH_TOKEN
```


```shell
owner="forest-town"
for repo_name in $(gh repo list --owner ${owner} --json nameWithOwner --jq '.[] .nameWithOwner')
do
    gh repo -R ${repo_name} deploy-key list;\
done
```

Tested: 2024-10-26
