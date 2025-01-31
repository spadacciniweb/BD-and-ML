# Esercizi vari del corso

## Esercizio 0

Importare csv normalizzando la stessa importazione.\
Nella directory `esercizio_0/` sono presenti:

#### Esecuzione

- `url.txt` -> url del csv sorgente e spiegazione campi;
- `cars.csv.gz` -> copia compressa del csv sorgente;
- `DB/structure.sql` -> DDL - struttura DB (MariaDB);
- `DB/control.sql` -> DCL - permessi utente;
- `import.pl` -> esempio di script Perl per l'importazione in DB.

## Esercizio 1

L'esercizio è composto dai seguenti step:

1. Creare i csv `bank_accounts.csv` e `bank_movements.csv`.
2. Importare nel DB i csv prodotti nelle tabelle `bank_account` e `bank_movement`.
3. Processare i movimenti nella tabella `bank_movement` e aggiornare la corrispondente disponibilità nella colonna `available_balance` della tabella `bank_account`, Solo al termine del processamento dei movimenti, aggiornare il campo `accounting_balance` (che dovrà corrispondere a `available_balance`).
4. Eseguire gli step 2. e 3. attraverso trigger su tabella equivalente a `bank_movement` denominata `bank_movement_trigger`;
5. Aggiungere 2 views.
    - `bank_account_view` in cui non saranno visibili le colonne `id` e `creazione`;
    - `bank_movement_view` in cui saranno mostrare le colonne `username`, `euro` e `ts` ma limitato all'ultimo movimento processato per ciascuna `username`.
6. Eseguire gli step 2. e 3. introducendo correttamente il processo di transazione.

#### Esecuzione

Nella directory `esercizio_1/` sono presenti:

- `build_csv.pl` -> script Perl per la creazione dei csv da importare (`step 1`).
- `DB/structure.sql` -> DDL - struttura DB (MariaDB) (`step 2`);
- `DB/control.sql` -> DCL - permessi utente (`step 2`);
- `import.pl` -> script Perl per l'importazione dei csv su DB (`step 2`);
- `process.pl` -> script Perl per il processamento dei movimenti sulla tabella `bank_movement` (`step 3`);
- `DB/trigger.sql` -> DDL - aggiunta tabella `bank_movement_trigger` e relativo trigger (`step 4`);
- `import_and_process_with_trigger.pl` -> script Perl per la creazione dei movimenti sulla tabella `bank_movement_trigger` (`step 4`);
- `DB/view.sql` -> DDL e DCL - aggiunta viste e relativa utenza (`step 5`);
- `process_with_transactions.pl` -> script Perl per la creazione dei movimenti sulla tabella `bank_movement` adottando i trigger (`step 6`).

#### Note

Per chiarezza esemplificativa è stato inserito lo script `process_slow.pl` quasi equivalente a `process.pl`.\
Differentemente da quest'ultimo, al primo è stato introdotto (nel ciclo di processamento dei movimenti) un ritardo tra le due query per mostrare l'utilità/necessità del meccanismo della transazione.\
Il medesimo meccaniscmo di ritardo è stato introdotto nello script `process_with_transactions.pl`. 