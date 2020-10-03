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