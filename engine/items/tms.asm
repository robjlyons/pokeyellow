; tests if mon [wCurPartySpecies] can learn move [wMoveNum]
CanLearnTM:
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld hl, wMonHLearnset
	push hl
	ld a, [wMoveNum]
	ld b, a
	ld c, $0
	ld hl, TechnicalMachines
.findTMloop
	ld a, [hli]
	cp -1 ; reached terminator?
	jr z, .done
	cp b
	jr z, .TMfoundLoop
	inc c
	jr .findTMloop
.TMfoundLoop
	pop hl
	ld b, FLAG_TEST
	predef_jump FlagActionPredef
.done
	pop hl
	ld c, 0
	ret

; converts TM/HM number in [wTempTMHM] into move number
; HMs start at 51
TMToMove:
	ld a, [wTempTMHM]
	dec a                   ; A = 0-indexed slot (0-49 = TMs, 50+ = HMs)
	ld c, a                 ; save index
	; If RANDOMISE is on and this is a TM (not HM), use sNuzlockTMMoves
	ld a, [wNuzloptionsRandomise]
	and a
	jr z, .useOriginal
	ld a, c
	cp NUM_TMS              ; index < NUM_TMS means TM01..TM50
	jr nc, .useOriginal     ; HM: always use original table
	; Read randomised move from sNuzlockTMMoves[c]
	ld a, BANK(sNuzlockTMMoves)
	call OpenSRAM
	ld hl, sNuzlockTMMoves
	ld d, 0
	ld e, c
	add hl, de
	ld a, [hl]
	call CloseSRAM          ; preserves A
	ld [wTempTMHM], a
	ret
.useOriginal:
	ld hl, TechnicalMachines
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wTempTMHM], a
	ret

INCLUDE "data/moves/tmhm_moves.asm"
