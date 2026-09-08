# Änderungslog – Jahresvorschau (Fassung mit Datenbank)

Dokumentiert Änderungen an `index.html` (Single-File-HTML-Werkzeug, Springer Medizin,
Onkologie; Daten aus Supabase, veröffentlicht über GitHub Pages). Neueste Änderung oben.

**Hinweise zur Datengrundlage**
- Das Log beginnt am 08.09.2026. Was davor liegt, steht vollständig in den
  Commit-Nachrichten des Repositorys und, als Überblick, im `README.md` unter
  *Stand der Arbeiten* — dort nachzuschlagen ist genauer, als es hier ein zweites
  Mal zu erzählen.
- Zu jedem Eintrag gehören der Commit und die MD5 der Datei vorher und nachher.
  Anders als bei den Angebotswerkzeugen gibt es keine Sicherungskopien im
  Dateisystem: die Versionsverwaltung ist hier die Sicherung.
- **Veröffentlichen:** Gepusht wird ausschließlich auf ausdrückliche Anweisung.
  Nach dem Push wird die Prüfsumme der ausgelieferten Seite
  (`https://barings1995.github.io/jahresvorschau/index.html`) gegen die lokale
  Datei gehalten, bis beide übereinstimmen — GitHub Pages braucht dafür in der
  Regel eine knappe Minute.
- Der Ordner `werkzeug/` bleibt außerhalb der Versionsverwaltung; er enthält
  Zugangsdaten im Klartext. Vor jedem Push wird das nachgesehen.

---

## 2026-09-08 — Kongressspalte im PDF-Export auf 42 %: eine Seite weniger

**Anlass.** Marcus fragte, ob die 38 % für die Kongressspalte im PDF-Export der
Tabellenansicht noch stimmen — er vermutete, der Wert stamme aus einer Zeit, als
in den Kongressen noch keine Termine und Orte standen.

