
## Query a Syslog File for Streaks
A streak is where the same deamon writes to the syslog more than once in a row. Streaks of long duration may be  problematic.

#### Open the support bundle

#### Clone the syslog-to-csv repo into the support bundle

```
git clone https://github.com/gm3dmo/syslog-to-csv
```


#### Run syslog-to-csv.py to create a syslog.csv file

```
pypy3 syslog-to-csv/syslog-to-csv.py --csv-file system-logs/syslog.cs system-logs/syslog
```

```
INFO:syslog-to-csv:filename: system-logs/syslog
INFO:syslog-to-csv:filename.stem: syslog
INFO:syslog-to-csv:filename.suffix: ()
INFO:syslog-to-csv:filename.size: 13.5 GB
INFO:syslog-to-csv:filename.log_type: syslog
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
CREATE TABLE syslog AS
     SELECT * FROM 'system-logs/syslog.csv';
```

#### Query the syslog for "streaks"

Switch on the timer and column modes:

```
.timer on
.mode column
```

Run the query:

```sql
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
  ORDER BY duration DESC
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
