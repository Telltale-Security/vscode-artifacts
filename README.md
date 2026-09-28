# VS Code Extension Artifacts

This repo holds some resources to help defenders hunt for malicious extensions. Its accompanying blog post can be found [here](https://telltalesecurity.com/blog/malicious-vscode-artifacts).


## Repository Contents

| Path | Description |
| ---- | ----------- |
| [`Artifacts/`](Artifacts/) | Holds example files. Useful when building your own parser. |
| [`ESQL/launched-extensions.esql`](ESQL/launched-extensions.esql) | Example query to fetch extensions which were activated (must already be parsed by the exthost ingest pipeline) |
| [`ESQL/parse-exthost.esql`](ESQL/parse-exthost.esql) | Query to parse the exthost.log file on the fly |
| [`Index-Templates/`](Index-Templates/) | Holds index templates for the indexes which hold the removal list from Microsoft. |
| [`OSQuery/installed-extensions.sql`](OSQuery/installed-extensions.sql) | Example osquery query to fetch all installed extensions |
| [`OSQuery/pack.json`](OSQuery/pack.json) | osquery pack which runs the query above every 15 minutes on Windows hosts |
| [`Pipelines/`](Pipelines/) | Holds all ingest pipelines |
| [`Rules/`](Rules/) | Holds two rules, which trigger on an indicator match. |
| [`Workflows/`](Workflows/) | Holds the workflow which fetches Microsoft's removed list and updates the indexes. |
| [`deploy.sh`](deploy.sh) | Installs the pipelines, index templates, osquery pack, rules and workflow in Elastic. |
