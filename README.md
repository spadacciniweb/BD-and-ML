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

1. creare i csv `bank_accounts.csv` e `bank_movements.csv` prodotti dallo script `build_csv.pl`.
2. importare nel DB i csv prodotti.
3. TODO

Nella directory `esercizio_1/` sono presenti:

- `build_csv.pl` -> script Perl per la creazione dei csv da importare (`step 1`).
- `DB/structure.sql` -> DDL - struttura DB (MariaDB) (`step 2`);
- `DB/control.sql` -> DCL - permessi utente (`step 2`);
- `import.pl` -> script Perl per l'importazione dei csv su DB (`step 2`).
