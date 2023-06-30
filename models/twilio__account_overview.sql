
{% set message_categories = ['accepted', 'scheduled', 'canceled', 'queued', 'sending', 'sent', 'failed', 'delivered', 'undelivered', 'receiving','received', 'read'] %}

with messages as (

    select *
    from {{ ref('int_twilio__messages')}}
)

select
    account_id,
    day_sent as date_day,
    week_sent as date_week,
    month_sent as date_month,
    count(case
        when direction like '%outbound%'
        then message_id end)
        as total_outbound_messages,
    count(case
        when direction like '%inbound%'
        then message_id end)
        as total_inbound_messages,

    {% for m in message_categories %}
    count(case
        when status like '{{ m }}'
        then message_id end)
        as total_{{m}}_messages,
    {% endfor %}
    
    count(message_id) as total_messages,
    sum(price) as total_spent,
    price_unit

from messages
group by 1,2,3,4,21
