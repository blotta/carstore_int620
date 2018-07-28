CREATE TABLE postal (
    pcode varchar(6) NOT NULL,
    city varchar(30) NOT NULL,
    province varchar(2) NOT NULL,
    PRIMARY KEY (pcode)
);

CREATE TABLE users (
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

CREATE TABLE supplier (
    sid int(11) NOT NULL AUTO_INCREMENT,
    name varchar(60) NOT NULL,
    address varchar(200) NOT NULL,
    PRIMARY KEY (sid)
);

CREATE TABLE itemInfo (
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

CREATE TABLE transactions(
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