**Der Befund.** Die Vermutung trifft zu. Seit der Umstellung auf eigene
Kongresssätze setzt `kongressAus()` den Zellinhalt aus `Name, Zeitraum, Ort`
zusammen; in der Datenbank trägt heute jeder der 81 Kongresse einen Ort und 79
von 81 ein Datum — rund zwanzig bis fünfundzwanzig Zeichen mehr je Eintrag. Bei
38 % brachen dadurch 75 der 169 Einträge des Jahrgangs 2027 um (2026: 86 von
171), und die Tabelle brauchte in **beiden** Jahrgängen eine siebte Seite. Die
Begründung im Druck-CSS beschrieb noch den alten Bestand („20 statt 87 der 181
Einträge brechen um").

**Die Messreihe.** Druckfassung A4 quer, Ränder 12/11 mm, Chrome headless, Daten
lesend aus der Datenbank geholt (der Prüfstand `daten_pruef.json` führt für 2026
noch die alten Textspalten und taugt für diese Frage nicht). Jahrgang 2027, 169
Einträge:

| Breite | Seiten | Umbrüche Kongresse | Zeilen Schwerpunkt | Zeilen Titel | Tabellenhöhe |
|--------|--------|--------------------|--------------------|--------------|--------------|
| 34 %   | 7      | —                  | —                  | —            | 4217 px |
| 36 %   | 7      | —                  | —                  | —            | 3917 px |
| **38 % (alt)** | **7** | **75**      | 88                 | 90           | 3793 px |
| 40 %   | 6      | 62                 | 92                 | 90           | 3644 px |
| 41 %   | 6      | —                  | —                  | —            | 3614 px |
| **42 % (neu)** | **6** | **33**      | 105                | 90           | 3303 px |
| 43 %   | 6      | 28                 | 107                | 90           | 3241 px |
| 44 %   | 6      | —                  | —                  | 100          | 3336 px |
| 45 %   | 6      | 28                 | 122                | 100          | 3355 px |
| 48 %   | 6      | —                  | 128                | 116          | 3301 px |
| 50 %   | 6      | —                  | —                  | 116          | 3408 px |
| ab 52 %| 6      | —                  | —                  | 116          | 3422 px |

Jahrgang 2026 verhält sich gleich: 38 % → 7 Seiten, ab 39 % → 6 Seiten, niedrigste
Tabelle bei 41,5 bis 42 % (3261 bzw. 3275 px). Ab 52 % wächst die Kongressspalte
nicht weiter — die Nachbarspalten sind dann auf ihrem Mindestmaß.

**Belastungsprobe.** Damit die Empfehlung nicht am heutigen Umfang hängt, wurde
der Bestand von hinten gekürzt und bei neun Größen zwischen 30 und 169 Einträgen
38 % gegen 42 % gestellt: 42 % ist nirgends schlechter und spart in vier der neun
Fälle eine Seite (bei 90, 130, 150 und 169 Einträgen). Die Tabelle ist überall
niedriger; einzige Ausnahme ist der kleinste Bestand, dort 5 px höher bei
gleicher Seitenzahl.

**Was sich geändert hat.** Eine Zahl im Druckblatt: `.t-kong{…width:42%}` statt
`38%`. Die Kongressspalte misst damit 436 statt 394 Pixel. Sonst nichts — der
Bildschirmwert (40 %, eigene Regel) bleibt unangetastet, ebenso der hängende
Einzug von 36 px und alle übrigen Spalten.

**Die verworfenen Alternativen** — festgehalten, falls die Frage wiederkommt:
- **40 %** spart die Seite ebenfalls, lässt aber 62 statt 33 Umbrüche stehen. Hätte
  den Reiz, dass Druck und Bildschirm denselben Wert trügen; der Gewinn in der
  Kongressspalte ist aber nur halb so groß.
- **43 %** ist für 2027 minimal besser (28 Umbrüche, niedrigste gemessene Tabelle),
  für 2026 minimal schlechter. Nimmt sich mit 42 % praktisch nichts und ist der
  unrundere Wert.
- **45 % und darüber** sind verworfen: dort beginnt die Titelspalte umzubrechen
  (90 → 100 Zeilen), und die Kongressspalte gewinnt nichts mehr dazu. Das ist
  dasselbe Feld, das Marcus schon 2026-08 verworfen hatte.
- **Ein fester Wert statt der Prozentangabe** kommt weiterhin nicht in Frage: er
  träfe quer und hoch verschiedene Anteile. `calc(42% + 1px)` ebenso wenig —
  Chrome behandelt das in der Spaltenberechnung wie `auto`.

**Kommentarpflege.** Der lange Kommentar über der Regel argumentierte mit dem
Bestand von August (181 Einträge, „20 statt 87"), mit den 38,1 % und mit der
Stufenmessung bei 395 px. Das ist alles überholt und durch die neue Messreihe
ersetzt; die zwei weiter gültigen Sätze — kein fester Wert, kein `calc`, Einzug
36 px — stehen unverändert dort.

**Nachweis.** 33 Prüfskripte zeichenweise gleich zum Stand vorher. Golden Test
über alle zehn Signaturen der fünf Ansichten in beiden Jahrgängen unverändert.
Beispiel-PDFs für 40 % und 42 % (Jahrgang 2027, nach Erscheinungstermin und nach
Titel sortiert) lagen Marcus zur Auswahl vor.

**Commit** `32e31ac` · **MD5 vorher** `b5160959683759c0b6b2ae0a840e0d0c` ·
**MD5 nachher** `98b07b149291eaa473fcab4b5df00950` · **noch nicht gepusht**.

## 2026-09-08 — Aufgeklappte Heftwahl: Inhalt rückt vom blauen Streifen ab

**Anlass.** Marcus fiel auf, dass der Inhalt der Aufklapper in der Kongressmatrix
sehr weit links beginnt, und fragte, ob mehr Abstand zum Rand guttäte.

**Der Befund.** Nachgemessen in Chrome (1400 px, Jahrgang 2027, ein Feld offen):
Der Text im Aufklapper stand bei 32 Pixel, der Kongressname der Zeile darüber bei
33 — die beiden waren also praktisch bündig, und das war so gewollt. Das Problem
lag woanders: Der linke Rand der Zelle trägt einen drei Pixel starken Navy-Streifen
als Innenschatten, und zwischen ihm und der Überschrift blieben nur vier Pixel.
Vier Pixel sind zu wenig, um neben einer kräftigen Linie zu bestehen — die
Heftchips im selben Kasten halten innen acht. Nicht der Einzug war falsch, sondern
die Luft neben der Kante.

**Was sich geändert hat.** Eine Regel, `.mx-tab td.mx-inline-zelle`:
Polster `8px 12px 8px 15px` statt `5px 4px 5px 7px`. Der Text steht jetzt bei
40 Pixel — zwölf Pixel frei neben dem Streifen und sieben Pixel weiter innen als
der Kongressname darüber. Rechts sowie oben und unten dieselbe Luft, sonst wäre
der Kasten einseitig gepolstert. Sonst nichts: Streifen, Flächenton, Schriftgrade
und der Aufbau des Panels bleiben unangetastet.

**Die Überlegung dahinter.** Die Zugehörigkeit des Aufklappers zur Zeile darüber
trägt der Streifen, nicht die gemeinsame linke Kante. Ein aufgeklappter Bereich,
der ein Stück weiter innen sitzt als die Zeile, die ihn geöffnet hat, liest sich
als darunterliegend — nicht als verrutscht.

**Kommentarpflege.** Der ausführliche Kommentar über der Regel begründete bisher
„7 statt 4, damit zwischen Streifen und Text dieselben vier Pixel bleiben wie
zuvor". Das gilt nicht mehr und ist nachgezogen. Der Grund für den Zuschlag der
drei Streifenpixel steht weiter dort — er ist unverändert richtig.

**Nachweis.** Zwölf Prüfskripte (`mx`, `hl`, `abstand`, `kante`, `stick`,
`spalten`, `druck`, `mxdlg`, `erw`, `art`, `raum`, `kopf`) zeichenweise gleich zum
Stand vorher. Golden Test über alle zehn Signaturen der fünf Ansichten in beiden
Jahrgängen unverändert. Bildbeleg vorher/nachher aus Chrome headless.

**Commit** `781e530` · **MD5 vorher** `fbeeb2826802309ece46f28c1ce0d23c` ·
**MD5 nachher** `b5160959683759c0b6b2ae0a840e0d0c` · **gepusht** am 08.09.2026,
Prüfsumme der ausgelieferten Seite abgeglichen.
