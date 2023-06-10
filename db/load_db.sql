-- Delete logic
DROP TABLE IF EXISTS product_order;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS product_category;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS product_allergy;
DROP TABLE IF EXISTS allergy;
DROP TABLE IF EXISTS product;

-- ____________ Product ____________

CREATE TABLE product (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    icon text DEFAULT 'generic_product.png',
    price real NOT NULL
);

-- ____________ Allergy ____________

CREATE TABLE allergy (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    icon text DEFAULT 'generic_allergy.png'
);

CREATE TABLE product_allergy (
    product_id uuid,
    allergy_id uuid,
    PRIMARY KEY (product_id, allergy_id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (allergy_id) REFERENCES allergy(id)
);

-- ____________ Category ____________

CREATE TABLE category (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE product_category (
    product_id uuid,
    category_id uuid,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

-- ____________ Order ____________
-- TODO table_id
CREATE TABLE session (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    table_id text,
    in_progress boolean DEFAULT true
);

CREATE TABLE orders (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    session uuid,
    FOREIGN KEY (session) REFERENCES session(id)
);

CREATE TABLE product_order (
    order_id uuid,
    product_id uuid,
    quantity integer,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- *********** DATA ***********

-- **** Allergies ****
INSERT INTO allergy (name) VALUES ('Gluten');
INSERT INTO allergy (name) VALUES ('Lactose');
INSERT INTO allergy (name) VALUES ('Nuts');
INSERT INTO allergy (name) VALUES ('Egg');
INSERT INTO allergy (name) VALUES ('Shellfish');

-- **** Categories ****
INSERT INTO category (name) VALUES ('Appetizers');
INSERT INTO category (name) VALUES ('Starters');
INSERT INTO category (name) VALUES ('Main Courses');
INSERT INTO category (name) VALUES ('Desserts');
INSERT INTO category (name) VALUES ('Drinks');

-- **** Products ****
-- Appetizers
INSERT INTO product (name, description, icon, price) VALUES (
    'Stiky Ribs', 'Pork ribs, honey, soy sauce', 'stiky_ribs.png', 8.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Green Power', 'Spinach, apple, celery, ginger', 'green_power.png', 5.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Rainbow Poke', 'Salmon, avocado, mango, rice', 'rainbow_poke.png', 8.00
);

INSERT INTO product (name, description, icon, price) VALUES (
    'Oriental Chicken', 'Chicken, rice, soy sauce', 'oriental_chicken.png', 7.00

-- Starters
INSERT INTO product (name, description, icon, price) VALUES (
    'Croquettes', 'Potatoes, eggs, breadcrumbs', 'croquettes.png', 5.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Bravas potatoes', 'Potatoes, spicy sauce', 'bravas_potatoes.png', 6.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Ham Quesadilla', 'Ham and cheese', 'quesadilla.png', 4.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Onion Rings', 'Onion, flour, eggs, breadcrumbs', 'onion_rings.png', 3.00
);

-- Main Courses
INSERT INTO product (name, description, icon, price) VALUES (
    'Soria Carbonara', 'Pasta, bacon, cream, cheese', 'soria_carbonara.png', 8.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Wellington', 'Beef, mushrooms, puff pastry', 'wellington.png', 12.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Iberian Curry', 'Pork, curry, rice', 'iberian_curry.png', 10.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Iberian Dam', 'Pork, potatoes, eggs', 'iberian_dam.png', 10.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Chic Chicken BBQ', 'Chicken, BBQ sauce, rice', 'chic_chicken_bbq.png', 10.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Vegan Burger', 'Vegan burger, lettuce, tomato', 'vegan_burger.png', 8.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Benedict', 'Eggs, bacon, bread, sauce', 'benedict.png', 8.00
);

-- Desserts
INSERT INTO product (name, description, icon, price) VALUES (
    'Sweet Nachos', 'Nachos, chocolate, cream', 'sweet_nachos.png', 6.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Bun & Roll Choco', 'Bun, chocolate, cream', 'bun_roll_chocolate.png', 6.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Pancakes', 'Pancakes, chocolate, cream', 'pancakes.png', 6.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Oreo Shake', 'Oreo, milk, cream', 'oreo_shake.png', 6.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Cake Caramel', 'Cake, caramel, cream', 'cake_caramel.png', 6.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Brownie', 'Brownie, chocolate, cream', 'brownie.png', 6.00
);

-- Drinks
INSERT INTO product (name, description, icon, price) VALUES (
    'Soft Drink', '', 'soft_drink.png', 2.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Beer', '', 'beer.png', 3.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Wine', '', 'wine.png', 12.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Coffee', '', 'coffee.png', 1.00
);
INSERT INTO product (name, description, icon, price) VALUES (
    'Tea', '', 'tea.png', 1.00
);

-- **** Product Allergies ****
-- ** Appetizers **
-- Bruschetta
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Bruschetta'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Bruschetta'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- Garlic Bread
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Garlic Bread'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);

-- Fried Calamari
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Fried Calamari'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);

-- ** Starters **
-- Caprese Salad
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Caprese Salad'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- Caesar Salad
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Caesar Salad'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- Mozzarella Salad
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Mozzarella Salad'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- ** Main Courses **
-- Spaghetti carbonara
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Spaghetti carbonara'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Spaghetti carbonara'),
    (SELECT id FROM allergy WHERE name = 'Egg')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Spaghetti carbonara'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- Pizza
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Pizza'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Pizza'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Pizza'),
    (SELECT id FROM allergy WHERE name = 'Egg')
);

-- Steak

-- Risotto
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Risotto'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- ** Desserts **
-- Tiramisu
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Tiramisu'),
    (SELECT id FROM allergy WHERE name = 'Egg')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Tiramisu'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Tiramisu'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- Panna cotta
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Panna cotta'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- Cannoli
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Cannoli'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Cannoli'),
    (SELECT id FROM allergy WHERE name = 'Lactose')
);

-- ** Drinks **
-- Coca Cola

-- Nestea

-- Water

-- Beer
INSERT INTO product_allergy (product_id, allergy_id) VALUES (
    (SELECT id FROM product WHERE name = 'Beer'),
    (SELECT id FROM allergy WHERE name = 'Gluten')
);

-- Wine

-- ** Product categories **
-- Appetizers
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Bruschetta'),
    (SELECT id FROM category WHERE name = 'Appetizers')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Garlic Bread'),
    (SELECT id FROM category WHERE name = 'Appetizers')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Fried Calamari'),
    (SELECT id FROM category WHERE name = 'Appetizers')
);

