select PersonenID,
       Name as Empfaenger,
       Kontotype,
       Finanzamt,
       FinanzamtVom,
       FinanzamtNr from Journal
left join konten on konten.KontoNr = journal.konto_nach
where ((journal.BuchungsJahr=:BJAHR) and 
      (((journal.konto_nach like '2%') and (konten.kontotype = "D") and (journal.Betrag>0)) or
	    (journal.konto_nach like '85%')))
group by PersonenID, Empfaenger, FinanzamtNr
order by konten.KontoNr