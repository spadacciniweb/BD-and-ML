# Esercizi vari del corso

## Esercizio 0

Importare csv normalizzando la stessa importazione.

### Esecuzione

Nella directory `esercizio_0/` sono presenti:

- `url.txt` -> url del csv sorgente e spiegazione campi;
- `cars.csv.gz` -> copia compressa del csv sorgente;
- `DB/structure.sql` -> DDL - struttura DB (MariaDB);
- `DB/control.sql` -> DCL - permessi utente;
- `import.pl` -> esempio di script Perl per l'importazione in DB.

## Esercizio 1

L'esercizio è composto dai seguenti step:

1. Creare i csv `bank_accounts.csv` e `bank_movements.csv`.
2. Importare nel DB i csv prodotti in cui:
    - la tabella `bank_account` avrà le due colonne `available_balance` e `accounting_balance` popolate in maniera equivalente al campo `euro` del csv;
    - la tabella `bank_movement` avrà la colonna `euro` equivalente al merge dei campi `type` e `euro` del csv, in particolare il segno della colonna `euro` sarà in accordo alla tipologia del movimento (quindi `+` e `-` nella colonna `euro` sostituiranno rispettivamente `ADD` e `SUB` del campo `type`).
3. Processare i movimenti nella tabella `bank_movement` e aggiornare la corrispondente disponibilità nella colonna `available_balance` della tabella `bank_account`, Solo al termine del processamento dei movimenti, aggiornare il campo `accounting_balance` (che dovrà corrispondere a `available_balance`).
4. Eseguire gli step 2. e 3. attraverso trigger su tabella equivalente a `bank_movement` denominata `bank_movement_trigger`;
5. Aggiungere 2 view:
    - `bank_account_view` in cui non saranno visibili le colonne `id` e `creazione`;
    - `bank_movement_view` in cui saranno mostrare le colonne `username`, `euro` e `ts` ma limitato all'ultimo movimento processato per ciascuna `username`.
6. Eseguire gli step 2. e 3. introducendo correttamente il processo di transazione.

### Esecuzione

Nella directory `esercizio_1/` sono presenti:

- `build_csv.pl` -> script Perl per la creazione dei csv da importare (`step 1`);
- `DB/structure.sql` -> DDL - struttura DB (MariaDB) (`step 2`);
- `DB/control.sql` -> DCL - permessi utente (`step 2`);
- `import.pl` -> script Perl per l'importazione dei csv su DB (`step 2`);
- `process.pl` -> script Perl per il processamento dei movimenti sulla tabella `bank_movement` (`step 3`);
- `DB/trigger.sql` -> DDL - aggiunta tabella `bank_movement_trigger` e relativo trigger (`step 4`);
- `import_and_process_with_trigger.pl` -> script Perl per la creazione dei movimenti sulla tabella `bank_movement_trigger` (`step 4`);
- `DB/view.sql` -> DDL e DCL - aggiunta viste e relativa utenza (`step 5`);
- `process_with_transactions.pl` -> script Perl per la creazione dei movimenti sulla tabella `bank_movement` adottando la tecnica transazionale (`step 6`);
- `TRANSACTION.md` -> evoluzione esemplificativa di due sessioni parallele al DBMS durante l'attivazione di una transazione nella prima sessione.

#### Note

Per chiarezza sono stati inseriti gli script `process_slow.pl` e `process_with_transactions_slow.pl` quasi equivalenti rispettivamente a `process.pl` e `process_with_transactions.pl`.\
Differentemente da questi ultimi, ai primi è stato introdotto (nel ciclo di processamento dei movimenti) un ritardo tra le due query per mostrare l'utilità/necessità del meccanismo della transazione.

## Esercizio 1b

Eseguire nuovamente gli `step 2` e `step 3` dell'`Esercizio 1` tramite il DBMSR SQLite.

### Nota

Per questo esercizio non si dovrà cambiare nessuna logica di esecuzione, ma semplicemente:

- modificare la `DDL` (semplici ritocchi);
- nel secondo script modificare il driver e connettore al DBMS utilizzato.

## Esercizio 2

Prima dell'esercizio, consultare [Teoria ed esempi su MongoDB](https://github.com/spadacciniweb/argomenti-vari/blob/main/MongoDB/README.md)

Importare i file JSON in MongoDB con l'accortezza di ignorare le strutture JSON in cui non sono riportati valori significativi (quindi ignorare quei JSON in cui è riporato solo l'orario di produzione dello stesso, ma nessun altro attributo è valorizzato).

### Esecuzione

Nella directory `esercizio_2/` sono presenti vari script con l'indicazione degli step incrementali:

- `LEGEND.md` -> legenda di un JSON;
- `16230.tgz` -> archivio compresso dei JSON da importare;
- `insert.pl` -> script Perl per l'importazione dei JSON utilizzando `insertOne` (`step 1`, una importazione per ciascun documento JSON);
- `insert_many.pl` -> script Perl per l'importazione dei JSON utilizzando `insertMany` (`step 2`, una importazione per ciascun file);
- `insert_all.pl` -> script Perl per l'importazione dei JSON utilizzando `insertMany` (`step 3`, un'unica importazione per la totalità dei file);
- `insert_parallel_retrieve_data.pl` -> script Perl per l'importazione dei JSON utilizzando `insertMany` via parallelizzazione (`step 4`, inserimento come in `step 2` ma dal `parent`);
- `insert_parallel_reconnect.pl` -> script Perl per l'importazione dei JSON utilizzando `insertMany` via parallelizzazione (`step 5`, inserimento come in `step 2` ma dai singoli `child`).

### Note

Per la programmazione parallale sono stati inseriti i due script `insert_parallel_retrieve_data.pl` e `insert_parallel_reconnect.pl`.\
Il primo non è efficiente, peggiorando le performance rispetto gli step precedenti (sequenziali), aggiunto per mostrare uno dei possibili fail.\
Il secondo è il più efficiente tra tutti gli script.

## Esercizio 3

Prima dell'esercizio, consultare [Teoria ed esempi su DuckDB](https://github.com/spadacciniweb/argomenti-vari/blob/main/DuckDB/README.md)

L'esercizio è composto dai seguenti step:

1. Importare il file `video_games.csv.gz` in DuckDB attraverso la shell.
2. Eseguire la medesima importazione del punto precedente tramite software.
