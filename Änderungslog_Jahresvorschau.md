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

## 2026-09-09 (Nachtrag) — Der Knopf heißt „Als Excel sichern"

Marcus wies darauf hin, dass die beiden Knöpfe in der Datenpflege „Aus Excel
laden …" und „Als Excel sichern" heißen. Schritt 1 des Hinweisblattes nannte
den zweiten „Abzug sichern" — das ist das Wort für die Datei, nicht für den
Knopf, und wer danach sucht, findet ihn nicht. Im Hinweisblatt und im
`README.md` steht jetzt der Wortlaut des Knopfes.

Nachgemessen: das Blatt „Termine" weiterhin zeichengleich, 22 Prüfskripte
zeichengleich, Hinweisblatt neu ausgelesen und Zeile für Zeile gelesen.

**Commit** `bd59aba` · MD5 `c6541fad…` → `9636d063…`

---

## 2026-09-09 (später) — Die Kongress-Datei erklärt sich selbst

**Anlass.** Der Weg in die Datenpflege stand nach dem vorigen Eintrag nur im
`README.md`. Marcus wollte ihn dort haben, wo er gebraucht wird: in der
erzeugten Datei, als eigenes Blatt vor »Termine«.

**Die Änderung.** `Export → Kongresse für die Datenpflege` gibt die Datei jetzt
mit zwei Blättern aus. Vorn steht `Hinweise`, eine einzelne Textspalte von 104
Zeichen Breite und 35 Zeilen: dass die Datei eine Abschreibvorlage ist und
keine Ladedatei; warum der Excel-Eingang der Datenpflege sie abweist und was
geschähe, würde er es nicht; die Übernahme in vier Schritten; warum ein Verweis
und nicht Einfügen von Hand; und die Warnung, die Werte nur über den Zeilen des
eigenen Jahrgangs einzusetzen. Dahinter unverändert `Termine`.

Die Zeilennummern im Hinweisblatt sind keine Platzhalter: `datenpflegeBlatt`
rechnet die letzte belegte Zeile aus (Kopf in Zeile 5, Daten ab 6) und setzt sie
in beide Formeln ein. Für den Jahrgang 2026 mit 54 Ausgaben steht dort also
`Kongresse!I$6:I$59`, nicht ein geratener Bereich.

Neu sind `dpHinweisZeilen(letzte)` und `hinweisBlattXml(zeilen)`;
`baueDatenpflegeXlsx` nimmt zwei Blätter statt einem. Der Abschlussdialog nennt
das neue Blatt und sagt in einem Satz, dass die Datei sich in der Datenpflege
nicht direkt einlesen lässt. `README.md` verweist an beiden Stellen darauf.

**Nachweis.**

| Prüfung | Ergebnis |
|---|---|
| Blatt »Termine« der erzeugten Datei, vorher gegen nachher | **zeichengleich**; auch `styles.xml` unverändert |
| Aufbau der Mappe | zwei Blätter in der Folge `Hinweise`, `Termine`; alle sieben Teile wohlgeformt; jede `r:id` löst auf, jede Beziehung zeigt auf eine vorhandene Datei, jeder Teil hat einen Content-Type, keine Stilnummer außerhalb der sieben `cellXfs` |
| Zeilenrechnung | 54 Ausgaben → letzte Zeile 59; das Blatt nennt »Zeilen 6 bis 59« und dieselben Grenzen in beiden Formeln |
| Prüfreihe (22 Skripte gegen `9081373`) | 22-mal zeichengleich |
| Goldener Test, zehn Signaturen | zeichengleich |
| Abschlussdialog | „… Das vorangestellte Blatt „Hinweise" beschreibt Schritt für Schritt, wie die Angaben in die Datenpflege gelangen. Direkt einlesen lässt sich die Datei dort nicht — der Excel-Eingang erwartet den vollständigen Abzug." |

In Excel geöffnet wurde die Datei nicht: dafür gibt es auf dieser Maschine
keinen Weg ohne Fenster. Geprüft ist der Aufbau der Mappe, nicht die Anzeige.

