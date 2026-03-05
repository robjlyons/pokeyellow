; engine/nuzlock/randomise_init.asm
;
; InitRandomiserTables - called once when a new game starts with RANDOMISE enabled.
; Fills the sNuzlockData SRAM block with freshly randomised permutation tables.
;
; sNuzlockBasePerm / sNuzlockEvoPerm / sNuzlockMovePerm use national dex / move IDs.
; sNuzlockWild1to1, sNuzlockStarterSpecies, sNuzlockStaticSpecies, sNuzlockTradeSpecies
; store internal species IDs (via ValidSpeciesTable).
; Called via farcall from OakSpeech (bank1); this file lives in bank3.

InitRandomiserTables::
	ld a, [wNuzloptionsRandomise]
	and a
	ret z                   ; RANDOMISE is OFF — nothing to do

	ld a, BANK(sNuzlockData)
	call OpenSRAM           ; enable SRAM bank 0

	; ---------------------------------------------------------------
	; sNuzlockBasePerm: random permutation of 1..151
	; GetMonHeader will use sNuzlockBasePerm[wPokedexNum-1] as the
	; national dex number of the species whose stats to load.
	; ---------------------------------------------------------------
	ld hl, sNuzlockBasePerm
	ld b, 151
	call ShuffleTable       ; HL now points past end of BasePerm

	; ---------------------------------------------------------------
	; sNuzlockEvoPerm: random permutation of 1..151
	; sNuzlockEvoPerm[species-1] gives the national dex number of the
	; species that this one evolves into (under the randomised rules).
	; ---------------------------------------------------------------
	ld hl, sNuzlockEvoPerm
	ld b, 151
	call ShuffleTable

	; ---------------------------------------------------------------
	; sNuzlockMovePerm: permutation of 1..164, then STRUGGLE fixed
	; sNuzlockMovePerm[move-1] = randomised replacement move.
	; STRUGGLE (165) always maps to itself; it is placed at index 164.
	; ---------------------------------------------------------------
	ld hl, sNuzlockMovePerm
	ld b, 164
	call ShuffleTable       ; HL now points to index 164
	ld [hl], STRUGGLE       ; index 164 => STRUGGLE stays as STRUGGLE

	; ---------------------------------------------------------------
	; sNuzlockWild1to1: kept for save-file compatibility.
	; Wild encounter species are now drawn fresh from RandomSpecies on
	; each encounter (see wild_encounters.asm), so this table is no
	; longer read — but it is still filled so that old saves don't see
	; uninitialised bytes if the code is ever reverted.
	; ---------------------------------------------------------------
	ld hl, sNuzlockWild1to1
	ld b, 0                 ; b=0 with dec b loop => 256 iterations
.wildLoop:
	call RandomSpecies      ; A = random internal species ID
	ld [hli], a
	dec b
	jr nz, .wildLoop

	; ---------------------------------------------------------------
	; sNuzlockTMMoves: 50 random move IDs (1..164) for TM01-TM50
	; Duplicates are allowed; HMs are left untouched by the hook.
	; ---------------------------------------------------------------
	ld hl, sNuzlockTMMoves
	ld b, NUM_TMS
.tmLoop:
	call Random             ; A = random 0..255
	ld c, 164
	call RandomMod          ; A = 0..163
	inc a                   ; A = 1..164
	ld [hli], a
	dec b
	jr nz, .tmLoop

	; ---------------------------------------------------------------
	; sNuzlockStarterSpecies: one random species for the starter
	; ---------------------------------------------------------------
	call RandomSpecies
	ld [sNuzlockStarterSpecies], a

	; ---------------------------------------------------------------
	; sNuzlockStaticSpecies: 14 random species (one per static encounter)
	; Indexed by STATIC_INDEX_* constants (defined in ram_constants.asm).
	; ---------------------------------------------------------------
	ld hl, sNuzlockStaticSpecies
	ld b, 14
.staticLoop:
	call RandomSpecies
	ld [hli], a
	dec b
	jr nz, .staticLoop

	; ---------------------------------------------------------------
	; sNuzlockTradeSpecies: 12 random species (6 trades × give + recv)
	; ---------------------------------------------------------------
	ld hl, sNuzlockTradeSpecies
	ld b, 12
.tradeLoop:
	call RandomSpecies
	ld [hli], a
	dec b
	jr nz, .tradeLoop

	; ---------------------------------------------------------------
	; sNuzlockPCItem: random item from the allowed pool
	; ---------------------------------------------------------------
	call Random
	ld c, PC_ITEM_POOL_SIZE
	call RandomMod          ; A = 0..PC_ITEM_POOL_SIZE-1
	ld hl, PCItemPool
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [sNuzlockPCItem], a

	call CloseSRAM
	ret