-- Starters
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Caprese Salad'),
    (SELECT id FROM category WHERE name = 'Starters')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Caesar Salad'),
    (SELECT id FROM category WHERE name = 'Starters')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Mozzarella Salad'),
    (SELECT id FROM category WHERE name = 'Starters')
);

-- Main Courses
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Spaghetti carbonara'),
    (SELECT id FROM category WHERE name = 'Main Courses')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Pizza'),
    (SELECT id FROM category WHERE name = 'Main Courses')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Steak'),
    (SELECT id FROM category WHERE name = 'Main Courses')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Risotto'),
    (SELECT id FROM category WHERE name = 'Main Courses')
);

-- Desserts
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Tiramisu'),
    (SELECT id FROM category WHERE name = 'Desserts')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Panna cotta'),
    (SELECT id FROM category WHERE name = 'Desserts')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Cannoli'),
    (SELECT id FROM category WHERE name = 'Desserts')
);

-- Drinks
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Coca Cola'),
    (SELECT id FROM category WHERE name = 'Drinks')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Nestea'),
    (SELECT id FROM category WHERE name = 'Drinks')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Water'),
    (SELECT id FROM category WHERE name = 'Drinks')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Beer'),
    (SELECT id FROM category WHERE name = 'Drinks')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Wine'),
    (SELECT id FROM category WHERE name = 'Drinks')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Coffee'),
    (SELECT id FROM category WHERE name = 'Drinks')
);
INSERT INTO product_category (product_id, category_id) VALUES (
    (SELECT id FROM product WHERE name = 'Tea'),
    (SELECT id FROM category WHERE name = 'Drinks')
);

-- **** Session ****
INSERT INTO session (table_id, in_progress) VALUES ('t10', false);
INSERT INTO session (table_id, in_progress) VALUES ('t11', false);
INSERT INTO session (table_id, in_progress) VALUES ('t12', false);

-- **** Order ****
INSERT INTO orders (session) VALUES (
    (SELECT id FROM session WHERE table_id = 't11')
);
INSERT INTO orders (session) VALUES (
    (SELECT id FROM session WHERE table_id = 't12')
);
INSERT INTO orders (session) VALUES (
    (SELECT id FROM session WHERE table_id = 't12')
);

