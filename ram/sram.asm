SECTION "Sprite Buffers", SRAM

sSpriteBuffer0:: ds SPRITEBUFFERSIZE
sSpriteBuffer1:: ds SPRITEBUFFERSIZE
sSpriteBuffer2:: ds SPRITEBUFFERSIZE

	ds $100

sHallOfFame:: ds HOF_TEAM * HOF_TEAM_CAPACITY


SECTION "Nuzlock Randomiser Data", SRAM, BANK[0]

sNuzlockData::
sNuzlockBasePerm::       ds 151  ; dex slot i -> use BaseStats of species sNuzlockBasePerm[i]
sNuzlockEvoPerm::        ds 151  ; species i -> evolves into species sNuzlockEvoPerm[i]
sNuzlockMovePerm::       ds 165  ; move i -> remapped to move sNuzlockMovePerm[i] (1-based)
sNuzlockWild1to1::       ds 256  ; map_id -> species (0 = no override for this map)
sNuzlockTMMoves::        ds 50   ; TM01..TM50 move assignments (move IDs, 1-based)
sNuzlockStarterSpecies:: db      ; starter species for this run
sNuzlockStaticSpecies::  ds 14   ; static encounter species (indexed by STATIC_INDEX_* constants)
sNuzlockTradeSpecies::   ds 12   ; 6 trades x (give_species, recv_species)
sNuzlockPCItem::         db      ; starting PC Potion replacement
sNuzlockDataEnd::
; Total: 151+151+165+256+50+1+14+12+1 = 801 bytes


SECTION "Save Data", SRAM

	ds $598

sGameData::
sPlayerName::  ds NAME_LENGTH
sMainData::    ds wMainDataEnd - wMainDataStart
sSpriteData::  ds wSpriteDataEnd - wSpriteDataStart
sPartyData::   ds wPartyDataEnd - wPartyDataStart
sCurBoxData::  ds wBoxDataEnd - wBoxDataStart
sTileAnimations:: db
sGameDataEnd::
sMainDataCheckSum:: db

SECTION "Encounter Catch Flags", SRAM, BANK[0]
sMapEncounterCatchFlags:: flag_array NUM_MAPS
sMapEncounterCatchFlagsInitialized:: db


; The PC boxes will not fit into one SRAM bank,
; so they use multiple SECTIONs
DEF box_n = 0
MACRO boxes
	REPT \1
		DEF box_n += 1
	sBox{d:box_n}:: ds wBoxDataEnd - wBoxDataStart
	ENDR
ENDM

SECTION "Saved Boxes 1", SRAM

; sBox1 - sBox6
	boxes 6
sBank2AllBoxesChecksum:: db
sBank2IndividualBoxChecksums:: ds 6

SECTION "Saved Boxes 2", SRAM

; sBox7 - sBox12
	boxes 6
sBank3AllBoxesChecksum:: db
sBank3IndividualBoxChecksums:: ds 6

; All 12 boxes fit within 2 SRAM banks
	ASSERT box_n == NUM_BOXES, \
		"boxes: Expected {d:NUM_BOXES} total boxes, got {d:box_n}"

ENDSECTION
