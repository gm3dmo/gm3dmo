
#### GitHub Audit log Stream
Why stream the audit log?
- When (not if) a security incident is experienced you'll thank yourself for having the audit log streamed to at least one read only location that is not GitHub.
- The [GitHub hosted copy if the audit log is limited to 180 days](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise)

  With audit log streaming established a new data source for activity across your enterprise is established.
  


- [Load the audit log stream into DuckDB](github-audit-log-stream-duckdb.md)
- [Query for users inactive 30 days](audit-log-stream-inactive-users.md)
