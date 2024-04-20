# Making sense of the GitHub Audit log exports with DuckDB
Having [exported git events](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/exporting-audit-log-activity-for-your-enterprise#exporting-git-events-data) from my organization and stored them in a file named `audit.json` I found that json is not the most pleasant thing to read:

```json
{"@timestamp":1713596671828,"_document_id":"URqi_-__Xjl1qZojMcYnqA==","action":"git.fetch","actor":"datadog-forest-town[bot]","actor_id":111058333,"actor_ip":"44.192.28.48","actor_location":{"country_code":"US"},"business":"gm3dmo-enterprise-cloud-testing","business_id":3082,"external_id":"","hashed_token":"j7TxdJbRhfNhkIOs67EXYceuX0EXL+du673X+6QYSow=","org":"forest-town","org_id":86825428,"programmatic_access_type":"GitHub App server-to-server token","repo":"forest-town/repo-2079435","repository":"forest-town/repo-2079435","repository_public":false,"token_id":0,"transport_protocol":1,"transport_protocol_name":"http","user":"","user_agent":"go-git/5.x","user_id":0}
{"@timestamp":1713596669109,"_document_id":"UcKnmGTmhciMVlkYOGkUaQ==","action":"git.push","actor":"github-actions[bot]","actor_id":41898282,"actor_ip":"20.57.77.4","actor_location":{"country_code":"US"},"business":"gm3dmo-enterprise-cloud-testing","business_id":3082,"external_id":"","hashed_token":"EJmtcbNI26UXIHgh0fnmlmRsDcqsW6y9zLP4xwk9S+s=","org":"forest-town","org_id":86825428,"programmatic_access_type":"GitHub App server-to-server token","repo":"forest-town/repo-2079435","repository":"forest-town/repo-2079435","repository_public":false,"token_id":0,"transport_protocol":1,"transport_protocol_name":"http","user":"","user_agent":"git/2.43.2","user_id":0}
```

I wanted to be able to do two things quickly:

1. Run SQL type commands to create a report.
2. Provide a CSV file to a data analyst.

Let's use a tool called [DuckDB](https://duckdb.org/) to work through these two requirements.

### Install DuckDB

#### MacOS

```
brew install duckdb
```

The version of duckdb installed was:

```
duckdb --version
v0.10.1 4a89d97db8
```

### Reading git audit log events with DuckDB

#### Read the `audit.log` file directly into DuckDB

Load the `audit.json` file into DuckDB and select:

```sql
D select * from './audit.json';
```

This gives a nice overview of the data:

```
┌───────────────┬──────────────────────┬───────────┬──────────────────────┬───────────┬───┬────────────────────┬──────────────────────┬─────────┬────────────┬─────────┐
│  @timestamp   │     _document_id     │  action   │        actor         │ actor_id  │ … │ transport_protocol │ transport_protocol…  │  user   │ user_agent │ user_id │
│     int64     │       varchar        │  varchar  │       varchar        │   int64   │   │       int64        │       varchar        │ varchar │  varchar   │  int64  │
├───────────────┼──────────────────────┼───────────┼──────────────────────┼───────────┼───┼────────────────────┼──────────────────────┼─────────┼────────────┼─────────┤
│ 1713596671828 │ URqi_-__Xjl1qZojMc…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713596669109 │ UcKnmGTmhciMVlkYOG…  │ git.push  │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713596668584 │ aFLfHyPf-7eEFO5eMm…  │ git.push  │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │            │       0 │
│ 1713596668291 │ V_YDukLxvEIwzWWgvI…  │ git.clone │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713596656476 │ DNdRsbQ3vI3DR4FoEf…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713596656336 │ swP0m3CkqXKM2EtW5j…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713595844852 │ CVaNSqkyQQlBC_5xcJ…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713595842730 │ SX_xwY8azmWH0Dr48Y…  │ git.push  │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713595842094 │ RSDTZvTmEO5Shi-qSH…  │ git.push  │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │            │       0 │
│ 1713595841793 │ g2xWxRGSnesA_ummLz…  │ git.clone │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713595830151 │ CDrHgvssSwF29mjqUM…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713595316202 │ xcR98WTFOj4YKNrzLP…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713595313846 │ JlzgWX_yhJjukcv-LM…  │ git.push  │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713595313178 │ PzIsAsU16p2UHXWgfL…  │ git.push  │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │            │       0 │
│ 1713595312799 │ WRJK22nuhBW8grIine…  │ git.clone │ github-actions[bot]  │  41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713595301642 │ EOqh4iKqqvjdl6Es75…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713595300725 │ nxyeupCM_DrzVXire-…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713536001284 │ 2ISVKnjh5t7aT2MHFN…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713535981699 │ BPb0Wo-6S6_cQqAg3b…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713535980893 │ 6_esSCNYxgZHcMusvW…  │ git.clone │ dependabot[bot]      │  49699333 │ … │                  1 │ http                 │         │ git/2.34.1 │       0 │
│       ·       │          ·           │    ·      │     ·                │      ·    │ · │                  · │  ·                   │    ·    │     ·      │       · │
│       ·       │          ·           │    ·      │     ·                │      ·    │ · │                  · │  ·                   │    ·    │     ·      │       · │
│       ·       │          ·           │    ·      │     ·                │      ·    │ · │                  · │  ·                   │    ·    │     ·      │       · │
│ 1713534583301 │ TfirVMruSEDvkVX88s…  │ git.push  │ pipcrispy            │  63502882 │ … │                  1 │ http                 │         │ git/2.42.0 │       0 │
│ 1713534582619 │ ll9bJhyiEPQgLLrfsI…  │ git.push  │ pipcrispy            │  63502882 │ … │                  1 │ http                 │         │            │       0 │
│ 1713534564524 │ TSrE4PQ29UWrkhJvt1…  │ git.clone │ pipcrispy            │  63502882 │ … │                  1 │ http                 │         │ git/2.42.0 │       0 │
│ 1713534524933 │ vHDvmjXCbqY9xSS1NV…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713534503140 │ JiVwSOgwVVWNJs0Ku7…  │ git.clone │ dependabot[bot]      │  49699333 │ … │                  1 │ http                 │         │ git/2.34.1 │       0 │
│ 1713534502603 │ PzYkSCBHWJWUA4hAGQ…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713534498440 │ 4ynJU0C3x0eFILZCHS…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713534493708 │ 8rUZiIgRFUv5inAO1_…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713534489954 │ jAWgMykYsK-T1o3ztt…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523502489 │ I9Pu0AvIWkgH72oNjq…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523501098 │ HkDTa7jNu011BstPBL…  │ git.clone │ dependabot[bot]      │  49699333 │ … │                  1 │ http                 │         │ git/2.34.1 │       0 │
│ 1713523495342 │ x6QBfmxiw_dL5huE-H…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523491923 │ HBoYcDem9yhMo5WSg2…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523490944 │ Oop-l9xkXbF7CYvgCa…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523489373 │ -dhgG8UqMIT2SwxSAN…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523445574 │ HtKJ522nIkDHvP2Zb-…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523440571 │ M5-aCVq6qiXBxa_FSA…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523440029 │ 2eWzimISojrIe0HiEJ…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523435665 │ b7M52lvoM4P5cYOms1…  │ git.fetch │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
│ 1713523433070 │ YfM-NBvJm5jlU25Hx5…  │ git.clone │ datadog-forest-tow…  │ 111058333 │ … │                  1 │ http                 │         │ go-git/5.x │       0 │
├───────────────┴──────────────────────┴───────────┴──────────────────────┴───────────┴───┴────────────────────┴──────────────────────┴─────────┴────────────┴─────────┤
│ 44 rows (40 shown)                                                                                                                             23 columns (10 shown) │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```
Find `git.push` actions:

```sql
D select * from './audit.json' where action = 'git.push';
```

```
┌───────────────┬──────────────────────┬──────────┬─────────────────────┬──────────┬───┬────────────────────┬──────────────────────┬─────────┬────────────┬─────────┐
│  @timestamp   │     _document_id     │  action  │        actor        │ actor_id │ … │ transport_protocol │ transport_protocol…  │  user   │ user_agent │ user_id │
│     int64     │       varchar        │ varchar  │       varchar       │  int64   │   │       int64        │       varchar        │ varchar │  varchar   │  int64  │
├───────────────┼──────────────────────┼──────────┼─────────────────────┼──────────┼───┼────────────────────┼──────────────────────┼─────────┼────────────┼─────────┤
│ 1713596669109 │ UcKnmGTmhciMVlkYOG…  │ git.push │ github-actions[bot] │ 41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713596668584 │ aFLfHyPf-7eEFO5eMm…  │ git.push │ github-actions[bot] │ 41898282 │ … │                  1 │ http                 │         │            │       0 │
│ 1713595842730 │ SX_xwY8azmWH0Dr48Y…  │ git.push │ github-actions[bot] │ 41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713595842094 │ RSDTZvTmEO5Shi-qSH…  │ git.push │ github-actions[bot] │ 41898282 │ … │                  1 │ http                 │         │            │       0 │
│ 1713595313846 │ JlzgWX_yhJjukcv-LM…  │ git.push │ github-actions[bot] │ 41898282 │ … │                  1 │ http                 │         │ git/2.43.2 │       0 │
│ 1713595313178 │ PzIsAsU16p2UHXWgfL…  │ git.push │ github-actions[bot] │ 41898282 │ … │                  1 │ http                 │         │            │       0 │
│ 1713534583301 │ TfirVMruSEDvkVX88s…  │ git.push │ pipcrispy           │ 63502882 │ … │                  1 │ http                 │         │ git/2.42.0 │       0 │
│ 1713534582619 │ ll9bJhyiEPQgLLrfsI…  │ git.push │ pipcrispy           │ 63502882 │ … │                  1 │ http                 │         │            │       0 │
├───────────────┴──────────────────────┴──────────┴─────────────────────┴──────────┴───┴────────────────────┴──────────────────────┴─────────┴────────────┴─────────┤
│ 8 rows                                                                                                                                      23 columns (10 shown) │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Create a DuckDB database and import the audit.log json file

```
duckdb git-events.db
```

#### Import the audit.json file into a table called "audit"

```sql
CREATE TABLE audit AS SELECT * FROM read_json_auto('audit.json');
```

#### Select action and group by minute

```sql
SELECT
 action,
  DATE_TRUNC('minute', to_timestamp("@timestamp"/1000)) AS minute,
  COUNT(*) AS count
FROM audit
GROUP BY DATE_TRUNC('minute', to_timestamp("@timestamp"/1000)), action
ORDER BY minute;
```

```
┌───────────┬──────────────────────────┬───────┐
│  action   │          minute          │ count │
│  varchar  │ timestamp with time zone │ int64 │
├───────────┼──────────────────────────┼───────┤
│ git.fetch │ 2024-04-19 11:43:00+01   │     1 │
│ git.clone │ 2024-04-19 11:43:00+01   │     1 │
│ git.fetch │ 2024-04-19 11:44:00+01   │     6 │
│ git.clone │ 2024-04-19 11:44:00+01   │     1 │
│ git.fetch │ 2024-04-19 11:45:00+01   │     1 │
│ git.clone │ 2024-04-19 11:45:00+01   │     1 │
│ git.fetch │ 2024-04-19 14:48:00+01   │     4 │
│ git.clone │ 2024-04-19 14:48:00+01   │     2 │
│ git.push  │ 2024-04-19 14:49:00+01   │     2 │
│ git.clone │ 2024-04-19 14:49:00+01   │     1 │
│ git.fetch │ 2024-04-19 15:12:00+01   │     3 │
│ git.clone │ 2024-04-19 15:12:00+01   │     1 │
│ git.fetch │ 2024-04-19 15:13:00+01   │     2 │
│ git.clone │ 2024-04-19 15:13:00+01   │     1 │
│ git.fetch │ 2024-04-20 07:41:00+01   │     1 │
│ git.clone │ 2024-04-20 07:41:00+01   │     3 │
│ git.push  │ 2024-04-20 07:41:00+01   │     2 │
│ git.push  │ 2024-04-20 07:50:00+01   │     2 │
│ git.fetch │ 2024-04-20 07:50:00+01   │     1 │
│ git.clone │ 2024-04-20 07:50:00+01   │     2 │
│ git.fetch │ 2024-04-20 08:04:00+01   │     2 │
│ git.clone │ 2024-04-20 08:04:00+01   │     2 │
│ git.push  │ 2024-04-20 08:04:00+01   │     2 │
├───────────┴──────────────────────────┴───────┤
│ 23 rows                            3 columns │
└──────────────────────────────────────────────┘
```

