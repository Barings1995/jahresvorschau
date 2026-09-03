-- ---------------------------------------------------------------------------
--  Jahresvorschau — Datenbankschema
--
--  Einspielen im Supabase-SQL-Editor („SQL Editor" → „New query"), einmalig,
--  danach nur noch bei Erweiterungen.
--
--  Grundzuege:
--    • Der Jahrgang ist der Anker. Titel haengen am Jahrgang, nicht umgekehrt:
--      Auflagen unterscheiden sich von Jahr zu Jahr (FORUM DKG 8.700 in 2026,
--      8.800 in 2027). Ein titelweit gefuehrter Wert waere dort falsch.
--    • Eine Zeile je Ausgabe. Die beiden Kongresslisten stehen als text[] in
--      dieser Zeile — sie gehoeren zur Ausgabe, werden nie einzeln abgefragt
--      und behalten so ihre Reihenfolge und ihren Wortlaut aus der
--      Heftplanung.
--    • „as" ist in SQL belegt. Der Anzeigenschluss heisst deshalb
--      „anzeigenschluss"; das Werkzeug bildet ihn innen weiter auf iss.as ab.
--    • Termine sind date, nicht text. Die Datenbank weist damit einen
--      unmoeglichen Termin selbst zurueck.
--    • Zugang hat ausschliesslich, wer angemeldet ist. Ohne Anmeldung ist
--      keine Zeile lesbar.
-- ---------------------------------------------------------------------------

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------- Jahrgang --

create table if not exists jahrgang (
  jahr         text        primary key,
  stand        text        not null default '',
  geaendert_am timestamptz not null default now()
);

-- ------------------------------------------------------------------ Titel --
-- id ist die Nummer aus der Heftplanung (1–6). Sie bestimmt zugleich die
-- Reihenfolge und die Farbzuordnung, deshalb steht sie hier und wird nicht
-- von der Datenbank vergeben.

create table if not exists titel (
  id           integer     not null,
  jahr         text        not null references jahrgang (jahr) on delete cascade,
  kurz         text        not null,
  voll         text        not null,
  auflage      integer     not null default 0,
  hex          text        not null default '#00285a',
  geaendert_am timestamptz not null default now(),
  primary key (jahr, id)
);

-- ---------------------------------------------------------------- Ausgabe --
-- „heft" ist Text, nicht Zahl: es gibt Doppelhefte („1–2", „7–8").
-- „reihenfolge" haelt die Abfolge innerhalb des Titels fest, unabhaengig
-- davon, wie die Heftnummer geschrieben ist.

create table if not exists ausgabe (
  id              uuid        primary key default gen_random_uuid(),
  jahr            text        not null,
  titel_id        integer     not null,
  reihenfolge     integer     not null,
  heft            text        not null,
  erscheinung     date,
  anzeigenschluss date,
  druckunterlagen date,
  anlieferung     date,
  thema           text        not null default '',
  sonderthema     text        not null default '',
  auslagen        text[]      not null default '{}',
  berichte        text[]      not null default '{}',
  geaendert_am    timestamptz not null default now(),
  foreign key (jahr, titel_id) references titel (jahr, id) on delete cascade
);

create index if not exists ausgabe_titel_idx on ausgabe (jahr, titel_id, reihenfolge);

-- --------------------------------------------------------------- Kongress --
-- Ein Kongress steht einmal je Jahrgang, nicht einmal je Ausgabe. Zuvor stand
-- er als Zeichenkette in "auslagen"/"berichte" jeder Ausgabe erneut - im
-- Jahrgang 2027 bis zu neunmal wortgleich. Verschob sich ein Termin, waren es
-- neun Aenderungen; der AEK-Kongress war dadurch bereits in zwei Schreibweisen
-- auseinandergelaufen.
--
-- "von"/"bis" sind date wie die uebrigen Termine - die Datenbank weist damit
-- einen unmoeglichen Termin selbst zurueck. Genau das haette den Eintrag
-- "19th International Congress on MDS, 14.04.-16.04.2026" im Jahrgang 2027
-- aufgehalten.
--
-- "unscharf" fuehrt die Faelle, fuer die es keinen Tag gibt ("September 2027",
-- "September"). Steht dort etwas, bleiben von/bis leer und die Angabe erscheint
-- unveraendert. Auf den Monatsersten zu raten waere schlechter als nichts: die
-- Heftwahl rechnet dann mit einem Tag, den niemand gesagt hat.
--
-- "kurz" ist die Form der Datenpflege ("DCK") und wird allein fuer deren
-- Ausgabe gebraucht; in der Jahresvorschau steht ueberall der volle Wortlaut.

create table if not exists kongress (
  id           uuid        primary key default gen_random_uuid(),
  jahr         text        not null references jahrgang (jahr) on delete cascade,
  lang         text        not null,
  kurz         text        not null default '',
  von          date,
  bis          date,
  unscharf     text        not null default '',
  ort          text        not null default '',
  geaendert_am timestamptz not null default now(),
  -- Beim Jahreswechsel uebernommene Titelverteilung, solange keine Ausgabe
  -- dafuer steht: [{"titel_id":3,"art":"auslage"}, ...]. Reine Anzeigehilfe -
  -- die Matrix markiert ein Feld als offene Arbeit, wenn es hier steht und
  -- noch keine Zeile in kongress_ausgabe dafuer existiert. Nichts anderes
  -- liest dieses Feld; ausser beim Uebernehmen schreibt nichts hinein.
  erwartet     jsonb       not null default '[]',
  check (bis is null or von is null or bis >= von),
  check (unscharf = '' or von is null)
);

