PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS MenuItemAllergen;
DROP TABLE IF EXISTS RecipeConsistsOf;
DROP TABLE IF EXISTS RawMaterial;
DROP TABLE IF EXISTS PizzaCustomization;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS CustomerOrder;
DROP TABLE IF EXISTS SizeVariant;
DROP TABLE IF EXISTS StoreManager;
DROP TABLE IF EXISTS KitchenStaff;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS CustomerPhone;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS MenuItem;
DROP TABLE IF EXISTS FranchiseLocation;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer(
    member_id TEXT NOT NULL,
    name TEXT NOT NULL,
    points_balance INTEGER NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY(member_id),
    CONSTRAINT CK_Customer_points_balance CHECK(points_balance >= 0)
);

CREATE TABLE FranchiseLocation(
    store_id TEXT PRIMARY KEY,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    province TEXT NOT NULL,
    postal_code TEXT NOT NULL,
    store_phone TEXT NOT NULL,
    seating_capacity INTEGER NOT NULL CHECK(seating_capacity > 0)
);

CREATE TABLE MenuItem(
    item_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    base_price REAL NOT NULL CHECK(base_price > 0),
    category TEXT NOT NULL CHECK(category IN ('Pizza', 'Drink', 'Side'))
);

CREATE TABLE Employee(
    employee_id TEXT PRIMARY KEY,
    store_id TEXT NOT NULL,
    name TEXT NOT NULL,
    hourly_rate REAL NOT NULL CHECK(hourly_rate >= 0),
    FOREIGN KEY (store_id) REFERENCES FranchiseLocation(store_id)
);

CREATE TABLE CustomerPhone(
    member_id TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    PRIMARY KEY(member_id, phone_number),
    FOREIGN KEY (member_id) REFERENCES Customer(member_id)
);

CREATE TABLE Driver(
    employee_id TEXT PRIMARY KEY,
    vehicle_type TEXT NOT NULL,
    insurance_expiry TEXT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE KitchenStaff(
    employee_id TEXT PRIMARY KEY,
    food_handler_cert_id TEXT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE StoreManager(
    manager_id TEXT PRIMARY KEY,
    store_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    start_date TEXT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES FranchiseLocation(store_id)
);

CREATE TABLE SizeVariant(
    variant_id TEXT PRIMARY KEY,
    item_id TEXT NOT NULL,
    size_name TEXT NOT NULL,
    crust_type TEXT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id)
);

CREATE TABLE CustomerOrder(
    order_id TEXT PRIMARY KEY,
    member_id TEXT NOT NULL,
    order_date TEXT NOT NULL,
    order_type TEXT NOT NULL CHECK(order_type IN ('Delivery', 'Pickup', 'Walk-in')),
    FOREIGN KEY (member_id) REFERENCES Customer(member_id)
);

CREATE TABLE Delivery(
    order_id TEXT PRIMARY KEY,
    driver_id TEXT NOT NULL,
    delivery_time TEXT NOT NULL,
    tip_amount REAL NOT NULL CHECK(tip_amount >= 0),
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(employee_id)
);

CREATE TABLE OrderItem(
    order_item_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    item_id TEXT NOT NULL,
    variant_id TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity >= 1),
    unit_price REAL NOT NULL CHECK(unit_price > 0),
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id),
    FOREIGN KEY (variant_id) REFERENCES SizeVariant(variant_id)
);

CREATE TABLE PizzaCustomization(
    order_item_id TEXT NOT NULL,
    custom_id TEXT NOT NULL,
    instruction TEXT NOT NULL,
    extra_charge REAL NOT NULL CHECK(extra_charge >= 0),
    PRIMARY KEY(order_item_id, custom_id),
    FOREIGN KEY (order_item_id) REFERENCES OrderItem(order_item_id)
);

CREATE TABLE RawMaterial(
    material_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    unit TEXT NOT NULL,
    expiry_date TEXT NOT NULL,
    quantity_in_stock INTEGER NOT NULL CHECK(quantity_in_stock >= 0),
    reorder_level INTEGER NOT NULL CHECK(reorder_level >= 0),
    store_id TEXT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES FranchiseLocation(store_id)
);

CREATE TABLE RecipeConsistsOf(
    item_id TEXT NOT NULL,
    material_id TEXT NOT NULL,
    quantity_required REAL NOT NULL CHECK(quantity_required > 0),
    PRIMARY KEY(item_id, material_id),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id),
    FOREIGN KEY (material_id) REFERENCES RawMaterial(material_id)
);

