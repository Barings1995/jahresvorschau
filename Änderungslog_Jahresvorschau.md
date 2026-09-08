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
