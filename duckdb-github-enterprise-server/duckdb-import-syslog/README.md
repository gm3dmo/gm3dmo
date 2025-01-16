
## Query a Syslog File for Streaks
A streak is where the same deamon writes to the syslog more than once in a row. Streaks of long duration may be  problematic.

#### Open the support bundle

#### Clone the syslog-to-csv repo into the support bundle

```
git clone https://github.com/gm3dmo/syslog-to-csv
```


#### Run syslog-to-csv.py to create a syslog.csv file

```
pypy3 syslog-to-csv/syslog-to-csv.py --csv-file system-logs/syslog.csv system-logs/syslog
```

The output looks something like:

```
INFO:syslog-to-csv:filename: system-logs/syslog
INFO:syslog-to-csv:filename.stem: syslog
INFO:syslog-to-csv:filename.suffix: ()
INFO:syslog-to-csv:filename.size: 13.5 GB
INFO:syslog-to-csv:filename.log_type: syslog
INFO:syslog-to-csv:Converted file: system-logs/syslog size type: syslog to CSV file system-logs/syslog.csv size 13152522261 bytes or roughly 12.2 GB.
```

syslog-to-csv.py may warn about lines that could not be processed. These may be ignored:

```
WARNING:syslog-to-csv:squib: line 3047437 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3047438 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3047439 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3047440 (  "BalancerAttributes": null,) not enough values to unpack (expected 3, got 1)
WARNING:syslog-to-csv:squib: line 3047441 is not minimum length of (15) characters
WARNING:syslog-to-csv:squib: line 3047442 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3047443 (}. Err: connection error: desc = "error reading server preface: read tcp 127.0.0.1:57334->127.0.0.1:6002: use of closed network connection") time data '2025 }. Err: connect' does not match format '%Y %b %d %H:%M:%S'
WARNING:syslog-to-csv:squib: line 3048660 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3048661 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 3048662 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3048663 (  "BalancerAttributes": null,) not enough values to unpack (expected 3, got 1)
WARNING:syslog-to-csv:squib: line 3048664 is not minimum length of (15) characters
WARNING:syslog-to-csv:squib: line 3048665 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 3048666 (}. Err: connection error: desc = "transport: Error while dialing dial tcp 127.0.0.1:6002: operation was canceled") time data '2025 }. Err: connect' does not match format '%Y %b %d %H:%M:%S'
WARNING:syslog-to-csv:squib: line 15110048 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 15110049 does not have host/daemon portion.
WARNING:syslog-to-csv:squib: line 15110050 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 15110051 (  "BalancerAttributes": null,) not enough values to unpack (expected 3, got 1)
WARNING:syslog-to-csv:squib: line 15110052 is not minimum length of (15) characters
WARNING:syslog-to-csv:squib: line 15110053 does not have host/daemon portion.
WARNING:syslog-to-csv:Could not parse: 15110054 (}. Err: connection error: desc = "transport: Error while dialing dial tcp 127.0.0.1:6002: operation was canceled") time data '2025 }. Err: connect' does not match format '%Y %b %d %H:%M:%S'
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
.timer on
CREATE TABLE syslog AS
     SELECT * FROM 'system-logs/syslog.csv';
```

Result:

```
Run Time (s): real 30.742 user 110.845174 sys 202.077361
```

The 14Gb of syslog has been reduced significantly by DuckDB and is now 48Mb of database file:

```
ls -lh duckdb
-rwxr-xr-x 1 gm3dmo gm3dmo 48M Nov  4 09:01 duckdb
```

#### Query the syslog for "streaks"

Switch on the timer and column modes:

```
.timer on
.mode column

```

Run the query:

```sql
WITH sequence_groups AS (
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
ORDER BY streak_length DESC
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

### Babeld

```
pypy3 klp.py --stats babeld-logs/babeld.log  --output-format csv > babeld-logs/babeld.csv -k ts,pid,tid,version,proto,id,http_url,http_ua,ip,xff_ip,repo,cmd,duration_ms,sr,ss,fs_sent,fs_recv,client_recv,client_send,log_level,msg,banner,best_kex,best_sigtype,best_cipher,best_mac,kex,keytype,sigtype,cipher,hmac,fp_sha256,pk_ms,srcp,dstp,fs_host,repo_public,gpv,client_sent,fsc_ms,ac_ms,ssh_cmd,user_agent,cid,cactive,ctotal,code,status,auth_tries,probe_ok,probe_fail,cr,creason,imode,user,http_status,auth_status,have_count,want_count,vk_ms,out_hash,entries_total,entries_freed,hits_ok,hits_unknown,expired_via_get,repl_host,ridx,sb_rs_po,cb,prerx,ct,postrx,nru,gt_ms,srq_ok,srq_bad,hin,hout,sin,sout,siocin,siocout,fds,fde,conn_progress
```


```.timer on
CREATE TABLE babeld AS
     SELECT * FROM 'babeld-logs/babeld.csv';