**Nicht Teil dieser Änderung.** Weiterhin kein eigener Eingang in der
Datenpflege für diese Datei.

**Commit** `49ec28b` · MD5 `f801a08e…` → `c6541fad…`

---

## 2026-09-09 — Der Weg der Kongress-Datei in die Datenpflege, festgehalten

**Anlass.** Marcus versuchte, die Datei aus *Export → Kongresse für die
Datenpflege* in der Datenpflege über *Aus Excel laden* einzulesen. Die
Datenpflege wies sie ab: „In der Datei fehlt das Tabellenblatt »Preise«."

**Der Befund.** Kein Defekt, sondern eine Sperre an der richtigen Stelle. Der
Excel-Eingang der Datenpflege (`Datenpflege.html`, `excelLesen`) erwartet den
vollständigen Abzug — Blatt »Preise« zwingend, »Termine« dazu — und ersetzt
jeden darin enthaltenen Jahrgang im Ganzen. Die Kongress-Datei führt ein
einziges Blatt und keine einzige Preiszeile; angenommen, hätte sie dem Jahrgang
sämtliche Preise genommen. Die Datei ist als Abschreibvorlage gebaut, nicht als
Ladedatei, und die Menü- und Dialogtexte sagen das auch — nur die Fehlermeldung
der Datenpflege nennt eben nur das fehlende Blatt.

**Nachgemessen** (lesend, gegen die Datenbank und gegen `Angebotsdaten.xlsx`):

| Frage | Ergebnis |
|---|---|
| Stimmen die Titelnamen überein? | ja, alle sechs wortgleich (`titel.kurz` ↔ Spalte B), auch „FORUM DKG" und die Hefte „1–2"/„7–8" mit Halbgeviertstrich |
| Trifft der Schlüssel Jahrgang·Titel·Heft? | 108 von 108 Ausgaben, keine ohne Treffer |
| Stimmt die Zeilenfolge? | nein — die Jahresvorschau ordnet nach Titelkennung (ÄZ zuerst), der Abzug beginnt mit »Die Onkologie« und führt dreizehn weitere Titel dazwischen. Spalte J blind einzusetzen geht schief. |
| Stehen die Onkologie-Titel im Abzug beieinander? | ja, als Block: 2026 in den Zeilen 2–55, 2027 in 142–195, je 54 Zeilen |

**Die Änderung.** Nur Dokumentation, kein Eingriff ins Werkzeug. `README.md`
bekommt unter *Ausgabe für die Datenpflege* den Abschnitt *Der Weg in die
Datenpflege*: warum der direkte Eingang abweist, und die Übernahme in vier
Schritten — Abzug sichern, das Blatt der Kongress-Datei in die Abzugsmappe
kopieren, Themenschwerpunkte und Kongresse über einen Schlüssel aus Jahrgang,
Titel und Heft holen (`INDEX`/`VERGLEICH`, Verkettung mit `&`, weil der
Jahrgang hier als Zahl und dort als Text steht), die Werte allein über dem
Block des betroffenen Jahrgangs einsetzen und den ergänzten Abzug einlesen.

Der Hinweis, die Werte nur über diesem Block einzusetzen, ist kein Beiwerk:
außerhalb liefert der Verweis leere Zeichenketten und löschte damit die
Einträge der dreizehn übrigen Titel.

**Nicht Teil dieser Änderung.** Ein eigener, schmaler Eingang in der
Datenpflege, der genau diese einblättrige Datei liest und ausschließlich
Themenschwerpunkte und Kongresse an vorhandenen Terminen fortschreibt — ohne
Ersetzen, ohne Preise. Vorgeschlagen und zurückgestellt; die Handarbeit oben
bleibt vorerst der Weg.

**Commit** `9081373` · `index.html` unverändert (MD5 `f801a08e…`) · geändert nur
`README.md` und dieses Log

---

## 2026-09-09 — Aus Schwerpunkt und Top-Thema werden Themenschwerpunkte

