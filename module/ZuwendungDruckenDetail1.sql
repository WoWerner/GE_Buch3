select PersonenID,
       Sachkonto as Empfaenger,
       Kontotype,
       Finanzamt,
       FinanzamtVom,
       FinanzamtNr from Journal
left join sachkonten on sachkonten.SachkontoNr = Journal.SachkontoNr
where ((journal.BuchungsJahr=:BJAHR) and 
      (((journal.SachkontoNr like '2%') and (sachkonten.kontotype = "DE")) or
	    (journal.SachkontoNr like '84%') or 
	    (journal.SachkontoNr like '85%') or 
	    (journal.SachkontoNr like '86%') or 
	    (journal.SachkontoNr like '87%') or 
	    (journal.SachkontoNr like '88%')))
group by PersonenID, Empfaenger, FinanzamtNr
order by sachkonten.SachkontoNr