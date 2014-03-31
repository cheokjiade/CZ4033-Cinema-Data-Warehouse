CZ4033-Cinema-Data-Warehouse
============================

CZ4033 Cinema Data Warehouse Project

The folder SQL Commands contains all the various commands needed.  
tables.sql generates the schema and indices. It is recommended to remove the foreign key constraints in the Sales Fact Table and then re insert them after importing data.


7 tables have been manually generated and the data for them is in Insert Movie Flake.sql. The tables are Customer, Address, Cinema, Director, Star, Person, Movie.  

The schema is in schema.png  

The remaining tables are generated via GenerateCSV.java which outputs txt files with comma separated values.

The database engine used is SQL server and the txt files are imported.