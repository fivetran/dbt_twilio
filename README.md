# Twilio Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_twilio/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_twilio/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?

- Produces modeled tables that leverage Twilio data from [Fivetran's connector](https://fivetran.com/docs/applications/twilio) in the format described by [this ERD](https://fivetran.com/docs/applications/twilio#schemainformation).

<!--section=“twilio_transformation_model"-->

The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_twilio/#!/overview?g_v=1).

| **Table**                          | **Description**                                                                                                                                                                                                                              |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [twilio__message_enhanced](https://fivetran.github.io/dbt_twilio/#!/model/model.twilio.twilio__message_enhanced)    | This table provides additional information of every message sent or received.                                                                                                         |
| [twilio__number_overview](https://fivetran.github.io/dbt_twilio/#!/model/model.twilio.twilio__number_overview)      | This table has aggregate messaging information for each phone number level, such as total messages, total inbound messages, total messages by status, and total spend.                                                                                                         |
| [twilio__account_overview](https://fivetran.github.io/dbt_twilio/#!/model/model.twilio.twilio__account_overview)      | This table provides aggregate information per each account regarding the Twilio Messages resource. |                                                     |

### Materialized Models
Each Quickstart transformation job run materializes 20 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Twilio connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package
Include the following Twilio package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/twilio
    version: [">=1.0.0", "<1.1.0"]
```
### Step 3: Define database and schema variables
By default, this package runs using your destination and the `Twilio` schema. If this is not where your Twilio data is (for example, if your Twilio schema is named `twilio_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  twilio_database: your_database_name
  twilio_schema: your_schema_name
```

### Step 4: Enabling/Disabling Models

Your Twilio connection might not sync every table that this package expects, for example if you are not using the Twilio messaging service feature. If your syncs exclude certain tables, it is either because you do not use that functionality in Twilio or have actively excluded some tables from your syncs. In order to enable or disable the relevant tables in the package, you will need to add the following variable(s) to your `dbt_project.yml` file.

By default, all variables are assumed to be `true`.

```yml
vars:
  using_twilio_call: False # Disable this if not using call
  using_twilio_messaging_service: False # Disable this if not using messaging_service
  using_twilio_usage_record: False # Disable this if not using usage_record

```

### (Optional) Step 5: Additional configurations

<details open><summary>Expand/Collapse configurations</summary>

#### Changing the Build Schema

By default, this package will build the Twilio final models within a schema titled (`<target_schema>` + `_twilio`), intermediate models in (`<target_schema>` + `_int_twilio`), and staging models within a schema titled (`<target_schema>` + `_stg_twilio`) in your target database. If this is not where you would like your modeled Twilio data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    twilio:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

> Note that if your profile does not have permissions to create schemas in your warehouse, you can set each `+schema` to blank. The package will then write all tables to your pre-existing target schema.

#### Change the source table references
If an individual source table has a different name than the package expects (but is in the same schema and database as the other tables), add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_twilio/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    twilio_<default_source_table_name>_identifier: your_table_name 
```

</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/twilio_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_twilio_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_twilio/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
