# Agent Execution Schedules

## Periodic System Health Audit
- **Cron Expression**: `*/10 * * * *`
- **Task**: 
  "Trigger the SRE-Agent to perform a comprehensive health scan on the Grafana 'Main-Service-Metrics' dashboard. If any SLI (Service Level Indicator) breaches the defined thresholds, initiate the Root Cause Analysis (RCA) workflow with Dev-Agent."
