{% set message_categories = ['accepted', 'scheduled', 'canceled', 'queued', 'sending', 'sent', 'failed', 'delivered', 'undelivered', 'receiving','received', 'read'] %}

with messages as (

    select *
    from {{ ref('int_twilio__messages') }}
),

account_history as (

    select * 
    from {{ ref('stg_twilio__account_history' )}}
)

{% if var('using_twilio_usage_record', True) %}
,
usage_record as (

    select * 
    from {{ ref('stg_twilio__usage_record' )}}
)
{% endif %}

select
    messages.account_id,
    account_history.friendly_name as account_name,
    account_history.status as account_status,
    account_history.type as account_type,
    messages.date_day,
    messages.date_week,
    messages.date_month,
    messages.price_unit,
    count(case
        when messages.direction like '%outbound%'
        then messages.message_id end)
        as total_outbound_messages,
    count(case
        when messages.direction like '%inbound%'
        then messages.message_id end)
        as total_inbound_messages,

    {% for m in message_categories %}
    count(case
        when messages.status like '{{ m }}'
        then messages.message_id end)
        as total_{{m}}_messages,
    {% endfor %}
    
    count(messages.message_id) as total_messages,
    round( cast(sum(messages.price) as {{ dbt.type_numeric() }}), 2) * -1 as total_messages_spend
    
    {% if var('using_twilio_usage_record', True) %}
    , round( cast(sum(usage_record.price) as {{ dbt.type_numeric() }}), 2) as total_account_spend
    {% endif %}

from messages
{% if var('using_twilio_usage_record', True) %}
left join usage_record
    on messages.account_id = usage_record.account_id
    and messages.date_day = usage_record.start_date
{% endif %}
left join account_history
    on messages.account_id = account_history.account_id

{{ dbt_utils.group_by(n=8) }}