CREATE TABLE MenuItemAllergen(
    item_id TEXT NOT NULL,
    allergen TEXT NOT NULL,
    PRIMARY KEY(item_id, allergen),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id)
);

INSERT INTO Customer (member_id, name, points_balance) VALUES
('C001', 'Alice Chen', 120),
('C002', 'Brian Li', 45),
('C003', 'Cathy Wang', 200),
('C004', 'David Zhang', 60),
('C005', 'Emma Liu', 150),
('C006', 'Frank Sun', 35),
('C007', 'Grace Wu', 80),
('C008', 'Henry Xu', 95),
('C009', 'Ivy Zhao', 140),
('C010', 'Jason Gao', 20);

INSERT INTO FranchiseLocation (store_id, street_address, city, province, postal_code, store_phone, seating_capacity) VALUES
('S001', '100 Bloor St W', 'Toronto', 'ON', 'M5S1M4', '4165551001', 40),
('S002', '200 Yonge St', 'Toronto', 'ON', 'M5B1R8', '4165551002', 35),
('S003', '300 King St W', 'Toronto', 'ON', 'M5V1J2', '4165551003', 45),
('S004', '400 Queen St E', 'Toronto', 'ON', 'M5A1T7', '4165551004', 30),
('S005', '500 Dundas St W', 'Toronto', 'ON', 'M5T1H3', '4165551005', 38),
('S006', '600 Bloor St E', 'Toronto', 'ON', 'M4W1J5', '4165551006', 42),
('S007', '700 Danforth Ave', 'Toronto', 'ON', 'M4J1L1', '4165551007', 28),
('S008', '800 Eglinton Ave W', 'Toronto', 'ON', 'M5N1E3', '4165551008', 36),
('S009', '900 Sheppard Ave E', 'Toronto', 'ON', 'M2K2Y5', '4165551009', 50),
('S010', '1000 Finch Ave W', 'Toronto', 'ON', 'M3J2G3', '4165551010', 32);

INSERT INTO MenuItem (item_id, name, base_price, category) VALUES
('I001', 'Pepperoni Pizza', 14.99, 'Pizza'),
('I002', 'Margherita Pizza', 13.99, 'Pizza'),
('I003', 'Veggie Pizza', 14.49, 'Pizza'),
('I004', 'Hawaiian Pizza', 15.49, 'Pizza'),
('I005', 'BBQ Chicken Pizza', 15.99, 'Pizza'),
('I006', 'Garlic Bread', 5.99, 'Side'),
('I007', 'Chicken Wings', 9.99, 'Side'),
('I008', 'Caesar Salad', 7.49, 'Side'),
('I009', 'Cola', 2.99, 'Drink'),
('I010', 'Bottled Water', 1.99, 'Drink');

INSERT INTO Employee (employee_id, store_id, name, hourly_rate) VALUES
('D001', 'S001', 'Daniel Park', 18.50),
('D002', 'S002', 'Ethan Kim', 18.00),
('D003', 'S003', 'Felix Zhou', 19.00),
('D004', 'S004', 'George Lin', 18.25),
('D005', 'S005', 'Hugo Ma', 18.75),
('D006', 'S006', 'Ian Luo', 18.50),
('D007', 'S007', 'Kevin He', 18.00),
('D008', 'S008', 'Leo Tang', 19.25),
('D009', 'S009', 'Mason Qiu', 18.60),
('D010', 'S010', 'Noah Xie', 18.40),
('K001', 'S001', 'Olivia Shen', 17.50),
('K002', 'S002', 'Peter Han', 17.00),
('K003', 'S003', 'Queenie Yu', 17.80),
('K004', 'S004', 'Ryan Gu', 17.20),
('K005', 'S005', 'Sophia Dai', 18.00),
('K006', 'S006', 'Tony Fan', 17.40),
('K007', 'S007', 'Uma Jin', 17.60),
('K008', 'S008', 'Victor Cai', 17.90),
('K009', 'S009', 'Wendy Hou', 18.10),
('K010', 'S010', 'Yuki Ren', 17.30);

INSERT INTO CustomerPhone (member_id, phone_number) VALUES
('C001', '6475550001'),
('C002', '6475550002'),
('C003', '6475550003'),
('C004', '6475550004'),
('C005', '6475550005'),
('C006', '6475550006'),
('C007', '6475550007'),
('C008', '6475550008'),
('C009', '6475550009'),
('C010', '6475550010');

