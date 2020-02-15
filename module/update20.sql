alter table Personen add column [Notiz] TEXT NULL
alter table Personen add column [Gemeindeglied] BOOLEAN DEFAULT TRUE      
Update Personen set Gemeindeglied=TRUE
Update Version set version = "2.0"