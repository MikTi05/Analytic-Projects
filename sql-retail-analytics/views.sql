-- Аналитические представления для маркетинга, закупок и менеджмента.

-- Покупательская активность и программа лояльности.
CREATE OR REPLACE VIEW view_marketing_analytics AS
SELECT
    c.customer_id,
    c.full_name,
    lc.card_number,
    ct.card_type_name,
    COUNT(r.receipt_id) AS total_purchases,
    COALESCE(SUM(r.total_amount), 0) AS total_spent
FROM Customer c
LEFT JOIN LoyaltyCard lc
    ON c.customer_id = lc.customer_id
LEFT JOIN CardType ct
    ON lc.card_type_id = ct.card_type_id
LEFT JOIN Receipt r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.full_name,
    lc.card_number,
    ct.card_type_name;


-- Детализация поставок по поставщикам, товарам и магазинам.
CREATE OR REPLACE VIEW view_procurement_supplies AS
SELECT
    d.delivery_id,
    d.delivery_date,
    s.supplier_name,
    s.city AS supplier_city,
    p.product_name,
    pt.product_type_name,
    st.store_name,
    st.city AS store_city,
    d.quantity
FROM Delivery d
JOIN Supplier s
    ON d.supplier_id = s.supplier_id
JOIN Product p
    ON d.product_id = p.product_id
JOIN ProductType pt
    ON p.product_type_id = pt.product_type_id
JOIN Store st
    ON d.store_id = st.store_id;


-- Количество чеков и сумма продаж по торговым точкам.
CREATE OR REPLACE VIEW view_executive_sales_summary AS
SELECT
    st.store_id,
    st.store_name,
    st.city,
    sf.store_format_name,
    COUNT(r.receipt_id) AS sales_transaction_count,
    COALESCE(SUM(r.total_amount), 0) AS total_sales_revenue
FROM Store st
JOIN StoreFormat sf
    ON st.store_format_id = sf.store_format_id
LEFT JOIN Receipt r
    ON st.store_id = r.store_id
GROUP BY
    st.store_id,
    st.store_name,
    st.city,
    sf.store_format_name;
