# Jahresvorschau — Fassung mit Datenbank

Zweite Fassung des Werkzeugs „Jahresvorschau Onkologie/Print". Sie holt die
Heftplanung aus einer Datenbank, statt sie im Dokument mitzuführen. Die
bisherige Einzeldatei in `../Jahresvorschau Print/` bleibt unverändert
bestehen.

## Dateien

| Datei | Zweck |
|---|---|
| `index.html` | das Werkzeug; eine Datei, wie zuvor |
| `konfiguration.js` | Adresse und öffentlicher Schlüssel der Datenbank |
| `schema.sql` | Aufbau der Datenbank, einmalig einzuspielen |
| `werkzeug/` | Hilfsskripte der Übernahme, für den Betrieb nicht nötig |

## Datenbank

Supabase-Projekt `jahresvorschau`, Region Frankfurt (eu-central-1),
Kennung `husiqbxtustjnbwpeuqh`. Kosten: 0 €/Monat.

Vier Tabellen: `jahrgang`, `titel`, `ausgabe`, `sicherung`. Eine Zeile je
Ausgabe; die beiden Kongresslisten stehen als Liste in dieser Zeile.

Der Schlüssel in `konfiguration.js` ist zur Veröffentlichung bestimmt. Zugang
hat nur, wer angemeldet **und** in der Tabelle `berechtigt` eingetragen ist.
Angemeldet allein genügt bewusst nicht: der Schlüssel steht nach dem
Veröffentlichen im Netz, und die Neuanmeldung ist im Projekt offen — ohne diese
Liste könnte sich jeder ein Konto anlegen und hätte vollen Zugriff.

Nachgemessen: freigegebenes Konto 108 Ausgaben, fremdes angemeldetes Konto 0,
ohne Anmeldung 0.

Eine weitere Person freigeben (im SQL-Editor):

```sql
insert into berechtigt (benutzer_id, notiz)
values ('<Kennung aus auth.users>', 'Name');
```

## Benutzerkonten

Konten werden im Supabase-Verwaltungsbereich angelegt, nicht im Werkzeug:
*Authentication → Users → Add user*, E-Mail und Kennwort eintragen,
**„Auto Confirm User" einschalten**. Danach die Kennung des Kontos in
`berechtigt` eintragen — ohne diesen Eintrag bleibt das Werkzeug leer.

## Stand der Arbeiten

* **Erster Bauabschnitt — fertig.** Datenbank angelegt, Jahrgänge 2026 und 2027
  eingespielt, Werkzeug liest daraus. Sämtliche gemessenen Sollwerte kommen
  unverändert heraus.
* **Zweiter Bauabschnitt — fertig.** Sechste Ansicht „Bearbeiten": Termine,
  Themen und die beiden Kongresslisten je Ausgabe, mit Vorschlägen aus den
  bereits verwendeten Kongressnamen. Gespeichert wird auf Knopfdruck, nie
  stillschweigend; eine angefangene Änderung überlebt jeden Ansichtswechsel und
  meldet sich beim Verlassen der Seite. Dazu Sicherungspunkte je Jahrgang.
* **Dritter Bauabschnitt — offen.** Excel-Eingang auf die Datenbank umstellen,
  Ausgaben und Titel anlegen und entfernen, Veröffentlichung über GitHub Pages.

## Bearbeiten

Links die Ausgaben des Jahrgangs, rechts das Formular. Gearbeitet wird auf
einer Arbeitskopie: erst *Speichern* schreibt in die Datenbank und danach in
den angezeigten Jahrgang. Ein Abbruch lässt den gezeigten Stand unangetastet.

Die Kongressfelder schlagen beim Tippen bereits verwendete Namen vor. Ein neuer
Name ist erlaubt — nur wird ein Kongress, dessen Schreibweise von den übrigen
abweicht, in der Kongressansicht zu einem eigenen Kasten.

## Sicherungspunkte

*Sicherungspunkt anlegen* legt den ganzen Jahrgang als Schnappschuss ab.
*Zurücksetzen* spielt ihn wieder ein — Titel und Ausgaben des Jahrgangs werden
dabei ersetzt, alles seither Geänderte geht verloren. Es wird vorher gefragt.

## Veröffentlichung

Noch nicht erfolgt. `.gitignore` schließt den Ordner `werkzeug/` aus: dort
liegt `daten.json` mit der vollständigen Heftplanung im Klartext. Öffentlich
gehören nur `index.html`, `konfiguration.js`, `schema.sql` und `README.md`.

Bis dahin ruhen im Menü „Daten" die Punkte *Aus Excel laden* und *Jahrgang
entfernen*: sie schrieben nur in den Arbeitsspeicher und täuschten einen Stand
vor, den die Datenbank nicht kennt. *Werkzeug sichern* ist mit der Datenbank
hinfällig und durch *Abmelden* ersetzt.

## Was unverändert geblieben ist

Alle fünf Ansichten, die Mehrfachauswahl der Inhalte, Suche, Druckregeln,
PDF-, HTML- und Excel-Ausgabe. Die Kopie („Als HTML") bettet den Jahrgang
weiterhin ein und läuft eigenständig — ohne Datenbank, ohne Anmeldung.
