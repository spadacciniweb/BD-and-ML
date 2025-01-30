# Esercizi vari del corso

## Esercizio 0

Importare csv normalizzando la stessa importazione.\
Nella directory `esercizio_0/` sono presenti:

- `url.txt` -> url del csv sorgente e spiegazione campi;
- `cars.csv.gz` -> copia compressa del csv sorgente;
- `DB/structure.sql` -> DDL - struttura DB (MariaDB);
- `DB/control.sql` -> DCL - permessi utente;
- `import.pl` -> esempio di script Perl per l'importazione in DB.

## Esercizio 1

L'esercizio è composto dai seguenti step:

1. creare i csv `bank_accounts.csv` e `bank_movements.csv`;
2. importare nel DB i csv prodotti;
3. importare nel DB i csv prodotti movimentando per ogni record in `bank_movements.csv` la corrispondente disponibilità nella colonna `available_balance` nella tabella `bank_account`, e solo al termine del processamento dei movimenti aggiornare il campo `accounting_balance` (che dovrà corrispondere a `available_balance`);
4. eseguire gli step 2. e 3. attraverso trigger su tabella equivalente a `bank_movement` denominata `bank_movement_trigger`;
5. aggiungere 2 view:
    - `bank_account_view` in cui non saranno visibili le colonne `id` e `creazione`;
    - `bank_movement_view` in cui saranno mostrare le colonne `username`, `euro` e `ts` ma limitato all'ultimo movimento processato per ciascuna `username`.

Nella directory `esercizio_1/` sono presenti:

- `build_csv.pl` -> script Perl per la creazione dei csv da importare (`step 1`).
- `DB/structure.sql` -> DDL - struttura DB (MariaDB) (`step 2`);
- `DB/control.sql` -> DCL - permessi utente (`step 2`);
- `import.pl` -> script Perl per l'importazione dei csv su DB (`step 2`);
- `process.pl` -> script Perl per il processamento dei movimenti sulla tabella `bank_movement` (`step 3`);
- `DB/trigger.sql` -> DDL - aggiunta tabella `bank_movement_trigger` e relativo trigger (`step 4`);
- `import_and_process.pl` -> script Perl per la creazione dei movimenti sulla tabella `bank_movement_trigger` (`step 4`);
- `DB/view.sql` -> DDL e DCL - aggiunta viste e relativa utenza (`step 5`).
