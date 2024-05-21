# EsameDiBaseDiDati
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

![Diagramma E/R](percorso/DiagrammaE_R.png)
