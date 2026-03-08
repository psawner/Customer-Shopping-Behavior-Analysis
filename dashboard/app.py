import streamlit as st
import pandas as pd
import pymysql
import plotly.express as px

import os
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

# Database connection
conn = pymysql.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    database=DB_NAME
)

st.set_page_config(page_title="Shopping Analytics Dashboard", layout="wide")

st.title("Customer Shopping Analytics Dashboard")

base_query = """
SELECT p.purchase_amount,
       p.payment_method,
       p.discount_applied,
       p.customer_id,
       pr.category,
       p.season
FROM purchases p
JOIN products pr
ON p.product_id = pr.product_id
"""

df = pd.read_sql(base_query, conn)

st.sidebar.header("Filters")

season_filter = st.sidebar.selectbox(
    "Select Season",
    ["All","Winter","Spring","Summer","Fall"]
)


if season_filter != "All":
    df = df[df["season"] == season_filter]



# KPI METRICS

total_revenue = df["purchase_amount"].sum()
total_orders = df.shape[0]
total_customers = df["customer_id"].nunique()

col1, col2, col3 = st.columns(3)

col1.metric("Total Revenue", f"${total_revenue:,.0f}")
col2.metric("Total Orders", total_orders)
col3.metric("Total Customers", total_customers)

st.divider()

colm1, colm2 = st.columns(2)
colm3, colm4 = st.columns(2)

# REVENUE BY CATEGORY 


category_df = df.groupby("category")["purchase_amount"].sum().reset_index()
category_df = category_df.sort_values("purchase_amount", ascending=False)

with colm1:
    st.subheader("Revenue by Category")
    fig1 = px.bar(category_df,
                  x="category",
                  y="purchase_amount",
                  color="category")
    st.plotly_chart(fig1, use_container_width=True)


# PAYMENT METHODS 
payment_df = df.groupby("payment_method").size().reset_index(name="orders")
with colm2:
    st.subheader("Payment Method Distribution")
    fig2 = px.pie(payment_df,
                  names="payment_method",
                  values="orders")
    st.plotly_chart(fig2, use_container_width=True)


# TOP CUSTOMERS 
top_customers = (
    df.groupby("customer_id")["purchase_amount"]
    .sum()
    .reset_index()
    .sort_values(by="purchase_amount", ascending=False)
    .head(10)
)

top_customers["customer_id"] = top_customers["customer_id"].astype(str)

with colm3:
    st.subheader("Top Customers")
    fig3 = px.bar(
    top_customers,
        x="purchase_amount",
        y="customer_id",
        orientation="h",
        title="Top 10 Customers by Spending",
        color="purchase_amount",
    )

    fig3.update_layout(
        yaxis_title="Customer ID",
        xaxis_title="Total Spending",
    )
    st.plotly_chart(fig3, use_container_width=True)

# DISCOUNT IMPACT 
discount_df = df.groupby("discount_applied")["purchase_amount"].mean().reset_index()
with colm4:
    st.subheader("Discount Impact")
    fig4 = px.bar(discount_df,
                  x="discount_applied",
                  y="purchase_amount",
                  color="discount_applied")
    st.plotly_chart(fig4, use_container_width=True)


csv = df.to_csv(index=False).encode("utf-8")

st.download_button(
    label="Download Filtered Data",
    data=csv,
    file_name="filtered_shopping_data.csv",
    mime="text/csv"
)

