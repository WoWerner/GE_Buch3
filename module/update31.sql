BEGIN TRANSACTION;
alter table konten add column [Steuer] VARCHAR (20) NULL;
Update konten set Steuer = "Nicht umsatzsteuerbar";
Update init set version = "3.1";
COMMIT;
vacuum;
