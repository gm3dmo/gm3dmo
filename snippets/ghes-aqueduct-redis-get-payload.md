#### Ghostty

Fix ghostty terminal:

```
infocmp -x | ssh -p 122 admin@54.67.78.60 -- tic -x -
```


Display messages from the queue
```bash
for guid in $(redis-cli -n 2 keys "aql:payload:github-production:*" | grep issue_comment_orchestration | awk -F: '{print $5}')
do
    echo "================ ${guid} ======================="
    redis-cli -n 2 get aql:payload:github-production:issue_comment_orchestration:${guid} | jq -r
    read x
done
```

#### Pause
```
ghe-aqueduct pause --queue issue_comment_orchestration
```

#### Resume
```
ghe-aqueduct resume --queue issue_comment_orchestration
```



#### Aqueuduct select queues with messages > 0

```
ghe-aqueduct-info | tail -n+7 | jq '.queues[] | select(.depth != 0)'
```


