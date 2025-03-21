# Identify GitHub Actions used in a Repository

This script can be used to determine which GitHub Actions may be in use on a repository [graphql-list-repository-dependencyGraphManifests.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-list-repository-dependencyGraphManifests.sh)


```
 ./graphql-list-repository-dependencyGraphManifests.sh | jq -r
```
Output:

```json
{
  "data": {
    "repository": {
      "dependencyGraphManifests": {
        "totalCount": 2,
        "nodes": [
          {
            "id": "DGM_kwDOOMUX96oxMjk1MDg5MTgz",
            "filename": "requirements.txt"
          },
          {
            "id": "DGM_kwDOOMUX96oxMjk1MDg5MTc2",
            "filename": ".github/workflows/workflow-simple.yml"
          }
        ],
        "edges": [
          {
            "node": {
              "blobPath": "/forest-town/repo-3301628/blob/main/requirements.txt",
              "dependencies": {
                "totalCount": 1,
                "nodes": [
                  {
                    "packageName": "lxml",
                    "requirements": "= 4.6.1",
                    "hasDependencies": true,
                    "packageManager": "PIP"
                  }
                ]
              }
            }
          },
          {
            "node": {
              "blobPath": "/forest-town/repo-3301628/blob/main/.github/workflows/workflow-simple.yml",
              "dependencies": {
                "totalCount": 2,
                "nodes": [
                  {
                    "packageName": "actions/checkout",
                    "requirements": "= 4.*.*",
                    "hasDependencies": false,
                    "packageManager": "ACTIONS"
                  },
                  {
                    "packageName": "actions/upload-artifact",
                    "requirements": "= 4.*.*",
                    "hasDependencies": false,
                    "packageManager": "ACTIONS"
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}
```
