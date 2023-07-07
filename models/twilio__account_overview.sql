
{% set message_categories = ['accepted', 'scheduled', 'canceled', 'queued', 'sending', 'sent', 'failed', 'delivered', 'undelivered', 'receiving','received', 'read'] %}

with messages as (

    select *
    from {{ ref('int_twilio__messages')}}
),

usage_record as (

    select * 
    from {{ var('usage_record')}}
)

select
    messages.account_id,
    messages.day_sent as date_day,
    messages.week_sent as date_week,
    messages.month_sent as date_month,
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
    trunc(sum(messages.price),2) as total_messages_spent,
    messages.price_unit,
    trunc(sum(usage_record.price),2) as total_account_spent

from messages
left join usage_record
    on messages.account_id = usage_record.account_id
    and messages.day_sent = usage_record.start_date
group by 1,2,3,4,21