INSERT INTO Driver (employee_id, vehicle_type, insurance_expiry) VALUES
('D001', 'Car', '2026-12-31'),
('D002', 'Bike', '2026-11-30'),
('D003', 'Car', '2026-10-31'),
('D004', 'Bike', '2026-09-30'),
('D005', 'Car', '2026-12-15'),
('D006', 'Bike', '2026-08-31'),
('D007', 'Car', '2026-07-31'),
('D008', 'Bike', '2026-12-20'),
('D009', 'Car', '2026-11-15'),
('D010', 'Bike', '2026-10-15');

INSERT INTO KitchenStaff (employee_id, food_handler_cert_id) VALUES
('K001', 'FHC001'),
('K002', 'FHC002'),
('K003', 'FHC003'),
('K004', 'FHC004'),
('K005', 'FHC005'),
('K006', 'FHC006'),
('K007', 'FHC007'),
('K008', 'FHC008'),
('K009', 'FHC009'),
('K010', 'FHC010');

INSERT INTO StoreManager (manager_id, store_id, name, start_date) VALUES
('MGR001', 'S001', 'Aaron Bell', '2023-01-15'),
('MGR002', 'S002', 'Betty Cole', '2023-02-01'),
('MGR003', 'S003', 'Chris Dean', '2023-03-10'),
('MGR004', 'S004', 'Diana Frost', '2023-04-20'),
('MGR005', 'S005', 'Eric Grant', '2023-05-05'),
('MGR006', 'S006', 'Fiona Hart', '2023-06-12'),
('MGR007', 'S007', 'Gavin Irwin', '2023-07-08'),
('MGR008', 'S008', 'Helen Jones', '2023-08-16'),
('MGR009', 'S009', 'Isaac Kent', '2023-09-09'),
('MGR010', 'S010', 'Julia Long', '2023-10-01');

INSERT INTO SizeVariant (variant_id, item_id, size_name, crust_type) VALUES
('V001', 'I001', 'Small', 'Thin'),
('V002', 'I001', 'Large', 'Regular'),
('V003', 'I002', 'Medium', 'Thin'),
('V004', 'I002', 'Large', 'Stuffed'),
('V005', 'I003', 'Medium', 'Thin'),
('V006', 'I003', 'Large', 'Regular'),
('V007', 'I004', 'Medium', 'Regular'),
('V008', 'I004', 'Large', 'Stuffed'),
('V009', 'I005', 'Medium', 'Thin'),
('V010', 'I005', 'Large', 'Regular'),
('V011', 'I006', 'Regular', 'N/A'),
('V012', 'I007', 'Regular', 'N/A'),
('V013', 'I008', 'Regular', 'N/A'),
('V014', 'I009', 'Regular', 'N/A'),
('V015', 'I010', 'Regular', 'N/A');

INSERT INTO CustomerOrder (order_id, member_id, order_date, order_type) VALUES
('O001', 'C001', '2026-03-01', 'Delivery'),
('O002', 'C002', '2026-03-02', 'Delivery'),
('O003', 'C003', '2026-03-03', 'Delivery'),
('O004', 'C004', '2026-03-04', 'Delivery'),
('O005', 'C005', '2026-03-05', 'Delivery'),
('O006', 'C006', '2026-03-06', 'Delivery'),
('O007', 'C007', '2026-03-07', 'Delivery'),
('O008', 'C008', '2026-03-08', 'Delivery'),
('O009', 'C009', '2026-03-09', 'Delivery'),
('O010', 'C010', '2026-03-10', 'Delivery'),
('O011', 'C003', '2026-03-11', 'Pickup'),
('O012', 'C005', '2026-03-12', 'Walk-in');

INSERT INTO RawMaterial (material_id, name, unit, expiry_date, quantity_in_stock, reorder_level, store_id) VALUES
('RM001', 'Pizza Dough', 'pcs', '2026-04-30', 120, 30, 'S001'),
('RM002', 'Mozzarella Cheese', 'kg', '2026-04-25', 40, 10, 'S001'),
('RM003', 'Pepperoni', 'kg', '2026-05-10', 25, 8, 'S002'),
('RM004', 'Tomato Sauce', 'L', '2026-06-01', 50, 15, 'S002'),
('RM005', 'Bell Peppers', 'kg', '2026-04-20', 18, 6, 'S003'),
('RM006', 'Pineapple', 'kg', '2026-04-18', 12, 5, 'S004'),
('RM007', 'Chicken Breast', 'kg', '2026-04-22', 20, 6, 'S005'),
('RM008', 'Garlic Butter', 'L', '2026-05-30', 15, 5, 'S006'),
('RM009', 'Cola Syrup', 'box', '2026-07-15', 30, 10, 'S007'),
('RM010', 'Bottled Water Case', 'case', '2027-01-01', 45, 12, 'S008');

