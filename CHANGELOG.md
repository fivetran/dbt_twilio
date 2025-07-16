[PR #15](https://github.com/fivetran/dbt_twilio/pull/15) includes the following updates:

### Under the Hood - July 2025 Updates

- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.
- Added `+docs: show: False` to `integration_tests/dbt_project.yml`.
- Migrated `flags` (e.g., `send_anonymous_usage_stats`, `use_colors`) from `sample.profiles.yml` to `integration_tests/dbt_project.yml`.
- Updated `maintainer_pull_request_template.md` with improved checklist.
- Refreshed README tag block:
  - Standardized Quickstart-compatible badge set
  - Left-aligned and positioned below the H1 title.
- Updated Python image version to `3.10.13` in `pipeline.yml`.
- Added `CI_DATABRICKS_DBT_CATALOG` to:
  - `.buildkite/hooks/pre-command` (as an export)
  - `pipeline.yml` (under the `environment` block, after `CI_DATABRICKS_DBT_TOKEN`)
- Added `certifi==2025.1.31` to `requirements.txt` (if missing).
- Updated `.gitignore` to exclude additional DBT, Python, and system artifacts.

# dbt_twilio v0.5.0

[PR #14](https://github.com/fivetran/dbt_twilio/pull/14) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Twilio Source v0.5.0](https://github.com/fivetran/dbt_twilio_source/releases/tag/v0.5.0)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `twilio` in file
`models/src_twilio.yml`. The `freshness` top-level property should be moved
into the `config` of `twilio`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Twilio freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `twilio` package. Pin your dependency on v0.4.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `twilio` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_twilio.yml` file and add an `overrides: twilio_source` property.

## Documentation
- Added Quickstart model counts to README. ([#12](https://github.com/fivetran/dbt_twilio/pull/12))
- Corrected references to connectors and connections in the README. ([#12](https://github.com/fivetran/dbt_twilio/pull/12))

## Under the Hood
- Updates to ensure integration tests use latest version of dbt.

# dbt_twilio v0.4.0

## Features
- Added the ability to disable the `USAGE_RECORD` source table via variable `using_twilio_usage_record` (default `true`). If disabled, downstream this will remove the `total_account_spend` field in `twilio__account_overview`. Refer to the [README](https://github.com/fivetran/dbt_twilio?tab=readme-ov-file#step-4-enablingdisabling-models) for more details. 

## Under the Hood
- Removes references to unused models in `twilio__message_enhanced`.

# dbt_twilio v0.3.0

> _Note_: This release is a 🚨 **breaking change** 🚨 due to breaking changes introduced in the upstream twilio_source package [v0.3.0](https://github.com/fivetran/dbt_twilio_source/releases/tag/v0.3.0) release, where we explicitly cast the below fields as float types and remove any non-numerical characters. 
- `queue_time, num_media, num_segments` in addition to the existing float-casted `duration, price, count, usage` fields

- Please be aware if you were expecting string values from these fields.

# dbt_twilio v0.2.0

> _Note_: This release is a 🚨 **breaking change** 🚨 due to breaking changes introduced in the upstream twilio_source package [v0.2.0](https://github.com/fivetran/dbt_twilio_source/releases/tag/v0.2.0) release, in which we have updated the `stg_*_tmp` models to use the `dbt_utils.star` macro instead of a basic `select *` ([PR #6](https://github.com/fivetran/dbt_twilio_source/pull/6)).

## Bug Fixes
- Fixed two testing-related typos in `twilio.yml` to conform to the [dbt YAML file JSON schema](https://github.com/dbt-labs/dbt-jsonschema/blob/main/schemas/dbt_yml_files.json#L683) ([PR #5](https://github.com/fivetran/dbt_twilio/pull/5)).
  - This was causing tests to not be run on the `message_id` column in `twilio__message_enhanced` nor the `account_id` field in `twilio__account_overview`.

## Features
- Added the ability to disable models related to the `CALL` source table. Refer to the [README](https://github.com/fivetran/dbt_twilio_source?tab=readme-ov-file#step-4-enablingdisabling-models) for more details ([twilio_source PR #5](https://github.com/fivetran/dbt_twilio_source/pull/5)).
- Ensured Fivetran's [Quickstart](https://fivetran.com/docs/transformations/quickstart) Data Models would be able to dynamically deploy the above `CALL` feature ([PR #6](https://github.com/fivetran/dbt_twilio/pull/6)).

## Under the Hood
- Updated the pull request [templates](/.github) ([PR #6](https://github.com/fivetran/dbt_twilio/pull/6)).
- Included auto-releaser GitHub Actions workflow to automate future releases ([PR #6](https://github.com/fivetran/dbt_twilio/pull/6)).

## Contributors
- [@raphaelvarieras](https://github.com/raphaelvarieras) ([PR #5](https://github.com/fivetran/dbt_twilio/pull/5) and [twilio_source PR #5](https://github.com/fivetran/dbt_twilio_source/pull/5)).

# dbt_twilio v0.1.0
## Initial Release
This is the first release of Fivetran Twilio dbt package! For more information, refer to the [README](/README.md)

This version of our dbt package focuses on Twilio's [Programmable Messaging](https://www.twilio.com/docs/messaging) product, specifically around the [Message Resource](https://www.twilio.com/docs/sms/api/message-resource).
