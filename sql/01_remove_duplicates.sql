-- Remove duplicate orders: keep the first row for each record_id
CREATE TABLE orders_dedup AS
SELECT record_id, order_date, product_name, batch_number,
       quantity, unit_price, customer_name, region, status
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY record_id
               ORDER BY rowid
           ) AS rn
    FROM raw_orders
)
WHERE rn = 1;