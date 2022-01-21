select konten.KontoNr as KontoNr,
       konten.KontoNr as KontoNr,
       journal.BuchungsJahr as BuchungsJahr,
       sum(journal.Betrag) as Summe
from konten
cross join journal on konten.KontoNr=journal.konto_nach
where (journal.BuchungsJahr=:BJAHR or journal.BuchungsJahr=:BJAHR-1) and konten.kontotype = 'E'      
Group by journal.BuchungsJahr, journal.konto_nach
order by konten.SortPos