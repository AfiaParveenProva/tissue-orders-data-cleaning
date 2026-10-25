# Changelog



## Day 1: Profiling

* Raw rows: 8,400 (9 columns)
* Exact duplicate rows: 620
* Missing values: 310 in total (quantity 74, unit_price 73, customer_name 79, region 84)
* No row has more than one blank
* Date formats seen: mixed separators (/ - .), stored as text
* Starting error rate: 11.1% ((620 duplicates + 310 rows with blanks) / 8,400)
* Expected rows after removing duplicates: 7,780

## Day 2: Cleaning in SQL

* Removed 620 duplicate rows by record_id (ROW_NUMBER, keep first): 8,400 rows down to 7,780
* Standardised 4 date formats to YYYY-MM-DD (YYYY-MM-DD 2,004; DD.MM.YYYY 1,990; DD/MM/YYYY 1,835; DD Mon YYYY 1,951)
* Checked that slash and dot dates are day first: 2,352 have a first part above 12, none have a middle part above 12
* Date check after conversion: 0 blank or invalid dates, range 2025-01-01 to 2025-12-31
* Duplicates and blanks were in different rows (blank counts were the same before and after removing duplicates)
* Missing value rules: unit_price (73) filled from the product's single fixed price; quantity (74) left blank and flagged needs_review = 1; customer_name (79) and region (84) set to 'Unknown'
* Result: orders_clean table with 7,780 unique rows and 0 missing prices

## Day 3: Validation in Excel

* Exported the cleaned table (orders_clean) to CSV: 7,780 rows, 10 columns including the needs_review flag
* Took a random sample of 200 of the 8,400 raw orders (seed 42) and put each raw row next to its cleaned version in validation_sample.xlsx
* Excel formulas checked every field against the cleaning rules: 200 of 200 rows OK, 0 flagged
* Date check: 200 of 200 dates converted correctly to YYYY-MM-DD, 0 flagged
* Match rate: 100% (200 of 200) on the random sample, which included orders that were duplicated in the raw file
* Built a pivot table of orders by region and month (orders_clean_pivot.xlsx): grand total 7,780 orders, with the 84 'Unknown' regions shown as their own row
* Screenshot saved in images/pivot_region_month.png

## Day 4: Automation in Python

- Wrote clean_orders.py, one script that does the full cleaning: remove duplicates, standardise dates, apply the missing-value rules, save the result

- Script output: 8,400 raw rows down to 7,780 clean rows, 0 dates unconverted, 74 quantities flagged for review

- Compared the Python output with the SQL output (orders_clean.csv vs orders_clean_python.csv): identical, 7,780 rows and 10 columns, cell for cell

- Run time: 0.27 seconds. Manual cleaning is estimated at about 52 minutes (an estimate, not a measured time)

