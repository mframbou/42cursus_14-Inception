CREATE DATABASE wordpress;
CREATE USER "$MARIADB_USER"@localhost IDENTIFIED BY "$MARIADB_PASSWORD";
GRANT ALL PRIVILEGES on wordpress.* TO "$MARIADB_USER"@localhost;
FLUSH PRIVILEGES;
