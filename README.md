# Progetto di Basi di Dati

## Puccio Andrea SM3201456

### 15 maggio 2024

## Presentazione

Si vuole realizzare una base di dati che gestisca le principali basi di lancio spaziali globali. Per adempiere a questo compito sono state selezionate diverse entità e relazioni che ora approfondiremo.

### Passeggero

Il **Passeggero** rappresenta il cliente che acquista il biglietto per un determinato viaggio spaziale. Di lui si vuole sapere l’anagrafica generale e se possiede un passaporto o meno; il campo sesso è un booleano in cui 0 rappresenta i maschi e 1 le femmine. È l’utente della piattaforma.

### Biglietto

Del **Biglietto** si vuole tenere traccia dei seguenti dati: prezzo, classe, posto, data di acquisto, assicurazione. Inoltre, si vuole considerare che i biglietti appartengono ad una sola missione, compagnia e shuttle.

### Missione

Delle **Missioni** si vuole memorizzare la base di lancio di partenza e di arrivo, il razzo con cui è stata eseguita, anche l’eventuale ritardo o cancellazione sono salvate sulla tabella. Si fa notare che più biglietti possono appartenere ad una missione ed anche più razzi possono effettuare la stessa missione.

### Razzo

Dei **Razzi** salviamo sigla, il numero di posti (infatti inseriremo un trigger che non permette di vendere più biglietti della capienza massima del razzo), il modello, una breve descrizione ed il produttore. Le compagnie possono possedere più razzi ma non viceversa.

### Turno

Tra razzo e personale si crea una cross-table chiamata **Turno** con lo scopo di tenere traccia dei turni di lavoro che ogni dipendente svolge su un veicolo spaziale. Per fare ciò salviamo un `datetime()` ad inizio e fine turno.

### Personale

La tabella **Personale** è simile a quella dei Passeggeri poiché anche essi sono utenti della piattaforma con l’aggiunta del campo Ruolo e Compagnia.

### Compagnia

Dell’entità **Compagnia** si vuole salvare nazionalità, recapito e descrizione. Essa può erogare molteplici biglietti.

### Ruolo

L’entità **Ruolo** tiene traccia dei mestieri svolti all’interno della base di lancio e soprattutto il referente per ogni ruolo. Si suppone che i servizi di segreteria e amministrazione delle aziende siano gestiti internamente dalle stesse. Ruolo tiene traccia della retribuzione di ogni dipendente.

Si è deciso di non collegare missione e compagnia poiché si assume che la missione è il generico percorso che molteplici compagnie eseguono coi loro razzi. Inoltre, si fa notare che sia i razzi sia il personale dispongono della chiave esterna della compagnia poiché nella cross-table Turni sono ammessi anche “prestiti” di personale tra le compagnie al fine di garantire la continuità dei collegamenti spaziali essenziali.

Poiché i viaggi spaziali includono molti cambi di fuso orario tutti gli orari dei turni sono espressi in GMT (UTC +0). Il biglietto è facilmente rappresentabile in codice alphanumerico e jpeg, con l'utilizzo dell'assicurazione per rimborsare automaticamente i passeggeri in caso di ritardo del razzo superiore ai 15 minuti. Tale tecnologia sarebbe ideale per il DB e potrebbe essere integrata con minime modifiche ai campi assicurazione e biglietto.

## Diagramma E/R

![Diagramma E/R](DiagrammaE_R.png)

## Scelta delle chiavi primarie

