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
* **Zweiter Bauabschnitt — fertig.** Arbeitsschirm „Bearbeiten": Termine,
  Themen und die beiden Kongresslisten je Ausgabe, mit Vorschlägen aus den
  bereits verwendeten Kongressnamen. Gespeichert wird auf Knopfdruck, nie
  stillschweigend; eine angefangene Änderung meldet sich beim Verlassen des
  Arbeitsschirms wie beim Verlassen der Seite. Dazu Sicherungspunkte je Jahrgang.
* **Dritter Bauabschnitt — fertig.** Veröffentlicht über GitHub Pages. Der
  Excel-Eingang schreibt in die Datenbank; Ausgaben und Titel lassen sich
  anlegen und entfernen, ebenso ein ganzer Jahrgang.

## Bearbeiten

Der Arbeitsschirm steht im Menü *Daten* an erster Stelle, nicht in der
Ansichtsauswahl — dort stehen nur die fünf Druckvorlagen. Er ist kein
gleichwertiger sechster Blick auf denselben Bestand und auch im Unterbau keine
Ansicht mehr, sondern ein eigener Zustand daneben: die zuletzt gewählte
Druckansicht bleibt bestehen und liegt darunter. Die Terminlegende wird
ausgeblendet, solange gearbeitet wird.

Derselbe Menüpunkt führt hinein und wieder hinaus — beim Öffnen heißt er
*Bearbeiten*, danach *Bearbeiten beenden* und benennt die Ansicht, zu der er
zurückführt. Er ist der einzige Weg hinaus: Suche, Inhaltsarten,
Ansichtsknöpfe, Titel-Schalter und der Knopf *Exportieren* sind blass und
gesperrt, solange gearbeitet wird. Sie bleiben sichtbar, damit die Kopfzeilen
beim Öffnen und Schließen nicht springen. Der Export ist gesperrt, weil er die
Druckansichten ausgibt — im Arbeitsschirm gäbe es dafür keine Vorlage; ein noch
offenes Klappmenü wird beim Öffnen der Arbeitsansicht geschlossen. Bedienbar
bleiben die Jahrgangswahl und der Stand der Heftplanung.

Der Stand im Navy-Streifen ist ausschließlich hier beschreibbar: außerhalb der
Arbeitsansicht steht er da wie jede andere Angabe im Kopf, ohne Schreibmarke und
ohne gepunktete Linie. Er gehört zum Jahrgang und wird in der Datenbank geführt
— beim Verlassen des Feldes wandert er dorthin, einen eigenen Speichern-Knopf
gibt es dafür nicht. Bleibt das Feld leer, kehrt der zuletzt gespeicherte Wert
zurück; der Stand lässt sich also ändern, aber nicht löschen.

Steht eine ungespeicherte Änderung im Weg, wird vor dem Schließen gefragt.
Gedruckt und als PDF ausgegeben wird immer eine der fünf Druckvorlagen: steht
der Arbeitsschirm offen, wird er dafür geschlossen.

Links die Ausgaben des Jahrgangs, rechts das Formular. Gearbeitet wird auf
einer Arbeitskopie: erst *Speichern* schreibt in die Datenbank und danach in
den angezeigten Jahrgang. Ein Abbruch lässt den gezeigten Stand unangetastet. Die
Liste links behält beim Wechsel der Ausgabe ihre Rollposition — sie wird bei
jedem Zeichnen neu aufgebaut, ihr Stand wird dabei aber gemerkt und wieder
gesetzt.

Die Kongressfelder schlagen beim Tippen bereits verwendete Namen vor. Ein neuer
Name ist erlaubt — nur wird ein Kongress, dessen Schreibweise von den übrigen
abweicht, in der Kongressansicht zu einem eigenen Kasten.

## Wenn die Anmeldung »JWT issued at future« meldet

Gelegentlich weist die Datenbank eine eben ausgestellte Sitzung mit dem Code
**PGRST303** ab: die Uhren des Anmeldedienstes und der Datenbank gehen ein
paar Sekunden auseinander, und die Sitzung gilt ihr deshalb als in der Zukunft
ausgestellt. Die Anfrage wird dabei gar nicht erst ausgeführt.

Das Werkzeug versucht es in diesem Fall von selbst noch dreimal — auch bei
schreibenden Anfragen, die dann nachweislich nicht ausgeführt wurden. Gewartet
wird 3, 8 und 15 Sekunden. Lässt sich der Versatz messen, richtet sich die
Wartezeit nach ihm: die abweisende Antwort trägt die Uhrzeit des vorgelagerten
Dienstes, die Sitzung ihren Ausstellungszeitpunkt — die Differenz plus eine
Sekunde, höchstens 15. Liegt die abweichende Uhr weiter hinten, misst sich hier
nichts, und es bleibt bei der Staffel.

Bleibt es auch dann dabei, erscheint statt der Rohmeldung ein Hinweis: mit dem
gemessenen Versatz, sofern er sich ermitteln ließ, mit dem Zeitpunkt für einen
erneuten Versuch und mit dem Rat, die Seite neu zu laden — das hilft
verlässlich. Eine neue Anmeldung ändert dagegen nichts; sie stellt die Sitzung
nur noch einmal aus und läuft in dieselbe Prüfung.

