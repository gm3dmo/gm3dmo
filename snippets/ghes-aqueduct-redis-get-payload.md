
```bash
for guid in $(redis-cli -n 2 keys "aql:payload:github-production:*" | grep issue_comment_orchestration | awk -F: '{print $5}')
do
    echo "================ ${guid} ======================="
    redis-cli -n 2 get aql:payload:github-production:issue_comment_orchestration:${guid} | jq -r
    read x
done
```


Fix ghostty:

```
infocmp -x | ssh -p 122 admin@54.67.78.60 -- tic -x -
```
