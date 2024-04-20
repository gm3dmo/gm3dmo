# Making sense of the GitHub Audit log exports
Having [exported git events](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/exporting-audit-log-activity-for-your-enterprise#exporting-git-events-data) from my organization I wanted to be able to do some quick reports. Install duckdb

### Reading git audit log events with DuckDB

Load the audit.json file into DuckDB and select:

```sql
D select * from './audit.json';
```

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
