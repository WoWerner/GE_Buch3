BEGIN TRANSACTION;
alter table konten add column [Steuer] VARCHAR (30);
update konten set steuer = "" where steuer isnull
Update konten set Steuer = "Nicht umsatzsteuerbar" where kontotype="E";
Update init set version = "3.1";
COMMIT;
vacuum;
