
Be careful. Doing this on a large production server you'll need to make sure and not fill the root with `dump.json`. It's going to dump the entire audit log.

```
/usr/local/share/enterprise/ghe-es-dump-json 'http://localhost:9200/audit_log*' > dump.json
```


```
scp -P 122 admin@${ghes_hostname}:dump.json
```

```sql
CREATE TABLE audit_log AS SELECT * FROM read_json_auto('dump.json');
```

```sql
CREATE TABLE extracted_audit_log AS
SELECT
    _index,
    _type,
    _id,
    json_extract_string(_source, '$.actor_ip') AS actor_ip,
    json_extract_string(_source, '$.from') AS source_from,
    json_extract_string(_source, '$.actor') AS actor,
    TRY_CAST(json_extract_string(_source, '$.actor_id') AS INTEGER) AS actor_id,
    json_extract_string(_source, '$.org') AS org,
    TRY_CAST(json_extract_string(_source, '$.org_id') AS INTEGER) AS org_id,
    json_extract_string(_source, '$.user') AS user,
    TRY_CAST(json_extract_string(_source, '$.user_id') AS INTEGER) AS user_id,
    json_extract_string(_source, '$.action') AS action,
    DATE_TRUNC('day', TO_TIMESTAMP(CAST(json_extract_string(_source, '$.@timestamp') AS BIGINT) / 1000)) AS timestamp_date,
    TRY_CAST(json_extract_string(_source, '$.created_at') AS BIGINT) AS created_at,
    json_extract_string(_source, '$.operation_type') AS operation_type,
    json_extract_string(json_extract(_source, '$.actor_location'), '$.country_code') AS country_code,
    json_extract_string(json_extract(_source, '$.actor_location'), '$.country_name') AS country_name,
    json_extract_string(json_extract(_source, '$.actor_location'), '$.region') AS region,
    json_extract_string(json_extract(_source, '$.actor_location'), '$.region_name') AS region_name,
    json_extract_string(json_extract(_source, '$.actor_location'), '$.city') AS city,
    json_extract_string(json_extract(_source, '$.actor_location'), '$.postal_code') AS postal_code,
    TRY_CAST(json_extract_string(json_extract(_source, '$.actor_location.location'), '$.lat') AS DOUBLE) AS lat,
    TRY_CAST(json_extract_string(json_extract(_source, '$.actor_location.location'), '$.lon') AS DOUBLE) AS lon,
    json_extract_string(json_extract(_source, '$.data'), '$.user_agent') AS user_agent,
    json_extract_string(json_extract(_source, '$.data'), '$.controller') AS controller,
    json_extract_string(json_extract(_source, '$.data'), '$.request_id') AS request_id,
    json_extract_string(json_extract(_source, '$.data'), '$.request_method') AS request_method,
    json_extract_string(json_extract(_source, '$.data'), '$.request_category') AS request_category,
    json_extract_string(json_extract(_source, '$.data'), '$.server_id') AS server_id,
    json_extract_string(json_extract(_source, '$.data'), '$.version') AS version,
    json_extract_string(json_extract(_source, '$.data'), '$.hashed_token') AS hashed_token,
    json_extract_string(json_extract(_source, '$.data'), '$.token_type') AS token_type,
    json_extract_string(json_extract(_source, '$.data'), '$.programmatic_access_type') AS programmatic_access_type,
    json_extract_string(json_extract(_source, '$.data'), '$.auth') AS auth,
    json_extract_string(json_extract(_source, '$.data'), '$.current_user') AS current_user,
    json_extract_string(json_extract(_source, '$.data'), '$.oauth_scopes') AS oauth_scopes,
    TRY_CAST(json_extract_string(json_extract(_source, '$.data'), '$.oauth_access_id') AS INTEGER) AS oauth_access_id,
    TRY_CAST(json_extract_string(json_extract(_source, '$.data'), '$.token_id') AS INTEGER) AS token_id,
    json_extract_string(json_extract(_source, '$.data'), '$.token_scopes') AS token_scopes,
    json_extract_string(json_extract(_source, '$.data'), '$.category_type') AS category_type
FROM
    audit_log;
```

```sql
SELECT
    user,
    action,
    DATE_TRUNC('hour', timestamp_date) AS hour,
    COUNT(*) AS count
FROM
    extracted_audit_log
GROUP BY
    user,
    action,
    hour
ORDER BY
    hour;
```
