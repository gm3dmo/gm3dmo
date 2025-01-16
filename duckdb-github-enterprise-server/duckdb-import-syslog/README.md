
## Query a Syslog File for Streaks
A streak is where the same deamon writes to the syslog more than once in a row. Streaks of long duration may be  problematic.

#### Open the support bundle

#### Clone the syslog-to-csv repo into the support bundle

```
git clone https://github.com/gm3dmo/syslog-to-csv
```


#### Run syslog-to-csv.py to create a syslog.csv file

```
pypy3 syslog-to-csv/syslog-to-csv.py --csv-file system-logs/syslog.csv system-logs/syslog
```

The output looks something like:

```
INFO:syslog-to-csv:filename: system-logs/syslog
INFO:syslog-to-csv:filename.stem: syslog
INFO:syslog-to-csv:filename.suffix: ()
INFO:syslog-to-csv:filename.size: 13.5 GB
INFO:syslog-to-csv:filename.log_type: syslog
INFO:syslog-to-csv:Converted file: system-logs/syslog size type: syslog to CSV file system-logs/syslog.csv size 13152522261 bytes or roughly 12.2 GB.
```

syslog-to-csv.py may warn about lines that could not be processed. These may be ignored:

```
WARNING:syslog-to-csv:squib: line 3047437 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3047438 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3047439 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3047440 (  "BalancerAttributes": null,) not enough values to unpack (expected 3, got 1)
WARNING:syslog-to-csv:squib: line 3047441 is not minimum length of (15) characters
WARNING:syslog-to-csv:squib: line 3047442 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3047443 (}. Err: connection error: desc = "error reading server preface: read tcp 127.0.0.1:57334->127.0.0.1:6002: use of closed network connection") time data '2025 }. Err: connect' does not match format '%Y %b %d %H:%M:%S'
WARNING:syslog-to-csv:squib: line 3048660 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3048661 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3048662 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3048663 (  "BalancerAttributes": null,) not enough values to unpack (expected 3, got 1)
WARNING:syslog-to-csv:squib: line 3048664 is not minimum length of (15) characters
WARNING:syslog-to-csv:squib: line 3048665 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3048666 (}. Err: connection error: desc = "transport: Error while dialing dial tcp 127.0.0.1:6002: operation was canceled") time data '2025 }. Err: connect' does not match format '%Y %b %d %H:%M:%S'
WARNING:syslog-to-csv:squib: line 15110048 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 15110049 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 15110050 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 15110051 (  "BalancerAttributes": null,) not enough values to unpack (expected 3, got 1)
WARNING:syslog-to-csv:squib: line 15110052 is not minimum length of (15) characters
WARNING:syslog-to-csv:squib: line 15110053 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 15110054 (}. Err: connection error: desc = "transport: Error while dialing dial tcp 127.0.0.1:6002: operation was canceled") time data '2025 }. Err: connect' does not match format '%Y %b %d %H:%M:%S'
```

#### Download and unzip DuckDB

```
curl -L -O https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip
```

```
unzip duckdb_cli-linux-amd64.zip
```

#### Create a DuckDB database

```
./duckdb syslog.db
```


#### Import the `syslog.csv` file into Duckdb

```sql
.timer on
CREATE TABLE syslog AS
     SELECT * FROM 'system-logs/syslog.csv';
```

Result:

```
Run Time (s): real 30.742 user 110.845174 sys 202.077361
```

The 14Gb of syslog has been reduced significantly by DuckDB and is now 48Mb of database file:

```
ls -lh duckdb
-rwxr-xr-x 1 gm3dmo gm3dmo 48M Nov  4 09:01 duckdb
```

#### Query the syslog for "streaks"

Switch on the timer and column modes:

```
.timer on
.mode column

```

Run the query:

```sql
WITH sequence_groups AS (
  SELECT 
    daemon,
    line_number,
    real_date,
    line_number - ROW_NUMBER() OVER (PARTITION BY daemon ORDER BY line_number) AS sequence_id
  FROM syslog
  WHERE daemon IS NOT NULL
),
streak_details AS (
  SELECT 
    daemon,
    sequence_id,
    COUNT(*) as streak_length,
    MIN(line_number) as start_line,
    MAX(line_number) as end_line,
    MIN(real_date) as start_time,
    MAX(real_date) as end_time
  FROM sequence_groups
  GROUP BY daemon, sequence_id
),
daemon_max_streaks AS (
  SELECT DISTINCT ON (daemon)
    daemon,
    streak_length,
    start_line,
    end_line,
    start_time,
    end_time
  FROM streak_details
  ORDER BY daemon, streak_length DESC
)
SELECT 
  daemon,
  streak_length as longest_streak,
  start_line,
  end_line,
  start_time,
  end_time,
  AGE(end_time, start_time) as duration
FROM daemon_max_streaks
ORDER BY streak_length DESC
LIMIT 10;

```

Result:

```
daemon                                longest_streak  start_line  end_line  start_time           end_time             duration
------------------------------------  --------------  ----------  --------  -------------------  -------------------  --------
kernel:                               763             707399      708161    2025-01-09 01:13:19  2025-01-09 01:19:02  00:05:43
systemd                               211             708550      708760    2025-01-09 01:14:39  2025-01-09 01:16:53  00:02:14
dependency-graph-api                  387             15641662    15642048  2025-01-09 15:17:34  2025-01-09 15:17:35  00:00:01
kafka-lite                            140             3047940     3048079   2025-01-09 04:11:37  2025-01-09 04:11:38  00:00:01
actions-job-agent                     1260            1482589     1483848   2025-01-09 01:51:38  2025-01-09 01:51:39  00:00:01
consul                                18              15110011    15110028  2025-01-09 14:55:46  2025-01-09 14:55:47  00:00:01
turboscan-repo-indexer-fallback       84              5839076     5839159   2025-01-09 06:01:49  2025-01-09 06:01:50  00:00:01
cracklib:                             1               6290039     6290039   2025-01-09 06:25:01  2025-01-09 06:25:01  00:00:00
dbus-daemon                           1               19431486    19431486  2025-01-09 16:51:59  2025-01-09 16:51:59  00:00:00
dependency-graph-api-aqueduct-worker  31              12947954    12947984  2025-01-09 13:12:28  2025-01-09 13:12:28  00:00:00

Run Time (s): real 6.760 user 67.779807 sys 176.301531
```

### Babeld

```
pypy3 klp.py --stats babeld-logs/babeld.log  --output-format csv > babeld-logs/babeld.csv -k ts,pid,tid,version,proto,id,http_url,http_ua,ip,xff_ip,repo,cmd,duration_ms,sr,ss,fs_sent,fs_recv,client_recv,client_send,log_level,msg,banner,best_kex,best_sigtype,best_cipher,best_mac,kex,keytype,sigtype,cipher,hmac,fp_sha256,pk_ms,srcp,dstp,fs_host,repo_public,gpv,client_sent,fsc_ms,ac_ms,ssh_cmd,user_agent,cid,cactive,ctotal,code,status,auth_tries,probe_ok,probe_fail,cr,creason,imode,user,http_status,auth_status,have_count,want_count,vk_ms,out_hash,entries_total,entries_freed,hits_ok,hits_unknown,expired_via_get,repl_host,ridx,sb_rs_po,cb,prerx,ct,postrx,nru,gt_ms,srq_ok,srq_bad,hin,hout,sin,sout,siocin,siocout,fds,fde,conn_progress
```


```.timer on
CREATE TABLE babeld AS
     SELECT * FROM 'babeld-logs/babeld.csv';
```