**Anlass.** Marcus fiel auf, dass das Werkzeug zwei Wörter für dieselbe Sache
führte: In der Datenleiste hieß der Inhaltsfilter *Themenschwerpunkte*, in den
Ansichten stand darüber *Schwerpunkt*. Aus der Frage, welches Wort und welche
Zahl richtig sei, wurde die eigentliche: ob die Trennung in *Schwerpunkt* und
*Top-Thema* überhaupt noch etwas trägt.

**Der Befund aus der Datenbank.** Lesende Abfrage über alle 108 Ausgaben beider
Jahrgänge: Ein Top-Thema führen ausschließlich die zwanzig Ausgaben der Ärzte
Zeitung ONKOLOGIE UND HÄMATOLOGIE 2026 und 2027. In **allen zwanzig** ist auch
der Schwerpunkt belegt — das Top-Thema tritt nie allein auf. Inhaltlich sind
beide gleichrangig; 2027/3 etwa führt *Pankreaskarzinom – Auf dem Weg zu
kurativen Konzepten?* neben *Lymphome – neue Substanzen, neue Hoffnung*. Marcus
hat die Gleichrangigkeit bestätigt.

**Was die Trennung kostete.** Drei Dinge, die einzeln kaum auffielen:

- *Die Ansichten waren sich uneins, welches Feld führt.* Kachel und Monatsliste
  stellten das Top-Thema voran, Tabelle und Excel den Schwerpunkt. Beide
  Reihenfolgen standen gleichzeitig im Werkzeug.
- *Die Kachel setzte eine Rangordnung, die es nicht gibt.* `.ttxt` war normal
  gesetzt in `--text`, `.stxt` kursiv und `--muted` — der Schwerpunkt las sich
  wie eine Fußnote zum Top-Thema.
- *In der Datenbank sind die Namen vertauscht.* Das Top-Thema lag in der Spalte
  `thema`, der Schwerpunkt in `sonderthema`.

**Die Änderung.** An die Stelle von `iss.sw` und `iss.top` tritt `iss.t`, eine
Liste mit einem oder zwei gleichrangigen Einträgen.

- **Zwei Plätze, keine offene Liste.** Mehr als zwei kommt nicht vor, und die
  Datenbank hat mit `thema`/`sonderthema` genau zwei Spalten. Die Änderung
  kommt deshalb **ohne DDL und ohne Migration** aus — es ändert sich die
  Darstellung, nicht der Bestand.
- **Reihenfolge.** Der bisherige Schwerpunkt steht vorn: er ist der Eintrag,
  den jeder Titel führt. `t[0] = sonderthema`, `t[1] = thema`. Damit gilt
  überall die Ordnung, die Tabelle und Excel schon hatten; Kachel und
  Monatsliste drehen sich um.
- **Die Beschriftung geht mit der Zahl.** Auf der Kachel steht
  *Themenschwerpunkt* bei einem Eintrag, *Themenschwerpunkte* bei zweien. Die
  Spaltenköpfe in Tabelle und Excel stehen immer im Plural — sie überschreiben
  viele Zeilen.
- **Der Bearbeiten-Dialog** führt statt zweier benannter Felder eine Gruppe mit
  zwei Plätzen, gebaut aus demselben Muster wie Kongressauslagen und
  -berichte. Der Knopf *Zeile hinzufügen* steht nur, solange weniger als zwei
  Einträge da sind. Der Hinweistext, der bisher nur das Sonderfeld
  entschuldigte, entfällt.
- **Zwei Wege der Rückwärtsverträglichkeit.** Die Excel-Spalte heißt
  jetzt *Themenschwerpunkte* und führt einen Eintrag je Zeile; der alte
  Spaltenname *Schwerpunkt* und der alte Zeilenvorsatz `Top-Thema:` bleiben
  lesbar. Ebenso Sicherungspunkte: `themenAusSatz` liest einen vor September
  2026 angelegten Punkt weiter richtig — ohne das hätte ein Zurücksetzen alle
  Themen des Jahrgangs gelöscht.

