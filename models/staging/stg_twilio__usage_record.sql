{{ config(enabled=var('using_twilio_usage_record', True)) }}

with base as (

    select * 
    from {{ ref('stg_twilio__usage_record_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_twilio__usage_record_tmp')),
                staging_columns=get_usage_record_columns()
            )
        }}
        {{ twilio.apply_source_relation() }}
    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        account_id,
        as_of,
        category,
        cast( {{ twilio.remove_non_numeric_chars('count')}} as {{ dbt.type_float() }}) as count,
        count_unit,
        description,
        end_date,
        cast( {{ twilio.remove_non_numeric_chars('price')}} as {{ dbt.type_float() }}) as price,
        price_unit,
        start_date,
        cast( {{ twilio.remove_non_numeric_chars('usage')}} as {{ dbt.type_float() }}) as usage,
        usage_unit
    from fields
)

select *
from final
