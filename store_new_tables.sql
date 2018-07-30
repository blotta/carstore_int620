
CREATE DATABASE IF NOT EXISTS carstore_int620;


CREATE TABLE IF NOT EXISTS carstore_int620.postal (
    pcode varchar(6) NOT NULL,
    city varchar(30) NOT NULL,
    province varchar(2) NOT NULL,
    PRIMARY KEY (pcode)
);

CREATE TABLE IF NOT EXISTS carstore_int620.users (
    cid int(11) NOT NULL AUTO_INCREMENT,
    username varchar(100) NOT NULL,
    password varchar(500) NOT NULL,
    fname varchar(100) NOT NULL,
    lname varchar(100) NOT NULL,
    phone varchar(20) NOT NULL,
    street varchar(200) NOT NULL,
    pcode varchar(6) NOT NULL,
    email varchar(100) NOT NULL,
    PRIMARY KEY (cid),
    FOREIGN KEY (pcode) REFERENCES postal(pcode)
);

CREATE TABLE IF NOT EXISTS carstore_int620.supplier (
    sid int(11) NOT NULL AUTO_INCREMENT,
    name varchar(60) NOT NULL,
    address varchar(200) NOT NULL,
    PRIMARY KEY (sid)
);

CREATE TABLE IF NOT EXISTS carstore_int620.itemInfo (
    pid int(11) NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    description varchar(200) NOT NULL,
    color varchar(12) NOT NULL,
    transmission varchar(12) NOT NULL,
    doors int(8) NOT NULL,
    driveTrain varchar(4) NOT NULL,
    price decimal(10,2) NOT NULL,
    qty int(2) NOT NULL,
    picture varchar(200) NOT NULL,
    sid int NOT NULL,
    CHECK ( price > 0 ),
    CHECK (qty >= 0 ),
    PRIMARY KEY (pid),
    FOREIGN KEY (sid) REFERENCES supplier(sid)
);

CREATE TABLE IF NOT EXISTS carstore_int620.transactions(
    tid int(11) NOT NULL AUTO_INCREMENT,
    cid int(11) NOT NULL,
    pid int(11) NOT NULL,
    paymentInfo varchar(20) NOT NULL,
    cardType varchar(30) NOT NULL,
    price decimal(10,2) NOT NULL,
    expiry varchar(6) NOT NULL,
    sec varchar(3) NOT NULL,
    date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CHECK ( price > 0 ),
    PRIMARY KEY (tid),
    FOREIGN KEY (cid) REFERENCES users(cid),
    FOREIGN KEY (pid) REFERENCES itemInfo(pid)
);

#################
### Suppliers ###
#################

INSERT INTO carstore_int620.supplier ( name, address) VALUES (
    'Hyundai',
    '11188 Yonge St, Richmond Hill, ON L4S 1K9'
);

INSERT INTO carstore_int620.supplier ( name, address) VALUES (
    'Acura',
    '5201 Highway 7 East in Markham, ON L3R 1N3'
);
INSERT INTO carstore_int620.supplier ( name, address) VALUES (
    'Honda',
    '8220 Kennedy Rd, Unionville, ON L3R 5X3'
);
INSERT INTO carstore_int620.supplier ( name, address) VALUES (
    'Volkswagen',
    '10440 Yonge St, Richmond Hill, ON L4C 3C4'
);
INSERT INTO carstore_int620.supplier ( name, address) VALUES (
    'Audi',
    '175 Yorkland Blvd, North York, ON M2J 4R2'
);
INSERT INTO carstore_int620.supplier ( name, address) VALUES (
    'BMW',
    '371 Ohio Rd, Richmond Hill, ON L4C 3A1'
);

#################
###   Cars    ###
#################

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Hyundai Elantra',
    '2017 Pearl Blue',
    'Pearl Blue',
    'Manual 6S',
    4,
    'FWD',
    18000,
    4,
    'Elantra.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Hyundai')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Acura MDX',
    '2017 Blue',
    'Blue',
    'Automatic 9S',
    4,
    'AWD',
    40000,
    30,
    'Acura_mdx2017.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Acura')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Honda Civic',
    '2017 Blue',
    'Blue',
    'Manual 6S',
    4,
    'FWD',
    19000,
    20,
    'HondaCivic2017.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Honda')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Volkswagen Tiguan',
    '2017 Red',
    'Red',
    'Automatic 6S',
    4,
    'FWD',
    26000,
    20,
    '2017_Tiguan.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Volkswagen')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Audi A4',
    '2017 Black',
    'Black',
    'Automatic 7S',
    4,
    'FWD',
    39000,
    25,
    'A4Audi.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Audi')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Honda Pilot',
    '2017 Cyan',
    'Cyan',
    'Automatic 6S',
    4,
    'AWD',
    41000,
    35,
    'PilotHonda.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Honda')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'Hyundai Genesis Coupe',
    '2017 White',
    'White',
    'Manual 6S',
    2,
    'RWD',
    30000,
    37,
    '2017_Genesis.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'Hyundai')
);

INSERT INTO carstore_int620.itemInfo (name, description, color, transmission, doors, driveTrain, price, qty, picture, sid) VALUES (
    'BMW M4',
    '2017 Gold',
    'Gold',
    'Automatic 7S',
    2,
    'RWD',
    80000,
    17,
    'BmwM4_gold.jpg',
    (SELECT sid FROM carstore_int620.supplier WHERE name = 'BMW')
);


-- None of these work
DELIMITER $$
CREATE PROCEDURE dec_qty(p INT)
BEGIN
    UPDATE itemInfo SET qty = qty - 1 WHERE pid = p;
END $$
DELIMETER ;

DELIMETER $$
CREATE TRIGGER decrement_qty
BEFORE INSERT ON transactions
FOR EACH ROW BEGIN
    CALL dec_qty(NEW.pid);
END$$
DELIMETER ;

DELIMETER $$
CREATE TRIGGER decrement_qty
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE itemInfo SET qty = qty - 1 WHERE itemInfo.pid = NEW.pid;
END$$
DELIMETER ;
-- ###################

-- Example transaction
INSERT INTO transactions (cid, pid, paymentInfo, cardType, price, expiry, sec) VALUES (
    (SELECT cid FROM users WHERE username = 'vvvv'),
    (SELECT pid FROM itemInfo WHERE name = 'Hyundai Elantra'),
    1234123412341234,
    'mastercard',
    20000,
    '11/18',
    123
);

INSERT INTO transactions (cid, pid, paymentInfo, cardType, price, expiry, sec) VALUES (
    (SELECT cid FROM users WHERE username = 'vvvv'),
    (SELECT pid FROM itemInfo WHERE name = 'BMW M4'),
    1234123412341234,
    'visa',
    40000,
    '11/18',
    423
);

-- ####################
