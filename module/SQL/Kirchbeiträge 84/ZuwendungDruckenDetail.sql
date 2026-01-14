select PersonenID, Datum, Betrag, Aufwandsspende, konten.KontoNr, konten.name as Sachkonto 
from Journal
left join konten on konten.KontoNr = journal.konto_nach
where ((journal.BuchungsJahr=:BJAHR) and (journal.konto_nach = '84'))
order by datum