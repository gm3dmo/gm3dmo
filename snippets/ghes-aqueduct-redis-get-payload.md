
```bash
for guid in $(redis-cli -n 2 keys "aql:payload:github-production:*" | grep issue_comment_orchestration | awk -F: '{print $5}')
do
    echo "================ ${guid} ======================="
    redis-cli -n 2 get aql:payload:github-production:issue_comment_orchestration:${guid} | jq -r
    read x
done
```
