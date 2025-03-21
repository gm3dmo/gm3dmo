## Detecting deploy keys

![tested_by](https://img.shields.io/badge/tested_by-gm3dmo-blue)
![tested_on](https://img.shields.io/badge/tested_on-ghec-blue)
![tested_date](https://img.shields.io/badge/tested_date-2025--03--21-blue)


To detect deploy keys in a repository:


```shell
# Optional. Set the GH_TOKEN to an appropriately scoped token:
#export GH_TOKEN=${GITHUB_TOKEN}
# For GitHub Enterprise server: 
#export GH_ENTERPRISE_TOKEN=${GITHUB_TOKEN}
#export GH_HOST=${hostname}

for repo_name in $(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/${owner}/repos --jq '.[].full_name' -X GET --paginate)
do
    gh repo -R ${repo_name} deploy-key list;\
done

```

