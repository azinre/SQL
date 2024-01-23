create database lab10;
use lab10;
CREATE TABLE product (product_id INT auto_increment PRIMARY KEY, name VARCHAR(100), quantity INT, price DECIMAL(5,2));

INSERT INTO product (name, quantity, price) VALUES ('Product-1', 10, 5.99);
INSERT INTO product (name, quantity, price) VALUES ('Product-2', 5, 10.99);
INSERT INTO product (name, quantity, price) VALUES ('Product-3', 2, 15.99);
INSERT INTO product (name, quantity, price) VALUES ('Product-4', 8, 7.99);
INSERT INTO product (name, quantity, price) VALUES ('Product-5', 20, 2.99);

CREATE TABLE product_log ( log_id int auto_increment PRIMARY KEY, product_id INT, name VARCHAR(100), quantity INT, price DECIMAL(5,2));

DELIMITER //
CREATE TRIGGER products_log_after_update
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
    INSERT INTO product_log (product_id, name, quantity, price)
    VALUES (OLD.product_id, OLD.name, OLD.quantity, OLD.price);
END//

CREATE TRIGGER log_delete_product
AFTER DELETE ON product
FOR EACH ROW
BEGIN
    INSERT INTO product_log (product_id, name, quantity, price)
    VALUES (OLD.product_id, OLD.name, OLD.quantity, OLD.price);
END//
DELIMITER ;

UPDATE product SET price = 18.00 WHERE product_id = 1;
DELETE FROM product WHERE product_id = 2;
UPDATE product SET quantity = 20 WHERE product_id = 3;
