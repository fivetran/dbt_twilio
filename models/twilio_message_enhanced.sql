with messages as (

    select *
    from {{ var('message')}}
),

inbound_messages as (

    select
        account_id,
        body,
        created_at,
        date_sent,
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
        created_at,
        date_sent,
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
),

incoming_phone_number as (

    select *
    from {{ var('incoming_phone_number')}}
),

addresses as (

    select *
    from {{ var('address')}}
),

final as (

    select
        union_messages.message_id,
        union_messages.messaging_service_id,
        union_messages.date_sent,
        cast ({{ dbt.date_trunc("week","union_messages.date_sent") }} as date) as week_sent,
        cast ({{ dbt.date_trunc("month","union_messages.date_sent") }} as date) as month_sent,
        union_messages.account_id,
        union_messages.created_at,
        union_messages.direction,
        union_messages.phone_number,
        union_messages.body,
        union_messages.status,
        union_messages.error_code,
        union_messages.error_message,
        union_messages.num_media,
        union_messages.num_segments,
        union_messages.price,
        union_messages.price_unit,
        union_messages.updated_at,
        addresses.iso_country

    from union_messages

    left join incoming_phone_number
        on union_messages.phone_number = incoming_phone_number.phone_number
        and union_messages.phone_number = incoming_phone_number.phone_number

    left join addresses
        on incoming_phone_number.address_id = addresses.address_id
)

select *
from final