Steht das Werkzeug lange offen, ist die Sitzung beim nächsten Griff womöglich
abgelaufen. Aufgefrischt wird sie deshalb in `dbAnfrage()` — der einen Stelle,
durch die jede Anfrage läuft. Zuvor stand die Zeile in dreizehn aufrufenden
Funktionen einzeln, und beim Holen der Sicherungspunkte fehlte sie; dieser eine
Weg scheiterte dann an der Sitzung statt an den Daten. Während des Abrufs steht
im Kasten »Die Sicherungspunkte werden geladen …«, nicht der Leerhinweis.

## Anlegen und Entfernen

In der Ansicht *Bearbeiten*:

* **Ausgabe anlegen** — die Zeile *+ Ausgabe* unter den Heften eines Titels.
  Die Ausgabe entsteht erst mit *Anlegen*, und nur mit Heftnummer. Sie wird
  anschließend nach ihrem Erscheinungstermin einsortiert.
* **Ausgabe entfernen** — im Formular unten rechts, mit Rückfrage.
* **Titel-Stammdaten** — der farbige Kopf über den Heften führt zu Kurzname,
  vollständigem Namen, Auflage und Kennfarbe. Sie gelten je Jahrgang: die
  Auflage unterscheidet sich von Jahr zu Jahr.
* **Titel anlegen und entfernen** — *+ Neuen Titel anlegen* steht unter der
  Liste, nicht in ihr, und bleibt damit sichtbar, gleich wie weit geblättert
  ist; *Titel entfernen* im Formular. Ein entfernter Titel nimmt seine Ausgaben mit; der
  letzte Titel eines Jahrgangs bleibt stehen.

Im Menü *Daten*:

* **Aus Excel laden** — erwartet das Blatt *Ausgaben* dieses Werkzeugs,
  ausgegeben ohne Suche und Filter, mit einem vollständigen Jahrgang. Der Jahrgang wird in der Datenbank
  **im Ganzen ersetzt**; nur so verschwinden gestrichene Hefte.
  Vorher entsteht ohne Zutun ein Sicherungspunkt. Der Prüfbericht vor dem
  Übernehmen bleibt derselbe wie zuvor.
* **Jahrgang anlegen** — der zweite Weg zu einem neuen Jahr, neben dem
  Excel-Eingang. Jahr und Stand im Dialog, auf Wunsch werden die Titel des
  gezeigten Jahrgangs übernommen (mit Nummer, vollem Namen, Kennfarbe und
  Auflage — Angaben, die nicht in der Excel-Tabelle stehen). Hefte kommen
  keine mit; der Jahrgang entsteht leer und wird über *+ Ausgabe* gefüllt.
  Danach steht der Arbeitsschirm offen.
* **Jahrgang entfernen** — nimmt Titel, Ausgaben und die Sicherungspunkte des
  Jahrgangs mit. Der letzte Jahrgang bleibt stehen.

## Sicherungspunkte

*Sicherungspunkt anlegen* legt den ganzen Jahrgang als Schnappschuss ab.
*Zurücksetzen* spielt ihn wieder ein — Titel und Ausgaben des Jahrgangs werden
dabei ersetzt, alles seither Geänderte geht verloren. Es wird vorher gefragt.

Die Liste wird beim Öffnen der Arbeitsansicht geholt, beim Jahrgangswechsel und
nach jedem Schreibvorgang — nicht mehr einmalig beim Anmelden. Misslingt der
Abruf, steht das im Kasten samt *Erneut versuchen*; früher sah ein Fehlschlag
aus wie „noch nichts angelegt".

Sicherungspunkte verfallen nicht von selbst und werden auch nicht still
ausgedünnt: Ein bewusst gesetzter Punkt soll nicht hinter der Liste
verschwinden. Aufgeräumt wird von Hand, mit dem × am Ende der Zeile; auch dort
wird vorher gefragt. Die Liste zeigt die 25 jüngsten je Jahrgang. Vom Platz her
fällt nichts ins Gewicht — ein Punkt ist der Jahrgang als JSON, für 2026 rund
20 KB.

## Veröffentlichung

Live unter https://barings1995.github.io/jahresvorschau/, Quelltext unter
https://github.com/Barings1995/jahresvorschau.

`.gitignore` schließt den Ordner `werkzeug/` aus: dort liegt `daten.json` mit
der vollständigen Heftplanung im Klartext. Öffentlich gehören nur
`index.html`, `konfiguration.js`, `schema.sql` und `README.md`.

*Werkzeug sichern* ist mit der Datenbank hinfällig und durch *Abmelden*
ersetzt.

## Tabelle im Druck

