# Changelog



## Day 1: Profiling

- Raw rows: 8,400 (9 columns)

- Exact duplicate rows: 620

- Missing values: 310 in total (quantity 74, unit_price 73, customer_name 79, region 84)

- No row has more than one blank

- Date formats seen: mixed separators (/ - .), stored as text

- Starting error rate: 11.1% ((620 duplicates + 310 rows with blanks) / 8,400)

- Expected rows after removing duplicates: 7,780

