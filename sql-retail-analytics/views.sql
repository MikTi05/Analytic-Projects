-- Три аналитических представления из ПР2, страницы 70-72.
-- Запускать после schema.sql и seed.sql от владельца таблиц.
-- Создание пользователей и назначение прав из отчёта сюда не включены.

-- Одна строка на покупателя и карту (либо на покупателя без карты).
-- При нескольких картах итоги покупателя повторяются: строки нельзя суммировать.
CREATE OR REPLACE VIEW view_marketing_analytics AS
SELECT
    c.customer_id,
    c.full_name,
    lc.card_number,
    ct.card_type_name,
    COUNT(r.receipt_id) AS total_purchases,
    COALESCE(SUM(r.total_amount), 0) AS total_spent
FROM Customer c
LEFT JOIN LoyaltyCard lc ON c.customer_id = lc.customer_id
LEFT JOIN CardType ct ON lc.card_type_id = ct.card_type_id
LEFT JOIN Receipt r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.full_name, lc.card_number, ct.card_type_name;

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
JOIN Supplier s ON d.supplier_id = s.supplier_id
JOIN Product p ON d.product_id = p.product_id
JOIN ProductType pt ON p.product_type_id = pt.product_type_id
JOIN Store st ON d.store_id = st.store_id;

-- Итоги по магазинам за всё время; формат и город служат признаками магазина.
CREATE OR REPLACE VIEW view_executive_sales_summary AS
SELECT
    st.store_id,
    st.store_name,
    st.city,
    sf.store_format_name,
    COUNT(r.receipt_id) AS sales_transaction_count,
    COALESCE(SUM(r.total_amount), 0) AS total_sales_revenue
FROM Store st
JOIN StoreFormat sf ON st.store_format_id = sf.store_format_id
LEFT JOIN Receipt r ON st.store_id = r.store_id
GROUP BY st.store_id, st.store_name, st.city, sf.store_format_name;
