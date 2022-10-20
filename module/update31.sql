BEGIN TRANSACTION;
alter table konten add column [Steuer] VARCHAR (30) NULL;
Update konten set Steuer = "Nicht umsatzsteuerbar" where kontotype="E";
Update init set version = "3.1";
COMMIT;
vacuum;
