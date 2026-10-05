-- Демонстрационные данные ПР1, страницы 15-19.
-- Сохранены исходные значения, включая отличия цен в справочнике и чеках.
-- Полный набор данных из скриншотов ПР2 не предоставлен.

INSERT INTO CardType (card_type_id, card_type_name) VALUES
    (1, 'discount'),
    (2, 'bonus'),
    (3, 'gift');

-- Эта запись введена вручную в ПР1; значение подтверждено скриншотом на стр. 19.
INSERT INTO CardType (card_type_id, card_type_name) VALUES
    (4, 'premium');

INSERT INTO ProductType (product_type_id, product_type_name) VALUES
    (1, 'dairy'),
    (2, 'bakery'),
    (3, 'beverages');

INSERT INTO StoreFormat (store_format_id, store_format_name) VALUES
    (1, 'магазин у дома'),
    (2, 'супермаркет'),
    (3, 'гипермаркет');

INSERT INTO Supplier (supplier_id, supplier_name, city, address, phone) VALUES
    (1, 'FreshFood LLC', 'Moscow', 'Lenina 10', '+79990001111'),
    (2, 'MilkTrade', 'Moscow', 'Tverskaya 25', '+79990002222'),
    (3, 'BreadHouse', 'Kazan', 'Centralnaya 7', '+79990003333'),
    (4, 'Neva Products', 'Saint-Petersburg', 'Nevsky 100', '+79990004444'),
    (5, 'Siberia Trade', 'Novosibirsk', 'Lenina 1', '+79990005555');

INSERT INTO Customer (customer_id, full_name, phone, email) VALUES
    (1, 'Ivan Petrov', '+79001112233', 'ivan@example.com'),
    (2, 'Anna Smirnova', '+79002223344', 'anna@example.com'),
    (3, 'Sergey Ivanov', '+79003334455', 'sergey@example.com'),
    (4, 'Maria Volkova', '+79004445566', 'maria@example.com');

-- Две строки CSV из ПР1, стр. 19, перенесены в INSERT без изменения значений.
INSERT INTO Customer (customer_id, full_name, phone, email) VALUES
    (5, 'Dmitry Sokolov', '+79005556677', 'dmitry@example.com'),
    (6, 'Elena Popova', '+79006667788', 'elena@example.com');

INSERT INTO Store (store_id, store_name, address, city, store_format_id) VALUES
    (1, 'Pyaterochka Center', 'Arbat 15', 'Moscow', 1),
    (2, 'SuperMart West', 'Pushkina 20', 'Moscow', 2),
    (3, 'HyperCity', 'Victory 100', 'Kazan', 3);

INSERT INTO Product (product_id, product_name, article, price, product_type_id) VALUES
    (1, 'Milk 1L', 'MILK001', 89.90, 1),
    (2, 'Bread White', 'BREAD001', 45.50, 2),
    (3, 'Yogurt Cherry', 'YOG001', 65.00, 1),
    (4, 'Cola 1.5L', 'COLA001', 120.00, 3),
    (5, 'Juice Orange', 'JUICE001', 150.00, 3),
    (6, 'Chocolate Bar', 'CHOCO001', 50.00, 2);

INSERT INTO LoyaltyCard (
    loyalty_card_id, card_number, customer_id, card_type_id, issue_date
) VALUES
    (1, 'CARD1001', 1, 1, '2024-01-10'),
    (2, 'CARD1002', 2, 2, '2024-02-15'),
    (3, 'CARD1003', 3, 2, '2024-03-05'),
    (4, 'CARD1004', 4, 3, '2024-04-01');

INSERT INTO Receipt (
    receipt_id, purchase_date, store_id, customer_id, total_amount
) VALUES
    (1, '2025-05-10', 1, 1, 200.40),
    (2, '2025-05-10', 2, 2, 270.00),
    (3, '2025-05-11', 1, 3, 154.90),
    (4, '2025-06-01', 3, 4, 315.00),
    (5, '2025-05-10', 1, 2, 179.80),
    (6, '2025-05-10', 2, 1, 89.90);

INSERT INTO ReceiptItem (
    receipt_id, product_id, quantity, price, line_amount
) VALUES
    (1, 1, 2, 89.90, 179.80),
    (1, 2, 1, 20.60, 20.60),
    (2, 4, 1, 120.00, 120.00),
    (2, 5, 1, 150.00, 150.00),
    (3, 2, 1, 45.50, 45.50),
    (3, 3, 1, 109.40, 109.40),
    (4, 1, 1, 89.90, 89.90),
    (4, 5, 1, 225.10, 225.10),
    (5, 1, 2, 89.90, 179.80),
    (6, 1, 1, 89.90, 89.90);

INSERT INTO Delivery (
    delivery_id, delivery_date, supplier_id, store_id, product_id, quantity
) VALUES
    (1, '2025-05-01', 1, 1, 1, 100),
    (2, '2025-05-02', 3, 1, 2, 80),
    (3, '2025-05-03', 2, 2, 1, 120),
    (4, '2025-05-04', 1, 2, 4, 60),
    (5, '2025-05-05', 1, 3, 5, 90),
    (6, '2025-06-01', 2, 1, 3, 70),
    (7, '2025-05-12', 2, 3, 5, 50),
    (8, '2025-05-15', 4, 2, 5, 200),
    (9, '2025-05-18', 3, 1, 5, 30);
