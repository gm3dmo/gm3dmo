
#### GitHub Audit log Stream
Why stream the audit log?
- When (not if) a security incident is experienced you'll thank yourself for having the audit log streamed to at least one read only location that is not GitHub.

Bear in mind:
- The [GitHub hosted copy of the audit log is limited to 180 days](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise)
- [Git events are not included in search results](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/searching-the-audit-log-for-your-enterprise#search-based-on-the-action-performed) on the web UI.
- [By default, only events from the past three months are displayed. To view older events, you must specify a date range with the created parameter. ](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/searching-the-audit-log-for-your-enterprise#about-search-for-the-enterprise-audit-log)

With audit log streaming established a new data source for activity across your enterprise is available.
  
- [Load the audit log stream into DuckDB](github-audit-log-stream-duckdb.md)
- [Query for users inactive 30 days](audit-log-stream-inactive-users.md)