-- -- **** Order product ****
-- Order 1
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't11'
    )),
    (SELECT id FROM product WHERE name = 'Bruschetta'),
    2
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't11'
    )),
    (SELECT id FROM product WHERE name = 'Garlic Bread'),
    1
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't11'
    )),
    (SELECT id FROM product WHERE name = 'Steak'),
    2
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't11'
    )),
    (SELECT id FROM product WHERE name = 'Pizza'),
    1
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't11'
    )),
    (SELECT id FROM product WHERE name = 'Coca Cola'),
    3
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't11'
    )),
    (SELECT id FROM product WHERE name = 'Beer'),
    1
);

-- Order 2
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't12'
    ) ORDER BY id DESC LIMIT 1),
    (SELECT id FROM product WHERE name = 'Risotto'),
    1
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't12'
    ) ORDER BY id DESC LIMIT 1),
    (SELECT id FROM product WHERE name = 'Water'),
    1
);

-- Order 3
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't12'
    ) ORDER BY id ASC LIMIT 1),
    (SELECT id FROM product WHERE name = 'Cannoli'),
    1
);
INSERT INTO product_order (order_id, product_id, quantity) VALUES (
    (SELECT id FROM orders WHERE session = (
        SELECT id FROM session WHERE table_id = 't12'
    ) ORDER BY id ASC LIMIT 1),
    (SELECT id FROM product WHERE name = 'Coffee'),
    1
);

-- ******************************************************

CREATE OR REPLACE FUNCTION hash_uuid(uuid_value uuid) RETURNS INTEGER
    LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    RETURN abs(('x' || md5(uuid_value::text))::bit(64)::bigint % 100000000);
END
$BODY$;

CREATE OR REPLACE FUNCTION generate_simple_uuid(id uuid) RETURNS TEXT
    LANGUAGE 'plpgsql'
AS $$
DECLARE
    words TEXT[] := array['apple', 'banana', 'cherry', 'dog', 'elephant', 'frog', 'guitar', 'hamburger', 'igloo', 'jacket', 'kangaroo', 'lemon', 'mango', 'noodle', 'octopus', 'piano', 'quilt', 'robot', 'sushi', 'tiger', 'umbrella', 'violin', 'watermelon', 'xylophone', 'yogurt', 'zebra'];
    hash_uuid INTEGER := hash_uuid(id);
    output TEXT := '';
BEGIN
    FOR i IN 0..2 LOOP
        output := output || words[(hash_uuid / power(array_length(words, 1), i)::INTEGER) % array_length(words, 1) + 1] || ' ';
    END LOOP;
    RETURN TRIM(output);
END
$$;

CREATE TABLE map_session_uuid (
  simple_id TEXT PRIMARY KEY,
  id UUID,
  FOREIGN KEY (id) REFERENCES session(id)
);

-- create_session
-- inputs:
--     table_id
-- First, check if there is a session in progress for the table_id
-- If there is, return error code
-- If not, continue
-- Add a new session to the session table
-- Query the uuid of the new session
-- Generate a simple_id for the new session
-- Add the simple_id and the uuid to the map_session_uuid table
-- Return row from map_session_uuid table
CREATE OR REPLACE FUNCTION create_session(mesa_id TEXT)
 RETURNS SETOF map_session_uuid
    LANGUAGE 'plpgsql'
AS $$
DECLARE
    session_id UUID;
    simple_id TEXT;
BEGIN
    IF EXISTS (SELECT * FROM session WHERE table_id = mesa_id AND in_progress = true) THEN
        RAISE EXCEPTION 'There is already a session in progress for table %', mesa_id;
    END IF;
    INSERT INTO session (table_id) VALUES (mesa_id);
    SELECT id INTO session_id FROM session WHERE table_id = mesa_id and in_progress = true;-- ORDER BY id DESC LIMIT 1;
    simple_id := generate_simple_uuid(session_id);
    INSERT INTO map_session_uuid (simple_id, id) VALUES (simple_id, session_id);
    RETURN QUERY SELECT * FROM map_session_uuid WHERE id = session_id;
END

-- CREATE OR REPLACE FUNCTION end_session(session_id uuid)
--  RETURNS VOID
--     LANGUAGE 'plpgsql'
-- AS $$
-- BEGIN -- ? Error handleling?
--     UPDATE session SET in_progress = false WHERE id = session_id;
-- END
