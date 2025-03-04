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

### Effective date in docker container

```
for d in $(docker ps  | tail -n +2 | awk '{print $NF}')
do
printf "%s" "$d"
docker exec -it $d date
done
```

### Restart nomad
```
 nomad stop redis
 nomad run /etc/nomad-jobs/redis/redis.hcl
```


```shell
nomad stop redis
export TZ=GMT+8
date
nomad run /etc/nomad-jobs/redis/redis.hcl
```


### What is the hardware clock set to
```
sudo hwclock
2025-03-04 20:14:01.871505+08:00
```

#### Um wieviel Uhr ist es Herr Wolf

```
set -x

date
sudo hwclock
sudo timedatectl status
cat /etc/timezone
cat /etc/localtime
# If hwclock -c has been run then this file will exist
cat /etc/adjtime
# /etc/adjtime is not present on an as GitHub appliance
```


```
sudo chronyc  -A makestep
```


```
admin@gm3dmo-038cac817cc352265-ghe-test-org-primary:~$ cat /etc/adjtime
cat: /etc/adjtime: No such file or directory

admin@gm3dmo-038cac817cc352265-ghe-test-org-primary:~$ sudo hwclock -w
admin@gm3dmo-038cac817cc352265-ghe-test-org-primary:~$ ls /etc/adjtime

cat /etc/adjtime
0.000000 1741092528 0.000000
1741092528
UTC
```

