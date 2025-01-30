DROP VIEW bank_account_view;
CREATE VIEW bank_account_view
AS 
SELECT
  username,
  accounting_balance,
  ts
FROM bank_account;

DROP VIEW bank_movement_view;
CREATE VIEW bank_movement_view
AS 
SELECT
  ba.username AS username,
  bmt.euro AS euro,
  bmt.ts AS ts
FROM bank_account AS ba
LEFT JOIN bank_movement_trigger AS bmt
    ON ba.id = bmt.user_id
WHERE bmt.id IN (
    SELECT MAX(id)
    FROM bank_movement_trigger
    GROUP BY user_id
);

CREATE USER <USER_VIEW>@localhost IDENTIFIED BY '<PASSWORD>';
GRANT SELECT ON BD_and_ML_1.bank_movement_view TO <USER_VIEW>@localhost;
GRANT SELECT ON BD_and_ML_1.bank_account_view TO <USER_VIEW>@localhost;

