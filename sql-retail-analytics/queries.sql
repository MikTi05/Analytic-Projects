-- Восемь основных запросов ПР2, страницы 1-33.
-- В запросах 1, 4, 5, 6 значения фильтров согласованы с данными ПР1.
-- Логика запросов сохранена; сценарии с дополнительными фильтрами исключены.

-- ============================================================
-- 1. Товары, продававшиеся в выбранном магазине
-- ============================================================
-- ПР2, стр. 1. Магазин: Pyaterochka Center (ПР1, стр. 16).
-- price берётся из Product и не является исторической ценой позиции чека.
SELECT DISTINCT
    p.product_name,
    p.article,
    p.price
FROM Product p
JOIN ReceiptItem ri ON p.product_id = ri.product_id
JOIN Receipt r ON ri.receipt_id = r.receipt_id
JOIN Store s ON r.store_id = s.store_id
WHERE s.store_name = 'Pyaterochka Center';

-- ============================================================
-- 2. Проданные товары с поставщиком из города магазина
-- ============================================================
-- ПР2, стр. 3-4. Поставка сопоставляется и по товару, и по магазину.
SELECT DISTINCT
    p.product_id,
    p.product_name,
    s.supplier_name,
    s.city AS supplier_city,
    st.store_name,
    st.city AS store_city
FROM Product p
JOIN ReceiptItem ri ON p.product_id = ri.product_id
JOIN Receipt r ON ri.receipt_id = r.receipt_id
JOIN Store st ON r.store_id = st.store_id
JOIN Delivery d ON d.product_id = p.product_id
    AND d.store_id = st.store_id
JOIN Supplier s ON d.supplier_id = s.supplier_id
WHERE s.city = st.city
ORDER BY p.product_id, s.supplier_name, st.store_name;

-- ============================================================
-- 3. Покупатели с суммой покупок за месяц не выше порога
-- ============================================================
-- ПР2, стр. 8. Период: май 2025 года; порог: 1000.
SELECT
    c.full_name,
    SUM(r.total_amount) AS total_spent
FROM Customer c
JOIN Receipt r ON c.customer_id = r.customer_id
WHERE DATE_TRUNC('month', r.purchase_date) = DATE '2025-05-01'
GROUP BY c.customer_id, c.full_name
HAVING SUM(r.total_amount) <= 1000
ORDER BY total_spent;

-- ============================================================
-- 4. Поставщики последней поставки товара в магазин по адресу
-- ============================================================
-- ПР2, стр. 11-12. Товар Milk 1L и адрес Arbat 15 взяты из ПР1.
WITH LastDelivery AS (
    SELECT
        MAX(d.delivery_date) AS last_delivery_date
    FROM Delivery d
    JOIN Product p ON d.product_id = p.product_id
    JOIN Store st ON d.store_id = st.store_id
    WHERE p.product_name = 'Milk 1L'
        AND st.address = 'Arbat 15'
)
SELECT DISTINCT
    s.supplier_name,
    d.delivery_date,
    p.product_name,
    st.store_name,
    st.address
FROM Delivery d
JOIN Supplier s ON d.supplier_id = s.supplier_id
JOIN Product p ON d.product_id = p.product_id
JOIN Store st ON d.store_id = st.store_id
JOIN LastDelivery ld ON d.delivery_date = ld.last_delivery_date
WHERE p.product_name = 'Milk 1L'
    AND st.address = 'Arbat 15'
ORDER BY s.supplier_name;

-- ============================================================
-- 5. Товары и поставщики в магазинах выбранного покупателя
-- ============================================================
-- ПР2, стр. 15-16. Покупатель: Ivan Petrov (ПР1, стр. 16).
WITH CustomerStores AS (
    SELECT DISTINCT
        r.store_id
    FROM Customer c
    JOIN Receipt r ON c.customer_id = r.customer_id
    WHERE c.full_name = 'Ivan Petrov'
)
SELECT DISTINCT
    p.product_id AS product_number,
    p.product_name,
    s.supplier_name
