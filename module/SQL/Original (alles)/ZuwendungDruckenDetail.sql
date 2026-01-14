select PersonenID, Datum, Betrag, Aufwandsspende, konten.KontoNr, konten.name as Sachkonto 
from Journal
left join konten on konten.KontoNr = journal.konto_nach
where ((journal.BuchungsJahr=:BJAHR) and 
      (((journal.konto_nach like '2%') and (konten.kontotype = "D") and (journal.Betrag>0)) or 
	    (journal.konto_nach like '8%')))
order by datum