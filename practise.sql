CREATE OR REPLACE TYPE BODY client_t AS 
MEMBER FUNCTION profit(stdate DATE) RETURN FLOAT IS
profitamt FLOAT;
BEGIN
    SELECT SUM((l.stock_cprice - i.pprice) * i.qty) INTO profitamt
    FROM TABLE(self.inversment) i
    WHERE i.pdate >= stdate;
    RETURN profitamt;
END;
END;

-- XML
UNTYPED XML COLUMN IN TABLE:
    CREATE TABLE AdminDocs(
        id INT PRIMARY KEY,
        xDoc XML NOT NULL
    )

TYPED XML COLUMN IN TABLE:
    CREATE TABLE AdminDocs(
        id INT PRIMARY KEY,
        xDoc XML (CONTENT myCollection)
    )

-- inserting values
INSERT INTO AdminDocs VALUES (1,
    '
    <book>
        <title>
            Writing Secure Code
        </title>
    </book>
    '
)

-- Member funtions practise
CREATE TYPE product_type AS OBJECT(
    productID CHAR(5),
    name VARCHAR(20),
    price FLOAT,
    MEMBER FUNCTION priceInYen(rate FLOAT) RETURN FLOAT;
)

CREATE TYPE BODY product_type AS
MEMBER FUNCTION priceInYen(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN rate * SELF.price;
    END priceInYen;
END;

ALTER TYPE product_type 
ADD MEMBER FUNCTION priceInUSD(rate FLOAT) RETURN FLOAT
CASCADE
/

CREATE OR REPLACE TYPE BODY product_type AS 
MEMBER FUNCTION priceInYen(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN rate * SELF.price;
    END priceInYen;
MEMBER FUNCTION priceInUSD(rate FLOAT) RETURN FLOAT
    BEGIN
        RETURN rate * SELF.price;
    END priceInUSD;
END;

ALTER TYPE stock_type 
ADD MEMBER FUNCTION yield RETURN FLOAT
CASCADE
/

CREATE OR REPLACE TYPE BODY stock_type AS
MEMBER FUNCTION yield RETURN FLOAT IS
    BEGIN
        RETURN ((SELF.individend/self.cprice) * 100);
    END yield;
END;

SELECT s.company, s.yield()
FROM stock_tbl s
/

ALTER TYPE stock_type
ADD MEMBER FUNCTION AUDtoUSD(rate FLOAT) RETURN FLOAT
CASCADE
/

CREATE OR REPLACE TYPE BODY stock_type AS
MEMBER FUNCTION yield RETURN FLOAT IS
    BEGIN
        RETURN ((SELF.individend/self.cprice) * 100);
    END yield;
MEMBER FUNCTION AUDtoUSD(rate FLOAT) RETURN FLOAT IS
    BEGIN
        RETURN SELF.cprice * rate;
    END AUDtoUSD;
END;

ALTER TYPE stock_type
ADD MEMBER FUNCTION  no_of_trades RETURN INTEGER
CASCADE
/

CREATE OR REPLACE TYPE BODY stock_type AS
MEMBER FUNCTION no_of_trades RETURN INTEGER IS
    BEGIN
        SELECT COUNT(e.column_value) INTO countt
        FROM TABLE(SELF.ex_traded) e;
        RETURN countt;
    END no_of_trades;
END

ALTER TYPE client_type
ADD MEMBER FUNCTION tot_purchase_val RETURN FLOAT
CASCADE
/

CREATE OR REPLACE TYPE BODY client_type AS
MEMBER FUNCTION tot_purchase_val RETURN FLOAT IS
    pvalue FLOAT;
    BEGIN
        SELECT SUM(i.pprice * i.qty) INTO pvalue
        FROM TABLE(SELF.inversment) i;
        RETURN pvalue;
    END tot_purchase_val;
END