FROM CustomerStores cs
JOIN Receipt r ON r.store_id = cs.store_id
JOIN ReceiptItem ri ON r.receipt_id = ri.receipt_id
JOIN Product p ON ri.product_id = p.product_id
JOIN Delivery d ON d.product_id = p.product_id
    AND d.store_id = cs.store_id
JOIN Supplier s ON d.supplier_id = s.supplier_id
ORDER BY p.product_id, s.supplier_name;

-- ============================================================
-- 6. Магазины, продававшие товар указанного поставщика
-- ============================================================
-- ПР2, стр. 19-20. Товар Milk 1L, поставщик FreshFood LLC из ПР1.
SELECT DISTINCT
    st.store_name,
    st.address
FROM Store st
JOIN Receipt r ON st.store_id = r.store_id
JOIN ReceiptItem ri ON r.receipt_id = ri.receipt_id
JOIN Product p ON ri.product_id = p.product_id
JOIN Delivery d ON d.store_id = st.store_id
    AND d.product_id = p.product_id
JOIN Supplier s ON d.supplier_id = s.supplier_id
WHERE p.product_name = 'Milk 1L'
    AND s.supplier_name = 'FreshFood LLC';

-- ============================================================
-- 7. Популярный и непопулярный товары у владельцев карт за день
-- ============================================================
-- ПР2, стр. 23-25. Дата: 2025-05-10; популярность по проданным единицам.
-- Только товары с продажами. EXISTS проверяет наличие карты у покупателя,
-- а не применение карты в конкретном чеке. Ничьи разрешаются по product_id.
WITH ProductStats AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(ri.quantity) AS total_quantity
    FROM Product p
    JOIN ReceiptItem ri ON p.product_id = ri.product_id
    JOIN Receipt r ON ri.receipt_id = r.receipt_id
    WHERE r.purchase_date = DATE '2025-05-10'
        AND EXISTS (
            SELECT 1
            FROM LoyaltyCard lc
            WHERE lc.customer_id = r.customer_id
        )
    GROUP BY p.product_id, p.product_name
),
RankedProducts AS (
    SELECT
        product_id,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (ORDER BY total_quantity DESC, product_id) AS rn_popular,
        ROW_NUMBER() OVER (ORDER BY total_quantity ASC, product_id) AS rn_unpopular
    FROM ProductStats
)
SELECT
    product_id,
    product_name,
    total_quantity,
    CASE
        WHEN rn_popular = 1 AND rn_unpopular = 1
            THEN 'Самый популярный и самый непопулярный'
        WHEN rn_popular = 1
            THEN 'Самый популярный'
        WHEN rn_unpopular = 1
            THEN 'Самый непопулярный'
    END AS status
FROM RankedProducts
WHERE rn_popular = 1 OR rn_unpopular = 1
ORDER BY status;

-- ============================================================
-- 8. До трёх ведущих поставщиков наименее частого в чеках товара
-- ============================================================
-- ПР2, стр. 32-33. Продажи и поставки за май 2025 года.
-- Непопулярность: число чеков, а не число единиц. Только проданные товары.
-- Объём поставок считается только по выбранному товару.
-- На seed.sql результат пуст: у Yogurt Cherry нет поставок в мае 2025 года.
WITH UnpopularProduct AS (
    SELECT
        ri.product_id,
        COUNT(DISTINCT r.receipt_id) AS receipt_count
    FROM ReceiptItem ri
    JOIN Receipt r ON ri.receipt_id = r.receipt_id
    WHERE r.purchase_date >= DATE '2025-05-01'
        AND r.purchase_date < DATE '2025-06-01'
    GROUP BY ri.product_id
    ORDER BY receipt_count ASC, ri.product_id
    LIMIT 1
)
SELECT
    s.supplier_name,
    SUM(d.quantity) AS total_supply_volume
FROM Delivery d
JOIN Supplier s ON d.supplier_id = s.supplier_id
JOIN UnpopularProduct up ON d.product_id = up.product_id
WHERE d.delivery_date >= DATE '2025-05-01'
    AND d.delivery_date < DATE '2025-06-01'
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_supply_volume DESC
LIMIT 3;
