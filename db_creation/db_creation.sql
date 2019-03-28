-- MySQL Script generated by MySQL Workbench
-- Thu Mar 28 17:12:10 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema payicam_reservation_sandwichs
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `payicam_reservation_sandwichs` ;

-- -----------------------------------------------------
-- Schema payicam_reservation_sandwichs
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `payicam_reservation_sandwichs` DEFAULT CHARACTER SET utf8 ;
USE `payicam_reservation_sandwichs` ;

-- -----------------------------------------------------
-- Table `payicam_reservation_sandwichs`.`config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payicam_reservation_sandwichs`.`config` ;

CREATE TABLE IF NOT EXISTS `payicam_reservation_sandwichs`.`config` (
  `days_displayed` INT(10) UNSIGNED NOT NULL,
  `default_quota` INT(10) UNSIGNED NOT NULL,
  `default_reservation_first_closure_time` TIME NOT NULL,
  `default_reservation_second_closure_time` TIME NOT NULL,
  `default_pickup_time` TIME NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `payicam_reservation_sandwichs`.`days`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payicam_reservation_sandwichs`.`days` ;

CREATE TABLE IF NOT EXISTS `payicam_reservation_sandwichs`.`days` (
  `day_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `quota` INT(10) UNSIGNED NOT NULL,
  `reservation_opening_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `reservation_first_closure_date` DATETIME NOT NULL,
  `reservation_second_closure_date` DATETIME NOT NULL,
  `pickup_date` DATETIME NOT NULL,
  `is_removed` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`day_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `payicam_reservation_sandwichs`.`sandwiches`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payicam_reservation_sandwichs`.`sandwiches` ;

CREATE TABLE IF NOT EXISTS `payicam_reservation_sandwichs`.`sandwiches` (
  `sandwich_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `default_quota` INT(10) UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `is_removed` TINYINT(1) UNSIGNED NOT NULL,
  `closure_type` TINYINT(1) NOT NULL DEFAULT 0,
  `is_special` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`sandwich_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `payicam_reservation_sandwichs`.`day_has_sandwiches`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payicam_reservation_sandwichs`.`day_has_sandwiches` ;

CREATE TABLE IF NOT EXISTS `payicam_reservation_sandwichs`.`day_has_sandwiches` (
  `day_id` INT(10) UNSIGNED NOT NULL,
  `sandwich_id` INT(10) UNSIGNED NOT NULL,
  `quota` INT(10) UNSIGNED NOT NULL,
  `is_removed` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`day_id`, `sandwich_id`),
  INDEX `fk_sandwiches_has_days_days1_idx` (`day_id` ASC),
  INDEX `fk_sandwiches_has_days_sandwiches_idx` (`sandwich_id` ASC),
  CONSTRAINT `fk_sandwiches_has_days_days1`
    FOREIGN KEY (`day_id`)
    REFERENCES `payicam_reservation_sandwichs`.`days` (`day_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sandwiches_has_days_sandwiches`
    FOREIGN KEY (`sandwich_id`)
    REFERENCES `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `payicam_reservation_sandwichs`.`purchases_possibilities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payicam_reservation_sandwichs`.`purchases_possibilities` ;

CREATE TABLE IF NOT EXISTS `payicam_reservation_sandwichs`.`purchases_possibilities` (
  `possibility_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `article_id` INT(10) UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `is_removed` TINYINT(1) NOT NULL DEFAULT 0,
  `is_special` TINYINT(1) NOT NULL DEFAULT 0,
  `closure_type` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`possibility_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `payicam_reservation_sandwichs`.`reservations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payicam_reservation_sandwichs`.`reservations` ;

CREATE TABLE IF NOT EXISTS `payicam_reservation_sandwichs`.`reservations` (
  `reservation_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `promo` VARCHAR(45) NOT NULL,
  `payement` VARCHAR(45) NOT NULL DEFAULT 'PayIcam',
  `status` ENUM('A', 'V', 'W') NOT NULL DEFAULT 'W',
  `payicam_transaction_id` INT(11) NULL DEFAULT NULL,
  `payicam_transaction_url` TEXT NULL DEFAULT NULL,
  `reservation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `payment_date` DATETIME NULL DEFAULT NULL,
  `pickup_date` DATETIME NULL DEFAULT NULL,
  `possibility_id` INT(10) UNSIGNED NOT NULL,
  `day_id` INT(10) UNSIGNED NOT NULL,
  `sandwich_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`reservation_id`),
  INDEX `fk_reservations_purchases_possibilities1_idx` (`possibility_id` ASC),
  INDEX `fk_reservations_day_has_sandwiches1_idx` (`day_id` ASC, `sandwich_id` ASC),
  CONSTRAINT `fk_reservations_day_has_sandwiches1`
    FOREIGN KEY (`day_id` , `sandwich_id`)
    REFERENCES `payicam_reservation_sandwichs`.`day_has_sandwiches` (`day_id` , `sandwich_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservations_purchases_possibilities1`
    FOREIGN KEY (`possibility_id`)
    REFERENCES `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `payicam_reservation_sandwichs`.`config`
-- -----------------------------------------------------
START TRANSACTION;
USE `payicam_reservation_sandwichs`;
INSERT INTO `payicam_reservation_sandwichs`.`config` (`days_displayed`, `default_quota`, `default_reservation_first_closure_time`, `default_reservation_second_closure_time`, `default_pickup_time`) VALUES (15, 50, '08:00:00', '10:00:00', '12:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `payicam_reservation_sandwichs`.`sandwiches`
-- -----------------------------------------------------
START TRANSACTION;
USE `payicam_reservation_sandwichs`;
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (1, 'Poulet Mayonaise', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (2, 'Poulet Andalouse', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (3, 'Poulet Curry', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (4, 'Poulet piquant', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (5, 'Salami', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (6, 'Lard', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (7, 'Brie', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (8, 'Filet Américain', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (9, 'Jambon blanc', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (10, 'Pâté', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (11, 'Chorizo', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (12, 'Crabe mayonnaise', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (13, 'Pain de viande', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (14, 'Jambon fumé', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (15, 'Mimolette rouge', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (16, 'Fromage gouda', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (17, 'Mozzarella', 10, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (18, 'Rôti de porc', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (19, 'Poulet Hawaï', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (20, 'Filet de dinde', 10, '', 0, 1, 0);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (21, 'Alexis', 10, 'Andalouse, Oignons frits, Oignons frais, Mimolette, Rôti', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (22, 'Anglais', 50, 'Andalouse, Oignons frais, Pain de Viande, Œufs, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (23, 'Ardennais', 10, 'Mayonnaise, Jambon d\'Ardennes, Pain de viande, Oeufs, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (24, 'Basse cour', 50, 'Mayonnaise, Maïs, Filet de dinde, Oeufs, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (25, 'Berger', 56, 'Miel, Oignons frits, Fromage de chèvre, Lard grillé, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (26, 'Bresil', 10, 'Andalouse, Ananas, Maïs, Rôti de porc, Fromage, Salami', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (27, 'Brugeois', 10, 'Mayonnaise, Asperges, Jambon, Oeufs, Salade', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (28, 'Campagnard', 10, 'Oignons frais, Concombres, Gouda blanc, Tomates', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (29, 'Courseux', 10, 'Andalouse, Feta, Jambon fumé, Tomates, Salades', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (30, 'Crevettes', 10, 'Mayonnaise, crevettes', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (32, 'Dog Pepper', 10, 'Poivre, Filet de dinde, Oeufs, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (33, 'Dagobert', 10, 'Mayonnaise, Jambon, Fromage, Oeufs, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (34, 'Dagobrie', 10, 'Mayonnaise, Jambon, Brie, Oeufs, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (36, 'Exotique', 10, 'Mayonnaise, Ananas, Jambon, Fromage', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (37, 'Fermier', 10, 'Andalouse, Lard grillé, Rôti de porc, Oeufs, Tomates', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (38, 'Feta', 10, 'Sauce à L\'Ail, Oignons frais, Concombres, Fêta, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (39, 'Gillou', 10, 'Americain, Sauce piquante, Câpres, Anchois, Salade, Oeufs, Tomates', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (42, 'Grand mere', 10, 'Pâté, Moutarde, Oignons frais, Cornichons', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (43, 'Grecque', 10, 'Fromage blanc aux herbes, Anchois, Olives, Concombres, Tomates', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (44, 'Hurlus', 10, 'Andalouse, Oignons frits, Rôti de porc, Mimolette', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (45, 'Italien', 10, 'Huile d\'olives, Jambon fumé, Mozzarella, Tomates', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (46, 'Langoustine', 10, 'Cocktail, Langoustines', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (47, 'Martino', 10, 'Sauce Martino, Américain, Cornichons, Tomates', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (48, 'Nicois', 10, 'Thon mayo, Olives, Oignons frais, Oeufs, Tomates, Salade', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (49, 'Poulet', 10, 'Samouraï au Miel moutarde', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (51, 'Sante', 10, 'Fromage blanc aux herbes, Concombres, Tomates', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (52, 'Saumon', 10, 'Mousseline de Saumon', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (53, 'Sono', 10, 'Jambon d\'Ardennes, Brie', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (54, 'Thon', 10, 'Mayonnaise', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (55, 'Vegetarien', 10, 'Sauce à l\'ail, Oignons frais, Concombres, Fêta, Carottes, Céleri', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (56, 'Viennois', 10, 'Pommes de terre mayonnaise, Fromage, Oeufs, Céleri', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (57, 'Gitan', 10, 'Andalouse, Oignons frais, Rôti de porc, Salade', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`sandwiches` (`sandwich_id`, `name`, `default_quota`, `description`, `is_removed`, `closure_type`, `is_special`) VALUES (58, 'Gourmand', 10, 'Pomme de Terre, Mayonnaise, Concombre, Oeufs, Tomates, Rôti de Porc, Salami, Celeri, Carottes', 0, 1, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `payicam_reservation_sandwichs`.`purchases_possibilities`
-- -----------------------------------------------------
START TRANSACTION;
USE `payicam_reservation_sandwichs`;
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (1, 'Sandwich classique demi', 498, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (2, 'Menu classique demi', 493, '', 0, 0, 0);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (3, 'Sandwich spécial demi', 1039, '', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (4, 'Menu spécial demi', 1051, '', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (5, 'Sandwich classique baguette', 1050, '', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (6, 'Menu classique baguette 	', 1053, '', 0, 0, 1);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (7, 'Sandwich spécial baguette', 1049, '', 0, 1, 1);
INSERT INTO `payicam_reservation_sandwichs`.`purchases_possibilities` (`possibility_id`, `name`, `article_id`, `description`, `is_removed`, `is_special`, `closure_type`) VALUES (8, 'Menu spécial baguette', 1052, '', 0, 1, 1);

COMMIT;

