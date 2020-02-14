select LaufendeNr,
       Banknr, 
       Sachkontonr, 
       Journal.PersonenID,
       ifnull(personen.Nachname,'')||', '||ifnull(personen.Vorname,'') as Name
from journal
left join personen on personen.PersonenID=Journal.PersonenID
where (Buchungsjahr = :BJahr) and
      ((Sachkontonr not in (select Sachkontonr from Sachkonten)) or
       (Banknr not in (select Banknr from Banken)) or
       ((Journal.PersonenID not in (select personen.PersonenID from Personen)) and (Journal.PersonenID > 0)))
order by LaufendeNr