Die Trennlinie steht im Druck über der Zeile, nicht darunter, und den unteren
Abschluss jeder Seite zeichnet eine leere Fußzeile, die Chrome wie die Kopfzeile
auf jeder Seite wiederholt. Grund: Eine Linie am unteren Rand der letzten Zeile
einer Seite fällt genau auf die Seitenkante und wird dort nicht mehr gezeichnet
— die Ausgabe hatte dann eine Zeile ohne Abschluss. Ein stärkerer Strich,
getrennte Rahmen (`border-collapse: separate`) und `box-decoration-break: clone`
halfen gemessen nicht; die Fußzeile liegt dagegen innerhalb der Seite. Am
Bildschirm bleibt sie ausgeblendet, dort schließt der Tabellenrahmen ab. Im
Druck ist der untere Rand des Tabellenrahmens abgeschaltet: sonst stünden dort
zwei Linien dicht beieinander und der Abschluss wirkte doppelt so stark wie die
übrigen Linien.

Der Satzspiegel hat im Druck rechts ein Pixel Luft. Chrome zeichnet jede Kante
auf ganze Pixel und rundet dabei auf: der Druckbereich ist 1039,39 px breit
(quer, A4, 11 mm Rand), gezeichnet wurde bis 1040. Bei den waagerechten Linien —
Kopflinie, Legende — fällt das nicht auf, sie werden nur um 0,6 px gekürzt. Der
senkrechte rechte Rahmenstrich lag dagegen zu 61 % im Beschnitt und wirkte dünner
als die drei übrigen — in der Tabelle ebenso wie an den Kacheln, den Zeilen der
Monatsliste, den Kongresskästen und der Jahresmatrix. Mit dem Pixel Luft endet
alles gemeinsam bei 1039 px: der Strich steht ganz auf der Seite und bündig unter
Kopflinie und Legende — gemessen im Quer- und im Hochformat für alle fünf
Ansichten. Der
Abzug gehört an den Satzspiegel und nicht an die Tabelle; säße er an der Tabelle,
endete sie 0,4 px vor den Linien darüber.

## Meldungen

Meldungen erscheinen im Werkzeug, nicht im Browser. Der Dialog (`dialogZeigen`)
kann beides: mit einer Handlung trägt er zwei Knöpfe („Übernehmen"/„Abbrechen"),
ohne Handlung nur einen — „Schließen". Die eine Stelle, die bis zum 02.09.2026
noch ein `alert()` des Browsers zeigte, ist der Export ohne Auswahl; sie meldet
jetzt „Export nicht möglich" im selben Fenster wie alles andere. Damit steht in
allen vier Werkzeugen dieselbe Regel — in den Angebotswerkzeugen über einen
eigenen Baustein `hinweis()`, hier über den vorhandenen Dialog.

## Rückfragen

Seit dem 02.09.2026 gilt dasselbe für die Rückfragen: `frage(titel, html, jaText)`
tritt an die Stelle von `confirm()` und liefert ein Versprechen, auf das die
aufrufenden Funktionen warten. Betroffen sind sechs Stellen — die begonnene
Änderung beim Wechseln und beim Verwerfen, das Entfernen einer Ausgabe, eines
Titels und eines Sicherungspunkts sowie das Zurücksetzen eines Jahrgangs.

Der Gewinn liegt in der Beschriftung: statt „OK" steht dort „Verwerfen",
„Entfernen" oder „Zurücksetzen". Escape lehnt ab, wie zuvor bei `confirm()`, und
der Fokus liegt auf „Abbrechen" — die Rückfragen stehen vor Handlungen, die
etwas verwerfen.

Anders als `dialogZeigen` belegt `frage()` nicht den vorhandenen Dialog, sondern
legt ein eigenes Blatt an: zwei der Rückfragen kommen aus einem offenen Dialog
heraus. Das Blatt trägt dieselbe Klasse `daten-dialog`, damit die Regeln für
Druck und HTML-Kopie greifen, die es dort ausblenden bzw. entfernen; ein höherer
z-Wert (500 gegenüber 400) legt es darüber. In `baueKopie` wurde dafür
`querySelector` auf `querySelectorAll` umgestellt — es kann jetzt mehr als ein
Dialogblatt geben.

## Eingaben

Die letzte Stelle, die noch ein Fenster des Browsers zeigte, war die Bezeichnung
beim Anlegen eines Sicherungspunkts (`prompt()`). Seit dem 02.09.2026 gilt dort
`eingabe(titel, erklaerung, beschriftung, vorgabe, jaText)` — derselbe Aufbau wie
`frage()`, nur mit einem Textfeld dazwischen. Zurück kommt der eingetippte Text
oder `null` bei Abbruch.

Vom `prompt()` übernommen: die Vorgabe steht markiert im Feld, der Fokus liegt im
Feld statt auf einem Knopf, die Eingabetaste bestätigt, Escape bricht ab. Ein
leeres Feld liefert `''` und ist nicht dasselbe wie abgebrochen.

Damit kommt aus dem Werkzeug kein Fenster des Browsers mehr — abgesehen von der
Warnung des Browsers selbst beim Verlassen der Seite, die kein Werkzeug ersetzen
kann.

## Was unverändert geblieben ist

Alle fünf Ansichten, die Mehrfachauswahl der Inhalte, Suche, Druckregeln,
PDF-, HTML- und Excel-Ausgabe. Die Kopie („Als HTML") bettet den Jahrgang
weiterhin ein und läuft eigenständig — ohne Datenbank, ohne Anmeldung.