INSERT INTO RecipeConsistsOf (item_id, material_id, quantity_required) VALUES
('I001', 'RM001', 1.00),
('I001', 'RM003', 0.10),
('I002', 'RM001', 1.00),
('I002', 'RM002', 0.25),
('I003', 'RM001', 1.00),
('I003', 'RM005', 0.15),
('I004', 'RM001', 1.00),
('I004', 'RM006', 0.12),
('I005', 'RM001', 1.00),
('I005', 'RM007', 0.18),
('I006', 'RM008', 0.08),
('I007', 'RM007', 0.20),
('I008', 'RM005', 0.10),
('I009', 'RM009', 0.05),
('I010', 'RM010', 1.00);

INSERT INTO MenuItemAllergen (item_id, allergen) VALUES
('I001', 'Gluten'),
('I001', 'Dairy'),
('I002', 'Gluten'),
('I002', 'Dairy'),
('I003', 'Gluten'),
('I003', 'Dairy'),
('I004', 'Gluten'),
('I005', 'Gluten'),
('I006', 'Gluten'),
('I009', 'Caffeine');

INSERT INTO OrderItem (order_item_id, order_id, item_id, variant_id, quantity, unit_price) VALUES
('OI001', 'O001', 'I001', 'V002', 1, 18.99),
('OI002', 'O001', 'I009', 'V014', 2, 2.99),
('OI003', 'O002', 'I002', 'V004', 1, 17.99),
('OI004', 'O002', 'I006', 'V011', 1, 5.99),
('OI005', 'O003', 'I003', 'V006', 1, 16.99),
('OI006', 'O003', 'I010', 'V015', 2, 1.99),
('OI007', 'O004', 'I004', 'V008', 1, 18.49),
('OI008', 'O004', 'I007', 'V012', 1, 9.99),
('OI009', 'O005', 'I005', 'V010', 1, 19.49),
('OI010', 'O005', 'I009', 'V014', 2, 2.99),
('OI011', 'O006', 'I001', 'V001', 2, 14.99),
('OI012', 'O007', 'I002', 'V003', 1, 15.99),
('OI013', 'O008', 'I003', 'V005', 1, 15.49),
('OI014', 'O009', 'I004', 'V007', 1, 16.49),
('OI015', 'O010', 'I005', 'V009', 1, 16.99),
('OI016', 'O011', 'I006', 'V011', 2, 5.99),
('OI017', 'O011', 'I009', 'V014', 2, 2.99),
('OI018', 'O012', 'I008', 'V013', 1, 7.49),
('OI019', 'O012', 'I010', 'V015', 1, 1.99);

INSERT INTO Delivery (order_id, driver_id, delivery_time, tip_amount) VALUES
('O001', 'D001', '2026-03-01 18:35:00', 3.00),
('O002', 'D002', '2026-03-02 19:10:00', 2.50),
('O003', 'D003', '2026-03-03 18:50:00', 4.00),
('O004', 'D004', '2026-03-04 20:05:00', 3.50),
('O005', 'D005', '2026-03-05 19:25:00', 5.00),
('O006', 'D006', '2026-03-06 18:40:00', 2.00),
('O007', 'D007', '2026-03-07 19:55:00', 3.25),
('O008', 'D008', '2026-03-08 20:15:00', 4.50),
('O009', 'D009', '2026-03-09 18:30:00', 2.75),
('O010', 'D010', '2026-03-10 19:05:00', 3.80);

INSERT INTO PizzaCustomization (order_item_id, custom_id, instruction, extra_charge) VALUES
('OI001', 'CU001', 'Extra cheese', 1.50),
('OI003', 'CU002', 'No basil', 0.00),
('OI005', 'CU003', 'Add mushrooms', 1.25),
('OI007', 'CU004', 'Extra pineapple', 1.00),
('OI009', 'CU005', 'No onions', 0.00),
('OI011', 'CU006', 'Thin crust only', 0.00),
('OI012', 'CU007', 'Add olives', 1.25),
('OI013', 'CU008', 'No green peppers', 0.00),
('OI014', 'CU009', 'Extra sauce', 0.75),
('OI015', 'CU010', 'Add jalapenos', 1.00);
