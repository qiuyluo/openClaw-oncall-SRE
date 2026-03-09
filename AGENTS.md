# Multi-Agent Workflow Definition

## Agent: SRE-Agent
- **Tools**: Grafana, Slack
- **Operating Logic**:
  1. **Inspection**: Call `grafana.query_prometheus` to check:
     - `Error Rate`: `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))`
     - `P99 Latency`: `histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))`
  2. **Triage**: If `Error Rate > 0.01` or `P99 > 200ms`, escalate the incident.
  3. **Evidence Gathering**: Call `grafana.get_loki_logs` for `{level="error"}` in the last 10 minutes.
  4. **Reporting**: Use `slack.post_message` to `#oncall-alerts`. Include the metric value and a summary of the error logs.
  5. **Handover**: Delegate the investigation to `Dev-Agent` by providing the log context.

## Agent: Dev-Agent
- **Tools**: GitHub, Slack
- **Operating Logic**:
  1. **Traceability**: Search for recent code changes via `github.get_recent_commits` for the relevant repository.
  2. **Correlation**: Match the stack traces or error patterns from SRE-Agent with recent PR diffs.
  3. **Action**: 
     - Call `github.create_issue` with the label `auto-oncall-rca`.
     - Summarize the "Likely Root Cause" (e.g., "Regression in PR #452").
  4. **Feedback**: Reply to the Slack alert thread with the GitHub Issue link and a "Recommended Next Step" (e.g., Rollback or Hotfix).
