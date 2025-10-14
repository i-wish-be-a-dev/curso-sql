ALTER TABLE persons8
ADD surname VARCHAR(100);

ALTER TABLE persons8
ADD surname VARCHAR(100) NOT NULL AFTER name;

ALTER TABLE persons8
RENAME COLUMN surname TO description;

ALTER TABLE persons8
MODIFY COLUMN description VARCHAR(255) NOT NULL;

ALTER TABLE persons8
DROP COLUMN description;