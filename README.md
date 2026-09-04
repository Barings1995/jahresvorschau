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

## Kongresse

Ein Kongress steht einmal je Jahrgang, nicht einmal je Ausgabe. Zuvor stand er
als Zeichenkette in jeder Ausgabe erneut — im Jahrgang 2027 bis zu neunmal
wortgleich. Verschob sich ein Termin, waren es neun Änderungen; der
AEK-Kongress war dadurch bereits in zwei Schreibweisen auseinandergelaufen.

Tabelle `kongress` je Jahrgang (`lang`, `kurz`, `von`, `bis`, `unscharf`, `ort`)
und `kongress_ausgabe` für die Zuordnung mit `art` (Auslage oder Bericht). Die
Art steht mit im Schlüssel: eine Ausgabe kann beides zu demselben Kongress
führen — die Ärzte Zeitung tut das beim DGP 2027 nicht, wohl aber Heft 1 mit der
Auslage und Heft 3 mit dem Bericht.

`von` und `bis` sind `date` wie die übrigen Termine, die Datenbank weist damit
einen unmöglichen Termin selbst zurück. `unscharf` führt die Fälle ohne Tag
(»September 2027«, »September«); dort bleiben `von`/`bis` leer und die Angabe
erscheint unverändert. Auf den Monatsersten zu raten wäre schlechter als nichts.

Angezeigt wird der zusammengesetzte Wortlaut `Langname, Zeitraum, Ort` — genau
der, der zuvor als Zeichenkette dastand. Nachgemessen an beiden Jahrgängen: in
allen fünf Ansichten Zeichen für Zeichen dasselbe.

### Umstellen

Die Spalten `ausgabe.auslagen` und `ausgabe.berichte` bleiben vorerst stehen.
Das Werkzeug liest die Kongresse eines Jahrgangs aus den neuen Tabellen, sobald
dort Zeilen stehen, und fällt sonst auf die beiden Spalten zurück — so lässt
sich Jahrgang für Jahrgang umstellen. Fehlt das Schema ganz, ändert sich nichts.

*Daten → Kongresse umstellen* legt jeden Kongress des gezeigten Jahrgangs einmal
an. Der Punkt steht nur, solange der Jahrgang noch keine eigenen Kongresssätze
führt — danach verschwindet er wieder: normale Änderungen (Matrix,
Ausgabe bearbeiten) schreiben unmittelbar in die neuen Tabellen und brauchen
ihn nicht erneut. Vorher entsteht ein Sicherungspunkt ohne Zutun, und ein
Bericht zeigt, was auffällt — bereinigt wird nichts von selbst:

* **Gleicher Zeitraum, gleicher Ort, zwei Schreibweisen.** Sie bleiben zwei
  Kongresse; sie zusammenzuführen ist eine Entscheidung, keine Rechnung.
* **Zeitlich nicht schlüssig.** Geprüft wird gegen das Heft, an dem der Eintrag
  hängt, nicht gegen den Jahrgang: ein Bericht über einen Kongress des Vorjahres
  ist richtig und häufig, einer über einen Kongress von vor dreizehn Monaten
  nicht. Nachgemessen am Jahrgang 2027 liegen zwischen Kongressende und
  Anzeigenschluss des berichtenden Hefts 3 bis 70 Tage (Median 30), zwischen
  Erscheinen und Kongressbeginn beim Ausliegen 11 bis 99 (Median 33). Die
  Schwelle von 180 Tagen liegt weit über beidem.

Im Bestand traf der Bericht damit drei Stellen — alle drei echte Fehler und
keine falsche Meldung: die zwei AEK-Schreibweisen, der MDS-Eintrag mit dem
Termin aus 2026 im Jahrgang 2027, und über den Umweg des Abstands der
Anzeigenschluss »25.10.2927« bei Im Fokus Onkologie Heft 11.

Werden die gemeldeten Stellen vor dem Übernehmen von Hand berichtigt, wirkt das
sofort: solange ein Jahrgang noch nicht umgestellt ist, ist seine Kongressliste
nur eine Ableitung der beiden Textspalten, und ein Kongress, der beim Ändern
einer Ausgabe seine letzte Zuordnung verliert, fällt mit weg. Sonst stünde er
bis zum Neuladen weiter im Bericht und käme beim Umstellen sogar als Kongress
ohne Ausgabe in die Datenbank. Nach der Umstellung fällt hier nichts mehr weg —
dort ist ein Kongress ohne Ausgabe gewollt: ein aus dem Vorjahr übernommener
oder ein neu angelegter, dem noch kein Heft zugeordnet ist.

Sind alle Jahrgänge umgestellt und nachgesehen, können die beiden Spalten
entfallen:

```sql
alter table ausgabe drop column auslagen, drop column berichte;
```