**Nachweis.** Prüfbestand neu aus der Datenbank gezogen (`fixture_bauen.mjs`):
die Rohzeilen der fünf Tabellen laufen durch das `inDatenForm` der jeweiligen
Fassung, damit jede Seite genau das bekommt, was ihr eigener Ladeweg baut.
Ergebnis: 108 Ausgaben, davon 20 mit zwei Einträgen und 88 mit einem — genau
der Datenbankbefund.

Neues Prüfskript `thema_pruef.mjs`:

| geprüft | Ergebnis |
| --- | --- |
| Kachel mit zwei Themen | eine Beschriftung »Themenschwerpunkte«, zwei Einträge |
| Kachel mit einem Thema | »Themenschwerpunkt«, ein Eintrag |
| Schriftbild beider Einträge | 12,8 px · `rgb(0,40,90)` · nicht kursiv, identisch |
| Reihenfolge in Kachel, Liste, Tabelle, Kongressansicht | in allen vier gleich |
| »Top-Thema« in einer der fünf Ansichten | nirgends mehr |
| Tabellen-Spaltenkopf | »Themenschwerpunkte« |
| Suche nach einem Wort aus dem zweiten Eintrag | 1 Treffer; ohne Themenfilter 0 |
| Inhaltsfilter »Themenschwerpunkte« allein | 54 Ausgaben — alle mit Eintrag |

Neues Prüfskript `exthema_pruef.mjs` für den Excel-Rundlauf:

| geprüft | Ergebnis |
| --- | --- |
| Spaltenkopf in Blatt 1 und 2 | »Themenschwerpunkte«, alter Name weg |
| Vorsatz `Top-Thema:` in der Ausgabe | kommt nicht mehr vor |
| geschriebene Zelle wieder eingelesen | Zeichen für Zeichen dieselbe Liste |
| alte Form `Update NSCLC ⏎ Top-Thema: …` | ergibt beide Themen in der richtigen Folge |
| drei Zeilen in einer Zelle | zwei Einträge, nichts geht verloren |
| Kopfzeile mit altem Namen *Schwerpunkt* | wird ohne Beanstandung angenommen |

**Druckansicht** mit erzwungenen `@media print`-Regeln gemessen: Beschriftung
6,5 pt, beide Einträge 8 pt, gleiche Farbe, nicht kursiv.

**HTML-Kopie**: `baueKopie()` in einen Rahmen gehängt und darin nachgesehen —
54 Kacheln, richtige Beschriftung, richtige Einträge; der Datenblock führt nur
noch `t`, kein `sw` und kein `top`.

**Nichts schlägt nach außen durch.** Golden Test `pruef.mjs`: alle zehn
Statuszeilen der fünf Ansichten in beiden Jahrgängen unverändert, die
Jahresmatrix zeichenweise gleich. Prüfreihe über 21 Skripte: 18 gleich, drei
Abweichungen, alle erklärt — `thema_pruef` und `exthema_pruef` sind neu und
können auf der alten Fassung nicht zutreffen; `druck_pruef` zählt im
Ausgabenformular 8 statt 6 Löschzeichen, weil die beiden Themenzeilen jetzt
je eines tragen.

**Nicht Teil dieser Änderung.** Dass in den vier Kongressheften der Ärzte
Zeitung »Wirtschaft / Gesundheitspolitik« als Thema geführt wird, ist eine
Rubrik und kein Schwerpunkt — eine redaktionelle Frage, getrennt zu
entscheiden.

**Commit** `bac809c` · MD5 `60e205aaec238999ea53bf77b20ddf17` →
`f801a08e3edada7d66a3a1ab1ca5f53c` · gepusht

---

## 2026-09-09 — Die Hand steht jetzt auch über dem Häkchen

**Anlass.** Marcus fuhr im Dialog *Kongress bearbeiten* mit der Maus über das
Häkchen „Findet in Deutschland, Österreich oder der Schweiz statt": über dem
Schriftzug erschien die Hand, über dem Kästchen selbst nicht.

