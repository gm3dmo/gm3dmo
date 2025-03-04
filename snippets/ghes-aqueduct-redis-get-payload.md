#### Ghostty

Fix ghostty terminal:


```
H=54.67.78.60
U=azureuser
infocmp -x | ssh -p 122 ${U}@${H} -- tic -x -
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


#### Set the timezone

```bash
sudo timedatectl set-timezone Asia/Hong_Kong
```

```
admin@gm3dmo-038cac817cc352265-ghe-test-org-primary:~$ timedatectl
               Local time: Tue 2025-03-04 17:41:49 HKT
           Universal time: Tue 2025-03-04 09:41:49 UTC
                 RTC time: Tue 2025-03-04 09:41:48
                Time zone: Asia/Hong_Kong (HKT, +0800)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```
