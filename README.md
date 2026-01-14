# Buchhaltungsprogramm der SELK

Dieses Projekt ist das Buchhaltungsprogramm der SELK. Es wurde für Windows 11 entwickelt und setzt auf freie, plattformunabhängige Komponenten.

## Voraussetzungen / Benötigte Komponenten

Für den erfolgreichen Build und Betrieb werden folgende Bibliotheken und Werkzeuge benötigt:

* **Lazarus 4.4** – <https://www.lazarus-ide.org/>
  Entwicklungsumgebung für FreePascal.
* **ZeosLib 8.0** – <https://sourceforge.net/projects/zeoslib/>
  Datenbankzugriffskomponenten für verschiedene DBMS.
* **SQLite 3.51.0** – <https://sqlite.org/>
  Eingebettete SQL-Datenbank.
* **Synapse 41.0** – <https://github.com/geby/synapse>
  Netzwerk-Bibliothek für FreePascal/Lazarus.
* **7ZIP.dll 21.07** - <https://sourceforge.net/projects/sevenzip/files/7-Zip/21.07/>
  Wird für Komprimierungs- und Dekomprimierungsfunktionen benötigt.
* **OpenSSL DLLs 3.6.0.0** – Anleitung bei <https://www.ghisler.com/openssl/>
  Wird für den Internetzugriff auf HTTPS Seiten benötigt

## Installation

1. Lazarus 4.4 installieren.
2. ZeosLib 8.0 herunterladen und in Lazarus einbinden.
3. SQLite 3.51.0 bereitstellen (DLL im Projektverzeichnis oder im Systempfad).
4. Synapse-Bibliothek herunterladen und in Lazarus einrichten.
5. 7ZIP.dll in das Programmverzeichnis legen.

## Projekt bauen

1. Projekt in Lazarus öffnen.
2. Abhängigkeiten prüfen.
3. Projekt kompilieren (Target: Windows 11).

## Hinweise

* Die benötigten DLLs (SQLite, 7ZIP) müssen zur Laufzeit im selben Verzeichnis wie die ausführbare Datei liegen.
* Für den Datenbankzugriff über Zeos muss der entsprechende Treiber aktiviert sein.

## Lizenz

Bitte ggf. Lizenzbedingungen der einzelnen Drittanbieter-Bibliotheken beachten.