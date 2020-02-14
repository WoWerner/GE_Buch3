select personen.*, sum(journal.Betrag) as Betrag, CAST(sum(journal.Betrag) AS FLOAT)/100.0 as BetragInEuro
from Personen
left join journal on journal.PersonenID = Personen.PersonenID
left join sachkonten on sachkonten.SachkontoNr = Journal.SachkontoNr
where ((journal.BuchungsJahr=:BJAHR) and 
      (((journal.SachkontoNr like '2%') and (sachkonten.kontotype = "DE")) or 
	    (journal.SachkontoNr like '84%') or 
	    (journal.SachkontoNr like '85%') or 
	    (journal.SachkontoNr like '86%') or 
	    (journal.SachkontoNr like '87%') or 
	    (journal.SachkontoNr like '88%')))
group by Personen.PersonenID
order by nachname COLLATE NOCASE, vorname COLLATE NOCASE, Ort COLLATE NOCASE, strasse COLLATE NOCASE