Si è deciso di adottare come chiave primaria lo standard “idNomeTabella”, essi sono identificatori auto incrementanti generati automaticamente dal DBMS ogni volta che c’è una query di inserimento. Ci sono alcune eccezioni, ad esempio, gli ID di passeggero e personale che sono rappresentati da un generico codice identificativo fornito dallo stato in cui si risiede (in Italia è il codice fiscale → 16 caratteri, si suppone che siano simili anche in altre nazioni). Le basi di lancio invece utilizzano i codici IATA costituiti da una stringa di 3 caratteri (ad esempio “KSC” Kennedy Space Center, Stati Uniti d'America). Per i razzi invece è stato adottato il numero seriale come chiave primaria. Per le compagnie non è stato scelto il numero di partita IVA poiché la sua conformazione cambia da nazione a nazione, si predilige l’utilizzo di un identificatore generato dal sistema. Per i ruoli è stata adottata una stringa che contenga il nome del ruolo dell’impiegato. Si fa notare inoltre che ruolo contiene a sua volta un idReferente che punta alla tabella personale, inoltre la tabella Missione contiene due FK provenienti da Base di Lancio.

## Dizionario dei Dati

| **Entità/Relazione** | **Descrizione** | **Attributi** | **Identificatore** |
|----------------------|-----------------|---------------|--------------------|
| Passeggero           | Utente della piattaforma | Nome, Cognome, E-mail, Nazionalità, Password, Sesso, Telefono, Passaporto, Data Nascita | ID Generico della propria nazione, CF nel caso italiano |
| Biglietto            | QR-Code/NFT che permette di accedere al razzo | Prezzo, Classe, Assicurazione, Check-In, PDF, Data Acquisto, Posto | idBiglietto, auto incrementante |
| Missione             | Generica missione spaziale effettuata da una compagnia tra due basi di lancio | Ritardo, Cancellata | idMissione, auto incrementante |
| Base di Lancio       | Partenza/Destinazione delle missioni | Nazione, Coordinate, Regione | idBaseLancio, codice IATA |
| Razzo                | Veicolo spaziale che esegue la missione | Sigla, Posti, Descrizione, Produttore | idRazzo, numero seriale |
| Personale            | Utente della piattaforma, lavora sui razzi | Nome, Cognome, E-mail, Password, Data Nascita, Sesso, Telefono | ID Generico della propria nazione, CF nel caso italiano |
| Turno                | Associa il personale al razzo assegnatogli | Inizio Turno, Fine Turno | ID Generico della propria nazione + idRazzo |
| Compagnia            | Azienda eroga i biglietti e possiede i razzi e le concessioni per le missioni | Nazionalità, Telefono, Descrizione, E-mail | idCompagnia, auto incrementante |
| Ruolo                | Il ruolo ricoperto dal personale in servizio | Nome, Descrizione, RAL | idRuolo, nome del ruolo |

## Vincoli non esprimibili

Analizzando i dati che il database andrà ad immagazzinare sorgono i seguenti vincoli:
- Non si possono vendere più biglietti rispetto alla quantità disponibile di posti su un razzo.
- Se l’assicurazione è stipulata all’esterno dei siti ufficiali delle compagnie spaziali non risulterà nel database.

## Tabella dei volumi

| **Concetto**   | **Tipo**  | **Volume** |
|----------------|-----------|------------|
| Passeggero     | Entità    | 500.000    |
| Biglietto      | Entità    | 500.000    |
| Missione       | Entità    | 5.000      |
| Base di Lancio | Entità    | 50         |
| Razzo          | Entità    | 5.000      |
| Turno          | Relazione | 100.000    |
| Personale      | Entità    | 50.000     |
| Compagnia      | Entità    | 250        |
| Ruolo          | Entità    | 10.000     |

## Diagramma E/R ristrutturato

NB. Sono evidenziate in blu le modifiche apportate al diagramma.
- Generalizzazioni eliminate, aggiunta della nuova entità Ruolo.
- Accorpamento di Assicurazione all’interno di Biglietto.
- Specifica degli id

![Diagramma E/R Ristrutturato](schema.png)

## Analisi delle ridondanze

Sono presenti diverse ridondanze, esse sono state analizzate e strutturate in modo da ridurre notevolmente l’accesso ai dati e permettono di fare query piuttosto semplici e leggibili. Gli attributi composti sono stati volutamente evitati.

## Strutture del DataBase

```sql
DELIMITER $$

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

END$$

## Schema logico

![Schema Logico](schema_logico.png)

## Normalizzazione

La base di dati è già in prima forma normale, tutte le colonne sono atomiche.
La base di dati è già in seconda forma normale, ciascuna colonna dipende dalla primary key.
La base di dati è già in terza forma normale, ogni attributo dipende solo dalla primary key.

## Trigger

Trigger per controllare che non vengano venduti più biglietti del numero di posti disponibili su un razzo:

```sql
DELIMITER $$

CREATE TRIGGER trg_Biglietti BEFORE UPDATE ON biglietto
FOR EACH ROW
BEGIN
    DECLARE bigliettiVenduti int(6);
    SELECT count(*) INTO bigliettiVenduti FROM biglietto b
    INNER JOIN missione m ON (idMissione)
    INNER JOIN razzo r ON (idRazzo)
    WHERE b.idBiglietto = max(idBiglietto);
    IF (bigliettiVenduti >= r.posti) THEN
        SIGNAL sqlstate '45001' SET message_text = "Razzo Pieno!";
    END IF;
END$$

DELIMITER ;
