-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema baseSpaziale2024
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `baseSpaziale2024` ;

CREATE SCHEMA IF NOT EXISTS `baseSpaziale2024` DEFAULT CHARACTER SET utf8 ;
USE `baseSpaziale2024` ;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`compagnia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`compagnia` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`compagnia` (
  `idCompagnia` VARCHAR(45) NOT NULL,
  `nazionalita` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `descrizione` TINYTEXT NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCompagnia`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`razzo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`razzo` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`razzo` (
  `idRazzo` INT NOT NULL AUTO_INCREMENT,
  `sigla` VARCHAR(45) NOT NULL,
  `posti` INT NOT NULL,
  `modello` VARCHAR(45) NOT NULL,
  `descrizione` TINYTEXT NOT NULL,
  `produttore` VARCHAR(45) NOT NULL,
  `idCompagnia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRazzo`),
  UNIQUE INDEX `idRazzo_UNIQUE` (`idRazzo` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  CONSTRAINT `idCompagniaRazzo`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `baseSpaziale2024`.`compagnia` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`base_di_lancio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`base_di_lancio` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`base_di_lancio` (
  `idBaseDiLancio` VARCHAR(3) NOT NULL,
  `nazione` VARCHAR(45) NOT NULL,
  `regione` VARCHAR(45) NOT NULL,
  `coordinate` GEOMETRY NULL DEFAULT NULL,
  PRIMARY KEY (`idBaseDiLancio`),
  UNIQUE INDEX `idBaseDiLancio_UNIQUE` (`idBaseDiLancio` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`passeggero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`passeggero` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`passeggero` (
  `idPasseggero` VARCHAR(16) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `nazionalita` VARCHAR(45) NOT NULL,
  `passaporto` MEDIUMBLOB NULL DEFAULT NULL,
  `sesso` TINYINT NULL DEFAULT NULL,  -- 0 per maschio, 1 per femmina
  PRIMARY KEY (`idPasseggero`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `telefono_UNIQUE` (`telefono` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`missione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`missione` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`missione` (
  `idMissione` INT NOT NULL AUTO_INCREMENT,
  `idBaseDiLancioPartenza` VARCHAR(3) NOT NULL,
  `idBaseDiLancioArrivo` VARCHAR(3) NOT NULL,
  `idRazzo` INT NOT NULL,
  `ritardo` TIME NULL DEFAULT NULL,
  `cancellata` TINYINT NULL DEFAULT '0',
  PRIMARY KEY (`idMissione`),
  INDEX `idBaseDiLancioPartenza_idx` (`idBaseDiLancioPartenza` ASC) VISIBLE,
  INDEX `idBaseDiLancioArrivo_idx` (`idBaseDiLancioArrivo` ASC) VISIBLE,
  INDEX `idRazzo_idx` (`idRazzo` ASC) VISIBLE,
  CONSTRAINT `idBaseDiLancioArrivoMissione`
    FOREIGN KEY (`idBaseDiLancioArrivo`)
    REFERENCES `baseSpaziale2024`.`base_di_lancio` (`idBaseDiLancio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idBaseDiLancioPartenzaMissione`
    FOREIGN KEY (`idBaseDiLancioPartenza`)
    REFERENCES `baseSpaziale2024`.`base_di_lancio` (`idBaseDiLancio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idRazzoMissione`
    FOREIGN KEY (`idRazzo`)
    REFERENCES `baseSpaziale2024`.`razzo` (`idRazzo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`biglietto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`biglietto` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`biglietto` (
  `idBiglietto` INT NOT NULL AUTO_INCREMENT,
  `check_in` TINYINT NOT NULL DEFAULT '0',
  `prezzo` INT NOT NULL,
  `classe` VARCHAR(25) NOT NULL,
  `posto` VARCHAR(3) NOT NULL,
  `dataAcquisto` DATETIME NOT NULL,
  `assicurazione` TINYINT NULL DEFAULT NULL,
  `idCompagnia` VARCHAR(45) NOT NULL,
  `idPasseggero` VARCHAR(16) NOT NULL,
  `idMissione` INT NOT NULL,
  PRIMARY KEY (`idBiglietto`),
  UNIQUE INDEX `idBiglietto_UNIQUE` (`idBiglietto` ASC) VISIBLE,
  INDEX `idMissione_idx` (`idMissione` ASC) VISIBLE,
  INDEX `idPasseggero_idx` (`idPasseggero` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  CONSTRAINT `idCompagniaBiglietto`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `baseSpaziale2024`.`compagnia` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idPasseggeroBiglietto`
    FOREIGN KEY (`idPasseggero`)
    REFERENCES `baseSpaziale2024`.`passeggero` (`idPasseggero`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idMissioneBiglietto`
    FOREIGN KEY (`idMissione`)
    REFERENCES `baseSpaziale2024`.`missione` (`idMissione`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`ruolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`ruolo` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`ruolo` (
  `idRuolo` VARCHAR(100) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descrizione` VARCHAR(45) NOT NULL,
  `ral` DOUBLE NOT NULL,
  `idReferente` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`idRuolo`),
  UNIQUE INDEX `idRuolo_UNIQUE` (`idRuolo` ASC) VISIBLE,
  CONSTRAINT `idReferenteRuolo`
    FOREIGN KEY (`idReferente`)
    REFERENCES `baseSpaziale2024`.`personale` (`idPersonale`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`personale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`personale` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`personale` (
  `idPersonale` VARCHAR(16) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `sesso` TINYINT NULL DEFAULT NULL,
  `idCompagnia` VARCHAR(45) NOT NULL,
  `idRuolo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idPersonale`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `telefono_UNIQUE` (`telefono` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  INDEX `idRuolo_idx` (`idRuolo` ASC) VISIBLE,
  CONSTRAINT `idCompagniaPersonale`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `baseSpaziale2024`.`compagnia` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idRuoloPersonale`
    FOREIGN KEY (`idRuolo`)
    REFERENCES `baseSpaziale2024`.`ruolo` (`idRuolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Tabella `baseSpaziale2024`.`turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseSpaziale2024`.`turno` ;

CREATE TABLE IF NOT EXISTS `baseSpaziale2024`.`turno` (
  `idPersonale` VARCHAR(16) NOT NULL,
  `idRazzo` INT NOT NULL,
  `inizioTurno` DATETIME NOT NULL,
  `fineTurno` DATETIME NOT NULL,
  PRIMARY KEY (`idPersonale`, `idRazzo`),
  INDEX `idRazzo_idx` (`idRazzo` ASC) VISIBLE,
  CONSTRAINT `idRazzoTurno`
    FOREIGN KEY (`idRazzo`)
    REFERENCES `baseSpaziale2024`.`razzo` (`idRazzo`),
  CONSTRAINT `idPersonaleTurno`
    FOREIGN KEY (`idPersonale`)
    REFERENCES `baseSpaziale2024`.`personale` (`idPersonale`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
