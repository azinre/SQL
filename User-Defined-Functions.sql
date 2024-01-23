use sakila;
UPDATE film SET description ='A Epic @Drama of a Feminist And a Mad Scientist who must Battle a Teacher in The Canadian Rockies' WHERE film_id = 1;

UPDATE film SET description = 'A Astounding Epistle of a Database Administrator And a Explorer who must Find a #Car in Ancient China' WHERE film_id = 2;

UPDATE film SET description = 'A Astounding Reflection of a Lumberjack And a Car who must Sink a Lumberjack #% in A Baloon Factory' WHERE film_id = 3;

UPDATE film SET description = 'A Fanciful Documentary of a Frisbee And a Lumberjack who must Chase a

Monkey in.; A Shark Tank' WHERE film_id = 4;

UPDATE film SET description = 'A Fast-Paced! Documentary of a Pastry Chef And a Dentist who must Pursue a Forensic Psychologist* in The Gulf of Mexico' WHERE film_id = 5; commit;

ALTER TABLE film ADD COLUMN urlsafe VARCHAR(255);

DELIMITER //
CREATE FUNCTION clean_string(oldval VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE newval VARCHAR(255);
    SET newval = REPLACE(oldval, ' ', '');
    RETURN newval;
END //
DELIMITER ;

select clean_string(" this is a test");
SELECT clean_string("Hello, world!");
SELECT clean_string("I have ; semicolon, test");

drop function if exists clean_string;

DELIMITER //
CREATE FUNCTION clean_string(oldval VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE newval VARCHAR(255);
    SET newval = REGEXP_REPLACE(oldval, '[^a-zA-Z0-9-]+', '');
    RETURN newval;
END //
DELIMITER ;

SELECT clean_string(description) FROM film LIMIT 5;