### Auslagen und Berichte getrennt

Die Matrix zeigt immer nur **eine** der beiden Arten; ein Umschalter über der
Tabelle wechselt zwischen *Auslagen* und *Berichte*. Es sind zwei verschiedene
Planungen: die Auslage liegt beim Kongress aus und muss vorher erscheinen, der
Bericht kommt danach. Im Jahrgang 2027 tragen von 148 belegten Feldern nur 21
beide Arten, und von 41 Kongressen betreffen 30 überhaupt nur eine der beiden —
gemeinsam gezeigt stand also größtenteils beieinander, was nie zusammen geplant
wird.

Die beiden Umschalter sind absichtlich geschachtelt statt zu einer Reihe aus
drei Knöpfen verschmolzen: *Nach Ausgabe / Nach Kongress* ist der Blickwinkel,
*Auslagen / Berichte* die Art der Zuordnung — zwei Achsen, nicht drei
gleichrangige Zustände. Die Wahl der Art bleibt für die Sitzung erhalten, auch
über einen Abstecher zur Ausgabenseite und über einen Jahrgangswechsel hinweg.

Beide Ansichten führen **dieselben Zeilen** in derselben Reihenfolge. Ein
Kongress ohne Auslage steht in der Auslagenansicht als leere, aber anklickbare
Zeile — die Matrix ist eine Planungsfläche, und gerade die leere Zeile sagt,
dass hier noch zu entscheiden ist. Wären solche Zeilen ausgeblendet, gäbe es
keinen Weg mehr, ihnen eine erste Zuordnung zu geben. Die Zählung im Kopf und
die hohlen Formen der Vorjahresübernahme folgen ebenfalls der gewählten Art;
eine Zahl, die zur Hälfte unsichtbare Felder mitführte, orientiert nicht.

Auch die Heftwahl zeigt nur den Knopf der gewählten Art. Blieben dort beide
stehen, wäre ausgerechnet an der Stelle, an der geklickt wird, die
Verwechslung wieder möglich, die die Trennung vermeiden soll.

Die Trennlinie zwischen den Heften folgt der Art, weil die Schwelle eine andere
ist: bei der Auslage muss der **Erscheinungstermin vor Kongressbeginn** liegen,
beim Bericht der **Anzeigenschluss nach Kongressende** — vorher lässt sich über
den Kongress noch gar nicht berichten. Die Linie heißt entsprechend
*Kongressbeginn* oder *Kongressende*.

Aus demselben Grund steht je Heft nur **ein** Termin: in der Auslagenansicht der
Erscheinungstermin, in der Berichtsansicht der Anzeigenschluss — derselbe
Termin, nach dem die Trennlinie teilt. Der jeweils andere trägt zur
Entscheidung nichts bei; er stand vorher in jeder Zeile mit und ließ zweimal
zehn Datumsangaben lesen, wo eine gefragt war.

Die Trennung betrifft allein die Planungsfläche. Die fünf Ansichten, der Druck,
die Excel-Strecke und die Ausgabe für die Datenpflege zeigen Auslagen und
Berichte weiterhin gemeinsam je Ausgabe — dort ist gerade der vollständige
Blick gefragt.

Eine Fangfrage steckt im Entfernen: wie viel an einem Kongress noch hängt, wird
**über beide Arten hinweg** gezählt, nicht nur über die gezeigte. Sonst sähe
ein Kongress, der nur Berichte trägt, aus der Auslagenansicht heraus wie ein
leerer aus und ließe sich scheinbar folgenlos entfernen.

### Bearbeiten und Vorjahresübernahme

Zwei Klickziele, zwei Wege — je nachdem, wie oft und wie kurz der Vorgang ist:

Ein Klick auf die Kongresszeile selbst — nicht auf ein Titelfeld — öffnet ein
Dialogfenster für Name, Kurzname, Zeitraum (genau oder als Wortlaut wie
»September 2027«) und Ort, im selben Aufbau wie *Jahrgang anlegen*: gelesen
werden die Felder erst mit *Speichern*, nicht bei jedem Zeichen. Ein Dialog
passt hierher, weil an einer Kongresszeile meist nur einmal etwas zu ändern
ist; die Rückfragen dazu legen sich über das noch offene Dialogfenster.

*Entfernen* steht dort **immer** — auch wenn dem Kongress schon Hefte
zugeordnet sind. Der häufige Anlass ist ja gerade, dass ein Kongress im
Jahrgang nicht stattfindet oder doppelt geschrieben wurde; dann sollen die
Zuordnungen mit weg. Statt zu sperren nennt der letzte Absatz im Dialog, was es
kostet — »Zugeordnet sind noch 3 Berichte in 3 Titeln« —, und die Rückfrage
sagt es noch einmal. Beide Sätze sind Aussagen über den Kongress und stehen für
sich; sie führen den Knopf nicht ein, weil er nicht mehr neben ihnen sitzt.

