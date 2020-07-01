## Class 14. SQL

## install.packages("RSQLite")
library(RSQLite)

dcon <- dbConnect(SQLite(), dbname = "data/STAT405_605.sqlite")

## For example, to connect to a real database server, such as
## PostgreSQL, you should do something like:
# dcon <- dbConnect(PostgreSQL(), dbname = "test",
#                  user = "postgres", password = "STAT405")
## After this, everything is the same (with eventual slight
## changes in syntax as no implementation follows 100%  the
## SQL standard 100%).

dbSendQuery(conn = dcon, "
PRAGMA foreign_keys = ON;
")


## List tables
dbListTables(dcon)

## Fields in a table
dbListFields(dcon, "yahoo_symbol") 

res <- dbSendQuery(conn = dcon, "
SELECT *
FROM yahoo_symbol;
")
mydf <- dbFetch(res, -1)
dbClearResult(res)
mydf
## View(mydf)

res <- dbSendQuery(conn = dcon, "
SELECT symbol, name, type, exchange
FROM yahoo_symbol;
")
mydf <- dbFetch(res, -1)
dbClearResult(res)
mydf

## Filtering 
res <- dbSendQuery(conn = dcon, "
SELECT symbol, name, type, exchange
FROM yahoo_symbol
WHERE exchange = 'NYQ'
ORDER BY symbol;
")
mydf <- dbFetch(res, -1)
dbClearResult(res)
mydf
## View(mydf)


res <- dbSendQuery(conn = dcon, "
SELECT *
FROM yahoo_symbol
WHERE symbol between 'M' and 'R'
ORDER BY symbol;
")
dbFetch(res, -1)
dbClearResult(res)


res <- dbSendQuery(conn = dcon, "
SELECT *
FROM yahoo_symbol
WHERE symbol LIKE 'A%'
ORDER BY symbol;
")
mydf <- dbFetch(res, -1)
dbClearResult(res)
mydf

query <- paste0("
SELECT *
FROM yahoo_symbol
WHERE industry IN ('Aluminum',
                   'Specialty Chemicals');
")
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

### Inner Join
res <- dbSendQuery(conn = dcon, "
SELECT a.symbol, a.name, b.day,
       b.open, b.close
FROM yahoo_symbol AS a
INNER JOIN yahoo_quote AS b
ON a.symbol = b.symbol
WHERE a.symbol = 'GOOG'
ORDER BY b.day DESC
LIMIT 10;
")
dbFetch(res, -1)
dbClearResult(res)


res <- dbSendQuery(conn = dcon, "
SELECT a.symbol, a.name, b.day,
       b.open, b.close
FROM yahoo_symbol as a, yahoo_quote as b
WHERE a.symbol = b.symbol AND
      a.symbol = 'GOOG'
ORDER BY b.day DESC
LIMIT 10;
")
dbFetch(res, -1)
dbClearResult(res)

## Left join (righ and outer joins not implemented)
res <- dbSendQuery(conn = dcon, "
SELECT a.exchange, a.name, b.symbol, b.name
FROM yahoo_exchange AS a
LEFT JOIN yahoo_symbol AS b
ON a.exchange = b.exchange;
")
View(dbFetch(res, -1))
dbClearResult(res)


## Using variables for flexibility
sector <- "Basic Materials"

query <- paste0("
SELECT industry
FROM yahoo_industry
WHERE sector = '", sector, "';")
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

qqq <- function(sector) {
  query <- paste0("
SELECT industry, sector
FROM yahoo_industry
WHERE sector = '", sector, "';")
  res <- dbSendQuery(dcon, query)
  print(dbFetch(res, -1))
  dbClearResult(res)
}

qqq("Basic Materials")
qqq("Consumer Goods")

## Second lecture starts here

##
## Use a subselect to provide a list
## of values to match with IN.
query <- paste0("
SELECT *	
FROM yahoo_symbol
WHERE industry IN (
  SELECT industry
  FROM yahoo_industry
  WHERE sector = '", sector, "'
  );")
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)


## Constructing a query in steps
queryBM <- paste0("
SELECT industry
FROM yahoo_industry
WHERE sector = '", sector, "'")
res <- dbSendQuery(dcon, queryBM)
dbFetch(res, -1)
dbClearResult(res)


query <- paste0("
SELECT *
FROM yahoo_symbol
WHERE industry IN (", queryBM, ");")
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)


## Aggregate functions. Counting how many observations.
query <- paste0("
SELECT count(*)
FROM yahoo_industry;")
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

## Grouping to apply aggregate functions
query <- paste0("
SELECT sector, count(*)
FROM yahoo_industry
GROUP BY sector;")
res <- dbSendQuery(dcon, query)
data <- dbFetch(res, -1)
dbClearResult(res)
data

## Using result from previous query
## to loop across sectors
for (sector in data$sector) {
  query <- paste0("
SELECT symbol, name
FROM yahoo_symbol
WHERE industry IN (
  SELECT industry
  FROM yahoo_industry
  WHERE sector = '", sector, "'
  );")
  res <- dbSendQuery(dcon, query)
  by_sector <- dbFetch(res, -1)
  dbClearResult(res)
  if (nrow(by_sector) > 0) {
    cat("####################\n", sector,"\n####\n")
    print(by_sector)
  }
}


## Create a table from the result of a query
query <- "
CREATE TABLE morethan5percent AS
SELECT *
FROM yahoo_quote
WHERE close / open > 1.05
ORDER BY symbol;"
dbSendQuery(dcon, query)
## NOTE: you can use CREATE TEMPORARY TABLE
## to generate tables that will be automatically
## deleted when the connection is closed.

query <- "
SELECT *, close / open as propIncr, 
FROM yahoo_quote
WHERE close / open > 1.05
ORDER BY symbol;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)


query <- "
SELECT *
FROM morethan5percent;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

query <- "
SELECT symbol, count(*)
FROM morethan5percent
GROUP BY symbol;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

## Assign a name to count
query <- "
SELECT symbol, count(*) as qty
FROM morethan5percent
GROUP BY symbol
ORDER BY qty DESC;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

## Delete records from a table
query <- "
DELETE FROM morethan5percent
WHERE symbol = 'PM';"
dbSendQuery(dcon, query)

query <- "
DELETE FROM morethan5percent
WHERE symbol IN ('JNJ', 'GOOG', 'FB');"
dbSendQuery(dcon, query)

## Modify records
query <- "
UPDATE morethan5percent
SET symbol = 'MMMM'
WHERE symbol = 'MMM';"
dbSendQuery(dcon, query)

## Drop a table
query <- "
DROP TABLE morethan5percent"
dbSendQuery(dcon, query)


## Use a subselect as a table
query <- "
SELECT symbol, count(*) as qty
FROM (SELECT *
      FROM yahoo_quote
      WHERE close / open > 1.05
      ORDER BY symbol)
GROUP BY symbol
ORDER BY qty DESC;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

## Nested subselects with joins
query <- "
SELECT a.symbol, a.name, a.industry, b.sector, c.qty
FROM yahoo_symbol AS a,
     yahoo_industry AS b,
     (SELECT symbol, count(*) as qty
      FROM (SELECT *
            FROM yahoo_quote
            WHERE close / open > 1.05)
      GROUP BY symbol) AS c
WHERE a.symbol = c.symbol AND
      a.industry = b.industry;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

## Even more subselects.
## NOTE: this is just to show how powerful SQL can be.
## On the other side, approaches like this can become
## confusing and difficult to interpret.
query <- "
SELECT sector, SUM(qty) as total 
FROM (SELECT a.symbol, a.name, a.industry, b.sector, c.qty
      FROM yahoo_symbol AS a,
           yahoo_industry AS b,
           (SELECT symbol, count(*) as qty
            FROM (SELECT *
                  FROM yahoo_quote
                  WHERE close / open > 1.05)
                  GROUP BY symbol) AS c
            WHERE a.symbol = c.symbol AND
                  a.industry = b.industry)
GROUP BY sector
ORDER BY total DESC;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

## Inserting rows.
## This will fail as there is duplicate primary key
dbSendQuery(conn = dcon, "
            INSERT INTO yahoo_symbol VALUES ('FBI',
            'Facebook, Inc.', 'Stock', 'NMS',
            'Internet Information Providers', 'USD', NULL,
            '2013-11-19 09:47:29.219521', '1990-01');
            ")
## Same with this
dbSendQuery(conn = dcon, "
            INSERT INTO yahoo_quote VALUES('GOOG',
            '2006-06-01',373.54,
            382.99,371.6,382.62,6278000,382.62);
            ")
## This will fail because there is no GOO symbol
## in yahoo_symbol
dbSendQuery(conn = dcon, "
            INSERT INTO yahoo_quote VALUES('GOO',
            '2006-06-01',373.54,
            382.99,371.6,382.62,6278000,382.62);
            ")


## Catch errors.
query <-  "
INSERT INTO yahoo_quote VALUES('GOOG','2006-06-01',373.54,
382.99,371.6,382.62,6278000,382.62);
"
res <- try(dbSendQuery(conn = dcon, query),
           silent=TRUE)
class(res)
str(res)

if (class(res) == "try-error") {
  print(dbGetException(dcon))
  cat(res)
}
attr(res, "condition")$message


query <-  "
INSERT INTO yahoo_quote VALUES('GOO','2006-06-01',373.54,
382.99,371.6,382.62,6278000,382.62);
"
res <- try(dbSendQuery(conn = dcon, query),
           silent=TRUE)	

if (class(res) == "try-error") {
  print(dbGetException(dcon))
  cat(res)
}

tryCatch(dbSendQuery(conn = dcon, query),
         error = function(e) {
           print(e)
         },
         finally = print("There was an error"))

## NOTE: this technique of catching errors is general,
##       not limited to catching SQL errors.


query <- "
SELECT day, date(day, '+2 day'), 
       datetime(day, '+1 day'),
       date(day,'start of month','+1 month','-1 day')
FROM yahoo_quote
LIMIT 10;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

query <- "
SELECT symbol, max(day)
FROM yahoo_quote
GROUP BY symbol;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)

query <- "
SELECT symbol, first_day,
date(first_day,'start of month','+1 month','-1 day') as last_day_of_month,
julianday('now') - julianday(first_day) as days_since,
strftime('%Y',first_day) as year,
strftime('%m',first_day) as month,
cast(strftime('%Y',first_day) as real) + 
cast(strftime('%m',first_day) as real) / 12 as frac_year
FROM (SELECT symbol, min(day) as first_day
FROM yahoo_quote
GROUP BY symbol)
;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)


initExtension(dcon) ## To load extension functions
## This provides:
## - Math: acos, asin, atan, atn2, atan2, acosh, asinh, atanh,
##        difference, degrees, radians, cos, sin, tan, cot,
##        cosh, sinh, tanh, coth, exp, log, log10, power, sign,
##        sqrt, square, ceil, floor, pi.
## - String: replicate, charindex, leftstr, rightstr, ltrim,
##           rtrim, trim, replace, reverse, proper, padl, padr,
##           padc, strfilter.
## - Aggregate: stdev, variance, mode, median,
##              lower_quartile, upper_quartile

## Check if extensions work
res <- dbSendQuery(conn = dcon, "
                   select cos(radians(45));
                   ")
dbFetch(res, -1)
dbClearResult(res)
print(dbGetException(dcon))

## Check the extension aggregate functions
query <- "
SELECT symbol, count(*) as qty, avg(ratio),
stdev(ratio), variance(ratio), mode(round(ratio,2)),
median(ratio), lower_quartile(ratio),
upper_quartile(ratio)
FROM (SELECT *, close / open as ratio
FROM yahoo_quote
WHERE close / open > 1.05
ORDER BY symbol)
GROUP BY symbol
ORDER BY qty DESC;"
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)



library(stringr)
field_list <- dbListFields(dcon, "yahoo_symbol")
field_subset <- field_list[str_sub(field_list, 1, 1) == "l"]

query <- paste0("
                SELECT ", paste0(field_subset, collapse = ","), "
                FROM yahoo_symbol;")
res <- dbSendQuery(dcon, query)
dbFetch(res, -1)
dbClearResult(res)



dbDisconnect(dcon)

dcon <- dbConnect(SQLite(), dbname = "data/mydba.sqlite")

## Creating a table from scratch
dbSendQuery(conn = dcon, "
CREATE TABLE yahoo_industry2 (
            industry text NOT NULL,
            sector text NOT NULL,
            index_type text,
            PRIMARY KEY (industry)
            );
")

## Importing an csv file into a table
table <- read.csv(paste0("data/yahoo_industry.csv"))
dbWriteTable(conn = dcon, name = "yahoo_industry2", table,
             append = TRUE, row.names = FALSE)


dbSendQuery(conn = dcon, "
CREATE TABLE yahoo_quote (
            symbol text NOT NULL,
            day date NOT NULL,
            open numeric,
            high numeric,
            low numeric,
            close numeric,
            volume numeric,
            adj_close numeric,
            PRIMARY KEY (symbol, day),
            FOREIGN KEY (symbol) REFERENCES yahoo_symbol(symbol) ON UPDATE CASCADE ON DELETE CASCADE
);
            ")
table <- read.csv(paste0(dir, "yahoo_quote.csv"))
dbWriteTable(conn = dcon, name = "yahoo_quote", table,
             append = TRUE, row.names = FALSE)

