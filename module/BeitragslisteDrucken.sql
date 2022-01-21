select sum(Betrag) as Betrag,
       ifnull(Vorname,'')||' '||ifnull(Nachname,'') as Name,
       '('||ifnull(journal.konto_nach,'')||') '||ifnull(konten.Name,'') as konto_nach,
       BuchungsJahr
from Journal
left join personen   on personen.PersonenID=Journal.PersonenID
left join konten on journal.konto_nach=konten.KontoNr
where ((Journal.BuchungsJahr = :BJAHR-1) or (Journal.BuchungsJahr = :BJAHR)) and
       (Journal.PersonenID>0) :AddWhere
group by journal.konto_nach, Journal.PersonenID, Journal.BuchungsJahr
order by cast (journal.konto_nach as text), Journal.PersonenID, Journal.BuchungsJahr