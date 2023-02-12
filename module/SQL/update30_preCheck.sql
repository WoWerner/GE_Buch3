select
   sachkontonr 
from
   sachkonten 
   left join
      Banken 
where
   sachkonten.SachkontoNr = Banken.BankNr 
   and sachkonten.SachkontoNr > 1 
   and sachkonten.SachkontoNr < 999