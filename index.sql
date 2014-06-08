-- Indices on precomputed tables

-- template

CREATE INDEX users_id
ON pc_UsersAmt (uid);

CREATE INDEX users_total
ON pc_UsersAmt (total);


CREATE INDEX prod_id
ON pc_ProdAmt (pid);

CREATE INDEX prod_total
ON pc_ProdAmt (total);

CREATE INDEX state_total
ON pc_StateAmt (total);

CREATE INDEX state_name
ON pc_StateAmt (state);


CREATE INDEX useprod_uid
ON pc_UserProdAmt (uid);

CREATE INDEX useprod_pid
ON pc_UserProdAmt (pid);

CREATE INDEX useprod_total
ON pc_UserProdAmt (total);


CREATE INDEX usecat_uid
ON pc_UseCatAmt (uid);

CREATE INDEX usecat_cid
ON pc_UseCatAmt (cid);

CREATE INDEX usecat_total
ON pc_UseCatAmt (total);

CREATE INDEX stateprod_total
ON pc_StateProdAmt (total);

CREATE INDEX stateprod_pid
ON pc_StateProdAmt (pid);

CREATE INDEX stateprod_state
ON pc_StateProdAmt (state);


CREATE INDEX states_id
ON states (id);

CREATE INDEX states_name
ON states (name);


CREATE INDEX statecat_state
ON pc_StateCatAmt (state);

CREATE INDEX statecat_cid
ON pc_StateCatAmt (cid);

CREATE INDEX statecat_total
ON pc_StateCatAmt (total);

/*
users from project 2 schema
*/
CREATE INDEX usersP_state
ON users (state);

CREATE INDEX usersP_id
ON users (id);

/*
products
*/
CREATE INDEX productsP_id
ON products (id);

CREATE INDEX uproductsP_cid
ON products (cid);

CREATE INDEX uproductsP_name
ON products (name);

/*
sales
*/
CREATE INDEX salesP_uid
ON sales (uid);

CREATE INDEX salesP_pid
ON sales (pid);

/*
categories
*/
CREATE INDEX categoriesP_id
ON categories (id);

CREATE INDEX categoriesP_name
ON categories (name);