Der Knopf sitzt in der Fußzeile ganz links, mit der Standzeile als
Abstandhalter zur Bestätigung rechts: die zerstörende Handlung gehört weg von
*Speichern*. Die Fußzeile ist statisch und wird von allen Dialogen derselben
Hülle geteilt, `dialogZeigen()` nimmt sie darum als dritte, freiwillige
Handlung entgegen und blendet sie bei jedem Aufruf wieder aus — sonst bliebe
sie vom vorigen Dialog stehen. Die Aufschlüsselung nach Art ist dabei kein Zierrat: seit die Matrix
nur eine Art zeigt, kann eine Zeile in der Auslagenansicht leer aussehen,
während der Kongress in der Berichteansicht fünf Hefte trägt. Gezählt wird
deshalb über beide Arten hinweg, nicht über die gezeigte.

Die Datenbank räumt die Zuordnungen selbst weg (`on delete cascade`) — die
Arbeitskopie im Browser nicht. Sie wird darum beim Entfernen mit durchgegangen;
bliebe eine Kennung stehen, setzte sie der Druck als rohe Zeichenkette ein.

*+ Neuer Kongress* über der Matrix öffnet dasselbe Dialogfenster leer: ein
Kongress, dessen Name bereits feststeht, dessen Termin und Titelverteilung
aber noch offen sind. Angelegt wird er stets ohne Heftzuordnung; bleibt dabei
auch der Zeitraum leer, steht er in der Matrix unter *Termin fehlt*, bis
Recherche und Heftwahl ihn füllen.

Ein Klick auf ein Titelfeld dagegen öffnet die Heftwahl nicht als Dialog,
sondern **direkt unter der angeklickten Zeile** — dort wird oft mehrfach
hintereinander in derselben Zeile zugeordnet, ein Dialogfenster, das dabei bei
jedem Klick auf- und zuginge, wäre im Weg. Bei einer langen Liste bleibt das
Formular so an der Stelle, wo gerade gearbeitet wird, statt unabhängig von der
Zeilenzahl an einer festen Stelle zu erscheinen.

Ohne das Dialogfenster gäbe es keinen Weg, einem übernommenen Kongress ohne
Termin nachträglich einen zu geben: die Ausgabenseite hätte bei jeder Änderung
des zusammengesetzten Wortlauts einen zweiten Kongress angelegt statt den
vorhandenen zu ändern.

*Jahrgang anlegen* (Menü *Daten*) übernimmt auf Wunsch zusätzlich die
Kongresse des gewählten Vorlage-Jahrgangs — Name, Kurzname, Ort; Zeitraum und
Heftzuordnung bleiben offen. Mitgegeben wird auch, welcher Titel den Kongress
zuletzt in welcher Art führte: Die Kongressmatrix zeigt das als hohles Dreieck
in der Auslagen- bzw. hohles Quadrat in der Berichteansicht, solange keine
Ausgabe gewählt ist — eine
Erwartung, keine Zuordnung. Erst ein gewähltes Heft ersetzt sie durch die
gefüllte Form. Die Kopfzeile der Matrix zählt die noch offenen Felder mit.

### Ausgabe für die Datenpflege

*Daten → Kongresse für die Datenpflege* gibt den Jahrgang als Excel-Datei aus,
im Aufbau des Blattes »Termine« von `Angebotsdaten.xlsx` — Jahrgang, Titel,
Heft, Monat, ET, AS, DU-Schluss, EH-Termin, Themenschwerpunkte und, in der
letzten Spalte, die Kongresszeile in deren Schreibweise: `Kurzname (Auslage),
Zeitraum, Ort`, mehrere Kongresse einer Ausgabe je eine eigene Zeile. Ein
Kongress ohne Termin trägt kein Datum, das sich einsetzen ließe, und bleibt
darin aus — der Bericht nennt, wie viele das betrifft.

Innerhalb einer bearbeiteten Ausgabe kopiert *Kongresszeile für die
Datenpflege kopieren* nur deren eigene Zeile in die Zwischenablage; das bezieht
sich auf den gespeicherten Stand, nicht auf eine noch offene Änderung.

Beides schreibt nicht in die Angebotswerkzeuge zurück — kein zweiter
Datenbankschlüssel, kein Schreibzugriff über Projektgrenzen. Das Ergebnis wird
abgelegt und von Hand übernommen.

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

