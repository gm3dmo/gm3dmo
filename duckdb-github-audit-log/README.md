
#### GitHub Audit log Stream
Why stream the audit log?
- When (not if) a security incident is experienced you'll thank yourself for having the audit log streamed to at least one read only location that is not GitHub.

Bear in mind:
- The [GitHub hosted copy of the audit log is limited to 180 days](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise) if you need a longer period then you'll need to set up audit log streaming.
- [Git events are not included in search results](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/searching-the-audit-log-for-your-enterprise#search-based-on-the-action-performed) on the web UI.
- [By default, only events from the past three months are displayed. To view older events, you must specify a date range with the created parameter. ](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/searching-the-audit-log-for-your-enterprise#about-search-for-the-enterprise-audit-log)
- [You can configure a retention period for audit log data and see index storage details. After you configure a retention period, you can enable or disable Git-related events from appearing in the audit log](https://docs.github.com/en/enterprise-server@3.15/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/configuring-the-audit-log-for-your-enterprise#about-audit-log-configuration)

With audit log streaming established a new data source for activity across your enterprise is available.
  
- [Load the audit log stream into DuckDB](github-audit-log-stream-duckdb.md)
- [Query for users inactive 30 days](audit-log-stream-inactive-users.md)
