USE BD_and_ML_1;

CREATE TABLE bank_movement_trigger (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int unsigned NOT NULL,
    `euro` decimal(10,2) default 0,
    `processed` bool default 0,
    `dt_src` char(23) NOT NULL,
    `ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  CONSTRAINT `bank_movement_trigger_idfk_1` FOREIGN KEY (`user_id`) REFERENCES `bank_account` (`id`)
);

DROP TRIGGER IF EXISTS update_bank_account_on_insert_movement;
DROP TRIGGER IF EXISTS update_bank_account_on_delete_movement;

DELIMITER //
CREATE TRIGGER update_bank_account_on_insert_movement
BEFORE INSERT ON bank_movement_trigger
FOR EACH ROW 
BEGIN
    UPDATE bank_account SET available_balance = available_balance + NEW.euro WHERE id = NEW.user_id;
    SET NEW.processed = 1;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_bank_account_on_delete_movement AFTER DELETE ON bank_movement_trigger
FOR EACH ROW 
BEGIN
    UPDATE bank_account SET available_balance = available_balance - OLD.euro WHERE id = OLD.user_id;
END //
DELIMITER ;