**Die Ursache.** Das `cursor:pointer` stand allein am `<label>` (`.bearb-haken`,
Zeile 694). Ein natives `input[type=checkbox]` bringt aber seinen eigenen
Zeiger mit und erbt den des Elternteils nicht — im Browser gemessen `default`
über dem Kästchen, `pointer` daneben. Klickbar war das Kästchen die ganze Zeit;
nur zu sehen war es nicht.

**Dieselbe Lücke ein zweites Mal.** `.dlg-haken` (Zeile 412) im Dialog
*Jahrgang anlegen* trug denselben Fehler — beide Häkchen der Oberfläche, beide
gemessen mit `default`. Der Schalter der Kongressansicht (`.switch`) ist nicht
betroffen: dort ist das Kästchen unsichtbar gestellt, die Hand kommt von der
gezeichneten Wippe.

**Die Änderung.** `cursor:pointer` an beiden Eingabefeldern ergänzt, dazu ein
Kommentar an `.bearb-haken`, der die Erblücke benennt — damit die Regel bei
einer späteren Aufräumaktion nicht als überflüssig gestrichen wird.

**Nachweis.** Neues Prüfskript `zeiger_pruef.mjs` liest über beiden Zeilen den
errechneten Zeiger und zusätzlich, welches Element unter der Mitte des
Kästchens liegt:

| | vorher | nachher |
| --- | --- | --- |
| Kongressdialog, Schriftzug | pointer | pointer |
| Kongressdialog, Kästchen (15 × 15 px) | **default** | pointer |
| Jahrgang anlegen, Schriftzug | pointer | pointer |
| Jahrgang anlegen, Kästchen (13 × 13 px) | **default** | pointer |

Die 18 übrigen Prüfskripte laufen zeichenweise gleich zum Stand vorher, der
Golden Test (`pruef.mjs`, zehn Signaturen aus fünf Ansichten und zwei
Jahrgängen) unverändert.

**Commit** `f945d29` · MD5 `4bf78c54979cc6631903cf2eebdcae77` →
`60e205aaec238999ea53bf77b20ddf17` · gepusht

---

## 2026-09-08 (abends) — Das Löschzeichen im Suchfeld ist jetzt gezeichnet

**Anlass.** Marcus bat um eine Prüfung, ob die Gestaltung des Suchfeldes zur
Designsprache des Werkzeugs passt — „vor allem die des X in Bezug auf
Schriftart, Farbe etc.".

**Der Befund.** Das Feld selbst passt; das × nicht. `.clear-btn` setzte kein
`font-family:inherit`, und ein `<button>` erbt die Schrift nicht von allein.
Gemessen im Browser: **Arial**, als einzige Stelle der Oberfläche — überall
sonst steht Source Sans 3. Das Zeichen ist in Arial **9,34 px** breit, in
Source Sans 3 **7,95 px**: 17 % breiter, mit kräftigerem Strich. Dasselbe
Muster wie die „Erblücken", die am 05.09.2026 in den Angebotswerkzeugen
geschlossen wurden. Die drei verwandten Kreuze der Jahresvorschau
(`.bearb-weg`, `.bearb-sich-weg`, `.mx-panel-zu`) tragen `font-family:inherit`
alle.

Vier weitere Abweichungen, gemessen:

| | Suchfeld-× vorher | die drei anderen × | Lupe im selben Feld |
|---|---|---|---|
| Schrift | **Arial** | `inherit` | – |
| Größe | **16 px** (1 rem) | 14,4 / 16,8 px | 16 px, Strich 2 |
| Farbe | `--muted` ✓ | `--muted` | `--muted` ✓ |
| Zeigerzustand | **`--text`** | `--warm` | – |
| Fläche | **17,3 × 20 px** | 30 × 29 / 26 × 26 | – |

Dazu: der Text lief unter das Zeichen. Das Feld hatte rechts 14 px
Innenabstand, der Knopf begann 27,4 px vor der Kante — **13,3 px
Überdeckung**, sichtbar ab etwa 45 Zeichen.

**Was sich geändert hat.** Marcus hat aus vier vorgelegten Fassungen die
gezeichnete gewählt:

