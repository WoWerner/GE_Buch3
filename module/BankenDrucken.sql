select banken.BankNr as BankNr,
       Kontostand,
       SortPos,
       ifnull(Bank,'')||' - '||ifnull(Konto,'') as Bank,
       Statistik,
       ifnull(bankenabschluss.Anfangssaldo,'')  as StartSaldo
from banken
left join bankenabschluss on banken.BankNr = bankenabschluss.BankNr
where (banken.BankNr > 1) and (banken.BankNr < 900) and (bankenabschluss.Buchungsjahr=:BJAHR)
order by SortPos