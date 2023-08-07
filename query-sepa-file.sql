SELECT
XMLElement("Document",
           XMLAttributes('urn:iso:std:iso:20022:tech:xsd:pain.001.001.03' AS "xmlns",
                         'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi",
                         'http://www.oracle.com/Employee.xsd' AS "xsi:schemaLocation"
                        ),
           XMLElement("CstmrCdtTrfInitn",
                     ----- Head ------------------
                     XMLElement("GrpHdr",
                               XMLElement("MsgId", x.transfer_id),
                               XMLElement("CreDtTm",  TO_CHAR(sysdate, 'yyyy-mm-dd"T"HH24:mi:ss')),
                               XMLElement("NbOfTxs", y.count_pos),
                               XMLElement("CtrlSum", y.sum_amount),
                               XMLElement("InitgPty",
                                          XMLElement("Nm", x.debtor_name)
                                         )
                              ),
                     XMLElement("PmtInf",
                               XMLElement("PmtInfId", x.transfer_id),
                               XMLElement("PmtMtd", 'TRF'),
                               XMLElement("NbOfTxs", y.count_pos),
                               XMLElement("CtrlSum", y.sum_amount),
                               XMLElement("PmtTpInf",
                                          XMLElement("SvcLvl",
                                                     XMLElement("Cd", 'SEPA')
                                                    )
                                         ),
                               XMLElement("ReqdExctnDt", to_char(sysdate, 'yyyy-mm-dd')),
                               XMLElement("Dbtr", x.debtor_name),
                               XMLElement("DbtrAcct",
                                          XMLElement("Id",
                                                    XMLElement("IBAN", NULL)
                                                    ),
                                          XMLElement("Ccy", x.currency)
                                         ),
                              XMLElement("DbtrAgt",
                                         XMLElement("FinInstnId",
                                                    XMLElement("BIC", NULL)
                                                   )
                                        ),
                              XMLElement("ChrgBr", 'SLEV'),
                              ------ Positions --------
                              (SELECT
                              XMLAgg(XMLElement("CdtTrfTxInf",
                                               XMLElement("PmtId",
                                                          XMLElement("InstrId", x.transfer_id || s.client_id),
                                                          XMLElement("EndToEndId", x.transfer_id ||'/'||to_char(rownum-1))
                                                          ),
                                               XMLElement("Amt",
                                                          XMLElement("InstdAmt", XMLAttributes(x.currency AS "Ccy"), trim(to_char(s.amount, '9999999999990.99')))
                                                         ),
                                               XMLElement("CdtrAgt",
                                                          XMLElement("FinInstnId",
                                                                     XMLElement("BIC", s.bic)
                                                          )
                                                         ),
                                               XMLElement("Cdtr",
                                                          XMLElement("Nm", s.accountholder)
                                                         ),
                                               XMLElement("CdtrAcct",
                                                          XMLElement("Id",
                                                                     XMLElement("IBAN", s.iban)
                                                          )
                                                         ),
                                               XMLElement("RmtInf",
                                                          XMLElement("Ustrd", s.reason_for_transfer)
                                                         )
                                               )
                                   )
                              FROM sepa_cred_data s
                              WHERE s.deb_data_id = x.id
                                )
                              )
                      )
          ) AS sepa_xml
FROM sepa_deb_data x
JOIN (SELECT 
      c.deb_data_id,
      SUM(c.amount) AS sum_amount,
      COUNT(c.id) AS count_pos
      FROM sepa_cred_data c
      GROUP BY c.deb_data_id) y ON (x.id = y.deb_data_id)
WHERE x.id = 1;