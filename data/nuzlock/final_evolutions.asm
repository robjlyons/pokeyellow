; FinalEvolutionTable
; Indexed by (species_id - 1), i.e. same indexing as EvosMovesPointerTable.
; Value: species_id of the final-form species (0 for MissingNo / special sprites).
; Used by InitRandomiserTables when generating trainer-party species at level >= 30.
;
; Eevee's branching evo is resolved to VAPOREON (arbitrary canonical choice).
; Fossil/Ghost sprites ($B6-$B8) return 0; the trainer hook excludes those slots anyway.

FinalEvolutionTable:
	table_width 1
	db RHYDON        ; $01 Rhydon       -> Rhydon (final)
	db KANGASKHAN    ; $02 Kangaskhan   -> Kangaskhan (final)
	db NIDOKING      ; $03 Nidoran♂     -> Nidoking
	db CLEFABLE      ; $04 Clefairy     -> Clefable
	db FEAROW        ; $05 Spearow      -> Fearow
	db ELECTRODE     ; $06 Voltorb      -> Electrode
	db NIDOKING      ; $07 Nidoking     -> Nidoking (final)
	db SLOWBRO       ; $08 Slowbro      -> Slowbro (final)
	db VENUSAUR      ; $09 Ivysaur      -> Venusaur
	db EXEGGUTOR     ; $0A Exeggutor    -> Exeggutor (final)
	db LICKITUNG     ; $0B Lickitung    -> Lickitung (final)
	db EXEGGUTOR     ; $0C Exeggcute    -> Exeggutor
	db MUK           ; $0D Grimer       -> Muk
	db GENGAR        ; $0E Gengar       -> Gengar (final)
	db NIDOQUEEN     ; $0F Nidoran♀     -> Nidoqueen
	db NIDOQUEEN     ; $10 Nidoqueen    -> Nidoqueen (final)
	db MAROWAK       ; $11 Cubone       -> Marowak
	db RHYDON        ; $12 Rhyhorn      -> Rhydon
	db LAPRAS        ; $13 Lapras       -> Lapras (final)
	db ARCANINE      ; $14 Arcanine     -> Arcanine (final)
	db MEW           ; $15 Mew          -> Mew (final)
	db GYARADOS      ; $16 Gyarados     -> Gyarados (final)
	db CLOYSTER      ; $17 Shellder     -> Cloyster
	db TENTACRUEL    ; $18 Tentacool    -> Tentacruel
	db GENGAR        ; $19 Gastly       -> Gengar
	db SCYTHER       ; $1A Scyther      -> Scyther (final)
	db STARMIE       ; $1B Staryu       -> Starmie
	db BLASTOISE     ; $1C Blastoise    -> Blastoise (final)
	db PINSIR        ; $1D Pinsir       -> Pinsir (final)
	db TANGELA       ; $1E Tangela      -> Tangela (final)
	db 0             ; $1F MissingNo
	db 0             ; $20 MissingNo
	db ARCANINE      ; $21 Growlithe    -> Arcanine
	db ONIX          ; $22 Onix         -> Onix (final in Gen 1)
	db FEAROW        ; $23 Fearow       -> Fearow (final)
	db PIDGEOT       ; $24 Pidgey       -> Pidgeot
	db SLOWBRO       ; $25 Slowpoke     -> Slowbro
	db ALAKAZAM      ; $26 Kadabra      -> Alakazam
	db GOLEM         ; $27 Graveler     -> Golem
	db CHANSEY       ; $28 Chansey      -> Chansey (final in Gen 1)
	db MACHAMP       ; $29 Machoke      -> Machamp
	db MR_MIME       ; $2A Mr. Mime     -> Mr. Mime (final)
	db HITMONLEE     ; $2B Hitmonlee    -> Hitmonlee (final)
	db HITMONCHAN    ; $2C Hitmonchan   -> Hitmonchan (final)
	db ARBOK         ; $2D Arbok        -> Arbok (final)
	db PARASECT      ; $2E Parasect     -> Parasect (final)
	db GOLDUCK       ; $2F Psyduck      -> Golduck
	db HYPNO         ; $30 Drowzee      -> Hypno
	db GOLEM         ; $31 Golem        -> Golem (final)
	db 0             ; $32 MissingNo
	db MAGMAR        ; $33 Magmar       -> Magmar (final in Gen 1)
	db 0             ; $34 MissingNo
	db ELECTABUZZ    ; $35 Electabuzz   -> Electabuzz (final)
	db MAGNETON      ; $36 Magneton     -> Magneton (final in Gen 1)
	db WEEZING       ; $37 Koffing      -> Weezing
	db 0             ; $38 MissingNo
	db PRIMEAPE      ; $39 Mankey       -> Primeape
	db DEWGONG       ; $3A Seel         -> Dewgong
	db DUGTRIO       ; $3B Diglett      -> Dugtrio
	db TAUROS        ; $3C Tauros       -> Tauros (final)
	db 0             ; $3D MissingNo
	db 0             ; $3E MissingNo
	db 0             ; $3F MissingNo
	db FARFETCHD     ; $40 Farfetch'd   -> Farfetch'd (final)
	db VENOMOTH      ; $41 Venonat      -> Venomoth
	db DRAGONITE     ; $42 Dragonite    -> Dragonite (final)
	db 0             ; $43 MissingNo
	db 0             ; $44 MissingNo
	db 0             ; $45 MissingNo
	db DODRIO        ; $46 Doduo        -> Dodrio
	db POLIWRATH     ; $47 Poliwag      -> Poliwrath
	db JYNX          ; $48 Jynx         -> Jynx (final)
	db MOLTRES       ; $49 Moltres      -> Moltres (final)
	db ARTICUNO      ; $4A Articuno     -> Articuno (final)
	db ZAPDOS        ; $4B Zapdos       -> Zapdos (final)
	db DITTO         ; $4C Ditto        -> Ditto (final)
	db PERSIAN       ; $4D Meowth       -> Persian
	db KINGLER       ; $4E Krabby       -> Kingler
	db 0             ; $4F MissingNo
	db 0             ; $50 MissingNo
	db 0             ; $51 MissingNo
	db NINETALES     ; $52 Vulpix       -> Ninetales
	db NINETALES     ; $53 Ninetales    -> Ninetales (final)
	db RAICHU        ; $54 Pikachu      -> Raichu
	db RAICHU        ; $55 Raichu       -> Raichu (final)
	db 0             ; $56 MissingNo
	db 0             ; $57 MissingNo
	db DRAGONITE     ; $58 Dratini      -> Dragonite
	db DRAGONITE     ; $59 Dragonair    -> Dragonite
	db KABUTOPS      ; $5A Kabuto       -> Kabutops
	db KABUTOPS      ; $5B Kabutops     -> Kabutops (final)
	db SEADRA        ; $5C Horsea       -> Seadra
	db SEADRA        ; $5D Seadra       -> Seadra (final in Gen 1)
	db 0             ; $5E MissingNo
	db 0             ; $5F MissingNo
	db SANDSLASH     ; $60 Sandshrew    -> Sandslash
	db SANDSLASH     ; $61 Sandslash    -> Sandslash (final)
	db OMASTAR       ; $62 Omanyte      -> Omastar
	db OMASTAR       ; $63 Omastar      -> Omastar (final)
	db WIGGLYTUFF    ; $64 Jigglypuff   -> Wigglytuff
	db WIGGLYTUFF    ; $65 Wigglytuff   -> Wigglytuff (final)
	db VAPOREON      ; $66 Eevee        -> Vaporeon (canonical branch)
	db FLAREON       ; $67 Flareon      -> Flareon (final)
	db JOLTEON       ; $68 Jolteon      -> Jolteon (final)
	db VAPOREON      ; $69 Vaporeon     -> Vaporeon (final)
	db MACHAMP       ; $6A Machop       -> Machamp
	db GOLBAT        ; $6B Zubat        -> Golbat
	db ARBOK         ; $6C Ekans        -> Arbok
	db PARASECT      ; $6D Paras        -> Parasect
	db POLIWRATH     ; $6E Poliwhirl    -> Poliwrath
	db POLIWRATH     ; $6F Poliwrath    -> Poliwrath (final)
	db BEEDRILL      ; $70 Weedle       -> Beedrill
	db BEEDRILL      ; $71 Kakuna       -> Beedrill
	db BEEDRILL      ; $72 Beedrill     -> Beedrill (final)
	db 0             ; $73 MissingNo
	db DODRIO        ; $74 Dodrio       -> Dodrio (final)
	db PRIMEAPE      ; $75 Primeape     -> Primeape (final)
	db DUGTRIO       ; $76 Dugtrio      -> Dugtrio (final)
	db VENOMOTH      ; $77 Venomoth     -> Venomoth (final)
	db DEWGONG       ; $78 Dewgong      -> Dewgong (final)
	db 0             ; $79 MissingNo
	db 0             ; $7A MissingNo
	db BUTTERFREE    ; $7B Caterpie     -> Butterfree
	db BUTTERFREE    ; $7C Metapod      -> Butterfree
	db BUTTERFREE    ; $7D Butterfree   -> Butterfree (final)
	db MACHAMP       ; $7E Machamp      -> Machamp (final)
	db 0             ; $7F MissingNo
	db GOLDUCK       ; $80 Golduck      -> Golduck (final)
	db HYPNO         ; $81 Hypno        -> Hypno (final)
	db GOLBAT        ; $82 Golbat       -> Golbat (final)
	db MEWTWO        ; $83 Mewtwo       -> Mewtwo (final)
	db SNORLAX       ; $84 Snorlax      -> Snorlax (final)
	db GYARADOS      ; $85 Magikarp     -> Gyarados
	db 0             ; $86 MissingNo
	db 0             ; $87 MissingNo
	db MUK           ; $88 Muk          -> Muk (final)
	db 0             ; $89 MissingNo
	db KINGLER       ; $8A Kingler      -> Kingler (final)
	db CLOYSTER      ; $8B Cloyster     -> Cloyster (final)
	db 0             ; $8C MissingNo
	db ELECTRODE     ; $8D Electrode    -> Electrode (final)
	db CLEFABLE      ; $8E Clefable     -> Clefable (final)
	db WEEZING       ; $8F Weezing      -> Weezing (final)
	db PERSIAN       ; $90 Persian      -> Persian (final)
	db MAROWAK       ; $91 Marowak      -> Marowak (final)
	db 0             ; $92 MissingNo
	db GENGAR        ; $93 Haunter      -> Gengar
	db ALAKAZAM      ; $94 Abra         -> Alakazam
	db ALAKAZAM      ; $95 Alakazam     -> Alakazam (final)
	db PIDGEOT       ; $96 Pidgeotto    -> Pidgeot
	db PIDGEOT       ; $97 Pidgeot      -> Pidgeot (final)
	db STARMIE       ; $98 Starmie      -> Starmie (final)
	db VENUSAUR      ; $99 Bulbasaur    -> Venusaur
	db VENUSAUR      ; $9A Venusaur     -> Venusaur (final)
	db TENTACRUEL    ; $9B Tentacruel   -> Tentacruel (final)
	db 0             ; $9C MissingNo
	db SEAKING       ; $9D Goldeen      -> Seaking
	db SEAKING       ; $9E Seaking      -> Seaking (final)
	db 0             ; $9F MissingNo
	db 0             ; $A0 MissingNo
	db 0             ; $A1 MissingNo
	db 0             ; $A2 MissingNo
	db RAPIDASH      ; $A3 Ponyta       -> Rapidash
	db RAPIDASH      ; $A4 Rapidash     -> Rapidash (final)
	db RATICATE      ; $A5 Rattata      -> Raticate
	db RATICATE      ; $A6 Raticate     -> Raticate (final)
	db NIDOKING      ; $A7 Nidorino     -> Nidoking
	db NIDOQUEEN     ; $A8 Nidorina     -> Nidoqueen
	db GOLEM         ; $A9 Geodude      -> Golem
	db PORYGON       ; $AA Porygon      -> Porygon (final in Gen 1)
	db AERODACTYL    ; $AB Aerodactyl   -> Aerodactyl (final)
	db 0             ; $AC MissingNo
	db MAGNETON      ; $AD Magnemite    -> Magneton
	db 0             ; $AE MissingNo
	db 0             ; $AF MissingNo
	db CHARIZARD     ; $B0 Charmander   -> Charizard
	db BLASTOISE     ; $B1 Squirtle     -> Blastoise
	db CHARIZARD     ; $B2 Charmeleon   -> Charizard
	db BLASTOISE     ; $B3 Wartortle    -> Blastoise
	db CHARIZARD     ; $B4 Charizard    -> Charizard (final)
	db 0             ; $B5 MissingNo
	db 0             ; $B6 Fossil Kabutops (special sprite)
	db 0             ; $B7 Fossil Aerodactyl (special sprite)
	db 0             ; $B8 Ghost (special event)
	db VILEPLUME     ; $B9 Oddish       -> Vileplume
	db VILEPLUME     ; $BA Gloom        -> Vileplume
	db VILEPLUME     ; $BB Vileplume    -> Vileplume (final)
	db VICTREEBEL    ; $BC Bellsprout   -> Victreebel
	db VICTREEBEL    ; $BD Weepinbell   -> Victreebel
	db VICTREEBEL    ; $BE Victreebel   -> Victreebel (final)
	assert_table_length NUM_POKEMON_INDEXES
