select 
  konten.kontonr 
from
  konten
where
  (konten.Kontotype = "A" or konten.Kontotype = "E") and (konten.Statistik <> 99)
order by
  konten.Sortpos