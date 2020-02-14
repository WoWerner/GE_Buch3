select PersonenID, Datum, Betrag, ResS1,sachkonten.Sachkonto
from Journal
left join sachkonten on sachkonten.SachkontoNr = Journal.SachkontoNr
where ((journal.BuchungsJahr=:BJAHR) and 
      (((journal.SachkontoNr like '2%') and (sachkonten.kontotype = "DE")) or 
	    (journal.SachkontoNr like '84%') or 
		(journal.SachkontoNr = 1) or
	    (journal.SachkontoNr like '85%') or 
	    (journal.SachkontoNr like '86%') or 
	    (journal.SachkontoNr like '87%') or 
	    (journal.SachkontoNr like '88%')))
order by datum