create index if not exists kongress_jahr_idx on kongress (jahr, von);

-- Die Zuordnung. "art" entscheidet, ob die Ausgabe beim Kongress ausliegt oder
-- ueber ihn berichtet. Eine Ausgabe kann beides zu demselben Kongress fuehren -
-- die Aerzte Zeitung tut das beim DGP 2027 (Auslage in Heft 1, Bericht in
-- Heft 3) -, deshalb steht "art" mit im Schluessel.

create table if not exists kongress_ausgabe (
  kongress_id uuid not null references kongress (id) on delete cascade,
  ausgabe_id  uuid not null references ausgabe  (id) on delete cascade,
  art         text not null check (art in ('auslage','bericht')),
  primary key (kongress_id, ausgabe_id, art)
);

create index if not exists kongress_ausgabe_idx on kongress_ausgabe (ausgabe_id);

-- Die Spalten ausgabe.auslagen und ausgabe.berichte bleiben vorerst stehen.
-- Das Werkzeug liest die Kongresse eines Jahrgangs aus den Tabellen oben,
-- sobald dort Zeilen stehen, und faellt sonst auf die beiden Spalten zurueck.
-- So laesst sich Jahrgang fuer Jahrgang umstellen. Sind alle uebernommen und
-- nachgesehen, koennen die Spalten entfallen:
--   alter table ausgabe drop column auslagen, drop column berichte;

-- ------------------------------------------------------------- Sicherung --
-- Ein Schnappschuss des ganzen Jahrgangs in der Form, die das Werkzeug innen
-- ohnehin verwendet. Bewusst als ein Block und nicht aufgeloest: eine
-- Sicherung soll genau den Stand zurueckbringen, der beim Anlegen galt — auch
-- dann, wenn das Schema sich seither geaendert hat.

create table if not exists sicherung (
  id           uuid        primary key default gen_random_uuid(),
  jahr         text        not null,
  bezeichnung  text        not null default '',
  erstellt_am  timestamptz not null default now(),
  inhalt       jsonb       not null
);

create index if not exists sicherung_jahr_idx on sicherung (jahr, erstellt_am desc);

-- ----------------------------------------------------------- Zeilenschutz --
-- Angemeldet zu sein genuegt nicht. Der oeffentliche Schluessel steht nach dem
-- Veroeffentlichen im Netz, und die Neuanmeldung laesst sich nicht in jedem
-- Fall sperren – ohne diese Liste koennte sich jeder ein Konto anlegen und
-- haette damit vollen Zugriff. Zugelassen ist nur, wer in "berechtigt" steht.

create table if not exists berechtigt (
  benutzer_id uuid        primary key,
  notiz       text        not null default '',
  erstellt_am timestamptz not null default now()
);

alter table berechtigt enable row level security;
-- Bewusst ohne Regel: ueber die Schnittstelle ist die Liste weder lesbar noch
-- aenderbar. Gepflegt wird sie hier im SQL-Editor:
--   insert into berechtigt (benutzer_id, notiz)
--   values ('<Kennung aus auth.users>', 'Name');

-- "security definer" ist notwendig: die Funktion wird in den Regeln der
-- uebrigen Tabellen aufgerufen, wo die Liste selbst nicht lesbar ist.
create or replace function ist_berechtigt() returns boolean
language sql stable security definer
set search_path = ''
as $$
  select exists (select 1 from public.berechtigt where benutzer_id = auth.uid())
$$;

do $$
declare t text;
begin
  foreach t in array array['jahrgang','titel','ausgabe','kongress','kongress_ausgabe','sicherung'] loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists %I_nur_angemeldet on %I', t, t);
    execute format('drop policy if exists %I_nur_freigegeben on %I', t, t);
    execute format(
      'create policy %I_nur_freigegeben on %I for all to authenticated
         using (public.ist_berechtigt())
         with check (public.ist_berechtigt())', t, t);
  end loop;
end;
$$;

-- ------------------------------------------------------- Zeitstempel ------
-- geaendert_am setzt die Datenbank selbst. Ginge der Zeitstempel vom Geraet
-- aus, wuerde eine falsch gestellte Uhr die Reihenfolge verfaelschen.

create or replace function setze_geaendert_am() returns trigger
language plpgsql
set search_path = ''            -- ohne diese Angabe mahnt Supabase die Funktion an
as $$
begin
  new.geaendert_am := now();
  return new;
end;
$$;

do $$
declare t text;
begin
  foreach t in array array['jahrgang','titel','ausgabe','kongress'] loop
    execute format('drop trigger if exists %I_geaendert on %I', t, t);
    execute format(
      'create trigger %I_geaendert before update on %I
         for each row execute function setze_geaendert_am()', t, t);
  end loop;
end;
$$;
