-- Standardise 4 date formats into YYYY-MM-DD
-- Slash and dot dates are day first (verified: 2,352 have a first part above 12, none have a middle part above 12)
CREATE TABLE orders_dates AS
SELECT
  record_id,
  CASE
    WHEN order_date LIKE '____-__-__' THEN order_date
    WHEN order_date LIKE '__/__/____' OR order_date LIKE '__.__.____'
      THEN substr(order_date, 7, 4) || '-' || substr(order_date, 4, 2) || '-' || substr(order_date, 1, 2)
    WHEN order_date LIKE '__ ___ ____'
      THEN substr(order_date, 8, 4) || '-' ||
           CASE substr(order_date, 4, 3)
             WHEN 'Jan' THEN '01' WHEN 'Feb' THEN '02' WHEN 'Mar' THEN '03'
             WHEN 'Apr' THEN '04' WHEN 'May' THEN '05' WHEN 'Jun' THEN '06'
             WHEN 'Jul' THEN '07' WHEN 'Aug' THEN '08' WHEN 'Sep' THEN '09'
             WHEN 'Oct' THEN '10' WHEN 'Nov' THEN '11' WHEN 'Dec' THEN '12'
           END || '-' || substr(order_date, 1, 2)
  END AS order_date,
  product_name, batch_number, quantity, unit_price,
  customer_name, region, status
FROM orders_dedup;