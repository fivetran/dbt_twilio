with messages as (

    select *
    from {{ var('message')}}
),

inbound_messages as (

    select 
        message_from as phone_number,
        status,
        date_sent,
        message_from,
        message_to,
        body,
        error_code,
        error_message,
        direction,
        num_media,
        num_segments

    from messages
    group by 1,2
    where direction like '%inbound%'
),

outbound_messages as (

    select 
        message_from as phone_number,
        status,
        date_sent,
        message_from,
        message_to,
        body,
        error_code,
        error_message,
        direction,
        num_media,
        num_segments

    from messages
    group by 1,2
    where direction like '%outbound%'
),

union_messages as (

    select * from inbound_messages
    union all
    select * from outbound_messages
)

incoming_phone_number as (

    select *
    from {{ var('income_phone_number')}}
),

addresses as (

    select *
    from {{ var('address')}}
),

final as (

    select 
        union_messages.date_sent,
        union_messages.date_sent as week_sent, -- date trunc week
        union_messages.date_sent as month_sent, -- date trunc month
        union_messages.message_from,
        union_messages.message_to,
        union_messages.body,
        union_messages.status,
        union_messages.error_code,
        union_messages.error_message,
        union_messages.direction,
        union_messages.num_media,
        union_messages.num_segments,
        addresses.iso_country




    from union_messages

    left join incoming_phone_number
        on union_messages.message_to = incoming_phone_number.phone_number
        on union_messages.message_from = incoming_phone_number.phone_number

    left join addresses
        on income_phone_number.address_id = addresses.address_id

)


select * 
from final

