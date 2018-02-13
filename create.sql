-- MySQL Script generated by MySQL Workbench
-- Thu Feb  8 12:34:42 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema RSVier
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema RSVier
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `RSVier` DEFAULT CHARACTER SET utf8 ;
USE `RSVier` ;

-- -----------------------------------------------------
-- Table `RSVier`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`customer` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`customer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `last_name_preposition` VARCHAR(10) NULL,
  `email` VARCHAR(80) NULL,
  `phone_number` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`account` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(16) NOT NULL,
  `password` TEXT NOT NULL,
  `owner_type` VARCHAR(10) NOT NULL,
  `customer_id` INT NOT NULL,
  `active` TINYINT NOT NULL DEFAULT 1 COMMENT '1 = true, 0 = false',
  PRIMARY KEY (`id`),
  INDEX `account_owner_customer_id_idx` (`customer_id` ASC),
  CONSTRAINT `account_owner_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `RSVier`.`customer` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`order` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `total_price` DECIMAL(8,2) NOT NULL,
  `total_products` INT NOT NULL,
  `shipped_status` TINYINT NOT NULL,
  `customerID` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `customerID_idx` (`customerID` ASC),
  CONSTRAINT `customerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `RSVier`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`product` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(70) NOT NULL,
  `price` DECIMAL(6,2) NOT NULL,
  `stock_quantity` INT NOT NULL,
  `produced_year` INT(4) NOT NULL,
  `alcohol_percentage` DECIMAL(3,1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`order_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`order_line_item` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`order_line_item` (
  `productID` INT NOT NULL,
  `orderID` INT NOT NULL,
  `quantity` INT NOT NULL,
  INDEX `product_idx` (`productID` ASC),
  INDEX `order_idx` (`orderID` ASC),
  CONSTRAINT `product`
    FOREIGN KEY (`productID`)
    REFERENCES `RSVier`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order`
    FOREIGN KEY (`orderID`)
    REFERENCES `RSVier`.`order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`address` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postal_code` VARCHAR(6) NOT NULL,
  `street_name` VARCHAR(65) NOT NULL COMMENT 'Apparently the longest streetname in NL currently is 61 characters.',
  `city` VARCHAR(45) NOT NULL,
  `house_number` INT NOT NULL,
  `house_number_addition` VARCHAR(5) NOT NULL,
  `address_type` VARCHAR(10) NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `customer's address_idx` (`customer_id` ASC),
  CONSTRAINT `customer's address`
    FOREIGN KEY (`customer_id`)
    REFERENCES `RSVier`.`customer` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`grape_variety`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`grape_variety` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`grape_variety` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `variety_name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`product_has_grape_variety`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`product_has_grape_variety` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`product_has_grape_variety` (
  `productID` INT NOT NULL,
  `grape_varietyID` INT NOT NULL,
  INDEX `grape_varietyID_idx` (`grape_varietyID` ASC),
  INDEX `productID_idx` (`productID` ASC),
  CONSTRAINT `grape_varietyID`
    FOREIGN KEY (`grape_varietyID`)
    REFERENCES `RSVier`.`grape_variety` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `productID`
    FOREIGN KEY (`productID`)
    REFERENCES `RSVier`.`product` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`product_region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`product_region` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`product_region` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `region_name` VARCHAR(60) NOT NULL,
  `country` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RSVier`.`product_has_origin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RSVier`.`product_has_origin` ;

CREATE TABLE IF NOT EXISTS `RSVier`.`product_has_origin` (
  `productID` INT NOT NULL,
  `regionID` INT NOT NULL,
  INDEX `regionID_idx` (`regionID` ASC),
  INDEX `productID_idx` (`productID` ASC),
  CONSTRAINT `regionID`
    FOREIGN KEY (`regionID`)
    REFERENCES `RSVier`.`product_region` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `productID`
    FOREIGN KEY (`productID`)
    REFERENCES `RSVier`.`product` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO customer (id, first_name, last_name) VALUES (1, 'Onne', 'Dallinga');
INSERT INTO account (id, username, PASSWORD, owner_type, customer_id, active) VALUES (1, 'Onne', 'Hello', 'ADMIN', 1, 1);
INSERT INTO customer (id, first_name, last_name) VALUES (2, 'Piet', 'Pieters');
INSERT INTO account (id, username, PASSWORD, owner_type, customer_id, active) VALUES (2, 'Piet', 'Piet', 'NOTADMIN', 2, 2);