select '('||ifnull(banken.banknr,'')||') '||ifnull(banken.bank,'')||' '||ifnull(banken.konto,'') as Name,
        banken.BankNr,
        banken.Kontostand,
        bankenabschluss.Anfangssaldo,
        bankenabschluss.Abschlusssaldo 
from banken
left join bankenabschluss on banken.BankNr=bankenabschluss.BankNr
where (bankenabschluss.BuchungsJahr=:BJAHR) and 
      (banken.BankNr > 1) and 
	  (banken.BankNr < 900)
order by banken.BankNr