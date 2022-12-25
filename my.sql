-- -- create db
CREATE DATABASE tpcds_demo;
USE tpcds_demo;


-- create schema
source /home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/tpcds/tools/tpcds.sql; -- run tpcds.sql
source /home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/tpcds/tools/tpcds_source.sql; -- run tpcds_source.sql


-- load data
SET GLOBAL local_infile=1;

select 'Loading table call_center...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/call_center.dat' 
INTO TABLE call_center 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;

select 'Loading table catalog_page...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/catalog_page.dat' 
INTO TABLE catalog_page 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;

select 'Loading table catalog_returns...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/catalog_returns.dat' 
INTO TABLE catalog_returns 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;

select 'Loading table catalog_sales...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/catalog_sales.dat' 
INTO TABLE catalog_sales 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;

select 'Loading table customer_address...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/customer_address.dat' 
INTO TABLE customer_address 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;

select 'Loading table customer...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/customer.dat' 
INTO TABLE customer 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table customer_demographics...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/customer_demographics.dat' 
INTO TABLE customer_demographics 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table date_dim...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/date_dim.dat' 
INTO TABLE date_dim 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table dbgen_version...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/dbgen_version.dat' 
INTO TABLE dbgen_version 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table household_demographics...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/household_demographics.dat' 
INTO TABLE household_demographics 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table income_band...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/income_band.dat' 
INTO TABLE income_band 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table inventory...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/inventory.dat' 
INTO TABLE inventory 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table item...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/item.dat' 
INTO TABLE item 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table promotion...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/promotion.dat' 
INTO TABLE promotion 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table reason...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/reason.dat' 
INTO TABLE reason 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table ship_mode...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/ship_mode.dat' 
INTO TABLE ship_mode 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table store...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/store.dat' 
INTO TABLE store 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table store_returns...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/store_returns.dat' 
INTO TABLE store_returns 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

-- show warnings;
select 'Loading table store_sales...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/store_sales.dat' 
INTO TABLE store_sales 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table time_dim...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/time_dim.dat' 
INTO TABLE time_dim 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table warehouse...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/warehouse.dat' 
INTO TABLE warehouse 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table web_page...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/web_page.dat' 
INTO TABLE web_page 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table web_returns...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/web_returns.dat' 
INTO TABLE web_returns 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table web_sales...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/web_sales.dat' 
INTO TABLE web_sales 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
select 'Loading table web_site...' AS '';

LOAD DATA LOCAL 
INFILE '/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/web_site.dat' 
INTO TABLE web_site 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';

show warnings;