- Das × ist ein `<svg>` im selben 24er-Raster wie die Lupe, Strich 2, runde
  Enden wie an den Symbolen von *Daten* und *Export*. Mit 14 px bleibt es
  kleiner als die Lupe (16 px): die Lupe sagt, was das Feld ist, das Kreuz nur,
  dass sich etwas zurücknehmen lässt.
- Zeigerzustand auf `--warm`, wie an den drei anderen Kreuzen — dieselbe Geste,
  dieselbe Antwort.
- Fläche 24 × 24 px, das kleinste Ziel, das sich verlässlich treffen lässt.
  Eingeblendet wird sie jetzt als `flex`, nicht als `block`; das Zeichen sitzt
  darin mittig.
- `.search-wrap input{padding-right:34px}` (8 + 24) — der Text endet jetzt
  2 px vor dem Knopf statt 13,3 px dahinter. Bewusst nur hier und nicht an
  `input[type=text]`: die Felder in den Rückfragen tragen kein Zeichen.
- `type="button"` nachgetragen, das die übrigen Knöpfe des Werkzeugs führen.

Ohne Rahmen und Füllung bleibt es — anders als die drei anderen Kreuze, die
frei neben einer Zeile stehen. Dieses sitzt im Feld und braucht dort keinen
zweiten Rahmen.

**Ein Fund beim Prüfen des eigenen Eingriffs.** Der erste Wurf sah richtig aus,
war es aber nicht: `.search-wrap svg` (die Regel für die Lupe) griff auch auf
das neue Zeichen und setzte ihm `position:absolute`, `left:11px` und vor allem
`color:var(--muted)` — womit der Zeigerzustand des Knopfes wirkungslos blieb.
Aufgefallen ist es am Bildbeleg, nicht am Code: das Kreuz blieb blau. Die Regel
heißt jetzt `.search-wrap>svg` — die Lupe ist unmittelbares Kind, das Kreuz
steckt im Knopf.

**Nachweis.** `x_pruef.mjs`: Fläche 24 × 24, Zeichnung 14 × 14 im Raster
`0 0 24 24`, Strich 2, runde Enden, Farbe `--muted` geerbt (nicht mehr eigens
gesetzt), Zeigerzustand `--warm`, Innenabstand rechts 34 px, Überdeckung −2 px.
`x_kopie.mjs`: in der weitergereichten HTML-Kopie stehen Lupe und Zeichnung
unverändert, das Feld ist leer und der Knopf verborgen. Bildbelege im
Kritzelordner: `x_vgl_crop.png` (die vier Fassungen), `x_neu_crop.png`,
`x_neu_lang_crop.png` (lange Eingabe), `x_hover_crop.png`.

**Nichts schlägt nach außen durch.** Golden Test `pruef.mjs`: alle zehn
Signaturen der fünf Ansichten in beiden Jahrgängen unverändert. 35 Prüfskripte
zeichenweise gleich zum Stand vorher (ohne `gleit_pruef`, das von Haus aus
unruhig ist, und ohne `x_pruef` selbst).

**Commit** 246db09 · **MD5 vorher** 550852fb73194e38a0e6bc10bff7c252 ·
**MD5 nachher** 4bf78c54979cc6631903cf2eebdcae77 · **gepusht**

---

## 2026-09-08 (später) — Jahrgangswechsel behält die gewählte Stelle

**Anlass.** Marcus: „Wenn man in der Datenpflege und in der Ausgabenansicht im
Bearbeiten-Menü der Jahresvorschau das Jahr wechselt, soll die zuletzt
ausgewählte Stelle erhalten bleiben und nicht wieder auf die oberste Auswahl
springen (sofern im geänderten Jahrgang enthalten)." Der Eintrag hier betrifft
die Jahresvorschau; die gleichlautende Änderung an `Datenpflege.html` steht im
`Änderungslog_Datenpflege.md` der Angebotswerkzeuge.

**Der Befund.** `waehleJahrgang()` setzte `bearbAuswahl` unbesehen auf `null`.
Wer Heft 4 der *Ärzte Zeitung* in 2027 offen hatte und nach 2026 wechselte, um
denselben Anzeigenschluss zu vergleichen, stand vor einer leeren rechten Seite
und musste sich durch die Liste zurückklicken.

