ReadTrainer:

; don't change any moves in a link battle
	ld a, [wLinkState]
	and a
	ret nz

; set [wEnemyPartyCount] to 0, [wEnemyPartySpecies] to FF
; XXX first is total enemy pokemon?
; XXX second is species of first pokemon?
	ld hl, wEnemyPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

; get the pointer to trainer data for this class
	ld a, [wTrainerClass] ; get trainer class
	dec a
	add a
	ld hl, TrainerDataPointers
	ld c, a
	ld b, 0
	add hl, bc ; hl points to trainer class
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTrainerNo]
	ld b, a
; At this point b contains the trainer number,
; and hl points to the trainer class.
; Our next task is to iterate through the trainers,
; decrementing b each time, until we get to the right one.
.CheckNextTrainer
	dec b
	jr z, .IterateTrainer
.SkipTrainer
	ld a, [hli]
	and a
	jr nz, .SkipTrainer
	jr .CheckNextTrainer

; if the first byte of trainer data is FF,
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [wLoneAttackNo] != 0, one pokemon on the team has a special move
; else the first byte is the level of every pokemon on the team
.IterateTrainer
	ld a, [hli]
	cp $FF ; is the trainer special?
	jr z, .SpecialTrainer ; if so, check for special moves
	ld [wCurEnemyLevel], a
.LoopTrainerData
	ld a, [hli]
	and a ; have we reached the end of the trainer data?
	jp z, .AddAdditionalMoveData
	ld [wCurPartySpecies], a
	; If RANDOMISE is on, override species with a random one (final form at level 30+)
	ld a, [wNuzloptionsRandomise]
	and a
	call nz, RandomTrainerSpecies
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	push hl
	call AddPartyMon
	pop hl
	jr .LoopTrainerData
.SpecialTrainer
; if this code is being run:
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [wLoneAttackNo] != 0, one pokemon on the team has a special move
	ld a, [hli]
	and a ; have we reached the end of the trainer data?
	jr z, .AddAdditionalMoveData
	ld [wCurEnemyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	; If RANDOMISE is on, override species (final form at level 30+)
	ld a, [wNuzloptionsRandomise]
	and a
	call nz, RandomTrainerSpecies
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	push hl
	call AddPartyMon
	pop hl
	jr .SpecialTrainer
.AddAdditionalMoveData
; does the trainer have additional move data?
	ld a, [wTrainerClass]
	ld b, a
	ld a, [wTrainerNo]
	ld c, a
	ld hl, SpecialTrainerMoves
.loopAdditionalMoveData
	ld a, [hli]
	cp $ff
	jr z, .FinishUp
	cp b
	jr nz, .loopSkipTrainer
	ld a, [hli]
	cp c
	jr nz, .loopSkipTrainer
	ld d, h
	ld e, l
.writeAdditionalMoveDataLoop
	ld a, [de]
	inc de
	and a
	jp z, .FinishUp
	dec a
	ld hl, wEnemyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [de]
	inc de
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	inc de
	ld [hl], a
	jr .writeAdditionalMoveDataLoop
.loopSkipTrainer
	ld a, [hli]
	and a
	jr nz, .loopSkipTrainer
	jr .loopAdditionalMoveData
.FinishUp
; clear wAmountMoneyWon addresses
	xor a
	ld de, wAmountMoneyWon
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	ld a, [wCurEnemyLevel]
	ld b, a
.LastLoop
; update wAmountMoneyWon addresses (money to win) based on enemy's level
	ld hl, wTrainerBaseMoney + 1
	ld c, 2 ; wAmountMoneyWon is a 3-byte number
	push bc
	predef AddBCDPredef
	pop bc
	inc de
	inc de
	dec b
	jr nz, .LastLoop ; repeat wCurEnemyLevel times
	ret

; RandomTrainerSpecies
; Pick a random species for a trainer slot.
; If wCurEnemyLevel >= 30, use the final evolution form.
; Writes the internal species ID to wCurPartySpecies.
; Preserves HL.
RandomTrainerSpecies:
	push hl
	call Random             ; A = random 0..255 (home bank, preserves HL/BC)
	ld c, 151
.modloop:
	cp c
	jr c, .moddone
	sub c
	jr .modloop
.moddone:
	; A = 0..150 — index into TrainerValidSpeciesTable to get internal species ID
	ld hl, TrainerValidSpeciesTable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]              ; A = internal species ID
	; Check if level >= 30: apply FinalEvolutionTable
	ld b, a                 ; B = species
	ld a, [wCurEnemyLevel]
	cp 30
	jr c, .noFinalEvo       ; below 30: keep species as-is
	; Look up final form in FinalEvolutionTable[species-1]
	ld a, b
	dec a                   ; 0-indexed
	ld hl, FinalEvolutionTable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]              ; final-form internal species ID (0 if N/A)
	and a
	jr z, .noFinalEvo       ; 0 = no final form listed, keep original
	ld b, a
.noFinalEvo:
	ld a, b
	ld [wCurPartySpecies], a
	pop hl
	ret

INCLUDE "data/nuzlock/final_evolutions.asm"

; ---------------------------------------------------------------
; TrainerValidSpeciesTable — 151 internal species IDs, national dex order.
; Index 0 = dex 1 (Bulbasaur) ... index 150 = dex 151 (Mew).
; ---------------------------------------------------------------
TrainerValidSpeciesTable:
INCLUDE "data/nuzlock/species_list_data.asm"
