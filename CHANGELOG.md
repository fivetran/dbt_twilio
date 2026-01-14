# dbt_twilio v1.3.0

[PR #20](https://github.com/fivetran/dbt_twilio/pull/20) includes the following updates:

## Documentation
- Updates README with standardized Fivetran formatting

## Under the Hood
- In the `.quickstart.yml` file:
  - Adds `table_variables` for relevant sources to prevent missing sources from blocking downstream Quickstart models.
  - Adds `supported_vars` for Quickstart UI customization,

# dbt_twilio v1.2.0

[PR #19](https://github.com/fivetran/dbt_twilio/pull/19) includes the following updates:

## Features
  - Increases the required dbt version upper limit to v3.0.0

# dbt_twilio v1.1.0

[PR #18](https://github.com/fivetran/dbt_twilio/pull/18) includes the following updates:

## Schema/Data Change
**1 total change • 0 possible breaking changes**

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | ----| --- | ----- |
| All models | New column | | `source_relation` | Identifies the source connection when using multiple Twilio connections |

## Feature Update
- **Union Data Functionality**: This release supports running the package on multiple Twilio source connections. See the [README](https://github.com/fivetran/dbt_twilio/tree/main?tab=readme-ov-file#step-3-define-database-and-schema-variables) for details on how to leverage this feature.

## Tests Update
- Removes uniqueness tests. The new unioning feature requires combination-of-column tests to consider the new `source_relation` column in addition to the existing primary key, but this is not supported across dbt versions.
  - These tests will be reintroduced once a version-agnostic solution is available.

## Under the Hood
- Added consistency validation tests for all end models (`twilio__account_overview`, `twilio__message_enhanced`, `twilio__number_overview`) to compare results between dev and prod schemas.

# dbt_twilio v1.0.0

[PR #17](https://github.com/fivetran/dbt_twilio/pull/17) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/twilio_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/twilio_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/twilio_source` package will also need to be removed or updated to reference this package.
  - Update any twilio_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_twilio/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_twilio.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

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
