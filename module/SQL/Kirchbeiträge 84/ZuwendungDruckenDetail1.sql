select PersonenID,
       Name as Empfaenger,
       Kontotype,
       Finanzamt,
       FinanzamtVom,
       FinanzamtNr from Journal
left join konten on konten.KontoNr = journal.konto_nach
where ((journal.BuchungsJahr=:BJAHR) and (journal.konto_nach = '84'))
group by PersonenID, Empfaenger, FinanzamtNr
order by konten.KontoNr