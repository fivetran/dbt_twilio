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
