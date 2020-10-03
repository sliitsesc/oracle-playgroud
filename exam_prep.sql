-- sqlplus

-- @/orcl

CREATE TYPE exchanges_varray as VARRAY(3) OF VARCHAR(40)
/

CREATE TYPE stock_type AS OBJECT (
    companyName VARCHAR(20),
    currentPrice NUMBER(6,2),
    exchanges exchanges_varray,
    lastDivident NUMBER(4,2),
    eps NUMBER(4,2)
)
/

CREATE TYPE address_type AS OBJECT (
    streetNo CHAR(10),
    streetName CHAR(15),
    subrub CHAR(20),
    state CHAR(15),
    pin CHAR(10)
)
/

CREATE TYPE invesment_type AS OBJECT (
    company REF stock_type,
    purchasePrice NUMBER(6,2)
)


-- Member functions
CREATE TYPE product_typ AS OBJECT(
    productID CHAR(5),
    name VARCHAR(20),
    price FLOAT,
    MEMBER FUNCTION priceInYen(rate FLOAT) RETURN FLOAT
)

CREATE TYPE BODY product_typ AS
MEMBER FUNCTION priceInYen(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN rate * SELF.price;
    END;
END;

CREATE TABLE products_tbl OF product_typ;

ALTER TYPE product_typ
ADD MEMBER FUNCTION priceInUSD(rate FLOAT) RETURN FLOAT
CASCADE;

CREATE OR REPLACE TYPE BODY product_typ AS
MEMBER FUNCTION priceInYen(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN rate * SELF.price;
    END priceInYen;

MEMBER FUNCTION priceInUSD(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN rate * SELF.price;
    END priceInUSD;
END

-- mb 2
ALTER TYPE stock_type
ADD MEMBER FUNCTION yield RETURN FLOAT
CASCADE
/

CREATE OR REPLACE TYPE BODY stock_type AS
MEMBER FUNCTION yield RETURN FLOAT IS
    BEGIN
        RETURN ((SELF.individend/self.cprice) * 100);
    END
END;

SELECT s.company, s.yield()
FROM stock_tbl s
/