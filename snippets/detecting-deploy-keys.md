## Detecting deploy keys in an Organizatoin

![tested_by](https://img.shields.io/badge/tested_by-gm3dmo-blue)
![tested_on](https://img.shields.io/badge/tested_on-ghec-blue)
![tested_date](https://img.shields.io/badge/tested_date-2025--03--21-blue)


To detect deploy keys in an organization The Power has a script [gh-list-deploy-keys-on-org-repos.sh](https://github.com/gm3dmo/the-power/blob/main/gh-list-deploy-keys-on-org-repos.sh). Here it is explained a little:

```shell
# Optional. Set the GH_TOKEN to an appropriately scoped token:
#export GH_TOKEN=${GITHUB_TOKEN}
# For GitHub Enterprise server: 
#export GH_ENTERPRISE_TOKEN=${GITHUB_TOKEN}
#export GH_HOST=${hostname}

owner="organization_name"

for repo_name in $(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/${owner}/repos --jq '.[].full_name' -X GET --paginate)
do
    gh repo -R ${repo_name} deploy-key list;\
done

```

Output shown below for negative and found deploy key responses:

```
no deploy keys found in forest-town/repo-2820495
ID         TITLE                            TYPE        KEY                                               CREATED AT
100948869  The Power Deploy Key 1717491670  read-write  ssh-ed25519 AAAAC3NzaC1...oClYqhFWzY2Ta/f7v1zYmV  about 9 months ago
no deploy keys found in forest-town/robin4
```



Duration:

In my test on an organization with approx 1,500 repositories it took 8.5 minutes to get the deploy keys report:

```
real    8m23.115s
user    2m18.744s
sys     0m21.908s
```

