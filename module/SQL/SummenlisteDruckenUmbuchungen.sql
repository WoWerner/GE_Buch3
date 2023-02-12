select
	(select '('||ifnull(journal.BankNr,'')||') '||ifnull(konten.Name,'') from konten where journal.BankNr = konten.KontoNr) || ' nach ' || (select '('||ifnull(journal.konto_nach,'')||') '||ifnull(konten.Name,'') from konten where journal.konto_nach = konten.KontoNr) as Name,
	sum(journal.Betrag) as Summe
from journal
where (journal.BuchungsJahr=:BJAHR) and (journal.Konto_nach in (select konten.KontoNr from konten where konten.Kontotype = 'B')) :AddWhere
group by journal.BankNr, journal.Konto_nach
order by journal.BankNr