```


### Unicorn

```
pypy3 klp.py --stats github-logs/unicorn.log  --output-format csv > github-logs/unicorn.csv -k Timestamp,InstrumentationScope,SeverityText,Body,TraceId,SpanId,TraceFlags,gh.repo.id,gh.repo.name,gh.repo.name_with_owner,gh.authzd.fgp,code.function,gh.sdk.name,gh.sdk.version,service.name,service.version,deployment.environment,host.name,ParentSpanId,gh.auth.fingerprint,code.namespace,gh.api.version,gh.auth.type,gh.actor.id,gh.actor.login,gh.integration.id,gh.installation.id,gh.api.is_protected_by_hmac,http.request.header.x_real_ip,http.request.header.x_forwarded_for,http.route,gh.organization.id,gh.organization.login,gh.rate_limit.primary.max,gh.rate_limit.primary.remaining,gh.rate_limit.primary.key,gh.rate_limit.primary.used,gh.rate_limit.primary.reset,gh.rate_limit.primary.family,gh.repo.visibility,gh.api.requested_version,gh.api.selected_version,gh.api.selected_version_reason,now,request_id,datacenter,server_id,remote_address,request_method,request_host,path_info,content_length,content_type,user_agent,accept,referer,status,elapsed,url,worker_request_count,worker_pid,worker_number,request_category,route,gh.request_id,http.host,http.scheme,http.method,http.target,http.url,http.status_code,http.client_ip,http.server_name,http.request.header.referer,http.request.header.accept,http.user_agent,http.response.header.content_type,http.response_content_length,gh.request.api.route,http.query,gh.auth.password_attempt,gh.auth.token_attempt,gh.auth.auth_attempt_data,gh.auth.result,gh.auth.origin,gh.auth.login,gh.enduser.id,gh.auth.hashed_token,gh.auth.token_type,gh.auth.programmatic_access_type,gh.auth.token_id,gh.api.is_unconverted_path,gh.graphql.global_id_type,gh.oauth.access.id,enduser.scope,gh.oauth.app.party_type,gh.parent_installation.id,gh.oauth.app.id,language,http.request.header.accept_language,user,user_spammy,user_session_id,time_zone,controller,action,stateless,x_requested_with,http.request.header.x_requested_with,peer.service,auth,oauth_access_id,gh.code_scanning.codeql_action.report_status.action_name,gh.code_scanning.codeql_action.report_status.action_oid,gh.code_scanning.codeql_action.report_status.action_ref,gh.code_scanning.codeql_action.report_status.action_started_at,gh.code_scanning.codeql_action.report_status.action_version,gh.code_scanning.codeql_action.report_status.analysis_key,gh.code_scanning.codeql_action.report_status.commit_oid,gh.code_scanning.codeql_action.report_status.job_name,gh.code_scanning.codeql_action.report_status.job_run_uuid,gh.code_scanning.codeql_action.report_status.ref,gh.code_scanning.codeql_action.report_status.runner_available_disk_space_bytes,gh.code_scanning.codeql_action.report_status.runner_os,gh.code_scanning.codeql_action.report_status.runner_total_disk_space_bytes,gh.code_scanning.codeql_action.report_status.started_at,gh.code_scanning.codeql_action.report_status.status,gh.code_scanning.codeql_action.report_status.testing_environment,gh.code_scanning.codeql_action.report_status.workflow_name,gh.code_scanning.codeql_action.report_status.workflow_run_attempt,gh.code_scanning.codeql_action.report_status.workflow_run_id,gh.code_scanning.codeql_action.report_status.completed_at,gh.code_scanning.codeql_action.report_status.runner_arch,gh.code_scanning.codeql_action.report_status.upload_failed_run_skipped_because,gh.code_scanning.codeql_action.report_status.feature_flags_status,gh.code_scanning.codeql_action.report_status.event_reports,gh.code_scanning.codeql_action.report_status.properties,gh.code_scanning.codeql_action.report_status.matrix_vars,repo,lfs_media_upload_scope,gh.elasticsearch.index,gh.elasticsearch.query,gh.elasticsearch.escaped_query,gh.actor.spammy,gh.search.context,http.request.header.x_original_user_agent,gh.context.from,gh.originating_request_id,gh.api.query,gh.search.server.timed_out,gh.search.cache_key.value,gh.catalog_service,gh.webhook.delivery_guid,gh.webhook.event_type,gh.repo.global_id,worker,gh.org.id,gh.org.login,gh.auth.result.message,gh.auth.failure.type,gh.auth.failure.reason,job,gh.check_run.id,gh.check_run.status,gh.check_run.conclusion,gh.check_run.created_at,gh.check_run.updated_at,gh.check_run.started_at,gh.check_suite.id,gh.check_suite.status,gh.check_suite.created_at,gh.check_suite.updated_at,pair_id,gh.check_suite.rollup_status,gh.check_suite.previous_status,gh.repo.branch_count,gh.actions.workflow_files.updated_count,gh.actions.ref_update.before_oid,gh.actions.ref_update.after_oid,git.ref,git.commit.oid,gh.code_scanning.analysis.category,gh.kv.key,gh.code_scanning.codeql_action.report_status.codeql_version,gh.code_scanning.codeql_action.report_status.tools_input,gh.code_scanning.codeql_action.report_status.tools_resolved_version,gh.code_scanning.codeql_action.report_status.tools_source,gh.code_scanning.codeql_action.report_status.workflow_languages,gh.code_scanning.codeql_action.report_status.disable_default_queries,gh.code_scanning.codeql_action.report_status.languages,gh.code_scanning.codeql_action.report_status.paths,gh.code_scanning.codeql_action.report_status.paths_ignore,gh.code_scanning.codeql_action.report_status.queries,gh.code_scanning.codeql_action.report_status.trap_cache_languages,gh.code_scanning.codeql_action.report_status.trap_cache_download_size_bytes,gh.code_scanning.codeql_action.report_status.trap_cache_download_duration_ms,gh.code_scanning.codeql_action.report_status.autobuild_languages,gh.security_center.step,gh.request.controller,gh.security_center.elapsed_ms,gh.check_suite.conclusion,gh.auth.raw_login,gh.actor.class_name,gh.branch_protection_rule.rule_suite.ref_name,gh.branch_protection_rule.rule_suite.before_commit,gh.branch_protection_rule.rule_suite.after_commit,gh.branch_protection_rule.rule_suite.rule_commit,gh.branch_protection_rule.rule_suite.rules_fulfilled,gh.branch_protection_rule.rule_suite.result,gh.branch_protection_rule.rule_suite.rule_runs,app,env,enterprise,method,priority,before_checksum,at,result,client_err,threepc_client,gh.issue.id,gh.issue.orchestration.id,gh.issue.orchestration.type,gh.issue.orchestration.state,gh.issue.orchestration.step_name,gh.issue.orchestration.attempts,gh.issue.orchestration.data,gh.notifications.rollup_summary.id,gh.notifications.rollup_summary.method,gh.notifications.update_summary.subject_type,gh.notifications.update_summary.subject_id,gh.notifications.update_summary.status,gh.notifications.update_summary.duration,gh.notifications_list.id,gh.notifications_list.klass,gh.notifications_thread.id,gh.notifications_thread.klass,gh.check_suite.new_status,gh.git.ref,gh.git.sha,gh.code_scanning.sarif.id,gh.code_scanning.sarif.size,gh.code_scanning.sarif.uri,gh.code_scanning.codeql_action.report_status.analyze_builtin_queries_java_duration_ms,gh.code_scanning.codeql_action.report_status.interpret_results_java_duration_ms,gh.code_scanning.codeql_action.report_status.raw_upload_size_bytes,gh.code_scanning.codeql_action.report_status.zipped_upload_size_bytes,gh.code_scanning.codeql_action.report_status.num_results_in_sarif,gh.code_scanning.codeql_action.report_status.scanned_language_extraction_duration_ms,gh.code_scanning.codeql_action.report_status.trap_import_duration_ms,gh.code_scanning.codeql_action.report_status.trap_cache_upload_duration_ms,gh.code_scanning.codeql_action.report_status.trap_cache_upload_size_bytes,gh.issue_comment.id,gh.issue_comment.orchestration.id,gh.issue_comment.orchestration.type,gh.issue_comment.orchestration.state,gh.issue_comment.orchestration.step_name,gh.issue_comment.orchestration.attempts,gh.issue_comment.orchestration.data,gh.pull_request.id,gh.pull_request_review_comment.orchestration.id,gh.pull_request_review_comment.orchestration.type,gh.pull_request_review_comment.orchestration.state,gh.pull_request_review_comment.orchestration.step_name,gh.pull_request_review_comment.orchestration.attempts,gh.pull_request_review_comment.orchestration.data,gh.pull_request_review_comment.id,gh.code_scanning.codeql_action.report_status.analyze_builtin_queries_javascript_duration_ms,gh.code_scanning.codeql_action.report_status.interpret_results_javascript_duration_ms,gh.auth.failure.name,gist,gh.oauth.method,gh.oauth.passed_callback,gh.oauth_application.id,oauth_application_id,gh.saml.raw_request,gh.saml.login,gh.saml.response.attributes,gh.enduser.login,saml.session.expires_at,gh.pull_request.codeowners.file_size,gh.pull_request.codeowners.num_paths,gh.pull_request.codeowners.num_rules,visibility,gh.context.url,installations_repositories_all,repositories_count,exception,db.system,level,gh.actions.workflow_exists_on_default_branch,gh.actor.ip,gh.actor.ip_was,gh.actor.location,gh.actor.location_was,associated_user.ids,associated_user.logins,session.id,client_id,update_at_was,integration_id,lfs_deploy_key_header,lfs_auth_scope,lfs_verify_reason,gh.code_scanning.codeql_action.report_status.sarifID,gh.user_programmatic_access.id,verification_code,gh.search.error.name,exception.type,exception.message,exception.stacktrace,gh.security_center.api.client.name,gh.owner.id,gh.owner.login,gh.authzd.rpc,gh.authzd.request.attributes,gh.authzd.decisions,timeout,gh.circuit_breaker.names,before_fork,duration,after_fork,msg,repo_id,network_id,repo_type,rows,last_insert_id,gh.repo.orchestration.id,gh.repo.orchestration.type,gh.repo.orchestration.state,gh.repo.orchestration.step_name,gh.repo.orchestration.attempts,gh.repo.orchestration.data,gh.repo.network_id,gh.prioritizable.sbt.unexpected_options,gh.user.id,gh.user.login,gh.notifications.avoided_users_ids,gh.notifications.avoided_users_logins,gh.code_scanning.codeql_action.report_status.cause,gh.code_scanning.codeql_action.report_status.exception,InstrumentatTimestamp,ionScope,gh.code_scanning.codeql_action.report_status.analyze_builtin_queries_go_duration_ms,gh.code_scanning.codeql_action.report_status.interpret_results_go_duration_ms,app_name,gh.repo.root,gh.repo.path,elapsed_locking,elapsed_under_lock,0a0b1a5afcd3_phase,0a0b1a5afcd3_checksum,0e2e0ee92497_phase,0e2e0ee92497_checksum,gh.creator_id,gh.deployment_id,gh.deployment.ref,gh.deployment.check_run_id,gh.deployment.new_latest_deployment_status_id,gh.deployment.new_latest_status_state,gh.deployment.previous_latest_environment,gh.deployment.new_latest_environment,gh.deployment.previous_latest_environment_id,gh.deployment.new_latest_environment_id,gh.deployment.previous_latest_deployment_status_id,gh.deployment.previous_latest_status_state,gh.job.id,gh.pages.queue.name,gh.pages.request.id,gh.correlation_id,gh.job.queue,gh.job.name,gh.server_id,preference,gh.security_center.source_event,robot,gh.code_scanning.codeql_action.report_status.autobuild_failure,gh.rate_limit.secondary.max,gh.rate_limit.secondary.ttl,gh.rate_limit.secondary.key,gh.rate_limit.secondary.limit_reason,gh.notifications.action,gh.notifications.service,gh.notifications.thread.type,gh.notifications.thread.id,lfs_missing_objects_count,gh.user.display_name,gh.user.email,gh.actions.workflow_exists_on_other_branch,gh.app.id,gh.app.name,gh.app.owner,gh.actions.auth_via_pat_without_workflow_scope,gh.actions.public_key_created_by_unknown,commit_metadata_keys,gh.issue.branch_name,gh.issue.source_branch_name,gh.commit.oid,gh.pull_request.base_sha.old,gh.pull_request.base_sha.new,gh.pull_request.base_ref.old,gh.pull_request.base_ref.new,gh.saml.errors,gh.saml.params,gh.commit.sha,gh.actions.tree_oid,gh.actions.default_branch_triggers,gh.actions.workflow_files.count,gh.actions.workflow_environment,gh.actions.default_branch,signal,wpid
```


```.timer on
CREATE TABLE unicorn AS
     SELECT * FROM 'github-logs/unicorn.csv';
```
