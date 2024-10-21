-- Table for Users
CREATE TABLE Users (
    acct_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE,
    acct_balance DECIMAL(12, 2) DEFAULT 0.00
);

-- Table for Purchases
CREATE TABLE Purchases (
    id INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    acct_ID INT NOT NULL REFERENCES Users(acct_ID),
    product_ID INT NOT NULL REFERENCES Products(product_ID),
    time_purchased TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')
);

-- Table for UserBuysProduct
CREATE TABLE UserBuysProduct (
    order_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    acct_ID INT NOT NULL REFERENCES Users(acct_ID),
    product_ID INT NOT NULL REFERENCES Products(product_ID),
    price DECIMAL(12, 2) NOT NULL,
    purchase_date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
    address VARCHAR(255),
    fulfillment_status VARCHAR(50) DEFAULT 'Pending'
);

-- Table for Seller
CREATE TABLE Seller (
    acct_ID INT NOT NULL,
    product_ID INT NOT NULL,
    PRIMARY KEY (acct_ID, product_ID),
    FOREIGN KEY (acct_ID) REFERENCES Users(acct_ID),
    FOREIGN KEY (product_ID) REFERENCES Products(product_ID)
);

-- Table for Inventory
CREATE TABLE Inventory (
    acct_ID INT NOT NULL,
    product_ID INT NOT NULL,
    available_quantity INT DEFAULT 0,
    PRIMARY KEY (acct_ID, product_ID),
    FOREIGN KEY (acct_ID) REFERENCES Users(acct_ID),
    FOREIGN KEY (product_ID) REFERENCES Products(product_ID)
);

-- Table for Cart
CREATE TABLE Cart (
    cart_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    acct_ID INT NOT NULL REFERENCES Users(acct_ID),
    total_cost DECIMAL(12, 2) DEFAULT 0.00
);

-- Table for CartItem
CREATE TABLE CartItem (
    cart_item_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    cart_ID INT NOT NULL REFERENCES Cart(cart_ID),
    product_ID INT NOT NULL REFERENCES Products(product_ID),
    seller_ID INT NOT NULL REFERENCES Seller(acct_ID),
    quantity INT DEFAULT 1,
    item_price DECIMAL(12, 2) NOT NULL
);

-- Table for Orders
CREATE TABLE Orders (
    order_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    acct_ID INT NOT NULL REFERENCES Users(acct_ID),
    total_cost DECIMAL(12, 2) DEFAULT 0.00,
    order_date TIMESTAMP WITHOUT TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
    order_status VARCHAR(50) DEFAULT 'Pending'
);

-- Table for OrderItem
CREATE TABLE OrderItem (
    order_item_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    order_ID INT NOT NULL REFERENCES Orders(order_ID),
    product_ID INT NOT NULL REFERENCES Products(product_ID),
    seller_ID INT NOT NULL REFERENCES Seller(acct_ID),
    order_item_status VARCHAR(50) DEFAULT 'Processing'
);

-- Table for Products
CREATE TABLE Products (
    product_ID INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    image VARCHAR(255),
    price DECIMAL(12, 2) NOT NULL,
    category VARCHAR(50),
    rating DECIMAL(2, 1) DEFAULT 0.0,
    link VARCHAR(255)
);

-- Table for UserReviewsProduct
CREATE TABLE UserReviewsProduct (
    customer_ID INT NOT NULL REFERENCES Users(acct_ID),
    product_ID INT NOT NULL REFERENCES Products(product_ID),
    rating_num INT CHECK (rating_num BETWEEN 1 AND 5),
    rating_message TEXT,
    review_date TIMESTAMP WITHOUT TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
    PRIMARY KEY (customer_ID, product_ID)
);

-- Table for UserReviewsSeller
CREATE TABLE UserReviewsSeller (
    customer_ID INT NOT NULL REFERENCES Users(acct_ID),
    seller_ID INT NOT NULL REFERENCES Seller(acct_ID),
    rating_num INT CHECK (rating_num BETWEEN 1 AND 5),
    rating_message TEXT,
    review_date TIMESTAMP WITHOUT TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
    PRIMARY KEY (customer_ID, seller_ID)
);

-- Table for UserSendsMessage
CREATE TABLE UserSendsMessage (
    customer_ID INT NOT NULL REFERENCES Users(acct_ID),
    seller_ID INT NOT NULL REFERENCES Seller(acct_ID),
    PRIMARY KEY (customer_ID, seller_ID)
);

-- Table for Message
CREATE TABLE Message (
    msg_num INT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    customer_ID INT NOT NULL REFERENCES Users(acct_ID),
    seller_ID INT NOT NULL REFERENCES Seller(acct_ID),
    message TEXT NOT NULL,
    message_date TIMESTAMP WITHOUT TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
    product INT REFERENCES Products(product_ID)
);
