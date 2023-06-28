with messages as (

    select *
    from {{ var('message')}}
),

inbound_messages as (

    select
        account_id,
        body,
        {{ dbt.length("body") }} as num_characters,
        {{ dbt.replace("body", "' '", "''") }} as body_no_spaces,
        created_at,
        timestamp_sent,
        direction,
        error_code,
        error_message,
        message_from as phone_number,
        message_id,
        messaging_service_id,
        num_media,
        num_segments,
        price,
        price_unit,
        status,
        message_to,
        updated_at

    from messages
    where direction like '%inbound%'
),

outbound_messages as (

    select
        account_id,
        body,
        {{ dbt.length("body") }} as num_characters,
        {{ dbt.replace("body", "' '", "''") }} as body_no_spaces,
        created_at,
        timestamp_sent,
        direction,
        error_code,
        error_message,
        message_to as phone_number,
        message_id,
        messaging_service_id,
        num_media,
        num_segments,
        price,
        price_unit,
        status,
        message_from,
        updated_at
        
    from messages
    where direction like '%outbound%'
),

union_messages as (

    select * from inbound_messages
    union all
    select * from outbound_messages
)

select * from union_messages