**Was sich geändert hat.** Gemerkt wird die Stelle, bevor der Jahrgang
umgestellt wird (`bearbMerken()`), und nach dem Umstellen wieder geöffnet
(`bearbWiederholen()`):

- **Titelnummer** als Merkmal für den Titel. Sie ist laut `schema.sql` über alle
  Jahrgänge dieselbe (`primary key (jahr, id)`, `id` aus der Heftplanung).
- **Heftnummer** als Merkmal für die Ausgabe — **nicht** der Listenplatz. Ein
  Jahrgang kann mehr oder weniger Hefte führen; nach dem Platz gegriffen, stünde
  auf einmal Heft 3 da, wo Heft 4 gewählt war. Nachgemessen: bei einem Titel,
  dessen Liste in 2026 um zwei Hefte kürzer beginnt, wandert Heft 6 von Platz 5
  auf Platz 3 — und wird richtig getroffen.
- **Fehlt die Stelle drüben**, bleibt es beim bisherigen Verhalten: keine
  Auswahl.
- **Ein angefangener Entwurf wandert nicht mit.** Er gehört zum vorigen
  Jahrgang und verfällt wie bisher; geöffnet wird die Stelle mit dem Stand des
  neuen Jahrgangs. Eine noch nicht angelegte Ausgabe (»+ Ausgabe«) und ein noch
  nicht angelegter Titel sind gar keine Stelle — sie werden nicht gemerkt.

**Nebenbei aufgeteilt.** `bearbWaehle()` und `bearbWaehleTitel()` trugen die
Rückfrage nach einer offenen Änderung und das Öffnen in einem Stück. Das Öffnen
steht jetzt für sich (`bearbOeffneAusgabe()`, `bearbOeffneTitel()`); beim
Jahrgangswechsel ist der Entwurf bereits verfallen, dort wäre die Rückfrage ein
zweites Mal gestellt worden. `bearbBeginn()` bekam dafür ein drittes Argument
`still`: der Jahrgangswechsel zeichnet ohnehin gleich danach neu, ein zweiter
Durchlauf über 169 Einträge wäre umsonst.

**Nachweis.** Prüfskript `jw_pruef.mjs` (Chrome headless, Bestand aus der
Datenbank), sieben Fälle:

| Fall | vorher | nach dem Wechsel |
|---|---|---|
| Ausgabe in beiden Jahrgängen | 2027 Titel 1, Heft 4 (Platz 3) | 2026 Titel 1, Heft 4 (Platz 3), Formular zeigt den 2026er Stand |
| und wieder zurück | 2026 | 2027, dieselbe Stelle |
| Stammdaten eines Titels | 2027 FORUM DKG | 2026 FORUM DKG |
| Heftnummer an anderer Stelle | 2027 Titel 3, Heft 6 (Platz 5) | 2026 Titel 3, Heft 6 (**Platz 3**) |
| Heft gibt es drüben nicht | Heft 4 | keine Auswahl |
| Titel gibt es drüben nicht | FORUM DKG | keine Auswahl |
| noch nicht angelegte Ausgabe | »+ Ausgabe« | keine Auswahl |

In jedem Fall genau **eine** markierte Zeile in der Liste, und das Formular
rechts zeigt dieselbe Ausgabe.

**Nichts schlägt nach außen durch.** Golden Test `pruef.mjs`: alle zehn
Signaturen der fünf Ansichten in beiden Jahrgängen unverändert. Die 33 übrigen
Prüfskripte (`mx_pruef` bis `kt2_pruef`, ohne das von Haus aus unruhige
`gleit_pruef`) zeichenweise gleich zum Stand vorher.

**Commit** 2dc7bac · **MD5 vorher** 98b07b149291eaa473fcab4b5df00950 ·
**MD5 nachher** 550852fb73194e38a0e6bc10bff7c252 · **gepusht**

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
**MD5 nachher** `98b07b149291eaa473fcab4b5df00950` · **gepusht**.

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
