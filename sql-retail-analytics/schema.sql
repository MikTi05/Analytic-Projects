-- Финальная схема ПР1, страницы 12-15. Запускать в пустой базе данных.

CREATE TABLE ProductType (
    product_type_id INT PRIMARY KEY,
    product_type_name VARCHAR(100) NOT NULL
);

CREATE TABLE StoreFormat (
    store_format_id INT PRIMARY KEY,
    store_format_name VARCHAR(100) NOT NULL
);

CREATE TABLE CardType (
    card_type_id INT PRIMARY KEY,
    card_type_name VARCHAR(100) NOT NULL
);

CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE Store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    address VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    store_format_id INT NOT NULL REFERENCES StoreFormat(store_format_id)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    article VARCHAR(50) UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    product_type_id INT NOT NULL REFERENCES ProductType(product_type_id)
);

CREATE TABLE LoyaltyCard (
    loyalty_card_id INT PRIMARY KEY,
    card_number VARCHAR(30) UNIQUE NOT NULL,
    customer_id INT NOT NULL REFERENCES Customer(customer_id),
    card_type_id INT NOT NULL REFERENCES CardType(card_type_id),
    issue_date DATE NOT NULL
);

CREATE TABLE Receipt (
    receipt_id INT PRIMARY KEY,
    purchase_date DATE NOT NULL,
    store_id INT NOT NULL REFERENCES Store(store_id),
    customer_id INT NOT NULL REFERENCES Customer(customer_id),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0)
);

CREATE TABLE ReceiptItem (
    receipt_id INT NOT NULL REFERENCES Receipt(receipt_id),
    product_id INT NOT NULL REFERENCES Product(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    line_amount DECIMAL(10,2) NOT NULL CHECK (line_amount >= 0),
    PRIMARY KEY (receipt_id, product_id)
);

CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY,
    delivery_date DATE NOT NULL,
    supplier_id INT NOT NULL REFERENCES Supplier(supplier_id),
    store_id INT NOT NULL REFERENCES Store(store_id),
    product_id INT NOT NULL REFERENCES Product(product_id),
    quantity INT NOT NULL CHECK (quantity > 0)
);
