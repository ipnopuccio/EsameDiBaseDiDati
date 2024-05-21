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

![Diagramma E/R Ristrutturato](DiagrammaE_RRistrutturato.png)

## Analisi delle ridondanze

Sono presenti diverse ridondanze, esse sono state analizzate e strutturate in modo da ridurre notevolmente l’accesso ai dati e permettono di fare query piuttosto semplici e leggibili. Gli attributi composti sono stati volutamente evitati.

## Struttura del Database

(https://github.com/ipnopuccio/EsameDiBaseDiDati/blob/main/StrutturaDataBase.sql)

## Schema Logico 

![Schema Logico](SchemaLogico.png)

## Normalizzazione 

La base di dati è già in prima forma normale, tutte le colonne sono atomiche.

La base di dati è già in seconda forma normale, ciascuna colonna dipende dalla primary key.

La base di dati è già in terza forma normale, ogni attributo dipende solo dalla primary key.

## Esempi di Tabelle

### Compagnia

| idAgenzia   | nazionalità | telefono   | descrizione                | email                     |
|-------------|-------------|------------|----------------------------|---------------------------|
| SpaceX      | USA         | 123456789  | Space Exploration Technologies | info@spacex.com      |
| Blue Origin | USA         | 987654321  | Blue Origin                 | info@blueorigin.com      |
| Roscosmos   | Russia      | 1122334455 | Roscosmos                   | contact@roscosmos.ru     |

### Razzo

| idRazzo    | sigla       | posti | descrizione           | produttore  | idAgenzia   |
|------------|-------------|-------|-----------------------|-------------|-------------|
| Falcon9    | Falcon 9    | 10    | Falcon 9 Full Thrust  | SpaceX      | SpaceX      |
| NewShepard | New Shepard | 6     | New Shepard           | Blue Origin | Blue Origin |
| Starship   | Starship    | 100   | Starship Prototype    | SpaceX      | SpaceX      |

### Base di Lancio

| idBaseLancio | nazione | coordinate         | regione          |
|--------------|---------|--------------------|------------------|
| KSC          | USA     | 28.5721, -80.648   | Florida          |
| CSG          | Francia | 5.236, -52.768     | Guyana Francese  |
| Baikonur     | Kazakhstan | 45.920278, 63.342222 | Baikonur      |

### Passeggero

| idPasseggero | nome      | cognome | email                | nazionalità | password | sesso | passaporto | dataNascita | telefono    |
|--------------|-----------|---------|----------------------|-------------|----------|-------|------------|-------------|-------------|
| JohnDoe      | John      | Doe     | john.doe@example.com | USA         | pass123  | 0     |        0x    |       xx/xx/xx      |        +1     |
| JaneSmith    | Jane      | Smith   | jane.smith@example.com | UK         | pass123  | 1     |      0x      |    xx/xx/xx         |      +49       |
| SergeyBrin   | Sergey    | Brin    | sergey.brin@example.com | Russia     | pass123  | 0     |        0x    |     xx/xx/xx        |       +421      |

### Missione

| idMissione | idBaseLancioPartenza | idBaseLancioArrivo | idRazzo    | ritardo |
|------------|----------------------|--------------------|-----------|---------|
| M001       | KSC                  | CSG                | Falcon 9  | 0       |
| M002       | CSG                  | Baikonur           | New Shepard | 15      |
| M003       | Baikonur             | KSC                | Starship  | 0       |

### Biglietto

| idBiglietto | check_in | prezzo | classe | assicurazione | idAgenzia | idMissione | idPasseggero | dataAcquisto | posto |
|-------------|----------|--------|--------|---------------|-----------|------------|--------------|--------------|-------|
| B001        | 1        | 500000 | 1      | 1             | SpaceX    | M001       | JohnDoe      | 2024-01-15   | 12A   |
| B002        | 0        | 250000 | 2      | 0             | Blue Origin | M002     | JaneSmith    | 2024-01-16   | 14B   |
| B003        | 1        | 150000 | 3      | 1             | SpaceX    | M003       | SergeyBrin   | 2024-01-17   | 16C   |

### Ruolo

| idRuolo | Descrizione | Ral    | idReferente |
|------------|----------------------|--------------------|-----------|
| R1       | Astronauta                  | 75000                | ID123  |
| R2       | Ingegnere                  | 65000           |  ID124 |
| R3       | Scienziato             | 70000                | ID125  |

### Personale

| idPersonale | idAgenzia   | ruolo      | ral    | dataNascita | sesso | nome    | cognome | password |
|--------------|-------------|------------|--------|-------------|-------|---------|---------|----------|
| ElonMusk     | SpaceX      | Pilota     | 100000 | 1980-05-15  | 0     | Elon    | Musk    | elonpass |
| JeffBezos    | Blue Origin | Ingegnere  | 90000  | 1985-06-12  | 0     | Jeff    | Bezos   | jeffpass |
| DmitryRogozin | Roscosmos  | Scienziato | 95000  | 1970-02-15  | 0     | Dmitry  | Rogozin | dmitrypass |

### Turno 

| idEquipaggio | idRazzo   | InizioTurno   | FineTurno    |
|--------------|-------------|------------|--------|
| ElonMusk     | Falcon 9      | 2024-01-01 08:00:00     | 2024-01-03 10:00:00|
| JeffBezos    | Blue Origin | 2024-01-02 09:00:00  |2024-01-02 19:00:00|
| DmitryRogozin | Roscosmos  | 2024-01-03 10:00:00 |2024-01-03 20:00:00|

## Trigger e Stored Procedures per la Gestione dei Biglietti e dei Dati dei Passeggeri

### Stored Procedures

Visualizzare la cartella SP

### Trigger

#### Trigger per Controllare la Vendita di Biglietti

Questo trigger controlla che non vengano venduti più biglietti del numero di posti disponibili su un razzo. Se si tenta di vendere un biglietto quando i posti sono esauriti, viene generato un errore.

```sql
DELIMITER $$  
CREATE TRIGGER trg_Biglietti BEFORE INSERT ON biglietto  
FOR EACH ROW  
BEGIN  
    DECLARE bigliettiVenduti INT;
    SELECT COUNT(*) INTO bigliettiVenduti 
    FROM biglietto b
    WHERE b.idMissione = NEW.idMissione;

    DECLARE postiDisponibili INT;
    SELECT r.posti INTO postiDisponibili 
    FROM missione m
    INNER JOIN razzo r ON m.idRazzo = r.idRazzo
    WHERE m.idMissione = NEW.idMissione;

    IF bigliettiVenduti >= postiDisponibili THEN  
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Razzo Pieno!';
    END IF;  
END$$
DELIMITER ;



