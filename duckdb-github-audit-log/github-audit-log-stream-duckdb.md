Download the audit log data stream. I've been using [Azure Storage Explorer](https://azure.microsoft.com/en-us/products/storage/storage-explorer/) for my test server but you man want to script something.

Create the `audit_log` table in DuckDB. I am ignoring errors and not building a schema here you may want to do more than this:

```sql
SET threads TO 16;
SET memory_limit = '16GB';
SET temp_directory='/tmp';
SET preserve_insertion_order = false;
CREATE TABLE audit_log_raw AS SELECT * FROM read_json_auto('./**/*.json.log.gz', ignore_errors = true);
```

Now create a view `audit_log` which has a human readable *_datetime* column
```sql
CREATE VIEW audit_log AS
SELECT *,
    to_timestamp("@timestamp" / 1000) AS _datetime
FROM audit_log_raw;
```

```sql
SELECT 
        action, _document_id, 
        actor,
        CAST(TO_TIMESTAMP("@timestamp" / 1000) AS DATETIME) AS timestamp_date
    FROM 
        audit_log;
```

```
┌────────────────────────────────────────────────────────────────┬──────────────────────────┬──────────────────────────┬─────────────────────────┐
│                             action                             │       _document_id       │          actor           │     timestamp_date      │
│                            varchar                             │         varchar          │         varchar          │        timestamp        │
├────────────────────────────────────────────────────────────────┼──────────────────────────┼──────────────────────────┼─────────────────────────┤
│ workflows.created_workflow_run                                 │ WxdCh1MT7gvTN0sX8VG9xQ   │ pipcrispy                │ 2024-09-01 01:46:21.713 │
│ workflows.completed_workflow_run                               │ ZtQK9ojXN5DqTZdgStwYDw   │ pipcrispy                │ 2024-09-01 01:46:23.774 │
│ workflows.created_workflow_run                                 │ IbtO9HBdURGCy6Y2ppQFFg   │ pipcrispy                │ 2024-09-01 01:49:55.508 │
│ workflows.completed_workflow_run                               │ 9kXsKTCX-tMXQa2cPrPENw   │ pipcrispy                │ 2024-09-01 01:49:57.667 │
```

Let's say we want to see the full record for `_document_id` **IbtO9HBdURGCy6Y2ppQFFg** we can use DuckDB's `.mode line` command to make the output format in lines:

```sql
 .mode line
D select * from audit_log where _document_id = 'IbtO9HBdURGCy6Y2ppQFFg';
                   @timestamp = 1725151795508
                 _document_id = IbtO9HBdURGCy6Y2ppQFFg
                       action = workflows.created_workflow_run
                        actor = pipcrispy
                     actor_id = 63502882
                 actor_is_bot = false
                     business = gm3dmo-enterprise-cloud-testing
                  business_id = 3082
                   created_at = 1725151795508
                        event = schedule
     external_identity_nameid = pip.crispy@gmail.com
                 hashed_token = 1dsBdHBCJOboxHLeziI9se9NEw9+0jFnq+2UBFTW9vo=
                  head_branch = main
                     head_sha = b22e6473485b0c5163de12360a1b00069e9efcf9
                         name = Alternative OS Build (Camel 4)
               operation_type = create
                          org = forest-town
                       org_id = 86825428
     programmatic_access_type = GitHub App server-to-server token
                  public_repo = true
                         repo = forest-town/repo-2823585
                      repo_id = 809894865
                   run_number = 615
                   started_at = 2024-09-01T00:49:55.000Z
                     token_id = 107896650106
                   trigger_id = 
                   user_agent = launch/production
                  workflow_id = 100949087
              workflow_run_id = 10649568281
                 completed_at = 
                   conclusion = 
                  run_attempt = 
                        topic = 
                     actor_ip = 
               actor_location = 
             application_name = 
                  integration = 
                 query_string = 
         rate_limit_remaining = 
                 request_body = 
               request_method = 
                        route = 
                  status_code = 
                 token_scopes = 
                     url_path = 
                         user = 
                      user_id = 
user_programmatic_access_name = 
         oauth_application_id = 
      audit_log_stream_result = 
```


```sql
SELECT 
      action, _document_id, 
      actor,
      CAST(TO_TIMESTAMP("@timestamp" / 1000) AS DATETIME) AS timestamp_date
  FROM 
      audit_log;
```

### Create a report on the busiest git users:

```sql
SELECT 
    DATE_TRUNC('day', TO_TIMESTAMP("@timestamp" / 1000)) AS day,
    action,
    actor,
    COUNT(*) AS activity_count
FROM 
    audit_log
WHERE
    action LIKE 'git.%'
GROUP BY 
    day, action, actor
ORDER BY 
    activity_count DESC;
```

```
┌──────────────────────────┬───────────┬──────────────────────────┬────────────────┐
│           day            │  action   │          actor           │ activity_count │
│ timestamp with time zone │  varchar  │         varchar          │     int64      │
├──────────────────────────┼───────────┼──────────────────────────┼────────────────┤
│ 2024-09-17 00:00:00+01   │ git.clone │ github-actions[bot]      │             37 │
│ 2024-09-03 00:00:00+01   │ git.clone │ github-actions[bot]      │             37 │
│ 2024-09-10 00:00:00+01   │ git.clone │ github-actions[bot]      │             37 │
│ 2024-09-02 00:00:00+01   │ git.fetch │ datadog-forest-town[bot] │             22 │
│ 2024-09-05 00:00:00+01   │ git.fetch │ datadog-forest-town[bot] │             14 │
│ 2024-09-11 00:00:00+01   │ git.clone │                          │             13 │
│ 2024-09-17 00:00:00+01   │ git.fetch │ datadog-forest-town[bot] │             12 │
│ 2024-09-09 00:00:00+01   │ git.fetch │ datadog-forest-town[bot] │             12 │
│ 2024-09-10 00:00:00+01   │ git.clone │                          │              9 │
│ 2024-09-04 00:00:00+01   │ git.fetch │ datadog-forest-town[bot] │              8 │
```
