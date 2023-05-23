# Trey Blanding - Data Engineer Portfolio

Welcome to my Data Engineering Portfolio!
I am a self-taught, aspiring Data Engineer looking to hone my skills and join a passionate team!

# Projects

## data_management

This project tasked me with creating a relational database with analytics-ready views that connects datasets that include Citi Bike data and weather data.  

Tasks included:
- Inspect/clean both datasets
- develop relational database
- implement said database in PostgreSQL and insert the dataset
- create views from the database that analysts may end up using

## pipeline_project

This project tasked me with creating a pipeline to reguarly transform a fake SQLite database into a clean database (& csv file) for our "analytics team".

This pipeline accomplished the following things:
- run unit tests to ensure data validity
- grab and clean data
- write errors to error log
- automatically check and update changelogs
- push clean data to production database
- create production .csv file