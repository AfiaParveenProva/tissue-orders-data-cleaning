import time
import pandas as pd

start = time.perf_counter()

# 1. Load everything as plain text so nothing is changed on the way in
raw = pd.read_csv("data/raw_orders_messy.csv", dtype=str, keep_default_na=False)
print("Raw rows:", len(raw))

# 2. Remove duplicates: keep the first row for each record_id
df = raw.drop_duplicates(subset="record_id", keep="first").copy()
print("Rows after removing duplicates:", len(df))

# 3. Standardise the 4 date formats to YYYY-MM-DD (slash and dot dates are day first)
dates = pd.to_datetime(df["order_date"], format="%Y-%m-%d", errors="coerce")
for fmt in ["%d/%m/%Y", "%d.%m.%Y", "%d %b %Y"]:
    dates = dates.fillna(pd.to_datetime(df["order_date"], format=fmt, errors="coerce"))
print("Dates that could not be converted:", dates.isna().sum())
df["order_date"] = dates.dt.strftime("%Y-%m-%d")

# 4. Missing values
# unit_price: each product has one price, so fill from the product's known price
prices = df[df["unit_price"] != ""].groupby("product_name")["unit_price"].first()
blank_price = df["unit_price"] == ""
df.loc[blank_price, "unit_price"] = df.loc[blank_price, "product_name"].map(prices)

# quantity: leave blank and flag for review
df["needs_review"] = (df["quantity"] == "").astype(int)

# customer_name and region: fill with Unknown
for col in ["customer_name", "region"]:
    df[col] = df[col].str.strip()
    df.loc[df[col] == "", col] = "Unknown"

# 5. Save
df.to_csv("data/orders_clean_python.csv", index=False)

print("Clean rows saved:", len(df))
print("Flagged for review (blank quantity):", df["needs_review"].sum())
print(f"Time taken: {time.perf_counter() - start:.2f} seconds")