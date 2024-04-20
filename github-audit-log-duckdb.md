# Extracting information from GitHub Audit log exports with DuckDB

Having [exported git events](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/exporting-audit-log-activity-for-your-enterprise#exporting-git-events-data) from my organization and stored them in a file named `git-events.json` I found that json is not the most pleasant thing to read:

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

#### Create a DuckDB database and import the `git-events.log` json file

```
duckdb github-enterprise-audit.db
```

#### Import the `git-events.json` file into a table called "gitevents"
This will create a table in the database containing all the data from git-events.json.

```sql
CREATE TABLE gitevents AS SELECT * FROM read_json_auto('git-events.json');
```

#### Select action and group by hour

```sql
SELECT
  DATE_TRUNC('hour', to_timestamp("@timestamp"/1000)) AS hour,
  COUNT(*) AS count,
   action
FROM gitevents
GROUP BY DATE_TRUNC('hour', to_timestamp("@timestamp"/1000)), action
ORDER BY hour;
```

```

```

### Create a table for the audit event
Follow the steps for [exporting audit log activity for your enterprise](
https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/exporting-audit-log-activity-for-your-enterprise#exporting-audit-log-data)

Save the audit log events to a file called`events.json`.

```
duckdb github-enterprise-audit.db
```

```sql
CREATE TABLE events AS SELECT * FROM read_json_auto('events.json',  ignore_errors=true);
```

#### Extract actions per minute

```sql
SELECT
 action,
  DATE_TRUNC('minute', to_timestamp("@timestamp"/1000)) AS minute,
  COUNT(*) AS count
FROM events
GROUP BY DATE_TRUNC('minute', to_timestamp("@timestamp"/1000)), action
ORDER BY minute;
```

#### Output CSV format

```sql
.mode csv
.headers on
SELECT
 action,
  DATE_TRUNC('minute', to_timestamp("@timestamp"/1000)) AS minute,
  COUNT(*) AS count
FROM events
GROUP BY DATE_TRUNC('minute', to_timestamp("@timestamp"/1000)), action
ORDER BY minute;
```

#### Create a CSV report file by hour

```sql
COPY (
SELECT
  DATE_TRUNC('hour', to_timestamp("@timestamp"/1000)) AS hour,
  action,
  COUNT(*) AS count
FROM events
GROUP BY DATE_TRUNC('hour', to_timestamp("@timestamp"/1000)), action
ORDER BY hour) TO 'events-by-hour.csv' (HEADER, DELIMITER ',');
```
