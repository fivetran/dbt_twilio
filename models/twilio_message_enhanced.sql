with messages as (

    select *
    from {{ var('message')}}
),

addresses as (

    select *
    from {{ var('address')}}
),

final as (

    select 
        date_sent,
        date_sent as week_sent,
        date_sent as month_sent,
        message_from,
        from_address.iso_country as from_country,
        message_to,
        to_address.iso_country as to_country,
        body,
        status,
        error_code,
        error_message,
        direction,
        num_media,
        num_segments




    from messages
    left join addresses from_address
        on messages.account_id = from_address.account_id
    left join addresses to_address
        on messages.account_id = to_address.account_id

)


select * 
from final

