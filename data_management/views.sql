-- Daily Rides
create view daily_rides as
select date.date_key,
    date.full_date,
    date.month_name,
    date.day,
    date.day_name,
    date.weekend,
    count(rides.id) as ride_totals,
    count(demo.user_type) filter (where demo.user_type = 'Subscriber') as subscriber_rides,
    count(demo.user_type) filter (where demo.user_type = 'Customer') as customer_rides,
    count(demo.user_type) filter (where demo.user_type = 'Unknown') as unknown_rides,
    count(rides.legal_duration) filter (where not rides.legal_duration) AS late_return
from rides
    right join date on rides.date_key = date.date_key
    left join demo on rides.demo = demo.id
group by date.date_key
order by date.date_key;

--Daily data
create view daily_data as
select daily_rides.date_key,
    daily_rides.month_name,
    daily_rides.day,
    daily_rides.day_name,
    daily_rides.ride_totals,
    sum(daily_rides.ride_totals) over (partition by daily_rides.month_name order by daily_rides.date_key) as month_total,
    daily_rides.subscriber_rides,
    daily_rides.customer_rides,
    daily_rides.unknown_rides,
    daily_rides.late_return,
    daily_rides.weekend,
    weather.tmin,
    weather.tavg,
    weather.tmax,
    weather.avg_wind,
    weather.prcp,
    weather.snow_amt,
    weather.rain,
    weather.snow
from daily_rides
    join weather on daily_rides.date_key = weather.date_key
order by daily_rides.date_key;

--Monthly data
create view monthly_data as
select date.month_name,
    round(avg(daily.ride_totals)) as avg_daily_rides,
    sum(daily.ride_totals) as total_rides,
    round(avg(daily.customer_rides)) as avg_customer_rides,
    sum(daily.customer_rides) as total_customer_rides,
    round(avg(daily.subscriber_rides)) as avg_subscriber_rides,
    sum(daily.subscriber_rides) as total_subscriber_rides,
    sum(daily.unknown_rides) as total_unknown_rides,
    sum(daily.late_return) as total_late_returns,
    round(avg(daily.tavg)) as avg_tavg,
    count(daily.snow) filter (where daily.snow) as snow_days,
    count(daily.rain) filter (where daily.rain) as rain_days,
    max(daily.snow_amt) as max_snow,
    max(daily.prcp) as max_prcp
from date
    join daily_data daily on date.date_key = daily.date_key
group by date.month, date.month_name
order by date.month;

--Late Returns
create view late_return as
select date.full_date,
    rides.id,
    rides.trip_hours,
    rides.bike_id,
    (select stations.station_name
        from stations
        where rides.start_station_id = stations.id) as start_location,
    (select stations.station_name
        from stations
        where rides.end_station_id = stations.id) as end_location,
    demo.user_type
from rides
    join date on rides.date_key = date.date_key
    join demo on rides.demo = demo.id
where rides.legal_duration = False;


--Example Queries

--hourly summary
CREATE VIEW hourly_summary AS
SELECT EXTRACT(hour FROM rides.start_time) AS start_hour,
    count(*) AS ride_totals
   FROM rides
  GROUP BY (EXTRACT(hour FROM rides.start_time))
  ORDER BY (count(*)) DESC;

--demographics
create view demographics as 
select count(rides.id) as total_rides,
    demo.age,
    demo.gender,
    demo.user_type
from rides 
    join demo on rides.demo = demo.id
group by demo.age, demo.gender, demo.user_type
order by demo.user_type, demo.gender, demo.age;

--Quarterly breakdown
with quarterly_data as
    (select rides.date_key,
    trip_hours,
    trip_minutes,
    financial_qtr,
    id
    from rides
    join date on rides.date_key = date.date_key
    order by date.financial_qtr)
select distinct financial_qtr,
    count(financial_qtr),
    avg(trip_hours) as avg_trip_hours,
    avg(trip_minutes) as avg_trip_min
from quarterly_data
    group by financial_qtr
    order by financial_qtr;