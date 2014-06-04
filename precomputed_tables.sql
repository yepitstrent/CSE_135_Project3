-- "first precomputation program"

-- create the precomputed tables and insert data from the database
-- project requirements:
-- 1) CREATE TABLE all the precomputed tables of the lattice. 
-- 2) Load the precomputed tables with the appropriate data, via 
--    INSERT commands. In particular, given the Sales table, write a
--    “first precomputation” program that will insert data in the
--    precomputed tables efficiently.

-- Create big table with all columns (at bottom of the lattice)
-- users, products, amt

DROP TABLE IF EXISTS pc_Big;
DROP TABLE IF EXISTS pc_StateProd;
DROP TABLE IF EXISTS pc_UseCat;
DROP TABLE IF EXISTS pc_StateCat;
DROP TABLE IF EXISTS pc_Users;
DROP TABLE IF EXISTS pc_Prod;

CREATE TABLE pc_Big (
  id SERIAL PRIMARY KEY,
  uid INT, --id of user
  pid INT, -- id of product
  use_prod_amt INT -- amount * price at the time of sale
);

INSERT INTO pc_Big
SELECT users.id, products.id, sales.quantity * sales.price AS amt
FROM users, products, sales
WHERE users.id = products.uid
AND sales.pid = products.id  ;


-- state, products
CREATE TABLE pc_StateProd (
  id SERIAL PRIMARY KEY,
  st_name TEXT, 
  prod_id INT,
  st_prod_amt INT 
);

INSERT INTO pc_StateProd 
SELECT users.state, pc_Big.pid, SUM(pc_Big.use_prod_amt)
FROM users, pc_Big
WHERE users.id = pc_Big.uid
GROUP BY users.state

-- users, categories
CREATE TABLE pc_UseCat (
  id SERIAL PRIMARY KEY,
  uid INT, 
  cid INT,
  use_cat_amt INT 
);

INSERT INTO pc_UseCat
SELECT pc_Big.uid, products.cid, SUM(pc_Big.use_prod_amt)
FROM products, pc_Big
WHERE products.id = pc_Big.pid
GROUP BY products.cid

-- state, categories
CREATE TABLE pc_StateCat (
  id SERIAL PRIMARY KEY,
  st_name TEXT, 
  cid INT,
  st_cat_amt INT
);

INSERT INTO pc_StateCat
SELECT pc_StateProd.st_name, products.cid, SUM(pc_StateProd.st_prod_amt)
FROM products, pc_StateProd -- use StateProd since O(50k rows) vs UseCat with O(200k rows)
WHERE pc_StateProd.prod_id = products.id -- join to get categories
GROUP BY products.cid -- should work


-- users
CREATE TABLE pc_Users (
  id SERIAL PRIMARY KEY,
  uid INT, 
  use_amt INT 
);

INSERT INTO pc_Users
SELECT pc_UseCat.uid, SUM(pc_UseCat.use_prod_amt)
FROM pc_UseCat
GROUP BY pc_UseCat.uid; -- sum over categories


-- products
CREATE TABLE pc_Prod (
  id SERIAL PRIMARY KEY,
  pid INT, 
  prod_amt INT 
);

INSERT INTO pc_Prod
SELECT pc_StateProd.pid, SUM(pc_StateProd.st_prod_amt)
FROM pc_StateProd
GROUP BY pc_StateProd.prod_id; -- sum over states
