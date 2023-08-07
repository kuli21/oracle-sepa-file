-----------------------------------------------------------
-- Create demo tables -------------------------------------
-----------------------------------------------------------
CREATE TABLE sepa_deb_data
(
  id          NUMBER(20),
  debtor_name VARCHAR2(127),
  transfer_id VARCHAR2(50),
  currency    VARCHAR2(4)
);
ALTER TABLE sepa_deb_data ADD CONSTRAINT sepa_deb_data_pk PRIMARY KEY (id);
COMMENT ON TABLE sepa_deb_data IS 'This table contains basic info about the debtor - can be extended with iban and bic if necessary';
-----------------------------------------------------------
CREATE TABLE sepa_cred_data
(
  id                  NUMBER(20),
  client_id           VARCHAR2(50),
  accountholder       VARCHAR2(127),
  iban                VARCHAR2(50),
  bic                 VARCHAR2(50),
  amount              NUMBER,
  reason_for_transfer VARCHAR2(255),
  deb_data_id         NUMBER(20)
);
ALTER TABLE sepa_cred_data ADD CONSTRAINT sepa_cred_data_pk PRIMARY KEY (id);
ALTER TABLE sepa_cred_data ADD CONSTRAINT sepa_cred_data_fk FOREIGN KEY (deb_data_id) REFERENCES sepa_deb_data (id);
COMMENT ON TABLE sepa_cred_data IS 'This table contains each creditor with bank data and amounts to transfer';

-----------------------------------------------------------
-- Create demo data----------------------------------------
-----------------------------------------------------------
INSERT INTO sepa_deb_data  (id, debtor_name, transfer_id, currency) 
                    VALUES (1, 'Dream Industries', 'DI23', 'EUR');
INSERT INTO sepa_cred_data (id, client_id, accountholder, iban, bic, amount, reason_for_transfer, deb_data_id)
                    VALUES (1, 'CL043', 'Major Max', 'LI15088110605699K002E', 'BFRILI22', 42.69, 'Parking fee', 1);
INSERT INTO sepa_cred_data (id, client_id, accountholder, iban, bic, amount, reason_for_transfer, deb_data_id)
                    VALUES (2, 'CL068', 'Major Max', 'LI0508812105028570001', 'VOAGLI22', 1337.99, 'Some stuff', 1);
INSERT INTO sepa_cred_data (id, client_id, accountholder, iban, bic, amount, reason_for_transfer, deb_data_id)
                    VALUES (3, 'CL014', 'Major Max', 'LI0208800000017197386', 'LILALI2X', 77.01, 'Lunch yesterday', 1);
