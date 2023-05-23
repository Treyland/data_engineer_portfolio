# Overview
This project served as a simulation of a bike company asking me to create a database to help their analysts understand the effects of weather on bike rentals. The bike data came in the form of csv files broken up monthly and the weather data was one csv file.

# Cleaning
- We had 247,584 initial observations in the data set.  
- My cleaning decisions:
1. First we change the column names to be more standard to work with (replace whitespace with _ and put them all in lower case)
2. I changed the gender values from the numerical values to the corresponding string values ('unknown', 'male', 'female') for ease of reading
3. I changed the start and stop times to datetime using the datetime library
4. I combed the age data to find any age outliers for data that may be inaccurate/too old, and thus not useful, and removed them
5. I then addressed the missing values that were common throughtout the data set.
    - I found that most (99%) of the user type 'customer' had a missing birth year and all of them had a gender of unknown
    - **NOTE TO ANALYSTS: This leads me to believe that birth year and gender is only relevant for 'subscriber' data!**
6. I found that none of the missing 'user_type' data did not have missing gender or birth year indicating that they are/were likely subscribers
    - **I replaced the NaNs in this column with unknown and suggest that someone from analytics look into the reasoning behind this**
7. Also noticed that there were some abnormally long trip durations (much longer than the max of 24 hours)
    - **I created a legal_duration column to acknowledge if the trip was under the legal amount (True) or over (False) so that those trips can be investigated**
8. The weather data was relatively clean
    - I removed the PGTM and TSUN variables as they were entirely empty
    - I decided to use AWND as our wind variable (the other two, WDF and WSF, seemed difficult to gel with dataset so I dropped them)
    - I also dropped station variable because all of our data came from the same station
    - I converted the dates to datetime
    - I added some columns for the analysts to use
        - **Added 'snow' and 'rain' columns as booleans to indicate snowfall or rainfaill**
9. **I created a date table to make some of our queries easier (given that date is integral to most of our data)**
    - *Added 'financial_qtr' column and 'date_key' to help join our tables together*
10. **I created a demographics table to gather all of the unique user demographics into one table**
    - *Added 'demo' column to assist with joins in analysis ('id' column in demo table)
11. **I created a stations table to gather all of our station data together**
12.  **I created a rides table to gather all of our ride information together**
 ## These changes should allow for our analysts to clearly visualize our data in seperate tables that each contain a primary key and can easily be joined on the available foreign keys.
 - Foreign Keys:
    - weather table:
        - 'date_key' references date.date_key
    - rides table: 
        - 'date_key' references date.date_key
        - 'start_station_id' references stations.id
        - 'end_station_id' references stations.id
        - 'demo' references demo.id

# Views and Analysis
1. **daily_rides view** 
    - Contains ride aggregate data (total rides, customer rides, subscriber rides, unknown rides, and late returns) based on day
    - uses outer joins to include days that are missing from the set (for investigation) 
2. **daily_data view**
    - Combines the data from daily_rides with weather data to give an accurate picture of rides and the weather on a specific day
    - I anticipate that this view will be used a lot to determine an immediate impact that weather has on rides (trends, correlations, etc.)
    - Could use filter to determine rides by user_type (customer, subscriber, unknown)
    - contains unknown user_type, so could allow for further investigation
3. **monthly_data view**
    - Gives monthly aggregate data for both rides and weather
    - I anticipate that this view will be used a lot to determine longer term relationships between weather and rides (trends, correlations, etc.)
4. **late_returns** 
    - Provides data for all of the rides that are over the maximum contracted time allowed (contains ids for bike and customer and the necessary ride info)
    - Will be useful to analyze the late return rides and may allow the company to track down the riders and determine what happened

## I wrote some example queries that some analysts may use
**hourly_summary**, **demographics**, **quarterly_breakdown** 
- Some examples of some smaller views that allow us to determine most popular riding hours, demographic summaries, and quarterly ride info