Kongresse werden hier nur zugeordnet, nicht angelegt. Zugeordnetes steht als
feste Zeile mit einem `×` daneben; darunter führt ein Auswahlfeld *Kongress
hinzufügen …* die Kongresse des Jahrgangs — gegliedert in *Termin fehlt* und
*Nach Zeitraum*, wie die Kongressmatrix, und um die dieser Ausgabe bereits
zugeordneten gekürzt. Eine leere Zeile kann damit nicht stehenbleiben, und
derselbe Kongress lässt sich nicht zweimal eintragen. Ein neuer Eintrag wird
gleich nach Zeitraum einsortiert, sodass das Formular dieselbe Reihenfolge zeigt
wie der nächste Aufruf.

Vorher standen dort zwei Freitextfelder mit einer Vorschlagsliste. Sie waren ein
Angebot, keine Schranke: wich der eingetippte Wortlaut auch nur in einem Komma
ab, entstand beim Speichern ein zweiter Kongresssatz — genau das Auseinanderlaufen,
gegen das die Kongresssätze eingeführt wurden. Der Weg dorthin ist nicht mehr
gesperrt, sondern nicht mehr vorhanden: der Entwurf führt Kennungen statt
Wortlaute, und aus einer Kennung lässt sich nichts Neues anlegen. Angelegt,
geändert und entfernt wird ein Kongress allein in der Ansicht *Nach Kongress*;
dorthin führt aus dem Formular ein Knopf, wenn der Jahrgang noch keinen führt.

Ein Jahrgang gilt als auf eigene Kongresssätze umgestellt, sobald er Kongresse
in der Datenbank führt — oder, bei erreichbaren Kongresstabellen, sobald keine
seiner Ausgaben ihre Kongresse noch als Text trägt. Der zweite Fall ist der eben
angelegte, leere Jahrgang: ohne ihn verwiese die Kongressansicht dort auf eine
Umstellung, die es gar nicht zu machen gibt. Die Freitextfelder samt
Vorschlagsliste stehen nur noch für einen Jahrgang, der seine Kongresse
tatsächlich noch als Text führt.

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

### Nach Kongress

Im Arbeitsschirm steht oben ein Umschalter *Nach Ausgabe · Nach Kongress* — dieselbe
Arbeitskopie, zwei Seiten. *Nach Kongress* zeigt eine Zeile je Kongress und eine
Spalte je Titel; im Feld stehen Heft und Art der bereits zugeordneten Ausgaben.
Kongresse ohne Termin (noch zu recherchieren, oder mit unscharfer Angabe wie
»September«) stehen oben in einer eigenen Gruppe.

Ein Klick auf ein Feld öffnet die Heftwahl darunter: alle Hefte des Titels **in
Heftfolge**, je Heft mit dem Termin, auf den es in der gewählten Ansicht
ankommt — in der Auslagenansicht der Erscheinungstermin mit seinem Abstand zum
Kongressbeginn, in der Berichtsansicht der Anzeigenschluss mit seinem Abstand
zum Kongressende. Der Abstand nach Ende steht nur dabei, wenn er positiv ist,
sonst stünde eine irreführende negative Zahl da. Zwischen den Heften vor der
Schwelle und denen danach steht eine Trennlinie. Ein Knopf je Heft — der der
gewählten Art — ordnet zu oder nimmt zurück; ein bereits zugeordnetes Heft ist
als solches zu erkennen. Es gibt
keinen Vorschlag: Ein Rechenweg, an den 2027er Zuordnungen gemessen, träfe zu
84–90 % — der Rest sähe wie eine geprüfte Angabe aus, wäre aber geraten.

Anders als beim Bearbeiten einer Ausgabe gibt es hier keinen Speichern-Knopf:
jeder Klick schreibt sofort. Schlägt das Schreiben fehl, nimmt die Anzeige die
Zuordnung sichtbar zurück, statt einen Stand zu zeigen, der in der Datenbank
nicht steht.

Die Matrix setzt einen umgestellten Jahrgang voraus (siehe *Kongresse* oben);
ohne eigene Kongresssätze verweist sie auf *Daten → Kongresse umstellen*.

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

Die Kongressspalte steht deshalb auf 38,1 % statt auf 38 %. Das Pixel Luft nimmt
ihr 0,38 px, und daran hängt der Zeilenumbruch, auch wenn die gezeichnete
Spaltenkante gerundet gleich bleibt: im Jahrgang 2027 brachen dadurch drei
Kongresseinträge zusätzlich um, und die Tabelle wuchs von sechs auf sieben
Seiten. 38,1 % geben der Spalte gut 1 px zurück — das Zweieinhalbfache des
Verlorenen. Die Innenabstände bleiben überall bei 5 px, links wie rechts, damit
nichts unsymmetrisch wird; die übrigen Spalten geben zusammen das eine Pixel ab.
An der seinerzeit gemessenen Abwägung 38 gegen 45 % ändert das nichts — die ging
um 27 mm Spaltenbreite.

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
