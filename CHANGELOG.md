# dbt_twilio v0.1.1

## Bug Fixes
- Fixed two testing-related typos in `twilio.yml` to conform to the [dbt YAML file JSON schema](https://github.com/dbt-labs/dbt-jsonschema/blob/main/schemas/dbt_yml_files.json#L683).
  - This was causing tests to not be run on the `message_id` column in `twilio__message_enhanced` nor the `account_id` field in `twilio__account_overview`.

## Features (from source package)
- Added the ability to disable models related to the `CALL` source table. Refer to the [README](https://github.com/fivetran/dbt_twilio_source?tab=readme-ov-file#step-4-enablingdisabling-models) for more details ([PR #5](https://github.com/fivetran/dbt_twilio_source/pull/5)).

## Under the Hood
- Updated the pull request [templates](/.github) ([PR #6](https://github.com/fivetran/dbt_twilio/pull/6)).
- Included auto-releaser GitHub Actions workflow to automate future releases ([PR #6](https://github.com/fivetran/dbt_twilio/pull/6)).

## Contributors
- [@raphaelvarieras](https://github.com/raphaelvarieras) ([PR #5](https://github.com/fivetran/dbt_twilio/pull/5) and [source PR #5](https://github.com/fivetran/dbt_twilio_source/pull/5)).

# dbt_twilio v0.1.0
## Initial Release
This is the first release of Fivetran Twilio dbt package! For more information, refer to the [README](/README.md)

This version of our dbt package focuses on Twilio's [Programmable Messaging](https://www.twilio.com/docs/messaging) product, specifically around the [Message Resource](https://www.twilio.com/docs/sms/api/message-resource).
