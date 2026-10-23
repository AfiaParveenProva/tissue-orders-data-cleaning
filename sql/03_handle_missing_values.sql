-- Handle missing values
-- unit_price: each product has exactly one price in the data, so fill from the product
-- quantity: left blank and flagged (needs_review = 1), not invented
-- customer_name, region: filled with 'Unknown'
CREATE TABLE orders_clean AS
WITH prices AS (
  SELECT product_name, MAX(unit_price) AS price
  FROM orders_dates
  WHERE unit_price IS NOT NULL AND unit_price <> ''
  GROUP BY product_name
)
SELECT
  d.record_id,
  d.order_date,
  d.product_name,
  d.batch_number,
  NULLIF(d.quantity, '')                          AS quantity,
  COALESCE(NULLIF(d.unit_price, ''), p.price)     AS unit_price,
  COALESCE(NULLIF(TRIM(d.customer_name), ''), 'Unknown') AS customer_name,
  COALESCE(NULLIF(TRIM(d.region), ''), 'Unknown')        AS region,
  d.status,
  CASE WHEN d.quantity IS NULL OR d.quantity = '' THEN 1 ELSE 0 END AS needs_review
FROM orders_dates d
LEFT JOIN prices p ON p.product_name = d.product_name;