; ---------------------------------------------------------------
; ApplyBasePermutation: overlay stats bytes from the permuted species
; into wMonHeader, leaving types and sprite bytes intact.
;
; GetMonHeader has already copied the ORIGINAL species' full BaseStats
; (28 bytes) into wMonHeader, so types and sprites are correct.  This
; predef overwrites only the 5 base stats (HP, Atk, Def, Spd, Spc) and
; CatchRate + BaseEXP with the permuted species' values.  Type1 and
; Type2 (bytes 6-7) are intentionally skipped so the displayed type
; always matches the original species.
;
; Input:  wPokedexNum = original national dex number.
; Destroys A, BC, DE, HL.
; ---------------------------------------------------------------
ApplyBasePermutation::
	; Fetch permuted dex number from SRAM
	ld a, BANK(sNuzlockBasePerm)
	call OpenSRAM
	ld a, [wPokedexNum]
	dec a                   ; 0-indexed slot
	ld hl, sNuzlockBasePerm
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]              ; A = permuted national dex number
	call CloseSRAM          ; preserves A
	; Point HL at permuted species' BaseStats entry
	dec a                   ; 0-indexed
	ld bc, BASE_DATA_SIZE
	ld hl, BaseStats
	call AddNTimes          ; HL → BaseStats[permuted - 1]
	; Copy bytes 1-5 (HP, Atk, Def, Spd, Spc) — skip byte 0 = dex no
	inc hl                  ; skip BASE_DEX_NO
	ld de, wMonHBaseStats   ; wMonHBaseHP — first stat byte
	ld bc, NUM_STATS        ; 5 bytes
	call CopyData
	; HL now points at permuted Type1 — skip Type1 + Type2 to preserve original types
	inc hl
	inc hl
	; Copy bytes 8-9: CatchRate + BaseEXP
	ld de, wMonHCatchRate
	ld bc, 2
	call CopyData
	ret


; ---------------------------------------------------------------
; RandomSpecies: return a random internal species ID in A
; Indexes into ValidSpeciesTable (151 valid internal IDs, national dex order).
; Destroys A, C, DE.  Preserves HL, B.
; ---------------------------------------------------------------
RandomSpecies:
	push hl
	call Random             ; A = random 0..255, preserves HL/BC/DE
	ld c, 151
	call RandomMod          ; A = 0..150
	ld hl, ValidSpeciesTable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]              ; A = internal species ID
	pop hl
	ret


; ---------------------------------------------------------------
; RandomMod: A = A mod C  (result 0..C-1)
; Input:  A = dividend, C = divisor (C must not be 0)
; Output: A = A mod C
; Destroys A only.  Preserves BC, HL, DE.
; ---------------------------------------------------------------
RandomMod:
	cp c
	ret c                   ; A < C — done
	sub c
	jr RandomMod


; ---------------------------------------------------------------
; ShuffleTable: fill HL[0..B-1] with 1..B, then Fisher-Yates shuffle.
; Input:  HL = base of byte array, B = count (1..255)
; Output: array holds a random permutation of 1..B
;         HL = one byte past end of array (HL_entry + B)
; Destroys A, BC, DE.
; Random() is called (home bank); it preserves HL, BC, DE.
; ---------------------------------------------------------------
ShuffleTable:
	; Phase 1 — fill with identity 1..B
	push bc
	push hl
	ld a, 1
.fill:
	ld [hli], a
	inc a
	dec b
	jr nz, .fill
	pop hl                  ; restore array base
	pop bc                  ; restore B = count

	; Phase 2 — top-down Fisher-Yates
	; C = remaining slots (starts at B, counts down to 1)
	; HL advances one slot per iteration
	ld c, b
.shuffleLoop:
	ld a, c
	cp 2
	jr c, .shuffleDone      ; remaining < 2 — stop

	; r = Random() mod C  (Random preserves HL, BC, DE)
	call Random
.modloop:
	cp c
	jr c, .modDone
	sub c
	jr .modloop
.modDone:
	; A = r (offset 0..remaining-1); swap array[i] with array[i+r]
	ld b, [hl]              ; B = array[i]
	push hl
	ld e, a
	ld d, 0
	add hl, de              ; HL = &array[i + r]
	ld a, [hl]              ; A = array[j]
	ld [hl], b              ; array[j] = old array[i]
	pop hl                  ; HL = &array[i]
	ld [hl], a              ; array[i] = old array[j]

	inc hl                  ; advance to next slot
	dec c                   ; remaining--
	jr .shuffleLoop
.shuffleDone:
	inc hl                  ; advance past last element so HL points past end
	ret


; ---------------------------------------------------------------
; PCItemPool — items the player may receive as their starting item
; ---------------------------------------------------------------
PCItemPool:
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db FULL_HEAL
	db SUPER_POTION
	db HYPER_POTION
	db FULL_RESTORE
	db REVIVE
	db MAX_REVIVE
	db ETHER
	db MAX_ETHER
PCItemPoolEnd:
DEF PC_ITEM_POOL_SIZE EQU PCItemPoolEnd - PCItemPool


; ---------------------------------------------------------------
; ValidSpeciesTable — 151 internal species IDs in national dex order.
; Index 0 = dex 1 (Bulbasaur) ... index 150 = dex 151 (Mew).
; ---------------------------------------------------------------
ValidSpeciesTable:
INCLUDE "data/nuzlock/species_list_data.asm"
