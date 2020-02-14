alter table Personen add column [Geburtstag] DATE NULL      
alter table Personen add column [Abgang] BOOLEAN NULL      
Update Personen set Abgang=0
Update Version set version = "1.8"    