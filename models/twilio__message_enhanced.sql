with messages as (

    select *
    from {{ ref('int_twilio__messages') }}
),

{% if var('using_twilio_messaging_service', True) %}
messaging_service as (

    select *
    from {{ var('messaging_service')}}
),

{% endif %}

final as (

    select
        messages.message_id,
        messages.messaging_service_id,
        messages.timestamp_sent,
        messages.date_day,
        messages.date_week,
        messages.date_month,
        messages.account_id,
        messages.created_at,
        messages.direction,
        messages.phone_number,
        messages.body,
        messages.num_characters,
        (messages.num_characters- {{ dbt.length("body_no_spaces") }}) + 1 as num_words,
        messages.status,
        messages.error_code,
        messages.error_message,
        messages.num_media,
        messages.num_segments,
        messages.price,
        messages.price_unit,
        messages.updated_at

        {% if var('using_twilio_messaging_service', True) %}
        , 
        messaging_service.friendly_name, 
        messaging_service.inbound_method, 
        messaging_service.us_app_to_person_registered, 
        messaging_service.use_inbound_webhook_on_number, 
        messaging_service.use_case

        {% endif %}

    from messages


    {% if var('using_twilio_messaging_service', True) %}
    left join messaging_service
        on messages.messaging_service_id = messaging_service.messaging_service_id

    {% endif %}

)

select *
from final

