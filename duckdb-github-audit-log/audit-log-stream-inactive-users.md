#### Extract Users from Audit log stream with no activity in the last 30 days

Use [list-enterprise-consumed-licenses-saml-name-id-csv.sh](https://github.com/gm3dmo/the-power/blob/main/list-enterprise-consumed-licenses-saml-name-id-csv.sh)

```
./list-enterprise-consumed-licenses-saml-name-id-csv.sh > enterprise_users.csv
```

Create `enterprise_users` table and populate it with `enteprise_users.csv` file

```sql
CREATE TABLE enterprise_users AS
SELECT *
FROM read_csv_auto('enterprise_users.csv');
```

Query to find enterprise_users with no activity for 30 days:

```sql
SELECT
    eu.github_com_login,
    TO_TIMESTAMP(al.last_activity_timestamp / 1000) AS last_activity_date
  FROM
    enterprise_users eu
  LEFT JOIN (
    SELECT
      actor,
      MAX("@timestamp") AS last_activity_timestamp
    FROM
      audit_log
    GROUP BY
      actor
  ) al ON eu.github_com_login = al.actor
  WHERE
    al.last_activity_timestamp IS NULL
    OR al.last_activity_timestamp < (EXTRACT(EPOCH FROM NOW() - INTERVAL '30' DAY) * 1000)
  ORDER BY
    last_activity_date ASC;
```

Result:

```
┌──────────────────────────┬────────────────────────────┐
│   github_com_login       │     last_activity_date     │
│       varchar            │  timestamp with time zone  │
├──────────────────────────┼────────────────────────────┤
│ pipcrispy                │ 2024-03-28 20:11:03.923+00 │
│ robin-of-loxley          │ 2024-03-28 20:11:04.795+00 │
│ roger-de-courcey         │ 2024-06-06 18:01:37.851+01 │
│ banned-from-urgent       │ 2024-10-08 16:14:50.991+01 │
│ somebody-we-used-to-know │                            │
└──────────────────────────┴────────────────────────────┘
```
