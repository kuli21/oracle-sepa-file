# oracle-sepa-file
Create a sepa file for money transfer using Oracle SQL only

## Info
The SEPA file that can be created using the script here is based on the European standards.
See here for more information: https://www.bundesbank.de/resource/blob/848450/74179e7094d69dca3632eb8605db95c2/mL/technische-spezifikationen-sepa-ueberweisungen-2022-11-data.pdf
The script provided here ist only a basic usage. If you have spacial fields, more data or another version of the SEPA Standard you can adjust the script to your needs.

## How to
* Create the demo tables executing the create table statements and insert demo data. (demo-tables.sql)
* Run the query based on the demo tables and data to generate a proper SEPA XML file
