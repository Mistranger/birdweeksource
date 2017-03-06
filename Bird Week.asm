;-------------------------------------------------------------------------------
; Bird Week (J) [!].nes disasembled by DISASM6 v1.5
; Further disassembling, label naming, comments and other stuff by cybermind
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; iNES Header
;-------------------------------------------------------------------------------
            .db "NES", $1A     ; Header
            .db 1              ; 1 x 16k PRG banks
            .db 1              ; 1 x 8k CHR banks
            .db %10010001      ; Mirroring: Vertical
                               ; SRAM: Not used
                               ; 512k Trainer: Not used
                               ; 4 Screen VRAM: Not used
                               ; Mapper: 9
            .db %10110000      ; RomType: NES
            .hex 00 00 00 00   ; iNES Tail 
            .hex 00 00 00 00    
			
; Player Input (vPlayerInput)
			; 0x01 - button A
			; 0x02 - button B
			; 0x04 - select
			; 0x08 - start
			; 0x10 - dup
			; 0x20 - ddown
			; 0x40 - dleft
			; 0x80 - dright
; Variables
		; Zero-page
			; Nametable bird currently in
			vBirdPPUNametable equ $02
			; Position of bird in nametable
			vBirdPPUX equ $03
			vPPUController equ $06
			vPPUMask equ $07
			vRandomVar equ $08
			vCycleCounter equ $09
			vPlayerInput equ $0a
			vPlayer2Input equ $0b
			vNestlingCountLabel equ $0f
			vNestlingOnes equ $10
			vNestling10s equ $11
			vNestling100s equ $12
			vRandomVar2 equ $17
			vMusicPlayerState equ $20
			vMusicSpeed equ $23
			vPulseLengthCounterLoad equ $24
			vMusicCounter equ $25
			vSoundPlayerState equ $2a
			vSoundAddr equ $2b
			vSoundHiAddr equ $2c
			vSoundSpeed equ $2d
			vTriangleLengthCounterLoad equ $2e
			vSoundCounter equ $2f
			vPaletteData equ $30
			vGameState equ $50
			;vIsSelectPressed equ $51
			; even values are "game start", odd values are "study mode" 
			vGameMode equ $52
			vDataAddress equ $53
			vDataAddressHi equ $54
			vCurrentLevel equ $55
			vBirdLives equ $56
			vMainMenuCounter equ $57
			vWoodpeckerState equ $58
			vBirdIsRight equ $5a
			vBirdX equ $5b
			vBirdOffsetX equ $5c
			vBirdDirection equ $5d
			vRisedNestlingCount equ $5f
			vIsBirdLanded equ $61
			vIsBirdLanding equ $62
			vNestlingMaxFeed equ $64
			vNestlingAwayState equ $65
			; when kite revives after death, it rises until its altitude will become #$80
			vKiteRiseAfterDeath equ $67
			vKiteYChange equ $68
			vKiteMaxYChange equ $69
			; 1 - left, 0 - right
			vKiteDirection equ $6a
			vIsGamePaused equ $6f
			vBeeX equ $70
			vButterfly1X equ $73
			vButterfly2X equ $74
			vButterfly3X equ $75
			vButterfly4X equ $76
			vKiteX1 equ $78
			vKiteX2 equ $79
			vMushroomX equ $7a
			vFoxX equ $7b
			vWoodpeckerSquirrelX equ $7e
			vWhaleCaterpillarX equ $7f
			vBonusItemsCaught equ $8b
			vNestling1State equ $8c
			vNestling2State equ $8d
			vNestling3State equ $8e
			vBeeY equ $90
			vButterfly1Y equ $93
			vButterfly2Y equ $94
			vButterfly3Y equ $95
			vButterfly4Y equ $96
			vKiteY1 equ $98
			vKiteY2 equ $99
			vFoxY equ $9b
			vWoodpeckerSquirrelY equ $9e
			vWhaleCaterpillarY equ $9f
			vHawkY equ $a0
			vNestlingIsRising equ $a4
			vTimeFreezeTimer equ $a6
			vButterflyXCaught equ $b3
			vInvulnTimer equ $bf
			vHawkState equ $c6
			vIsStartPressed equ $d0
			vStartPressedCount equ $d1
			vBirdFallState equ $d2
			vScoreScreenState equ $d3
			vScoreScreenCounter equ $d4
			vNestlingHappyTimer equ $e8
			vNestlingIsDead equ $e9
			vBonusScoreScreenCounter equ $f1
			vRoundNumberArray equ $f1
			vRoundNumber equ $f2
			vIsGameLoading equ $f6
			vGameLoadingCounter equ $f7
			
		; 0100
			vPlayerScore equ $0100
			
		; 0200
			vPage200 equ $0200
			vButterfly1Timer equ $0200
			vNestling1Timer equ $0205
			vNestling2Timer equ $0206
			vNestling3Timer equ $0207
			vIsCreatureDead equ $0210
			vGotExtraLife equ $0230
			vWhaleCounter equ $0252
			vStageSelectState equ $02e0
			vStageSelect10s equ $02e1
			vStageSelectOnes equ $02e2
			vDemoSequenceActive equ $0273
			
		; 0600 - OAM table
			vOAMTable equ $0600
			vOAMPosY equ $0604
			vOAMTileIndex equ $0605
			vOAMAttributes equ $0606
			vOAMPosX equ $0607
			
		; 0700
			; sptite table, organized as pair of bytes (yPos, spriteNum)
			vSpriteTable equ $0700
			vBirdSpritePosY equ $0700
			vWoodPeckerSprite equ $073d
			vNestlingCountSprite equ $0760
			
			vPaletteDataAbs equ $0030
; I/O registers
			; PPU
			ppuControl equ $2000
			ppuMask equ $2001
			ppuStatus equ $2002
			ppuOAMAddr equ $2003
			ppuScroll equ $2005
			ppuAddress equ $2006
			ppuData equ $2007
			
			; APU
			apu1Pulse1 equ $4000
			apu1PulseSweep equ $4001
			apu1PulseTLow equ $4002
			apu1PulseTHigh equ $4003
			apu2Pulse1 equ $4004
			apu2PulseSweep equ $4005
			apu2PulseTLow equ $4006
			apuTriangle equ $4008
			apuTriangleTLow equ $400a
			apuTriangleTHigh equ $400b
			apuStatus equ $4015
			
			OAMDMA equ $4014
			joy1port equ $4016
			joy2port equ $4017
			

;-------------------------------------------------------------------------------
; Program Origin
;-------------------------------------------------------------------------------
            .org $c000         ; Set program counter

;-------------------------------------------------------------------------------
; ROM Start
;-------------------------------------------------------------------------------
__mainMenuPalette:     
			.hex 21 18 36 26   ; $c000: 21 18 36 26   Data
            .hex 21 30 30 17   ; $c004: 21 30 30 17   Data
            .hex 21 30 30 17   ; $c008: 21 30 30 17   Data
            .hex 21 11 30 17   ; $c00c: 21 11 30 17   Data
            .hex 21 12 30 17   ; $c010: 21 12 30 17   Data
            .hex 21 0f 0f 0f   ; $c014: 21 0f 0f 0f   Data
            .hex 21 0f 0f 0f   ; $c018: 21 0f 0f 0f   Data
            .hex 21 0f 0f 0f   ; $c01c: 21 0f 0f 0f   Data
__c020:     .hex f0            ; $c020: f0            Data
__c021:     .hex 0f 13 3f 00   ; $c021: 0f 13 3f 00   Data
            .hex 01 02 03 04   ; $c025: 01 02 03 04   Data
            .hex 05 06 07 08   ; $c029: 05 06 07 08   Data
            .hex 09 0a 0b      ; $c02d: 09 0a 0b      Data
__initAPUshowGraphics:     jmp ___initAPUshowGraphics         ; $c030: 4c 52 f6  

;-------------------------------------------------------------------------------
__processGameState:     
			lda vGameState            ; $c033: a5 50  
			
			; is game starting
            beq __initGame         ; $c035: f0 3d     
			; is main menu
            cmp #$01           ; $c037: c9 01     
            beq __mainMenuLoop         ; $c039: f0 3c     
			
			; is "Round X" label
            cmp #$02           ; $c03b: c9 02     
            beq __gameLoadingLoop         ; $c03d: f0 41    
			
			; is game loop
            cmp #$03           ; $c03f: c9 03     
            beq __gameLoop         ; $c041: f0 2e     
			; game over
            cmp #$04           ; $c043: c9 04     
            beq __c05c         ; $c045: f0 15   
			
            cmp #$05           ; $c047: c9 05     
            beq __c05f         ; $c049: f0 14 
			; game freeze (bird is dead or nestling is rising)
            cmp #$ff           ; $c04b: c9 ff     
            beq __c062         ; $c04d: f0 13     
			; score screen
            cmp #$fe           ; $c04f: c9 fe     
            beq __scoreScreenLoop         ; $c051: f0 12     
			; f******cking best ending (bestyding)
            cmp #$fc           ; $c053: c9 fc     
            beq __bestEndingLoop         ; $c055: f0 14  
			
			; study mode
            cmp #$fb           ; $c057: c9 fb     
            beq __studyModeStageSelectLoop         ; $c059: f0 13    
			
            rts                ; $c05b: 60        

;-------------------------------------------------------------------------------
__c05c:     jmp __f467         ; $c05c: 4c 67 f4  

;-------------------------------------------------------------------------------
__c05f:     jmp __f5a2         ; $c05f: 4c a2 f5  

;-------------------------------------------------------------------------------
__c062:     jmp __c60a         ; $c062: 4c 0a c6  

;-------------------------------------------------------------------------------
__scoreScreenLoop:     jmp ___scoreScreenLoop         ; $c065: 4c 89 c8  

;-------------------------------------------------------------------------------
__c068:     jmp __d721         ; $c068: 4c 21 d7  

;-------------------------------------------------------------------------------
__bestEndingLoop:     jmp ___bestEndingLoop         ; $c06b: 4c 1b d7  

;-------------------------------------------------------------------------------
__studyModeStageSelectLoop:     jmp ___studyModeStageSelectLoop         ; $c06e: 4c 5e cc  

;-------------------------------------------------------------------------------
__gameLoop:     jmp ___gameLoop         ; $c071: 4c a6 c0  

;-------------------------------------------------------------------------------
__initGame:     jmp ___initGame         ; $c074: 4c 5b e1  

;-------------------------------------------------------------------------------
__mainMenuLoop:     
			jsr __mainMenuHandleSelect         ; $c077: 20 15 cb  
            jsr __drawMainMenuBird         ; $c07a: 20 2b cb  
            jmp __handleMainMenuDemo         ; $c07d: 4c 66 cb  

;-------------------------------------------------------------------------------
__gameLoadingLoop:     jmp ___gameLoadingLoop         ; $c080: 4c 5b c1  

;-------------------------------------------------------------------------------
__initGameLoop:     jmp ___initGameLoop         ; $c083: 4c 7c e2  

;-------------------------------------------------------------------------------
__c086:     jsr __c309         ; $c086: 20 09 c3  
            jsr __f62d         ; $c089: 20 2d f6  
            jsr __cd35         ; $c08c: 20 35 cd  
            jsr __showNestlingCountLabel         ; $c08f: 20 df c1  
            jsr __showSprites         ; $c092: 20 e0 fd  
            lda vGameState            ; $c095: a5 50     
            cmp #$01           ; $c097: c9 01     
            beq __c09d         ; $c099: f0 02     
            inc vGameState            ; $c09b: e6 50     
__c09d:     jsr __scrollScreen         ; $c09d: 20 b6 fd  
            jsr __c0d0         ; $c0a0: 20 d0 c0  
            jmp __enableNMI         ; $c0a3: 4c c6 fe  

;-------------------------------------------------------------------------------
___gameLoop:     
			jsr __handleStartButton         ; $c0a6: 20 2c c2  
            jmp __c248         ; $c0a9: 4c 48 c2  

;-------------------------------------------------------------------------------
__c0ac:     lda vGameState            ; $c0ac: a5 50     
            cmp #$fc           ; $c0ae: c9 fc     
				beq __c068         ; $c0b0: f0 b6     
            jsr __c309         ; $c0b2: 20 09 c3  
            jsr __drawScoreLabel         ; $c0b5: 20 91 ca  
            jsr __f618         ; $c0b8: 20 18 f6  
            jsr __f5e8         ; $c0bb: 20 e8 f5  
            jsr __c2b6         ; $c0be: 20 b6 c2  
            jsr __c444         ; $c0c1: 20 44 c4  
            jsr __c454         ; $c0c4: 20 54 c4  
            jsr __c4d9         ; $c0c7: 20 d9 c4  
            jsr __c582         ; $c0ca: 20 82 c5  
            jsr __c2f6         ; $c0cd: 20 f6 c2  
__c0d0:     lda $5e            ; $c0d0: a5 5e     
            bne __c11c         ; $c0d2: d0 48     
            .hex ad a6 00      ; $c0d4: ad a6 00  Bad Addr Mode - LDA $00a6
            bne __c107         ; $c0d7: d0 2e     
            jsr __levelModulo4         ; $c0d9: 20 5e c3  
            cpx #$03           ; $c0dc: e0 03     
            beq __c0fe         ; $c0de: f0 1e     
            jsr __d503         ; $c0e0: 20 03 d5  
            jsr __dc84         ; $c0e3: 20 84 dc  
            jsr __f26c         ; $c0e6: 20 6c f2  
            jsr __d681         ; $c0e9: 20 81 d6  
            jsr __df1b         ; $c0ec: 20 1b df  
            jsr __dce5         ; $c0ef: 20 e5 dc  
            jsr __dde0         ; $c0f2: 20 e0 dd  
            jsr __ee6b         ; $c0f5: 20 6b ee  
            jsr __f005         ; $c0f8: 20 05 f0  
            jsr __f39b         ; $c0fb: 20 9b f3  
__c0fe:     jsr __db39         ; $c0fe: 20 39 db  
            jsr __da58         ; $c101: 20 58 da  
            jsr __handleSecretCreatures         ; $c104: 20 59 f6  
__c107:     jsr __f19d         ; $c107: 20 9d f1  
            jsr __f10d         ; $c10a: 20 0d f1  
            jsr __d89e         ; $c10d: 20 9e d8  
            jsr __d48a         ; $c110: 20 8a d4  
            jsr __cf54         ; $c113: 20 54 cf  
            jsr __cff5         ; $c116: 20 f5 cf  
            jsr __ef69         ; $c119: 20 69 ef  
__c11c:     jsr __cabc         ; $c11c: 20 bc ca  
            jsr __c128         ; $c11f: 20 28 c1  
__c122:     jsr __handleMusicAndSound         ; $c122: 20 dd f6  
            jmp __composeOAMTable         ; $c125: 4c 3b ff  

;-------------------------------------------------------------------------------
__c128:     
			lda vDemoSequenceActive          ; $c128: ad 73 02  
				bne __c14b         ; $c12b: d0 1e     
            lda $5e            ; $c12d: a5 5e     
				bne __c14c         ; $c12f: d0 1b     
            lda vMusicPlayerState            ; $c131: a5 20     
				bne __c14b         ; $c133: d0 16     
            lda vInvulnTimer            ; $c135: a5 bf     
            bne __c151         ; $c137: d0 18     
            lda vCurrentLevel            ; $c139: a5 55     
            and #$0f           ; $c13b: 29 0f     
            cmp #$07           ; $c13d: c9 07     
            beq __c156         ; $c13f: f0 15     
            cmp #$0f           ; $c141: c9 0f     
            beq __c156         ; $c143: f0 11     
            jsr __levelModulo4         ; $c145: 20 5e c3  
            inx                ; $c148: e8        
            stx vMusicPlayerState            ; $c149: 86 20     
__c14b:     rts                ; $c14b: 60        

;-------------------------------------------------------------------------------
__c14c:     lda #$00           ; $c14c: a9 00     
__c14e:     sta vMusicPlayerState            ; $c14e: 85 20     
            rts                ; $c150: 60        

;-------------------------------------------------------------------------------
__c151:     lda #$10           ; $c151: a9 10     
            jmp __c14e         ; $c153: 4c 4e c1  

;-------------------------------------------------------------------------------
__c156:     lda #$11           ; $c156: a9 11     
            jmp __c14e         ; $c158: 4c 4e c1  

;-------------------------------------------------------------------------------
___gameLoadingLoop:     
			lda vIsGameLoading            ; $c15b: a5 f6     
            beq __initGameLoading         ; $c15d: f0 0c     
            lda vGameLoadingCounter            ; $c15f: a5 f7  
			; wait for 0x40 cycles on "Round X" screen
            cmp #$40           ; $c161: c9 40     
            bne __incGameLoadingCounter         ; $c163: d0 03     
			
            jmp __initGameLoop         ; $c165: 4c 83 c0  

;-------------------------------------------------------------------------------
__incGameLoadingCounter:     
			inc vGameLoadingCounter            ; $c168: e6 f7     
            rts                ; $c16a: 60        

;-------------------------------------------------------------------------------
__initGameLoading:     
			lda vStageSelectState          ; $c16b: ad e0 02  
				bne __gameLoadingDone         ; $c16e: d0 3d     
            jsr __e3da         ; $c170: 20 da e3  
            lda vCurrentLevel            ; $c173: a5 55     
            and #$03           ; $c175: 29 03     
            cmp #$03           ; $c177: c9 03     
				; if bonus round, display "bonus round"
				beq __drawBonusRoundLabel         ; $c179: f0 35    
			
            ldx #$00           ; $c17b: a2 00     
            stx vScoreScreenState            ; $c17d: 86 d3     
            jsr __setRoundLabelPosition         ; $c17f: 20 d4 c1  
__drawRoundXLabelLoop:     
			lda __roundXLabel,x       ; $c182: bd 21 c2  
            sta ppuData          ; $c185: 8d 07 20  
            inx                ; $c188: e8        
            cpx #$08           ; $c189: e0 08     
            bne __drawRoundXLabelLoop         ; $c18b: d0 f5    
			
            ldx #$03           ; $c18d: a2 03     
__c18f:     lda vRoundNumberArray,x          ; $c18f: b5 f1     
            bne __c1a3         ; $c191: d0 10     
            lda #$24           ; $c193: a9 24     
            sta ppuData          ; $c195: 8d 07 20  
            dex                ; $c198: ca        
            bne __c18f         ; $c199: d0 f4     
__c19b:     inc vIsGameLoading            ; $c19b: e6 f6     
            jsr __scrollScreen         ; $c19d: 20 b6 fd  
            jmp __enableNMI         ; $c1a0: 4c c6 fe  

;-------------------------------------------------------------------------------
__c1a3:     lda vRoundNumberArray,x          ; $c1a3: b5 f1     
            sta ppuData          ; $c1a5: 8d 07 20  
            dex                ; $c1a8: ca        
            bne __c1a3         ; $c1a9: d0 f8     
            beq __c19b         ; $c1ab: f0 ee     
__gameLoadingDone:     
			inc vIsGameLoading            ; $c1ad: e6 f6     
            rts                ; $c1af: 60        

;-------------------------------------------------------------------------------
__drawBonusRoundLabel:     
			jsr __clearXY         ; $c1b0: 20 16 d7  
            jsr __setRoundLabelPosition         ; $c1b3: 20 d4 c1  
__drawBonusLabelLoop:     
			lda __bonusLabel,x       ; $c1b6: bd 3e ca  
            sta ppuData          ; $c1b9: 8d 07 20  
            inx                ; $c1bc: e8        
            cpx #$06           ; $c1bd: e0 06     
            bne __drawBonusLabelLoop         ; $c1bf: d0 f5     
			
__drawRoundLabelLoop:     
			lda __roundXLabel,y       ; $c1c1: b9 21 c2  
            sta ppuData          ; $c1c4: 8d 07 20  
            iny                ; $c1c7: c8        
            cpy #$05           ; $c1c8: c0 05     
            bne __drawRoundLabelLoop         ; $c1ca: d0 f5     
			
            inc vIsGameLoading            ; $c1cc: e6 f6     
            jsr __scrollScreen         ; $c1ce: 20 b6 fd  
            jmp __enableNMI         ; $c1d1: 4c c6 fe  

;-------------------------------------------------------------------------------
__setRoundLabelPosition:     
			lda #$20           ; $c1d4: a9 20     
            sta ppuAddress          ; $c1d6: 8d 06 20  
            lda #$ca           ; $c1d9: a9 ca     
            sta ppuAddress          ; $c1db: 8d 06 20  c
            rts                ; $c1de: 60        

;-------------------------------------------------------------------------------
__showNestlingCountLabel:     
			jsr __levelModulo4         ; $c1df: 20 5e c3  
            cpx #$03           ; $c1e2: e0 03     
				; don't display in bonus level
				beq __return10         ; $c1e4: f0 22     
			; set position
            lda #$20           ; $c1e6: a9 20     
            sta ppuAddress          ; $c1e8: 8d 06 20  
            lda #$65           ; $c1eb: a9 65     
            sta ppuAddress          ; $c1ed: 8d 06 20  
			
            ldx #$03           ; $c1f0: a2 03     
__showNestlingCountLabelLoop:     
			lda vNestlingCountLabel,x          ; $c1f2: b5 0f     
            bne __showNestlingCountLabelLoop2         ; $c1f4: d0 0a     
            lda #$24           ; $c1f6: a9 24     
            sta ppuData          ; $c1f8: 8d 07 20  
            dex                ; $c1fb: ca        
            cpx #$01           ; $c1fc: e0 01     
            bne __showNestlingCountLabelLoop         ; $c1fe: d0 f2     
			
__showNestlingCountLabelLoop2:     
			lda vNestlingCountLabel,x          ; $c200: b5 0f     
            sta ppuData          ; $c202: 8d 07 20  
            dex                ; $c205: ca        
            bne __showNestlingCountLabelLoop2         ; $c206: d0 f8     
__return10:     
			rts                ; $c208: 60        

;-------------------------------------------------------------------------------
__increaseNestlingCount:     
			ldx #$00           ; $c209: a2 00     
__increaseNestlingCountLoop:     
			lda vNestlingOnes,x          ; $c20b: b5 10     
            clc                ; $c20d: 18        
            adc #$01           ; $c20e: 69 01     
            cmp #$0a           ; $c210: c9 0a     
            bne __storeNestlingCount         ; $c212: d0 0a     
            lda #$00           ; $c214: a9 00     
            sta vNestlingOnes,x          ; $c216: 95 10     
            inx                ; $c218: e8        
            cpx #$03           ; $c219: e0 03     
            bne __increaseNestlingCountLoop         ; $c21b: d0 ee     
            rts                ; $c21d: 60        

;-------------------------------------------------------------------------------
__storeNestlingCount:     
			sta vNestlingOnes,x          ; $c21e: 95 10     
            rts                ; $c220: 60        

;-------------------------------------------------------------------------------
__roundXLabel:     
			.hex 1b 18 1e 17   ; $c221: 1b 18 1e 17   Data
            .hex 0d 24 24 24   ; $c225: 0d 24 24 24   Data
__c229:     .hex dd df db      ; $c229: dd df db      Data

;-------------------------------------------------------------------------------
__handleStartButton:     
			lda vCycleCounter            ; $c22c: a5 09     
            and #$07           ; $c22e: 29 07     
				bne __return4         ; $c230: d0 15     
            lda vPlayerInput            ; $c232: a5 0a     
            and #$08           ; $c234: 29 08     
            bne __c23d         ; $c236: d0 05     
            lda #$00           ; $c238: a9 00     
            sta vIsStartPressed            ; $c23a: 85 d0     
            rts                ; $c23c: 60        

;-------------------------------------------------------------------------------
__c23d:     lda vIsStartPressed            ; $c23d: a5 d0     
				bne __return4         ; $c23f: d0 06     
            inc vStartPressedCount            ; $c241: e6 d1     
            lda #$01           ; $c243: a9 01     
            sta vIsStartPressed            ; $c245: 85 d0     
__return4:     
			rts                ; $c247: 60        

;-------------------------------------------------------------------------------
__c248:     lda vStartPressedCount            ; $c248: a5 d1     
            and #$01           ; $c24a: 29 01     
            bne __unPauseGame         ; $c24c: d0 35     
            lda vIsGamePaused            ; $c24e: a5 6f     
            bne __showPauseLabel         ; $c250: d0 23     
            inc vIsGamePaused            ; $c252: e6 6f     
            jsr __c29f         ; $c254: 20 9f c2  
            lda vGameState            ; $c257: a5 50     
            cmp #$fc           ; $c259: c9 fc     
            beq __c26e         ; $c25b: f0 11     
            jsr __clearXY         ; $c25d: 20 16 d7  
            lda #$f0           ; $c260: a9 f0     
__c262:     sta $0704,x        ; $c262: 9d 04 07  
            inx                ; $c265: e8        
            inx                ; $c266: e8        
            inx                ; $c267: e8        
            inx                ; $c268: e8        
            iny                ; $c269: c8        
            cpy #$13           ; $c26a: c0 13     
            bne __c262         ; $c26c: d0 f4     
__c26e:     lda #$05           ; $c26e: a9 05     
            sta vMusicPlayerState            ; $c270: 85 20     
            jmp __c122         ; $c272: 4c 22 c1  

;-------------------------------------------------------------------------------
__showPauseLabel:     
			lda #$40           ; $c275: a9 40     
            sta $0764          ; $c277: 8d 64 07  
            sta $0768          ; $c27a: 8d 68 07  
            sta $076c          ; $c27d: 8d 6c 07  
            jmp __c28b         ; $c280: 4c 8b c2  

;-------------------------------------------------------------------------------
__unPauseGame:     
			lda vIsGamePaused            ; $c283: a5 6f     
            beq __hidePauseLabel         ; $c285: f0 0a     
            lda #$00           ; $c287: a9 00     
            sta vIsGamePaused            ; $c289: 85 6f     
__c28b:     jsr __c29f         ; $c28b: 20 9f c2  
            jmp __c122         ; $c28e: 4c 22 c1  

;-------------------------------------------------------------------------------
__hidePauseLabel:     
			lda #$f0           ; $c291: a9 f0     
            sta $0764          ; $c293: 8d 64 07  
            sta $0768          ; $c296: 8d 68 07  
            sta $076c          ; $c299: 8d 6c 07  
            jmp __c0ac         ; $c29c: 4c ac c0  

;-------------------------------------------------------------------------------
__c29f:     lda vGameState            ; $c29f: a5 50     
            cmp #$fc           ; $c2a1: c9 fc     
            beq __c2b0         ; $c2a3: f0 0b     
            ldx #$00           ; $c2a5: a2 00     
__c2a7:     dex                ; $c2a7: ca        
            bne __c2a7         ; $c2a8: d0 fd     
            jsr __f618         ; $c2aa: 20 18 f6  
            jmp __f5e8         ; $c2ad: 4c e8 f5  

;-------------------------------------------------------------------------------
__c2b0:     lda #$00           ; $c2b0: a9 00     
            sta $0295          ; $c2b2: 8d 95 02  
            rts                ; $c2b5: 60        

;-------------------------------------------------------------------------------
__c2b6:     jsr __levelModulo4         ; $c2b6: 20 5e c3  
            cpx #$03           ; $c2b9: e0 03     
            beq __c2e9         ; $c2bb: f0 2c     
            lda vCycleCounter            ; $c2bd: a5 09     
            and #$0f           ; $c2bf: 29 0f     
            bne __c2ee         ; $c2c1: d0 2b     
            ldx #$00           ; $c2c3: a2 00     
__c2c5:     lda vNestling1State,x          ; $c2c5: b5 8c     
            cmp vNestlingAwayState            ; $c2c7: c5 65     
            beq __c2ce         ; $c2c9: f0 03     
            inc vNestling1Timer,x        ; $c2cb: fe 05 02  
__c2ce:     lda vCurrentLevel            ; $c2ce: a5 55     
            cmp #$10           ; $c2d0: c9 10     
            bcc __c2ef         ; $c2d2: 90 1b     
            inx                ; $c2d4: e8        
            cpx #$03           ; $c2d5: e0 03     
            bne __c2c5         ; $c2d7: d0 ec     
__c2d9:     ldx #$00           ; $c2d9: a2 00     
__c2db:     lda vNestling1Timer,x        ; $c2db: bd 05 02  
            cmp #$ff           ; $c2de: c9 ff     
            beq __c2ec         ; $c2e0: f0 0a     
            inx                ; $c2e2: e8        
            cpx #$03           ; $c2e3: e0 03     
            bne __c2db         ; $c2e5: d0 f4     
            beq __c2ee         ; $c2e7: f0 05     
__c2e9:     jmp __dffe         ; $c2e9: 4c fe df  

;-------------------------------------------------------------------------------
__c2ec:     inc vGameState            ; $c2ec: e6 50     
__c2ee:     rts                ; $c2ee: 60        

;-------------------------------------------------------------------------------
__c2ef:     inx                ; $c2ef: e8        
            cpx #$02           ; $c2f0: e0 02     
            bne __c2c5         ; $c2f2: d0 d1     
            beq __c2d9         ; $c2f4: f0 e3     
__c2f6:     ldx #$00           ; $c2f6: a2 00     
__c2f8:     lda vNestling1State,x          ; $c2f8: b5 8c     
            cmp vNestlingMaxFeed            ; $c2fa: c5 64     
            beq __c304         ; $c2fc: f0 06     
__c2fe:     inx                ; $c2fe: e8        
            cpx #$03           ; $c2ff: e0 03     
            bne __c2f8         ; $c301: d0 f5     
            rts                ; $c303: 60        

;-------------------------------------------------------------------------------
__c304:     inc $5e            ; $c304: e6 5e     
            jmp __c2fe         ; $c306: 4c fe c2  

;-------------------------------------------------------------------------------
__c309:     jsr __setPPUIncrementBy32         ; $c309: 20 e4 fe  
            jsr __levelModulo4         ; $c30c: 20 5e c3  
            cpx #$03           ; $c30f: e0 03     
				; bonus level
				beq __return11         ; $c311: f0 09     
            jsr __handleNestling1         ; $c313: 20 1f c3  
            jsr __handleNestling2         ; $c316: 20 33 c3  
            jsr __handleNestling3         ; $c319: 20 46 c3  
__return11:     
			jmp __setPPUIncrementBy1         ; $c31c: 4c da fe  

;-------------------------------------------------------------------------------
__handleNestling1:     
			lda #$21           ; $c31f: a9 21     
            sta vDataAddress            ; $c321: 85 53     
            ldy #$00           ; $c323: a0 00     
            lda vNestling1State            ; $c325: a5 8c     
            cmp vNestlingAwayState            ; $c327: c5 65     
				beq __return5         ; $c329: f0 1a     
            lda __nestling1Pos,x       ; $c32b: bd 64 c3  
            sta vDataAddressHi            ; $c32e: 85 54     
            jmp __updateNestlingState         ; $c330: 4c 6d c3  

;-------------------------------------------------------------------------------
__handleNestling2:     
			iny                ; $c333: c8        
            lda vNestling2State            ; $c334: a5 8d     
            cmp vNestlingAwayState            ; $c336: c5 65     
				beq __return5         ; $c338: f0 0b     
            jsr __levelModulo4         ; $c33a: 20 5e c3  
            lda __nestling2Pos,x       ; $c33d: bd 67 c3  
            sta vDataAddressHi            ; $c340: 85 54     
            jsr __updateNestlingState         ; $c342: 20 6d c3  
__return5:     
			rts                ; $c345: 60        

;-------------------------------------------------------------------------------
__handleNestling3:     
			lda vCurrentLevel            ; $c346: a5 55     
			; 3rd nestling only on level >=13
            cmp #$10           ; $c348: c9 10     
				bcc __return5         ; $c34a: 90 f9     
            iny                ; $c34c: c8        
            lda vNestling3State            ; $c34d: a5 8e     
            cmp vNestlingAwayState            ; $c34f: c5 65     
				beq __return5         ; $c351: f0 f2     
            jsr __levelModulo4         ; $c353: 20 5e c3  
            lda __nestling3Pos,x       ; $c356: bd 6a c3  
            sta vDataAddressHi            ; $c359: 85 54     
            jmp __updateNestlingState         ; $c35b: 4c 6d c3  

;-------------------------------------------------------------------------------
; gets modulo 4 of current level
__levelModulo4:     
			lda vCurrentLevel            ; $c35e: a5 55     
            and #$03           ; $c360: 29 03     
            tax                ; $c362: aa        
            rts                ; $c363: 60        

;-------------------------------------------------------------------------------
__nestling1Pos:     
			.hex d0 98 88      ; $c364: d0 98 88      Data
__nestling2Pos:     
			.hex d2 9a 8a      ; $c367: d2 9a 8a      Data
__nestling3Pos:     
			.hex d4 9c 8c      ; $c36a: d4 9c 8c      Data

;-------------------------------------------------------------------------------
__updateNestlingState:     
			jsr __setPPUAddressFromData         ; $c36d: 20 04 c4  
            lda vNestling1Timer,y        ; $c370: b9 05 02  
            cmp #$40           ; $c373: c9 40     
            bcc __setNestlingFed         ; $c375: 90 33     
            cmp #$a0           ; $c377: c9 a0     
            bcc __setNestlingSlightlyHungry         ; $c379: 90 0a     
            cmp #$e0           ; $c37b: c9 e0     
            bcc __setNestlingHungry         ; $c37d: 90 25     
            cmp #$f0           ; $c37f: c9 f0     
            bcc __setNestlingDying1         ; $c381: 90 31     
            bcs __setNestlingDying2         ; $c383: b0 2a     
__setNestlingSlightlyHungry:     
			jsr __setXEvery8Cycle         ; $c385: 20 8b d0  
__updateNestlingFrame:     
			lda __nestlingFrame1,x       ; $c388: bd b9 c3  
            sta ppuData          ; $c38b: 8d 07 20  
            lda __nestlingFrame2,x       ; $c38e: bd bf c3  
            sta ppuData          ; $c391: 8d 07 20  
            jsr __setPPUAddressIncrementFromData         ; $c394: 20 0f c4  
            lda __nestlingFrame3,x       ; $c397: bd c5 c3  
            sta ppuData          ; $c39a: 8d 07 20  
            lda __nestlingFrame4,x       ; $c39d: bd cb c3  
            sta ppuData          ; $c3a0: 8d 07 20  
            rts                ; $c3a3: 60        

;-------------------------------------------------------------------------------
__setNestlingHungry:     
			jsr __setXEvery4Cycle         ; $c3a4: 20 93 d0  
            jmp __updateNestlingFrame         ; $c3a7: 4c 88 c3  

;-------------------------------------------------------------------------------
__setNestlingFed:     
			ldx #$00           ; $c3aa: a2 00     
            jmp __updateNestlingFrame         ; $c3ac: 4c 88 c3  

;-------------------------------------------------------------------------------
__setNestlingDying2:     
			ldx #$05           ; $c3af: a2 05     
            jmp __updateNestlingFrame         ; $c3b1: 4c 88 c3  

;-------------------------------------------------------------------------------
__setNestlingDying1:     
			ldx #$04           ; $c3b4: a2 04     
            jmp __updateNestlingFrame         ; $c3b6: 4c 88 c3  

;-------------------------------------------------------------------------------
__nestlingFrame1:     
			.hex e0 e4 ec e8   ; $c3b9: e0 e4 ec e8   Data
            .hex 7e 7e         ; $c3bd: 7e 7e         Data
__nestlingFrame2:     
			.hex e1 e5 ed e9   ; $c3bf: e1 e5 ed e9   Data
            .hex f1 f0         ; $c3c3: f1 f0         Data
__nestlingFrame3:     
			.hex e2 e6 ee ea   ; $c3c5: e2 e6 ee ea   Data
            .hex 7e 7e         ; $c3c9: 7e 7e         Data
__nestlingFrame4:     
			.hex e3 e7 ef eb   ; $c3cb: e3 e7 ef eb   Data
            .hex f3 f2         ; $c3cf: f3 f2         Data

;-------------------------------------------------------------------------------
__c3d1:     jsr __setPPUIncrementBy32         ; $c3d1: 20 e4 fe  
            jsr __setPPUAddressFromData         ; $c3d4: 20 04 c4  
            lda ___nestlingFrame1,x       ; $c3d7: bd 1c c4  
            sta ppuData          ; $c3da: 8d 07 20  
            lda ___nestlingFrame2,x       ; $c3dd: bd 26 c4  
            sta ppuData          ; $c3e0: 8d 07 20  
            jsr __setPPUAddressIncrementFromData         ; $c3e3: 20 0f c4  
            lda ___nestlingFrame3,x       ; $c3e6: bd 30 c4  
            sta ppuData          ; $c3e9: 8d 07 20  
            lda ___nestlingFrame4,x       ; $c3ec: bd 3a c4  
            sta ppuData          ; $c3ef: 8d 07 20  
            jsr __setPPUIncrementBy1         ; $c3f2: 20 da fe  
            jsr __scrollScreen         ; $c3f5: 20 b6 fd  
			
			; freeze game
            lda vGameState            ; $c3f8: a5 50     
            cmp #$ff           ; $c3fa: c9 ff     
            bne __c401         ; $c3fc: d0 03     
            jsr __c29f         ; $c3fe: 20 9f c2  
__c401:     jmp __c122         ; $c401: 4c 22 c1  

;-------------------------------------------------------------------------------
__setPPUAddressFromData:     
			lda vDataAddress            ; $c404: a5 53     
            sta ppuAddress          ; $c406: 8d 06 20  
            lda vDataAddressHi            ; $c409: a5 54     
            sta ppuAddress          ; $c40b: 8d 06 20  
            rts                ; $c40e: 60        

;-------------------------------------------------------------------------------
__setPPUAddressIncrementFromData:     
			lda vDataAddress            ; $c40f: a5 53     
            sta ppuAddress          ; $c411: 8d 06 20  
            inc vDataAddressHi            ; $c414: e6 54     
            lda vDataAddressHi            ; $c416: a5 54     
            sta ppuAddress          ; $c418: 8d 06 20  
            rts                ; $c41b: 60        

;-------------------------------------------------------------------------------
___nestlingFrame1:     
			.hex e0 e4 ec e8   ; $c41c: e0 e4 ec e8   Data
            .hex f4 fc f8 fc   ; $c420: f4 fc f8 fc   Data
            .hex 7e 7a         ; $c424: 7e 7a         Data
___nestlingFrame2:     
			.hex e1 e5 ed e9   ; $c426: e1 e5 ed e9   Data
            .hex f5 fd f9 fd   ; $c42a: f5 fd f9 fd   Data
            .hex 7e 7a         ; $c42e: 7e 7a         Data
___nestlingFrame3:     
			.hex e2 e6 ee ea   ; $c430: e2 e6 ee ea   Data
            .hex f6 fe fa fe   ; $c434: f6 fe fa fe   Data
            .hex 7e 7a         ; $c438: 7e 7a         Data
___nestlingFrame4:     
			.hex e3 e7 ef eb   ; $c43a: e3 e7 ef eb   Data
            .hex f7 ff fb ff   ; $c43e: f7 ff fb ff   Data
            .hex 7e 7a         ; $c442: 7e 7a         Data

;-------------------------------------------------------------------------------
__c444:     lda $5e            ; $c444: a5 5e     
            bne __c449         ; $c446: d0 01     
            rts                ; $c448: 60        

;-------------------------------------------------------------------------------
__c449:     lda #$ff           ; $c449: a9 ff     
            sta vGameState            ; $c44b: 85 50     
            lda #$00           ; $c44d: a9 00     
            sta vMusicPlayerState            ; $c44f: 85 20     
            sta vSoundPlayerState            ; $c451: 85 2a     
            rts                ; $c453: 60        

;-------------------------------------------------------------------------------
__c454:     lda $ab            ; $c454: a5 ab     
            bne __c4a1         ; $c456: d0 49     
            ldx #$00           ; $c458: a2 00     
__c45a:     lda vBeeX,x          ; $c45a: b5 70     
            sta vBirdOffsetX            ; $c45c: 85 5c     
            jsr __d4e5         ; $c45e: 20 e5 d4  
            lda vBirdOffsetX            ; $c461: a5 5c     
            tay                ; $c463: a8        
            and #$01           ; $c464: 29 01     
            bne __c485         ; $c466: d0 1d     
            cpy #$74           ; $c468: c0 74     
            bcc __c485         ; $c46a: 90 19     
            cpy #$7d           ; $c46c: c0 7d     
            bcs __c485         ; $c46e: b0 15     
            lda vSpriteTable          ; $c470: ad 00 07  
            sec                ; $c473: 38        
            sbc #$0a           ; $c474: e9 0a     
            cmp vBeeY,x          ; $c476: d5 90     
            bcs __c485         ; $c478: b0 0b     
            clc                ; $c47a: 18        
            adc #$10           ; $c47b: 69 10     
            cmp vBeeY,x          ; $c47d: d5 90     
            bcc __c485         ; $c47f: 90 04     
            lda #$01           ; $c481: a9 01     
            sta $b0,x          ; $c483: 95 b0     
__c485:     inx                ; $c485: e8        
            cpx #$03           ; $c486: e0 03     
            beq __c4a2         ; $c488: f0 18     
            cpx #$07           ; $c48a: e0 07     
            beq __c4b7         ; $c48c: f0 29     
            cpx #$0a           ; $c48e: e0 0a     
            beq __c4c3         ; $c490: f0 31     
            cpx #$13           ; $c492: e0 13     
            bne __c45a         ; $c494: d0 c4     
            jsr __levelModulo4         ; $c496: 20 5e c3  
            cpx #$03           ; $c499: e0 03     
            bne __c4a1         ; $c49b: d0 04     
            lda #$00           ; $c49d: a9 00     
            sta vInvulnTimer            ; $c49f: 85 bf     
__c4a1:     rts                ; $c4a1: 60        

;-------------------------------------------------------------------------------
__c4a2:     lda $b0,x          ; $c4a2: b5 b0     
            beq __c4a8         ; $c4a4: f0 02     
            bne __c4b2         ; $c4a6: d0 0a     
__c4a8:     inx                ; $c4a8: e8        
            cpx #$07           ; $c4a9: e0 07     
            bne __c4a2         ; $c4ab: d0 f5     
            ldx #$03           ; $c4ad: a2 03     
            jmp __c45a         ; $c4af: 4c 5a c4  

;-------------------------------------------------------------------------------
__c4b2:     ldx #$06           ; $c4b2: a2 06     
            jmp __c485         ; $c4b4: 4c 85 c4  

;-------------------------------------------------------------------------------
__c4b7:     lda $e0            ; $c4b7: a5 e0     
            cmp #$02           ; $c4b9: c9 02     
            bcc __c485         ; $c4bb: 90 c8     
            cmp #$0c           ; $c4bd: c9 0c     
            bcc __c45a         ; $c4bf: 90 99     
            bcs __c485         ; $c4c1: b0 c2     
__c4c3:     lda $e7            ; $c4c3: a5 e7     
            bne __c485         ; $c4c5: d0 be     
            lda $ba            ; $c4c7: a5 ba     
            beq __c45a         ; $c4c9: f0 8f     
            .hex ad a6 00      ; $c4cb: ad a6 00  Bad Addr Mode - LDA $00a6
            bne __c4d6         ; $c4ce: d0 06     
            lda #$02           ; $c4d0: a9 02     
            sta vSoundPlayerState            ; $c4d2: 85 2a     
            inc $e7            ; $c4d4: e6 e7     
__c4d6:     jmp __c485         ; $c4d6: 4c 85 c4  

;-------------------------------------------------------------------------------
__c4d9:     lda $9a            ; $c4d9: a5 9a     
            cmp #$cc           ; $c4db: c9 cc     
            bcs __c52f         ; $c4dd: b0 50     
            ldx $0211          ; $c4df: ae 11 02  
            bne __c4f2         ; $c4e2: d0 0e     
            sec                ; $c4e4: 38        
            sbc #$04           ; $c4e5: e9 04     
            cmp vKiteY1            ; $c4e7: c5 98     
            bcs __c4f2         ; $c4e9: b0 07     
            clc                ; $c4eb: 18        
            adc #$10           ; $c4ec: 69 10     
            cmp vKiteY1            ; $c4ee: c5 98     
            bcs __c54c         ; $c4f0: b0 5a     
__c4f2:     lda $9a            ; $c4f2: a5 9a     
            ldx vIsCreatureDead          ; $c4f4: ae 10 02  
            bne __c4ff         ; $c4f7: d0 06     
            jsr __clearXY         ; $c4f9: 20 16 d7  
            jsr __c571         ; $c4fc: 20 71 c5  
__c4ff:     ldx $0213          ; $c4ff: ae 13 02  
            bne __c50b         ; $c502: d0 07     
            ldx #$10           ; $c504: a2 10     
            ldy #$03           ; $c506: a0 03     
            jsr __c571         ; $c508: 20 71 c5  
__c50b:     ldx $0214          ; $c50b: ae 14 02  
            bne __c517         ; $c50e: d0 07     
            ldx #$0e           ; $c510: a2 0e     
            ldy #$04           ; $c512: a0 04     
            jsr __c571         ; $c514: 20 71 c5  
__c517:     ldx $0215          ; $c517: ae 15 02  
            bne __c523         ; $c51a: d0 07     
            ldx #$01           ; $c51c: a2 01     
            ldy #$05           ; $c51e: a0 05     
            jsr __c571         ; $c520: 20 71 c5  
__c523:     ldx $0212          ; $c523: ae 12 02  
            bne __c52f         ; $c526: d0 07     
            ldx #$0b           ; $c528: a2 0b     
            ldy #$02           ; $c52a: a0 02     
            jsr __c571         ; $c52c: 20 71 c5  
__c52f:     rts                ; $c52f: 60        

;-------------------------------------------------------------------------------
__c530:     lda vBeeX,x          ; $c530: b5 70     
            sec                ; $c532: 38        
            sbc #$04           ; $c533: e9 04     
            cmp $7a            ; $c535: c5 7a     
            bpl __c549         ; $c537: 10 10     
            clc                ; $c539: 18        
            adc #$08           ; $c53a: 69 08     
            cmp $7a            ; $c53c: c5 7a     
            bmi __c549         ; $c53e: 30 09     
            lda #$01           ; $c540: a9 01     
            sta vIsCreatureDead,y        ; $c542: 99 10 02  
__c545:     lda #$03           ; $c545: a9 03     
            sta vSoundPlayerState            ; $c547: 85 2a     
__c549:     jmp __c57f         ; $c549: 4c 7f c5  

;-------------------------------------------------------------------------------
__c54c:     jsr __clearXY         ; $c54c: 20 16 d7  
__c54f:     lda vKiteX1,x          ; $c54f: b5 78     
            sec                ; $c551: 38        
            sbc #$04           ; $c552: e9 04     
            cmp $7a            ; $c554: c5 7a     
            bpl __c4f2         ; $c556: 10 9a     
            clc                ; $c558: 18        
            adc #$10           ; $c559: 69 10     
            cmp $7a            ; $c55b: c5 7a     
            bmi __c4f2         ; $c55d: 30 93     
            ldx $0211,y        ; $c55f: be 11 02  
            inx                ; $c562: e8        
            txa                ; $c563: 8a        
            sta $0211,y        ; $c564: 99 11 02  
            jmp __c545         ; $c567: 4c 45 c5  

;-------------------------------------------------------------------------------
            ldx #$03           ; $c56a: a2 03     
            ldy #$01           ; $c56c: a0 01     
            jmp __c54f         ; $c56e: 4c 4f c5  

;-------------------------------------------------------------------------------
__c571:     sec                ; $c571: 38        
            sbc #$04           ; $c572: e9 04     
            cmp vBeeY,x          ; $c574: d5 90     
            bcs __c57f         ; $c576: b0 07     
            clc                ; $c578: 18        
            adc #$10           ; $c579: 69 10     
            cmp vBeeY,x          ; $c57b: d5 90     
            bcs __c530         ; $c57d: b0 b1     
__c57f:     lda $9a            ; $c57f: a5 9a     
            rts                ; $c581: 60        

;-------------------------------------------------------------------------------
__c582:     ldx #$00           ; $c582: a2 00     
            lda $b0,x          ; $c584: b5 b0     
            beq __c595         ; $c586: f0 0d     
            lda #$01           ; $c588: a9 01     
            sta $66            ; $c58a: 85 66     
            lda vInvulnTimer            ; $c58c: a5 bf     
            bne __c592         ; $c58e: d0 02     
            inc $5e            ; $c590: e6 5e     
__c592:     jsr __c5eb         ; $c592: 20 eb c5  
__c595:     lda $b1            ; $c595: a5 b1     
            beq __c5a7         ; $c597: f0 0e     
            lda #$01           ; $c599: a9 01     
            sta $0294          ; $c59b: 8d 94 02  
            lda vInvulnTimer            ; $c59e: a5 bf     
            bne __c5a4         ; $c5a0: d0 02     
            inc $5e            ; $c5a2: e6 5e     
__c5a4:     jsr __c5eb         ; $c5a4: 20 eb c5  
__c5a7:     lda $b8            ; $c5a7: a5 b8     
            clc                ; $c5a9: 18        
            adc $b9            ; $c5aa: 65 b9     
            beq __c5bb         ; $c5ac: f0 0d     
            lda #$01           ; $c5ae: a9 01     
            sta $86            ; $c5b0: 85 86     
            lda vInvulnTimer            ; $c5b2: a5 bf     
            bne __c5b8         ; $c5b4: d0 02     
            inc $5e            ; $c5b6: e6 5e     
__c5b8:     jsr __c5eb         ; $c5b8: 20 eb c5  
__c5bb:     lda $bb            ; $c5bb: a5 bb     
            beq __c5cc         ; $c5bd: f0 0d     
            lda #$01           ; $c5bf: a9 01     
            sta $a8            ; $c5c1: 85 a8     
            lda vInvulnTimer            ; $c5c3: a5 bf     
            bne __c5c9         ; $c5c5: d0 02     
            inc $5e            ; $c5c7: e6 5e     
__c5c9:     jsr __c5eb         ; $c5c9: 20 eb c5  
__c5cc:     lda $be            ; $c5cc: a5 be     
            beq __c5da         ; $c5ce: f0 0a     
            lda #$01           ; $c5d0: a9 01     
            sta $88            ; $c5d2: 85 88     
            lda vInvulnTimer            ; $c5d4: a5 bf     
            bne __c5da         ; $c5d6: d0 02     
            inc $5e            ; $c5d8: e6 5e     
__c5da:     lda $c0            ; $c5da: a5 c0     
            beq __c5fc         ; $c5dc: f0 1e     
            lda #$01           ; $c5de: a9 01     
            sta $8a            ; $c5e0: 85 8a     
            lda vInvulnTimer            ; $c5e2: a5 bf     
            bne __c5e8         ; $c5e4: d0 02     
            inc $5e            ; $c5e6: e6 5e     
__c5e8:     jmp __c5eb         ; $c5e8: 4c eb c5  

;-------------------------------------------------------------------------------
__c5eb:     stx $51            ; $c5eb: 86 51     
            lda vInvulnTimer            ; $c5ed: a5 bf     
            bne __c5fc         ; $c5ef: d0 0b     
            ldx #$00           ; $c5f1: a2 00     
__c5f3:     lda vButterflyXCaught,x          ; $c5f3: b5 b3     
            bne __c5ff         ; $c5f5: d0 08     
__c5f7:     inx                ; $c5f7: e8        
            cpx #$04           ; $c5f8: e0 04     
            bne __c5f3         ; $c5fa: d0 f7     
__c5fc:     ldx $51            ; $c5fc: a6 51     
            rts                ; $c5fe: 60        

;-------------------------------------------------------------------------------
__c5ff:     lda #$f0           ; $c5ff: a9 f0     
            sta vButterfly1Y,x          ; $c601: 95 93     
            lda #$00           ; $c603: a9 00     
            sta vButterflyXCaught,x          ; $c605: 95 b3     
            jmp __c5f7         ; $c607: 4c f7 c5  

;-------------------------------------------------------------------------------
__c60a:     lda vDemoSequenceActive          ; $c60a: ad 73 02  
            bne __c635         ; $c60d: d0 26     
__c60f:     lda vInvulnTimer            ; $c60f: a5 bf     
				bne __c625         ; $c611: d0 12     
            lda $66            ; $c613: a5 66     
            clc                ; $c615: 18        
            adc $86            ; $c616: 65 86     
            adc $87            ; $c618: 65 87     
            adc $88            ; $c61a: 65 88     
            adc $a8            ; $c61c: 65 a8     
            adc $8a            ; $c61e: 65 8a     
            adc $0294          ; $c620: 6d 94 02  
            bne __c644         ; $c623: d0 1f     
__c625:     lda vNestlingIsRising            ; $c625: a5 a4     
            bne __c641         ; $c627: d0 18     
            lda vCurrentLevel            ; $c629: a5 55     
            cmp #$10           ; $c62b: c9 10     
            bcc __c632         ; $c62d: 90 03     
            jmp __c7e7         ; $c62f: 4c e7 c7  

;-------------------------------------------------------------------------------
__c632:     jmp __c6b7         ; $c632: 4c b7 c6  

;-------------------------------------------------------------------------------
__c635:     lda vPlayerInput            ; $c635: a5 0a     
            beq __c60f         ; $c637: f0 d6     
            lda #$f0           ; $c639: a9 f0     
            sta vNestlingCountSprite          ; $c63b: 8d 60 07  
            jmp __c69c         ; $c63e: 4c 9c c6  

;-------------------------------------------------------------------------------
__c641:     jmp __c6e5         ; $c641: 4c e5 c6  

;-------------------------------------------------------------------------------
__c644:     jsr __f618         ; $c644: 20 18 f6  
            jsr __f5e8         ; $c647: 20 e8 f5  
            lda vBirdFallState            ; $c64a: a5 d2     
            beq __c657         ; $c64c: f0 09     
            cmp #$01           ; $c64e: c9 01     
            beq __c665         ; $c650: f0 13     
            cmp #$02           ; $c652: c9 02     
            beq __c6a9         ; $c654: f0 53     
            rts                ; $c656: 60        

;-------------------------------------------------------------------------------
__c657:     lda vDemoSequenceActive          ; $c657: ad 73 02  
				bne __birdFalls         ; $c65a: d0 04     
            lda #$06           ; $c65c: a9 06     
            sta vMusicPlayerState            ; $c65e: 85 20     
__birdFalls:     
			inc vBirdFallState            ; $c660: e6 d2     
            jmp __c122         ; $c662: 4c 22 c1  

;-------------------------------------------------------------------------------
__c665:     jsr __dc9e         ; $c665: 20 9e dc  
            jsr __d48a         ; $c668: 20 8a d4  
            lda vBirdSpritePosY          ; $c66b: ad 00 07  
            cmp #$c8           ; $c66e: c9 c8     
            beq __c68e         ; $c670: f0 1c     
            inc vBirdSpritePosY          ; $c672: ee 00 07  
            lda vMusicPlayerState            ; $c675: a5 20     
            bne __c682         ; $c677: d0 09     
            lda vDemoSequenceActive          ; $c679: ad 73 02  
            bne __c682         ; $c67c: d0 04     
            lda #$06           ; $c67e: a9 06     
            sta vMusicPlayerState            ; $c680: 85 20     
__c682:     jsr __setXEvery8Cycle         ; $c682: 20 8b d0  
__c685:     lda __c6b2,x       ; $c685: bd b2 c6  
            sta $0701          ; $c688: 8d 01 07  
            jmp __c122         ; $c68b: 4c 22 c1  

;-------------------------------------------------------------------------------
__c68e:     lda vDemoSequenceActive          ; $c68e: ad 73 02  
            bne __c69c         ; $c691: d0 09     
            inc vBirdFallState            ; $c693: e6 d2     
            lda #$07           ; $c695: a9 07     
            sta vMusicPlayerState            ; $c697: 85 20     
            jmp __c122         ; $c699: 4c 22 c1  

;-------------------------------------------------------------------------------
__c69c:     jsr __clearBirdNametable         ; $c69c: 20 a2 c6  
            jmp __f467         ; $c69f: 4c 67 f4  

;-------------------------------------------------------------------------------
__clearBirdNametable:     
			lda #$00           ; $c6a2: a9 00     
            sta vBirdPPUNametable            ; $c6a4: 85 02     
            sta vBirdPPUX            ; $c6a6: 85 03     
            rts                ; $c6a8: 60        

;-------------------------------------------------------------------------------
__c6a9:     lda vMusicPlayerState            ; $c6a9: a5 20     
            beq __c70c         ; $c6ab: f0 5f     
            ldx #$04           ; $c6ad: a2 04     
            jmp __c685         ; $c6af: 4c 85 c6  

;-------------------------------------------------------------------------------
__c6b2:     .hex 12 13 12 13   ; $c6b2: 12 13 12 13   Data
            .hex 14            ; $c6b6: 14            Data

;-------------------------------------------------------------------------------
__c6b7:     jsr __levelModulo4         ; $c6b7: 20 5e c3  
            lda vNestling1State            ; $c6ba: a5 8c     
            cmp vNestlingMaxFeed            ; $c6bc: c5 64     
            beq __c6c7         ; $c6be: f0 07     
            lda vNestling2State            ; $c6c0: a5 8d     
            cmp vNestlingMaxFeed            ; $c6c2: c5 64     
            beq __c6d6         ; $c6c4: f0 10     
            rts                ; $c6c6: 60        

;-------------------------------------------------------------------------------
__c6c7:     lda #$21           ; $c6c7: a9 21     
            sta vDataAddress            ; $c6c9: 85 53     
            lda ___nestling1Pos,x       ; $c6cb: bd 15 c8  
            sta vDataAddressHi            ; $c6ce: 85 54     
            jsr __c81e         ; $c6d0: 20 1e c8  
            jmp __c3d1         ; $c6d3: 4c d1 c3  

;-------------------------------------------------------------------------------
__c6d6:     lda #$21           ; $c6d6: a9 21     
            sta vDataAddress            ; $c6d8: 85 53     
            lda ___nestling2Pos,x       ; $c6da: bd 18 c8  
            sta vDataAddressHi            ; $c6dd: 85 54     
            jsr __c81e         ; $c6df: 20 1e c8  
            jmp __c3d1         ; $c6e2: 4c d1 c3  

;-------------------------------------------------------------------------------
__c6e5:     lda vCycleCounter            ; $c6e5: a5 09     
            and #$01           ; $c6e7: 29 01     
				bne __c6fc         ; $c6e9: d0 11     
            dec $9d            ; $c6eb: c6 9d     
            lda $9d            ; $c6ed: a5 9d     
            cmp #$1a           ; $c6ef: c9 1a     
				beq __c705         ; $c6f1: f0 12     
            jsr __setXEvery4Cycle         ; $c6f3: 20 93 d0  
            lda __c708,x       ; $c6f6: bd 08 c7  
            sta $0739          ; $c6f9: 8d 39 07  
__c6fc:     jsr __c29f         ; $c6fc: 20 9f c2  
            jsr __d48a         ; $c6ff: 20 8a d4  
            jmp __c122         ; $c702: 4c 22 c1  

;-------------------------------------------------------------------------------
__c705:     jmp __c752         ; $c705: 4c 52 c7  

;-------------------------------------------------------------------------------
__c708:     .hex 7f 80 7f 80   ; $c708: 7f 80 7f 80   Data

;-------------------------------------------------------------------------------
__c70c:     jsr __clearBirdNametable         ; $c70c: 20 a2 c6  
            jsr __c776         ; $c70f: 20 76 c7  
            sta $5e            ; $c712: 85 5e     
            lda #$f0           ; $c714: a9 f0     
            sta vWhaleCaterpillarY            ; $c716: 85 9f     
            sta $a2            ; $c718: 85 a2     
            sta $a1            ; $c71a: 85 a1     
            inc vKiteRiseAfterDeath            ; $c71c: e6 67     
            lda #$a0           ; $c71e: a9 a0     
            sta vFoxX            ; $c720: 85 7b     
            lda #$a8           ; $c722: a9 a8     
            sta $7c            ; $c724: 85 7c     
            sta $80            ; $c726: 85 80     
            lda #$d8           ; $c728: a9 d8     
            sta vBeeX            ; $c72a: 85 70     
            sta vKiteX1            ; $c72c: 85 78     
            sta vWoodpeckerSquirrelX            ; $c72e: 85 7e     
            lda #$e0           ; $c730: a9 e0     
            sta $71            ; $c732: 85 71     
            sta vKiteX2            ; $c734: 85 79     
            lda #$e8           ; $c736: a9 e8     
            sta $72            ; $c738: 85 72     
            lda #$02           ; $c73a: a9 02     
            sta vWoodpeckerState            ; $c73c: 85 58     
            dec vBirdLives            ; $c73e: c6 56     
			; if no lives left, start game over seqeuence
            lda vBirdLives            ; $c740: a5 56     
            beq __c74b         ; $c742: f0 07     
			; continue game
            lda #$03           ; $c744: a9 03     
            sta vGameState            ; $c746: 85 50     
            jmp __composeOAMTable         ; $c748: 4c 3b ff  

;-------------------------------------------------------------------------------
__c74b:     lda #$04           ; $c74b: a9 04     
            sta vGameState            ; $c74d: 85 50     
            jmp __composeOAMTable         ; $c74f: 4c 3b ff  

;-------------------------------------------------------------------------------
__c752:     inc vRisedNestlingCount            ; $c752: e6 5f     
            lda #$00           ; $c754: a9 00     
            sta vNestlingIsRising            ; $c756: 85 a4     
            sta vMusicPlayerState            ; $c758: 85 20     
            lda #$f0           ; $c75a: a9 f0     
            sta $9d            ; $c75c: 85 9d     
            lda vCurrentLevel            ; $c75e: a5 55     
            cmp #$10           ; $c760: c9 10     
            bcs __c771         ; $c762: b0 0d     
            lda #$02           ; $c764: a9 02     
__c766:     cmp vRisedNestlingCount            ; $c766: c5 5f     
            beq __c7b8         ; $c768: f0 4e     
            lda #$03           ; $c76a: a9 03     
            sta vGameState            ; $c76c: 85 50     
            jmp __c7cc         ; $c76e: 4c cc c7  

;-------------------------------------------------------------------------------
__c771:     lda #$03           ; $c771: a9 03     
            jmp __c766         ; $c773: 4c 66 c7  

;-------------------------------------------------------------------------------
__c776:     lda #$00           ; $c776: a9 00     
            sta $63            ; $c778: 85 63     
            sta $66            ; $c77a: 85 66     
            sta $86            ; $c77c: 85 86     
            sta $87            ; $c77e: 85 87     
            sta $88            ; $c780: 85 88     
            sta $89            ; $c782: 85 89     
            sta $8a            ; $c784: 85 8a     
            sta $a5            ; $c786: 85 a5     
            sta vTimeFreezeTimer            ; $c788: 85 a6     
            sta $a7            ; $c78a: 85 a7     
            sta $a8            ; $c78c: 85 a8     
            jsr __eff8         ; $c78e: 20 f8 ef  
            sta $b7            ; $c791: 85 b7     
            sta $bc            ; $c793: 85 bc     
            sta vInvulnTimer            ; $c795: 85 bf     
            sta $c1            ; $c797: 85 c1     
            sta $c0            ; $c799: 85 c0     
            sta $c5            ; $c79b: 85 c5     
            sta $be            ; $c79d: 85 be     
            sta vBirdFallState            ; $c79f: 85 d2     
            sta $ea            ; $c7a1: 85 ea     
            sta $eb            ; $c7a3: 85 eb     
__c7a5:     tax                ; $c7a5: aa        
__c7a6:     sta vIsCreatureDead,x        ; $c7a6: 9d 10 02  
            sta $025a,x        ; $c7a9: 9d 5a 02  
            sta $0294,x        ; $c7ac: 9d 94 02  
            sta vStageSelect10s,x        ; $c7af: 9d e1 02  
            inx                ; $c7b2: e8        
            cpx #$06           ; $c7b3: e0 06     
            bne __c7a6         ; $c7b5: d0 ef     
            rts                ; $c7b7: 60        

;-------------------------------------------------------------------------------
__c7b8:     lda #$00           ; $c7b8: a9 00     
            sta vNestling1State            ; $c7ba: 85 8c     
            sta vNestling3State            ; $c7bc: 85 8e     
            sta vNestling2State            ; $c7be: 85 8d     
            sta vRisedNestlingCount            ; $c7c0: 85 5f     
            lda #$fe           ; $c7c2: a9 fe     
            sta vGameState            ; $c7c4: 85 50     
            jsr __increaseNestlingCount         ; $c7c6: 20 09 c2  
            jmp __c7d8         ; $c7c9: 4c d8 c7  

;-------------------------------------------------------------------------------
__c7cc:     jsr __setPPUIncrementBy1         ; $c7cc: 20 da fe  
            jsr __increaseNestlingCount         ; $c7cf: 20 09 c2  
            jsr __showNestlingCountLabel         ; $c7d2: 20 df c1  
            jsr __scrollScreen         ; $c7d5: 20 b6 fd  
__c7d8:     lda #$00           ; $c7d8: a9 00     
            sta $5e            ; $c7da: 85 5e     
            sta $63            ; $c7dc: 85 63     
            sta vBirdFallState            ; $c7de: 85 d2     
            lda #$f8           ; $c7e0: a9 f8     
            sta $9d            ; $c7e2: 85 9d     
            jmp __c29f         ; $c7e4: 4c 9f c2  

;-------------------------------------------------------------------------------
__c7e7:     jsr __levelModulo4         ; $c7e7: 20 5e c3  
            lda vNestling1State            ; $c7ea: a5 8c     
            cmp vNestlingMaxFeed            ; $c7ec: c5 64     
            beq __c7fd         ; $c7ee: f0 0d     
            lda vNestling2State            ; $c7f0: a5 8d     
            cmp vNestlingMaxFeed            ; $c7f2: c5 64     
            beq __c800         ; $c7f4: f0 0a     
            lda vNestling3State            ; $c7f6: a5 8e     
            cmp vNestlingMaxFeed            ; $c7f8: c5 64     
            beq __c803         ; $c7fa: f0 07     
            rts                ; $c7fc: 60        

;-------------------------------------------------------------------------------
__c7fd:     jmp __c6c7         ; $c7fd: 4c c7 c6  

;-------------------------------------------------------------------------------
__c800:     jmp __c6d6         ; $c800: 4c d6 c6  

;-------------------------------------------------------------------------------
__c803:     lda #$21           ; $c803: a9 21     
            sta vDataAddress            ; $c805: 85 53     
            lda ___nestling3Pos,x       ; $c807: bd 1b c8  
            sta vDataAddressHi            ; $c80a: 85 54     
            jsr __c81e         ; $c80c: 20 1e c8  
            jmp __c3d1         ; $c80f: 4c d1 c3  

;-------------------------------------------------------------------------------
            jmp __c6e5         ; $c812: 4c e5 c6  

;-------------------------------------------------------------------------------
___nestling1Pos:     
			.hex d0 98 88      ; $c815: d0 98 88      Data
___nestling2Pos:     
			.hex d2 9a 8a      ; $c818: d2 9a 8a      Data
___nestling3Pos:     
			.hex d4 9c 8c      ; $c81b: d4 9c 8c      Data

;-------------------------------------------------------------------------------
__c81e:     lda vMusicPlayerState            ; $c81e: a5 20     
				bne __c826         ; $c820: d0 04     
			; start bird happy music
            lda #$0d           ; $c822: a9 0d     
            sta vMusicPlayerState            ; $c824: 85 20     
			
__c826:     inc vNestlingHappyTimer            ; $c826: e6 e8     
				beq __c845         ; $c828: f0 1b     
            lda vNestlingHappyTimer            ; $c82a: a5 e8     
            cmp #$60           ; $c82c: c9 60     
				bcc __c836         ; $c82e: 90 06     
            cmp #$b0           ; $c830: c9 b0     
				bcc ___setXEvery4Cycle         ; $c832: 90 05     
				bcs __c83c         ; $c834: b0 06     
__c836:     jmp __setXEvery8Cycle         ; $c836: 4c 8b d0  

;-------------------------------------------------------------------------------
___setXEvery4Cycle:     
			jmp __setXEvery4Cycle         ; $c839: 4c 93 d0  

;-------------------------------------------------------------------------------
__c83c:     jsr __setXEvery4Cycle         ; $c83c: 20 93 d0  
__c83f:     txa                ; $c83f: 8a        
            clc                ; $c840: 18        
            adc #$04           ; $c841: 69 04     
            tax                ; $c843: aa        
            rts                ; $c844: 60        

;-------------------------------------------------------------------------------
__c845:     jsr __levelModulo4         ; $c845: 20 5e c3  
            lda __c879,x       ; $c848: bd 79 c8  
            sta $9d            ; $c84b: 85 9d     
            lda vNestling1State            ; $c84d: a5 8c     
            cmp vNestlingMaxFeed            ; $c84f: c5 64     
            bne __c85b         ; $c851: d0 08     
            inc vNestling1State            ; $c853: e6 8c     
            lda __c87d,x       ; $c855: bd 7d c8  
            jmp __c86e         ; $c858: 4c 6e c8  

;-------------------------------------------------------------------------------
__c85b:     lda vNestling2State            ; $c85b: a5 8d     
            cmp vNestlingMaxFeed            ; $c85d: c5 64     
            bne __c869         ; $c85f: d0 08     
            inc vNestling2State            ; $c861: e6 8d     
            lda __c881,x       ; $c863: bd 81 c8  
            jmp __c86e         ; $c866: 4c 6e c8  

;-------------------------------------------------------------------------------
__c869:     inc vNestling3State            ; $c869: e6 8e     
            lda __c885,x       ; $c86b: bd 85 c8  
__c86e:     sta $7d            ; $c86e: 85 7d     
            lda #$0c           ; $c870: a9 0c     
            sta vMusicPlayerState            ; $c872: 85 20     
            inc vNestlingIsRising            ; $c874: e6 a4     
            ldx #$08           ; $c876: a2 08     
            rts                ; $c878: 60        

;-------------------------------------------------------------------------------
__c879:     .hex 70 60 60 ff   ; $c879: 70 60 60 ff   Data
__c87d:     .hex 40 60 20 ff   ; $c87d: 40 60 20 ff   Data
__c881:     .hex 48 68 28 ff   ; $c881: 48 68 28 ff   Data
__c885:     .hex 50 70 30 ff   ; $c885: 50 70 30 ff   Data

;-------------------------------------------------------------------------------
___scoreScreenLoop:     
			lda vCurrentLevel            ; $c889: a5 55     
            and #$03           ; $c88b: 29 03     
            tay                ; $c88d: a8        
            lda vStageSelectState          ; $c88e: ad e0 02  
            bne __c8a0         ; $c891: d0 0d     
            lda vScoreScreenState            ; $c893: a5 d3     
            beq __c8ab         ; $c895: f0 14     
            cmp #$01           ; $c897: c9 01     
            beq __c8c3         ; $c899: f0 28     
            cmp #$02           ; $c89b: c9 02     
            beq __c8d2         ; $c89d: f0 33     
            rts                ; $c89f: 60        

;-------------------------------------------------------------------------------
__c8a0:     lda #$00           ; $c8a0: a9 00     
            sta vBirdLives            ; $c8a2: 85 56     
            lda #$04           ; $c8a4: a9 04     
            sta vGameState            ; $c8a6: 85 50     
            jmp __c69c         ; $c8a8: 4c 9c c6  

;-------------------------------------------------------------------------------
__c8ab:     jsr __clearBirdNametable         ; $c8ab: 20 a2 c6  
            cpy #$03           ; $c8ae: c0 03     
				bne __c8bc         ; $c8b0: d0 0a     
            lda #$08           ; $c8b2: a9 08     
            sta vMusicPlayerState            ; $c8b4: 85 20     
            jsr __handleMusicAndSound         ; $c8b6: 20 dd f6  
            jmp __e3da         ; $c8b9: 4c da e3  

;-------------------------------------------------------------------------------
__c8bc:     lda #$00           ; $c8bc: a9 00     
            sta vMusicPlayerState            ; $c8be: 85 20     
            jmp __e3da         ; $c8c0: 4c da e3  

;-------------------------------------------------------------------------------
__c8c3:     jsr __drawTotalScoreLabel         ; $c8c3: 20 4a ca  
            jsr __scrollScreen         ; $c8c6: 20 b6 fd  
            jsr __hideSprites         ; $c8c9: 20 d6 fd  
            jsr __handleMusicAndSound         ; $c8cc: 20 dd f6  
            inc vScoreScreenState            ; $c8cf: e6 d3     
            rts                ; $c8d1: 60        

;-------------------------------------------------------------------------------
__c8d2:     lda vCycleCounter            ; $c8d2: a5 09     
            and #$03           ; $c8d4: 29 03     
            bne __c8e8         ; $c8d6: d0 10     
            inc vScoreScreenCounter            ; $c8d8: e6 d4     
            lda vScoreScreenCounter            ; $c8da: a5 d4     
            cmp #$20           ; $c8dc: c9 20     
            beq __c8eb         ; $c8de: f0 0b     
            cpy #$03           ; $c8e0: c0 03     
            beq __c8ee         ; $c8e2: f0 0a     
            cmp #$40           ; $c8e4: c9 40     
            beq __c8fc         ; $c8e6: f0 14     
__c8e8:     jmp __handleMusicAndSound         ; $c8e8: 4c dd f6  

;-------------------------------------------------------------------------------
__c8eb:     jmp __c950         ; $c8eb: 4c 50 c9  

;-------------------------------------------------------------------------------
__c8ee:     lda vMusicPlayerState            ; $c8ee: a5 20     
            bne __c8e8         ; $c8f0: d0 f6     
            lda vBonusItemsCaught            ; $c8f2: a5 8b     
            bne __c8f9         ; $c8f4: d0 03     
            jmp __c98e         ; $c8f6: 4c 8e c9  

;-------------------------------------------------------------------------------
__c8f9:     jmp __c96f         ; $c8f9: 4c 6f c9  

;-------------------------------------------------------------------------------
__c8fc:     lda vCurrentLevel            ; $c8fc: a5 55     
            cmp #$2f           ; $c8fe: c9 2f     
            beq __c945         ; $c900: f0 43     
            inc vCurrentLevel            ; $c902: e6 55     
            lda vNestlingMaxFeed            ; $c904: a5 64     
            cmp #$04           ; $c906: c9 04     
            beq __c90e         ; $c908: f0 04     
            inc vNestlingMaxFeed            ; $c90a: e6 64     
            inc vNestlingAwayState            ; $c90c: e6 65     
__c90e:     lda #$02           ; $c90e: a9 02     
            sta vGameState            ; $c910: 85 50     
            jsr __caf5         ; $c912: 20 f5 ca  
__c915:     jsr __c776         ; $c915: 20 76 c7  
            sta $ba            ; $c918: 85 ba     
            sta $a5            ; $c91a: 85 a5     
            sta vTimeFreezeTimer            ; $c91c: 85 a6     
            sta vScoreScreenState            ; $c91e: 85 d3     
            sta vScoreScreenCounter            ; $c920: 85 d4     
            sta $ec            ; $c922: 85 ec     
            sta $ed            ; $c924: 85 ed     
            sta vBonusScoreScreenCounter            ; $c926: 85 f1     
            sta vIsGameLoading            ; $c928: 85 f6     
            sta vGameLoadingCounter            ; $c92a: 85 f7     
            sta $0228          ; $c92c: 8d 28 02  
            sta $0229          ; $c92f: 8d 29 02  
            sta $022a          ; $c932: 8d 2a 02  
            sta $022b          ; $c935: 8d 2b 02  
            sta $0250          ; $c938: 8d 50 02  
            sta vWhaleCounter          ; $c93b: 8d 52 02  
            lda #$f0           ; $c93e: a9 f0     
            sta $a1            ; $c940: 85 a1     
            sta $a2            ; $c942: 85 a2     
            rts                ; $c944: 60        

;-------------------------------------------------------------------------------
__c945:     lda #$fc           ; $c945: a9 fc     
            sta vGameState            ; $c947: 85 50     
            lda #$20           ; $c949: a9 20     
            sta vCurrentLevel            ; $c94b: 85 55     
            jmp __c915         ; $c94d: 4c 15 c9  

;-------------------------------------------------------------------------------
__c950:     cpy #$03           ; $c950: c0 03     
            beq __c96c         ; $c952: f0 18     
            lda $022b          ; $c954: ad 2b 02  
            bne __drawNoBonusLabel         ; $c957: d0 72     
            lda $022a          ; $c959: ad 2a 02  
            bne __c969         ; $c95c: d0 0b     
            lda $0229          ; $c95e: ad 29 02  
            bne __c966         ; $c961: d0 03     
            jmp __c9e5         ; $c963: 4c e5 c9  

;-------------------------------------------------------------------------------
__c966:     jmp __c9e8         ; $c966: 4c e8 c9  

;-------------------------------------------------------------------------------
__c969:     jmp __c9eb         ; $c969: 4c eb c9  

;-------------------------------------------------------------------------------
__c96c:     jmp __c8e8         ; $c96c: 4c e8 c8  

;-------------------------------------------------------------------------------
__c96f:     lda vBonusItemsCaught            ; $c96f: a5 8b     
            beq __c98e         ; $c971: f0 1b     
            lda vCycleCounter            ; $c973: a5 09     
            and #$0f           ; $c975: 29 0f     
            bne __c98b         ; $c977: d0 12     
            jsr __c99c         ; $c979: 20 9c c9  
            jsr __give100Score         ; $c97c: 20 15 ff  
            jsr __drawTotalScoreLabel         ; $c97f: 20 4a ca  
            jsr __scrollScreen         ; $c982: 20 b6 fd  
            dec vBonusItemsCaught            ; $c985: c6 8b     
            lda #$0f           ; $c987: a9 0f     
            sta vMusicPlayerState            ; $c989: 85 20     
__c98b:     jmp __handleMusicAndSound         ; $c98b: 4c dd f6  

;-------------------------------------------------------------------------------
__c98e:     inc vBonusScoreScreenCounter            ; $c98e: e6 f1     
            lda vBonusScoreScreenCounter            ; $c990: a5 f1     
            cmp #$20           ; $c992: c9 20     
            beq __c999         ; $c994: f0 03     
            jmp __handleMusicAndSound         ; $c996: 4c dd f6  

;-------------------------------------------------------------------------------
__c999:     jmp __c8fc         ; $c999: 4c fc c8  

;-------------------------------------------------------------------------------
__c99c:     lda vBonusItemsCaught            ; $c99c: a5 8b     
            cmp #$0a           ; $c99e: c9 0a     
				bcc __c9c4         ; $c9a0: 90 22     
            lda $0250          ; $c9a2: ad 50 02  
				bne __c9ad         ; $c9a5: d0 06     
            jsr __give1000Score         ; $c9a7: 20 1a ff  
            inc $0250          ; $c9aa: ee 50 02  
__c9ad:     lda #$21           ; $c9ad: a9 21     
            sta ppuAddress          ; $c9af: 8d 06 20  
            lda #$0d           ; $c9b2: a9 0d     
            sta ppuAddress          ; $c9b4: 8d 06 20  
            ldx #$00           ; $c9b7: a2 00     
__c9b9:     lda __goodLabel,x       ; $c9b9: bd c5 c9  
            sta ppuData          ; $c9bc: 8d 07 20  
            inx                ; $c9bf: e8        
            cpx #$06           ; $c9c0: e0 06     
            bne __c9b9         ; $c9c2: d0 f5     
__c9c4:     rts                ; $c9c4: 60        

;-------------------------------------------------------------------------------
__goodLabel:     
			.hex 10 18 18 0d   ; $c9c5: 10 18 18 0d   Data
            .hex 24 27         ; $c9c9: 24 27         Data
__drawNoBonusLabel:     
			lda #$21           ; $c9cb: a9 21     
            sta ppuAddress          ; $c9cd: 8d 06 20  
            lda #$0c           ; $c9d0: a9 0c     
            sta ppuAddress          ; $c9d2: 8d 06 20  
            ldx #$00           ; $c9d5: a2 00     
__drawNoBonusLabelLoop:     
			lda __noBonusLabel,x       ; $c9d7: bd 36 ca  
            sta ppuData          ; $c9da: 8d 07 20  
            inx                ; $c9dd: e8        
            cpx #$08           ; $c9de: e0 08     
            bne __drawNoBonusLabelLoop         ; $c9e0: d0 f5     
            jmp __scrollScreen         ; $c9e2: 4c b6 fd  

;-------------------------------------------------------------------------------
__c9e5:     jsr __give1000Score         ; $c9e5: 20 1a ff  
__c9e8:     jsr __give1000Score         ; $c9e8: 20 1a ff  
__c9eb:     jsr __give1000Score         ; $c9eb: 20 1a ff  
            lda #$21           ; $c9ee: a9 21     
            sta ppuAddress          ; $c9f0: 8d 06 20  
            lda #$08           ; $c9f3: a9 08     
            sta ppuAddress          ; $c9f5: 8d 06 20  
            ldx #$00           ; $c9f8: a2 00     
__c9fa:     lda __bonusLabel,x       ; $c9fa: bd 3e ca  
            sta ppuData          ; $c9fd: 8d 07 20  
            inx                ; $ca00: e8        
            cpx #$0c           ; $ca01: e0 0c     
            bne __c9fa         ; $ca03: d0 f5     
            lda $022a          ; $ca05: ad 2a 02  
            bne __ca31         ; $ca08: d0 27     
            lda $0229          ; $ca0a: ad 29 02  
            bne __ca2c         ; $ca0d: d0 1d     
            lda #$03           ; $ca0f: a9 03     
__ca11:     sta ppuData          ; $ca11: 8d 07 20  
            lda #$00           ; $ca14: a9 00     
            sta ppuData          ; $ca16: 8d 07 20  
            sta ppuData          ; $ca19: 8d 07 20  
            sta ppuData          ; $ca1c: 8d 07 20  
            lda #$0f           ; $ca1f: a9 0f     
            sta vMusicPlayerState            ; $ca21: 85 20     
            jsr __drawTotalScoreLabel         ; $ca23: 20 4a ca  
            jsr __scrollScreen         ; $ca26: 20 b6 fd  
            jmp __handleMusicAndSound         ; $ca29: 4c dd f6  

;-------------------------------------------------------------------------------
__ca2c:     lda #$02           ; $ca2c: a9 02     
            jmp __ca11         ; $ca2e: 4c 11 ca  

;-------------------------------------------------------------------------------
__ca31:     lda #$01           ; $ca31: a9 01     
            jmp __ca11         ; $ca33: 4c 11 ca  

;-------------------------------------------------------------------------------
__noBonusLabel:     
			.hex 17 18 24 0b   ; $ca36: 17 18 24 0b   Data
            .hex 18 17 1e 1c   ; $ca3a: 18 17 1e 1c   Data
__bonusLabel:     
			.hex 0b 18 17 1e   ; $ca3e: 0b 18 17 1e   Data
            .hex 1c 24 24 24   ; $ca42: 1c 24 24 24   Data
            .hex 24 24 24 24   ; $ca46: 24 24 24 24   Data

;-------------------------------------------------------------------------------
; draws "score" on level finished screen
__drawTotalScoreLabel:     
			; set position
			ldx #$00           ; $ca4a: a2 00     
            lda #$20           ; $ca4c: a9 20     
            sta ppuAddress          ; $ca4e: 8d 06 20  
            lda #$c8           ; $ca51: a9 c8     
            sta ppuAddress          ; $ca53: 8d 06 20  
			
__drawTotalScoreLabelLoop:     
			lda __scoreLabel,x       ; $ca56: bd 8c ca  
            sta ppuData          ; $ca59: 8d 07 20  
            inx                ; $ca5c: e8        
            cpx #$05           ; $ca5d: e0 05     
            bne __drawTotalScoreLabelLoop         ; $ca5f: d0 f5     
			
			; set position for score
            lda #$20           ; $ca61: a9 20     
            sta ppuAddress          ; $ca63: 8d 06 20  
            lda #$d0           ; $ca66: a9 d0     
            sta ppuAddress          ; $ca68: 8d 06 20  	
__drawPlayerScore:     
			ldx #$07           ; $ca6b: a2 07     
__drawScoreEmpty:     
			lda vPlayerScore,x        ; $ca6d: bd 00 01  
            bne __drawScoreNumber         ; $ca70: d0 0e     
            lda #$24           ; $ca72: a9 24     
            sta ppuData          ; $ca74: 8d 07 20  
            dex                ; $ca77: ca        
            bne __drawScoreEmpty         ; $ca78: d0 f3     
__drawExtraZero:     
			lda #$00           ; $ca7a: a9 00     
            sta ppuData          ; $ca7c: 8d 07 20  
__return:     rts                ; $ca7f: 60        

;-------------------------------------------------------------------------------
__drawScoreNumber:     
			lda vPlayerScore,x        ; $ca80: bd 00 01  
            sta ppuData          ; $ca83: 8d 07 20  
            dex                ; $ca86: ca        
            bne __drawScoreNumber         ; $ca87: d0 f7     
            jmp __drawExtraZero         ; $ca89: 4c 7a ca  

;-------------------------------------------------------------------------------
__scoreLabel:     
			.hex 1c 0c 18 1b   ; $ca8c: 1c 0c 18 1b   Data
            .hex 0e            ; $ca90: 0e            Data

;-------------------------------------------------------------------------------
__drawScoreLabel:     
			; don't draw score if in bonus level
			jsr __levelModulo4         ; $ca91: 20 5e c3  
            cpx #$03           ; $ca94: e0 03     
				beq __return         ; $ca96: f0 e7   
			
            ldx #$00           ; $ca98: a2 00     
            lda #$20           ; $ca9a: a9 20     
            sta ppuAddress          ; $ca9c: 8d 06 20  
            lda #$69           ; $ca9f: a9 69     
            sta ppuAddress          ; $caa1: 8d 06 20  
__drawScoreLabelLoop:     
			lda __scoreLabel,x       ; $caa4: bd 8c ca  
            sta ppuData          ; $caa7: 8d 07 20  
            inx                ; $caaa: e8        
            cpx #$05           ; $caab: e0 05  
            bne __drawScoreLabelLoop         ; $caad: d0 f5     
			
            lda #$20           ; $caaf: a9 20     
            sta ppuAddress          ; $cab1: 8d 06 20  
            lda #$6e           ; $cab4: a9 6e     
            sta ppuAddress          ; $cab6: 8d 06 20  
            jmp __drawPlayerScore         ; $cab9: 4c 6b ca  

;-------------------------------------------------------------------------------
__cabc:     lda vDemoSequenceActive          ; $cabc: ad 73 02  
            bne __caf4         ; $cabf: d0 33     
            lda vGotExtraLife          ; $cac1: ad 30 02  
            bne __cad6         ; $cac4: d0 10     
            lda $0104          ; $cac6: ad 04 01  
            cmp #$03           ; $cac9: c9 03     
            bcc __cad6         ; $cacb: 90 09     
            inc vGotExtraLife          ; $cacd: ee 30 02  
            inc vBirdLives            ; $cad0: e6 56     
            lda #$04           ; $cad2: a9 04     
            sta vSoundPlayerState            ; $cad4: 85 2a     
__cad6:     lda #$f0           ; $cad6: a9 f0     
            sta $0774          ; $cad8: 8d 74 07  
            sta $0778          ; $cadb: 8d 78 07  
            sta $0770          ; $cade: 8d 70 07  
            ldx #$00           ; $cae1: a2 00     
            ldy vBirdLives            ; $cae3: a4 56     
            dey                ; $cae5: 88        
            beq __caf4         ; $cae6: f0 0c     
__cae8:     lda #$18           ; $cae8: a9 18     
            sta $0770,x        ; $caea: 9d 70 07  
            inx                ; $caed: e8        
            inx                ; $caee: e8        
            inx                ; $caef: e8        
            inx                ; $caf0: e8        
            dey                ; $caf1: 88        
            bne __cae8         ; $caf2: d0 f4     
__caf4:     rts                ; $caf4: 60        

;-------------------------------------------------------------------------------
__caf5:     lda vCurrentLevel            ; $caf5: a5 55     
            and #$03           ; $caf7: 29 03     
            cmp #$03           ; $caf9: c9 03     
            beq __cb11         ; $cafb: f0 14     
            ldx #$00           ; $cafd: a2 00     
__caff:     lda vRoundNumber,x          ; $caff: b5 f2     
            clc                ; $cb01: 18        
            adc #$01           ; $cb02: 69 01     
            cmp #$0a           ; $cb04: c9 0a     
            bne __cb12         ; $cb06: d0 0a     
            lda #$00           ; $cb08: a9 00     
            sta vRoundNumber,x          ; $cb0a: 95 f2     
            inx                ; $cb0c: e8        
            cpx #$03           ; $cb0d: e0 03     
            bne __caff         ; $cb0f: d0 ee     
__cb11:     rts                ; $cb11: 60        

;-------------------------------------------------------------------------------
__cb12:     sta vRoundNumber,x          ; $cb12: 95 f2     
            rts                ; $cb14: 60        

;-------------------------------------------------------------------------------
; toogle game modes in main menu
__mainMenuHandleSelect:     
			lda vPlayerInput            ; $cb15: a5 0a     
			
			; is Select pressed
            and #$04           ; $cb17: 29 04     
            bne __cb20         ; $cb19: d0 05     
			
            lda #$00           ; $cb1b: a9 00     
            sta $51            ; $cb1d: 85 51     
            rts                ; $cb1f: 60        
			
__cb20:     
			; if select is kept pressed, don't change game mode 
			lda $51            ; $cb20: a5 51     
            bne __cb2a         ; $cb22: d0 06     
			; otherwise select another game mode
            inc vGameMode            ; $cb24: e6 52     
            lda #$01           ; $cb26: a9 01     
            sta $51            ; $cb28: 85 51     
			
__cb2a:     rts                ; $cb2a: 60        

;-------------------------------------------------------------------------------
__drawMainMenuBird:     
			; is it time to show demo play?
			lda vMainMenuCounter            ; $cb2b: a5 57     
            cmp #$20           ; $cb2d: c9 20     
            beq __cb2a         ; $cb2f: f0 f9     
            bcs __cb2a         ; $cb31: b0 f7     
			
            jsr __setPPUIncrementBy32         ; $cb33: 20 e4 fe  
            jsr __clearXY         ; $cb36: 20 16 d7  
			
			; draw bird either on "game start", or "study mode" label
            lda #$22           ; $cb39: a9 22     
            sta ppuAddress          ; $cb3b: 8d 06 20  
            lda #$89           ; $cb3e: a9 89     
            sta ppuAddress          ; $cb40: 8d 06 20  
            lda vGameMode            ; $cb43: a5 52     
            and #$01           ; $cb45: 29 01     
			; is study mode
            bne __mainMenuOnStudyGame         ; $cb47: d0 12 
			
__drawMainMenuBirdLoop:     
			lda __mainMenuBirdImage,x       ; $cb49: bd 35 cc  
            sta ppuData          ; $cb4c: 8d 07 20  
            inx                ; $cb4f: e8        
            iny                ; $cb50: c8        
            cpy #$03           ; $cb51: c0 03     
            bne __drawMainMenuBirdLoop         ; $cb53: d0 f4   
			
            jsr __scrollScreen         ; $cb55: 20 b6 fd  
            jmp __setPPUIncrementBy1         ; $cb58: 4c da fe  

;-------------------------------------------------------------------------------
__mainMenuOnStudyGame:     
			ldx #$03           ; $cb5b: a2 03     
            jmp __drawMainMenuBirdLoop         ; $cb5d: 4c 49 cb  

;-------------------------------------------------------------------------------
__initGameDemo:     jmp ___initGameDemo         ; $cb60: 4c cf cb  

;-------------------------------------------------------------------------------
__cb63:     jmp __cbea         ; $cb63: 4c ea cb  

;-------------------------------------------------------------------------------
__handleMainMenuDemo:     
			lda vMainMenuCounter            ; $cb66: a5 57     
            cmp #$20           ; $cb68: c9 20     
			
            beq __initGameDemo         ; $cb6a: f0 f4     
            bcs __cb63         ; $cb6c: b0 f5     
            jsr __handleStartButton         ; $cb6e: 20 2c c2  
            lda vStartPressedCount            ; $cb71: a5 d1     
            and #$01           ; $cb73: 29 01     
            beq __cbaa         ; $cb75: f0 33     
            lda vGameMode            ; $cb77: a5 52     
            and #$01           ; $cb79: 29 01     
            bne __cba5         ; $cb7b: d0 28     
            lda #$00           ; $cb7d: a9 00     
            sta vCurrentLevel            ; $cb7f: 85 55     
            lda #$01           ; $cb81: a9 01     
            sta vRoundNumber            ; $cb83: 85 f2     
__cb85:     lda #$01           ; $cb85: a9 01     
            sta vStartPressedCount            ; $cb87: 85 d1     
            lda #$03           ; $cb89: a9 03     
            sta vBirdLives            ; $cb8b: 85 56     
            sta vNestlingMaxFeed            ; $cb8d: 85 64     
            lda #$04           ; $cb8f: a9 04     
            sta vNestlingAwayState            ; $cb91: 85 65     
            lda #$00           ; $cb93: a9 00     
            sta $a7            ; $cb95: 85 a7     
            sta vDemoSequenceActive          ; $cb97: 8d 73 02  
            jsr __scrollScreen         ; $cb9a: 20 b6 fd  
            jsr __f596         ; $cb9d: 20 96 f5  
            inc vGameState            ; $cba0: e6 50     
            jmp __composeOAMTable         ; $cba2: 4c 3b ff  

;-------------------------------------------------------------------------------
__cba5:     lda #$fb           ; $cba5: a9 fb     
            sta vGameState            ; $cba7: 85 50     
            rts                ; $cba9: 60        

;-------------------------------------------------------------------------------
__cbaa:     lda vCycleCounter            ; $cbaa: a5 09     
            and #$1f           ; $cbac: 29 1f     
            bne __cbb8         ; $cbae: d0 08     
            lda vMainMenuCounter            ; $cbb0: a5 57     
            cmp #$08           ; $cbb2: c9 08     
            beq __startMainMenuMusic         ; $cbb4: f0 05     
__cbb6:     inc vMainMenuCounter            ; $cbb6: e6 57     
__cbb8:     jmp __c122         ; $cbb8: 4c 22 c1  

;-------------------------------------------------------------------------------
__startMainMenuMusic:     
			lda #$09           ; $cbbb: a9 09     
            sta vMusicPlayerState            ; $cbbd: 85 20     
            lda #$01           ; $cbbf: a9 01     
            sta vDemoSequenceActive          ; $cbc1: 8d 73 02  
            sta vBirdLives            ; $cbc4: 85 56     
            lda #$ff           ; $cbc6: a9 ff     
            sta vNestlingMaxFeed            ; $cbc8: 85 64     
            sta vNestlingAwayState            ; $cbca: 85 65     
            jmp __cbb6         ; $cbcc: 4c b6 cb  

;-------------------------------------------------------------------------------
___initGameDemo:     
			inc vMainMenuCounter            ; $cbcf: e6 57     
            jsr __clearBirdNametable         ; $cbd1: 20 a2 c6  
			
			; select random level to start (exclude bonus levels)
            lda vRandomVar            ; $cbd4: a5 08     
            and #$03           ; $cbd6: 29 03     
            tax                ; $cbd8: aa        
__demoLevelSelectLoop:     
			inx                ; $cbd9: e8        
            cpx #$03           ; $cbda: e0 03     
            beq __demoLevelSelectLoop         ; $cbdc: f0 fb     
			
            stx vCurrentLevel            ; $cbde: 86 55     
            lda #$01           ; $cbe0: a9 01     
            sta vRoundNumber            ; $cbe2: 85 f2     
            jsr __hideSpritesInTable         ; $cbe4: 20 94 fe  
            jmp __initGameLoop         ; $cbe7: 4c 83 c0  

;-------------------------------------------------------------------------------
__cbea:     
			lda vMainMenuCounter            ; $cbea: a5 57     
            cmp #$40           ; $cbec: c9 40     
				beq __cc2a         ; $cbee: f0 3a     
			
            lda vPlayerInput            ; $cbf0: a5 0a     
            and #$0c           ; $cbf2: 29 0c     
				bne __cc2a         ; $cbf4: d0 34   
				
            ldx $0271          ; $cbf6: ae 71 02  
            lda __cc23,x       ; $cbf9: bd 23 cc  
            cmp vMainMenuCounter            ; $cbfc: c5 57     
            beq __cc13         ; $cbfe: f0 13     
__cc00:     ldx $0272          ; $cc00: ae 72 02  
            lda __cc1c,x       ; $cc03: bd 1c cc  
            sta vPlayerInput            ; $cc06: 85 0a     
            lda vCycleCounter            ; $cc08: a5 09     
            and #$1f           ; $cc0a: 29 1f     
            bne __cc10         ; $cc0c: d0 02     
            inc vMainMenuCounter            ; $cc0e: e6 57     
__cc10:     jmp __c0ac         ; $cc10: 4c ac c0  

;-------------------------------------------------------------------------------
__cc13:     inc $0271          ; $cc13: ee 71 02  
            inc $0272          ; $cc16: ee 72 02  
            jmp __cc00         ; $cc19: 4c 00 cc  

;-------------------------------------------------------------------------------
__cc1c:     .hex 80 00 40 10   ; $cc1c: 80 00 40 10   Data
            .hex 80 40 10      ; $cc20: 80 40 10      Data
__cc23:     .hex 24 28 30 32   ; $cc23: 24 28 30 32   Data
            .hex 3a 3c 3e      ; $cc27: 3a 3c 3e      Data

;-------------------------------------------------------------------------------
__cc2a:     
			; hide nestling sprite
			lda #$f0           ; $cc2a: a9 f0     
            sta vNestlingCountSprite          ; $cc2c: 8d 60 07  
            jsr __clearBirdNametable         ; $cc2f: 20 a2 c6  
            jmp __f467         ; $cc32: 4c 67 f4  

;-------------------------------------------------------------------------------
__mainMenuBirdImage:     
			.hex 3d 24 24 24   ; $cc35: 3d 24 24 24   Data
            .hex 24 3f         ; $cc39: 24 3f         Data

;-------------------------------------------------------------------------------
__cc3b:     lda #$00           ; $cc3b: a9 00     
            sta vDemoSequenceActive          ; $cc3d: 8d 73 02  
            jsr __e3da         ; $cc40: 20 da e3  
            inc vStageSelectState          ; $cc43: ee e0 02  
            ldx #$00           ; $cc46: a2 00     
            stx vScoreScreenState            ; $cc48: 86 d3     
            jsr __setRoundLabelPosition         ; $cc4a: 20 d4 c1  
__cc4d:     lda __roundXLabel,x       ; $cc4d: bd 21 c2  
            sta ppuData          ; $cc50: 8d 07 20  
            inx                ; $cc53: e8        
            cpx #$08           ; $cc54: e0 08     
            bne __cc4d         ; $cc56: d0 f5     
            jsr __scrollScreen         ; $cc58: 20 b6 fd  
            jmp __enableNMI         ; $cc5b: 4c c6 fe  

;-------------------------------------------------------------------------------
___studyModeStageSelectLoop:     
			lda vStageSelectState          ; $cc5e: ad e0 02  
            beq __cc3b         ; $cc61: f0 d8     
            lda vCycleCounter            ; $cc63: a5 09     
            and #$0f           ; $cc65: 29 0f     
            bne __drawRoundNumber         ; $cc67: d0 2e     
            lda vPlayerInput            ; $cc69: a5 0a     
            and #$10           ; $cc6b: 29 10     
            beq __cc81         ; $cc6d: f0 12     
            lda vCurrentLevel            ; $cc6f: a5 55     
            cmp #$2e           ; $cc71: c9 2e     
            beq __cc81         ; $cc73: f0 0c     
            inc vCurrentLevel            ; $cc75: e6 55     
            lda vCurrentLevel            ; $cc77: a5 55     
            and #$03           ; $cc79: 29 03     
            cmp #$03           ; $cc7b: c9 03     
            bne __cc81         ; $cc7d: d0 02     
            inc vCurrentLevel            ; $cc7f: e6 55     
__cc81:     lda vPlayerInput            ; $cc81: a5 0a     
            and #$20           ; $cc83: 29 20     
            beq __drawRoundNumber         ; $cc85: f0 10     
            lda vCurrentLevel            ; $cc87: a5 55     
            beq __drawRoundNumber         ; $cc89: f0 0c     
            dec vCurrentLevel            ; $cc8b: c6 55     
            lda vCurrentLevel            ; $cc8d: a5 55     
            and #$03           ; $cc8f: 29 03     
            cmp #$03           ; $cc91: c9 03     
            bne __drawRoundNumber         ; $cc93: d0 02     
            dec vCurrentLevel            ; $cc95: c6 55    			
__drawRoundNumber:     
			lda vCurrentLevel            ; $cc97: a5 55     
            tax                ; $cc99: aa        
            lda __levelLabel10s,x       ; $cc9a: bd 05 cd  
            sta vStageSelect10s          ; $cc9d: 8d e1 02  
            lda __levelLabelOnes,x       ; $cca0: bd d5 cc  
            sta vStageSelectOnes          ; $cca3: 8d e2 02  
            lda #$20           ; $cca6: a9 20     
            sta ppuAddress          ; $cca8: 8d 06 20  
            lda #$d2           ; $ccab: a9 d2     
            sta ppuAddress          ; $ccad: 8d 06 20  
            lda vStageSelect10s          ; $ccb0: ad e1 02  
            sta ppuData          ; $ccb3: 8d 07 20  
            lda vStageSelectOnes          ; $ccb6: ad e2 02  
            sta ppuData          ; $ccb9: 8d 07 20  
            jsr __scrollScreen         ; $ccbc: 20 b6 fd  
            lda vPlayerInput            ; $ccbf: a5 0a     
            and #$02           ; $ccc1: 29 02     
            bne __ccc6         ; $ccc3: d0 01     
            rts                ; $ccc5: 60        

;-------------------------------------------------------------------------------
__ccc6:     lda #$00           ; $ccc6: a9 00     
            sta vStageSelect10s          ; $ccc8: 8d e1 02  
            sta vStageSelectOnes          ; $cccb: 8d e2 02  
            lda #$01           ; $ccce: a9 01     
            sta vGameState            ; $ccd0: 85 50     
            jmp __cb85         ; $ccd2: 4c 85 cb  

;-------------------------------------------------------------------------------
__levelLabelOnes:     
			.hex 01 02 03 03   ; $ccd5: 01 02 03 03   Data
            .hex 04 05 06 06   ; $ccd9: 04 05 06 06   Data
            .hex 07 08 09 09   ; $ccdd: 07 08 09 09   Data
            .hex 00 01 02 02   ; $cce1: 00 01 02 02   Data
            .hex 03 04 05 05   ; $cce5: 03 04 05 05   Data
            .hex 06 07 08 08   ; $cce9: 06 07 08 08   Data
            .hex 09 00 01 01   ; $cced: 09 00 01 01   Data
            .hex 02 03 04 04   ; $ccf1: 02 03 04 04   Data
            .hex 05 06 07 07   ; $ccf5: 05 06 07 07   Data
            .hex 08 09 00 00   ; $ccf9: 08 09 00 00   Data
            .hex 01 02 03 03   ; $ccfd: 01 02 03 03   Data
            .hex 04 05 06 06   ; $cd01: 04 05 06 06   Data
__levelLabel10s:     
			.hex 24 24 24 24   ; $cd05: 24 24 24 24   Data
            .hex 24 24 24 24   ; $cd09: 24 24 24 24   Data
            .hex 24 24 24 24   ; $cd0d: 24 24 24 24   Data
            .hex 01 01 01 01   ; $cd11: 01 01 01 01   Data
            .hex 01 01 01 01   ; $cd15: 01 01 01 01   Data
            .hex 01 01 01 01   ; $cd19: 01 01 01 01   Data
            .hex 01 02 02 02   ; $cd1d: 01 02 02 02   Data
            .hex 02 02 02 02   ; $cd21: 02 02 02 02   Data
            .hex 02 02 02 02   ; $cd25: 02 02 02 02   Data
            .hex 02 02 03 03   ; $cd29: 02 02 03 03   Data
            .hex 03 03 03 03   ; $cd2d: 03 03 03 03   Data
            .hex 03 03 03 03   ; $cd31: 03 03 03 03   Data

;-------------------------------------------------------------------------------
__cd35:     lda #$00           ; $cd35: a9 00     
            sta vMusicPlayerState            ; $cd37: 85 20     
            sta $84            ; $cd39: 85 84     
            sta $85            ; $cd3b: 85 85     
            sta vWoodpeckerState            ; $cd3d: 85 58     
            sta $59            ; $cd3f: 85 59     
            lda #$02           ; $cd41: a9 02     
            sta $0775          ; $cd43: 8d 75 07  
            sta $0779          ; $cd46: 8d 79 07  
            sta $0771          ; $cd49: 8d 71 07  
            sta $0701          ; $cd4c: 8d 01 07  
            lda #$15           ; $cd4f: a9 15     
            sta $072d          ; $cd51: 8d 2d 07  
            lda #$f0           ; $cd54: a9 f0     
            sta $0770          ; $cd56: 8d 70 07  
            sta $0774          ; $cd59: 8d 74 07  
            sta $0778          ; $cd5c: 8d 78 07  
            sta $0764          ; $cd5f: 8d 64 07  
            sta $0768          ; $cd62: 8d 68 07  
            sta $076c          ; $cd65: 8d 6c 07  
            sta $97            ; $cd68: 85 97     
            sta $9c            ; $cd6a: 85 9c     
            sta vBeeX            ; $cd6c: 85 70     
            sta vBeeY            ; $cd6e: 85 90     
            sta $9d            ; $cd70: 85 9d     
            sta vWhaleCaterpillarY            ; $cd72: 85 9f     
            sta $a1            ; $cd74: 85 a1     
            lda #$68           ; $cd76: a9 68     
            sta $0767          ; $cd78: 8d 67 07  
            lda #$71           ; $cd7b: a9 71     
            sta $0765          ; $cd7d: 8d 65 07  
            lda #$78           ; $cd80: a9 78     
            sta $076b          ; $cd82: 8d 6b 07  
            sta $0703          ; $cd85: 8d 03 07  
            lda #$72           ; $cd88: a9 72     
            sta $0769          ; $cd8a: 8d 69 07  
            lda #$88           ; $cd8d: a9 88     
            sta $076f          ; $cd8f: 8d 6f 07  
            lda #$73           ; $cd92: a9 73     
            sta $076d          ; $cd94: 8d 6d 07  
            lda #$c8           ; $cd97: a9 c8     
            sta $0773          ; $cd99: 8d 73 07  
            lda #$d8           ; $cd9c: a9 d8     
            sta $0777          ; $cd9e: 8d 77 07  
            lda #$e8           ; $cda1: a9 e8     
            sta $077b          ; $cda3: 8d 7b 07  
            lda #$15           ; $cda6: a9 15     
            sta $072d          ; $cda8: 8d 2d 07  
            lda #$30           ; $cdab: a9 30     
            sta vBirdSpritePosY          ; $cdad: 8d 00 07  
            jsr __levelModulo4         ; $cdb0: 20 5e c3  
            cpx #$03           ; $cdb3: e0 03     
            beq __cdba         ; $cdb5: f0 03     
            jsr __ce94         ; $cdb7: 20 94 ce  
__cdba:     lda vCurrentLevel            ; $cdba: a5 55     
            and #$07           ; $cdbc: 29 07     
            tay                ; $cdbe: a8        
            lda __cea4,y       ; $cdbf: b9 a4 ce  
            sta $6c            ; $cdc2: 85 6c     
            lda __kiteMaxYChange,y       ; $cdc4: b9 ac ce  
            sta vKiteMaxYChange            ; $cdc7: 85 69     
            ldx #$00           ; $cdc9: a2 00     
            stx $d6            ; $cdcb: 86 d6     
            lda __cecc,y       ; $cdcd: b9 cc ce  
            sta $d7            ; $cdd0: 85 d7     
            lda __ced4,y       ; $cdd2: b9 d4 ce  
            sta $d8            ; $cdd5: 85 d8     
            lda __cedc,y       ; $cdd7: b9 dc ce  
            sta $d9            ; $cdda: 85 d9     
            lda __nestling1StartingTimer,y       ; $cddc: b9 b4 ce  
            sta vNestling1Timer          ; $cddf: 8d 05 02  
            lda __nestling2StartingTimer,y       ; $cde2: b9 bc ce  
            sta vNestling2Timer          ; $cde5: 8d 06 02  
            lda __nestling3StartingTimer,y       ; $cde8: b9 c4 ce  
            sta vNestling3Timer          ; $cdeb: 8d 07 02  
            lda #$b0           ; $cdee: a9 b0     
            sta vKiteX1            ; $cdf0: 85 78     
            lda #$b8           ; $cdf2: a9 b8     
            sta vKiteX2            ; $cdf4: 85 79     
            lda #$a0           ; $cdf6: a9 a0     
            sta vButterfly2X            ; $cdf8: 85 74     
            lda #$b0           ; $cdfa: a9 b0     
            sta vButterfly3X            ; $cdfc: 85 75     
            lda #$c0           ; $cdfe: a9 c0     
            sta vButterfly4X            ; $ce00: 85 76     
            lda #$d0           ; $ce02: a9 d0     
            sta $77            ; $ce04: 85 77     
            sta $80            ; $ce06: 85 80     
            sta vBeeX            ; $ce08: 85 70     
            jsr __levelModulo4         ; $ce0a: 20 5e c3  
            lda __ce15,x       ; $ce0d: bd 15 ce  
            sta vWoodpeckerSquirrelX            ; $ce10: 85 7e     
            jmp __ce19         ; $ce12: 4c 19 ce  

;-------------------------------------------------------------------------------
__ce15:     .hex 3d 5d 98 f0   ; $ce15: 3d 5d 98 f0   Data

;-------------------------------------------------------------------------------
__ce19:     lda vCurrentLevel            ; $ce19: a5 55     
            and #$0f           ; $ce1b: 29 0f     
            tax                ; $ce1d: aa        
            lda __cef4,x       ; $ce1e: bd f4 ce  
            sta vBeeY            ; $ce21: 85 90     
            lda __cee4,x       ; $ce23: bd e4 ce  
            sta vWoodpeckerSquirrelY            ; $ce26: 85 9e     
            lda __cf04,x       ; $ce28: bd 04 cf  
            sta vButterfly1Y            ; $ce2b: 85 93     
            sta vButterfly2Y            ; $ce2d: 85 94     
            sta vButterfly3Y            ; $ce2f: 85 95     
            sta vButterfly4Y            ; $ce31: 85 96     
            lda __cf14,x       ; $ce33: bd 14 cf  
            sta vKiteY1            ; $ce36: 85 98     
            sta vKiteY2            ; $ce38: 85 99     
            lda __cf24,x       ; $ce3a: bd 24 cf  
            sta $9a            ; $ce3d: 85 9a     
            lda #$30           ; $ce3f: a9 30     
            sta $7a            ; $ce41: 85 7a     
            lda __cf34,x       ; $ce43: bd 34 cf  
            sta vFoxY            ; $ce46: 85 9b     
            lda vCurrentLevel            ; $ce48: a5 55     
            and #$07           ; $ce4a: 29 07     
            cmp #$07           ; $ce4c: c9 07     
            bne __ce60         ; $ce4e: d0 10     
            lda #$50           ; $ce50: a9 50     
            sta vButterfly1Y            ; $ce52: 85 93     
            lda #$58           ; $ce54: a9 58     
            sta vButterfly2Y            ; $ce56: 85 94     
            lda #$59           ; $ce58: a9 59     
            sta vButterfly3Y            ; $ce5a: 85 95     
            lda #$40           ; $ce5c: a9 40     
            sta vButterfly4Y            ; $ce5e: 85 96     
__ce60:     lda #$f0           ; $ce60: a9 f0     
            sta $91            ; $ce62: 85 91     
            sta $92            ; $ce64: 85 92     
            sta vOAMTable          ; $ce66: 8d 00 06  
            lda vCurrentLevel            ; $ce69: a5 55     
            cmp #$10           ; $ce6b: c9 10     
            bcc __ce81         ; $ce6d: 90 12     
            and #$0f           ; $ce6f: 29 0f     
            cmp #$0c           ; $ce71: c9 0c     
            bcc __ce81         ; $ce73: 90 0c     
            cmp #$0f           ; $ce75: c9 0f     
            beq __ce81         ; $ce77: f0 08     
            lda #$40           ; $ce79: a9 40     
            sta $91            ; $ce7b: 85 91     
            lda #$b0           ; $ce7d: a9 b0     
            sta $71            ; $ce7f: 85 71     
__ce81:     lda #$b0           ; $ce81: a9 b0     
            sta $80            ; $ce83: 85 80     
            lda __cf44,x       ; $ce85: bd 44 cf  
            sta vHawkY            ; $ce88: 85 a0     
            lda #$01           ; $ce8a: a9 01     
            sta $0261          ; $ce8c: 8d 61 02  
            lda #$02           ; $ce8f: a9 02     
            sta vWoodpeckerState            ; $ce91: 85 58     
            rts                ; $ce93: 60        

;-------------------------------------------------------------------------------
__ce94:     lda #$7f           ; $ce94: a9 7f     
            sta $0761          ; $ce96: 8d 61 07  
            lda #$14           ; $ce99: a9 14     
            sta vNestlingCountSprite          ; $ce9b: 8d 60 07  
            lda #$18           ; $ce9e: a9 18     
            sta $0763          ; $cea0: 8d 63 07  
            rts                ; $cea3: 60        

;-------------------------------------------------------------------------------
__cea4:     .hex 20 28 30 00   ; $cea4: 20 28 30 00   Data
            .hex 30 30 30 00   ; $cea8: 30 30 30 00   Data
__kiteMaxYChange:     .hex 18 20 28 00   ; $ceac: 18 20 28 00   Data
            .hex 28 28 28 00   ; $ceb0: 28 28 28 00   Data
__nestling1StartingTimer:     
			.hex 00 08 00 00   ; $ceb4: 00 08 00 00   Data
            .hex 10 20 18 00   ; $ceb8: 10 20 18 00   Data
__nestling2StartingTimer:     
			.hex 10 00 08 00   ; $cebc: 10 00 08 00   Data
            .hex 30 00 10 00   ; $cec0: 30 00 10 00   Data
__nestling3StartingTimer:     
			.hex 00 20 20 00   ; $cec4: 00 20 20 00   Data
            .hex 08 10 00 00   ; $cec8: 08 10 00 00   Data

__cecc:     .hex 20 30 40 10   ; $cecc: 20 30 40 10   Data
            .hex 30 40 50 20   ; $ced0: 30 40 50 20   Data
__ced4:     .hex 40 60 90 20   ; $ced4: 40 60 90 20   Data
            .hex 80 70 60 40   ; $ced8: 80 70 60 40   Data
__cedc:     .hex 90 80 60 58   ; $cedc: 90 80 60 58   Data
            .hex 50 90 98 58   ; $cee0: 50 90 98 58   Data
__cee4:     .hex f0 f0 90 f0   ; $cee4: f0 f0 90 f0   Data
            .hex 70 80 90 f0   ; $cee8: 70 80 90 f0   Data
            .hex 80 90 80 f0   ; $ceec: 80 90 80 f0   Data
            .hex 70 80 90 f0   ; $cef0: 70 80 90 f0   Data
__cef4:     .hex f0 f0 f0 f0   ; $cef4: f0 f0 f0 f0   Data
            .hex f0 f0 f0 f0   ; $cef8: f0 f0 f0 f0   Data
            .hex f0 f0 f0 f0   ; $cefc: f0 f0 f0 f0   Data
            .hex 40 50 60 f0   ; $cf00: 40 50 60 f0   Data
__cf04:     .hex 40 50 60 d4   ; $cf04: 40 50 60 d4   Data
            .hex 70 50 60 50   ; $cf08: 70 50 60 50   Data
            .hex 50 60 50 d4   ; $cf0c: 50 60 50 d4   Data
            .hex 50 60 70 60   ; $cf10: 50 60 70 60   Data
__cf14:     .hex 50 60 70 f0   ; $cf14: 50 60 70 f0   Data
            .hex 60 70 80 f0   ; $cf18: 60 70 80 f0   Data
            .hex 50 50 60 f0   ; $cf1c: 50 50 60 f0   Data
            .hex 70 80 50 f0   ; $cf20: 70 80 50 f0   Data
__cf24:     .hex c8 c8 c8 f0   ; $cf24: c8 c8 c8 f0   Data
            .hex c8 c8 c8 f0   ; $cf28: c8 c8 c8 f0   Data
            .hex c8 c8 c8 f0   ; $cf2c: c8 c8 c8 f0   Data
            .hex c8 c8 c8 f0   ; $cf30: c8 c8 c8 f0   Data
__cf34:     .hex f0 c8 f0 f0   ; $cf34: f0 c8 f0 f0   Data
            .hex f0 c8 f0 f0   ; $cf38: f0 c8 f0 f0   Data
            .hex f0 c8 c8 f0   ; $cf3c: f0 c8 c8 f0   Data
            .hex f0 c8 c8 f0   ; $cf40: f0 c8 c8 f0   Data
__cf44:     .hex f0 f0 f0 f0   ; $cf44: f0 f0 f0 f0   Data
            .hex f0 f0 c0 f0   ; $cf48: f0 f0 c0 f0   Data
            .hex c0 c0 c0 f0   ; $cf4c: c0 c0 c0 f0   Data
            .hex c0 c0 c0 f0   ; $cf50: c0 c0 c0 f0   Data

;-------------------------------------------------------------------------------
__cf54:     ldy #$01           ; $cf54: a0 01     
            lda #$3c           ; $cf56: a9 3c     
            sta vBirdOffsetX            ; $cf58: 85 5c     
            jsr __d186         ; $cf5a: 20 86 d1  
            jsr __isSeaBonusLevel         ; $cf5d: 20 ee cf  
            beq __cfa2         ; $cf60: f0 40     
            cmp #$07           ; $cf62: c9 07     
            beq __cfa2         ; $cf64: f0 3c     
            lda vBirdOffsetX            ; $cf66: a5 5c     
            and #$01           ; $cf68: 29 01     
            bne __cfa2         ; $cf6a: d0 36     
            jsr __levelModulo4         ; $cf6c: 20 5e c3  
            lda vCurrentLevel            ; $cf6f: a5 55     
            cmp #$10           ; $cf71: c9 10     
            bcs __cfbe         ; $cf73: b0 49     
__cf75:     lda vBirdOffsetX            ; $cf75: a5 5c     
            cmp __d1de,x       ; $cf77: dd de d1  
            bcc __cf8e         ; $cf7a: 90 12     
            cmp __d1e6,x       ; $cf7c: dd e6 d1  
            bcs __cf8e         ; $cf7f: b0 0d     
            lda vSpriteTable          ; $cf81: ad 00 07  
            cmp __d1ee,x       ; $cf84: dd ee d1  
            bcc __cf8e         ; $cf87: 90 05     
            cmp __d1f6,x       ; $cf89: dd f6 d1  
            bcc __cfe5         ; $cf8c: 90 57     
__cf8e:     lda vBirdOffsetX            ; $cf8e: a5 5c     
            cmp __d1fe,x       ; $cf90: dd fe d1  
            bcc __cfa2         ; $cf93: 90 0d     
            cmp __d206,x       ; $cf95: dd 06 d2  
            bcs __cfa2         ; $cf98: b0 08     
            lda vSpriteTable          ; $cf9a: ad 00 07  
            cmp __d1f6,x       ; $cf9d: dd f6 d1  
            beq __cfcb         ; $cfa0: f0 29     
__cfa2:     ldx #$00           ; $cfa2: a2 00     
            lda vSpriteTable          ; $cfa4: ad 00 07  
            cmp #$20           ; $cfa7: c9 20     
            bcc __cfc6         ; $cfa9: 90 1b     
            stx $60            ; $cfab: 86 60     
            cmp #$c8           ; $cfad: c9 c8     
            bcs __cfdc         ; $cfaf: b0 2b     
            stx vIsBirdLanded            ; $cfb1: 86 61     
            cmp #$b8           ; $cfb3: c9 b8     
            bcs __cfe5         ; $cfb5: b0 2e     
            stx vIsBirdLanding            ; $cfb7: 86 62     
__cfb9:     lda #$00           ; $cfb9: a9 00     
            sta $ab            ; $cfbb: 85 ab     
            rts                ; $cfbd: 60        

;-------------------------------------------------------------------------------
__cfbe:     txa                ; $cfbe: 8a        
            clc                ; $cfbf: 18        
            adc #$04           ; $cfc0: 69 04     
            tax                ; $cfc2: aa        
            jmp __cf75         ; $cfc3: 4c 75 cf  

;-------------------------------------------------------------------------------
__cfc6:     sty $60            ; $cfc6: 84 60     
            jmp __cfb9         ; $cfc8: 4c b9 cf  

;-------------------------------------------------------------------------------
__cfcb:     lda vCurrentLevel            ; $cfcb: a5 55     
            cmp #$20           ; $cfcd: c9 20     
            bcs __cfdc         ; $cfcf: b0 0b     
            lda #$00           ; $cfd1: a9 00     
            sta vIsBirdLanding            ; $cfd3: 85 62     
            sty vIsBirdLanded            ; $cfd5: 84 61     
            lda #$01           ; $cfd7: a9 01     
            sta $ab            ; $cfd9: 85 ab     
            rts                ; $cfdb: 60        

;-------------------------------------------------------------------------------
__cfdc:     sty vIsBirdLanded            ; $cfdc: 84 61     
            lda #$00           ; $cfde: a9 00     
            sta vIsBirdLanding            ; $cfe0: 85 62     
            jmp __cfb9         ; $cfe2: 4c b9 cf  

;-------------------------------------------------------------------------------
__cfe5:     sty vIsBirdLanding            ; $cfe5: 84 62     
            lda #$00           ; $cfe7: a9 00     
            sta vIsBirdLanded            ; $cfe9: 85 61     
            jmp __cfb9         ; $cfeb: 4c b9 cf  

;-------------------------------------------------------------------------------
__isSeaBonusLevel:     
			lda vCurrentLevel            ; $cfee: a5 55     
            and #$07           ; $cff0: 29 07     
            cmp #$03           ; $cff2: c9 03     
            rts                ; $cff4: 60        

;-------------------------------------------------------------------------------
__cff5:     lda #$78           ; $cff5: a9 78     
            sta $0703          ; $cff7: 8d 03 07  
            lda vBirdSpritePosY          ; $cffa: ad 00 07  
            cmp #$1e           ; $cffd: c9 1e     
            bcc __d005         ; $cfff: 90 04     
            cmp #$ca           ; $d001: c9 ca     
            bcc __d00d         ; $d003: 90 08     
__d005:     jsr __hideSpritesInTable         ; $d005: 20 94 fe  
            lda #$30           ; $d008: a9 30     
            sta vBirdSpritePosY          ; $d00a: 8d 00 07  
__d00d:     jsr __isSeaBonusLevel         ; $d00d: 20 ee cf  
            bne __handleBirdMovement         ; $d010: d0 07     
            lda vIsBirdLanded            ; $d012: a5 61     
            beq __handleBirdMovement         ; $d014: f0 03     
            jmp __d19d         ; $d016: 4c 9d d1  

;-------------------------------------------------------------------------------
__handleBirdMovement:     	
			lda vCycleCounter            ; $d019: a5 09     
			and #$07           ; $d01b: 29 07     
            beq __birdChangeDirection         ; $d01d: f0 14     
            lda vBirdDirection            ; $d01f: a5 5d     
            beq __birdMoveRight         ; $d021: f0 37     
            cmp #$01           ; $d023: c9 01     
            beq __birdMoveLeft         ; $d025: f0 2c     
            cmp #$02           ; $d027: c9 02     
            beq __birdMoveDown         ; $d029: f0 25     
            cmp #$03           ; $d02b: c9 03     
            beq ___birdMoveUp         ; $d02d: f0 32     
            cmp #$04           ; $d02f: c9 04     
            beq ___birdFreeFall         ; $d031: f0 1a     
			
__birdChangeDirection:     
			lda #$00           ; $d033: a9 00     
            sta vBirdDirection            ; $d035: 85 5d     
            lda vPlayerInput            ; $d037: a5 0a     
            asl                ; $d039: 0a        
            bcs __birdMoveRight         ; $d03a: b0 1e     
            inc vBirdDirection            ; $d03c: e6 5d     
            asl                ; $d03e: 0a        
            bcs __birdMoveLeft         ; $d03f: b0 12     
            inc vBirdDirection            ; $d041: e6 5d     
            asl                ; $d043: 0a        
            bcs __birdMoveDown         ; $d044: b0 0a     
            inc vBirdDirection            ; $d046: e6 5d     
            asl                ; $d048: 0a        
            bcs ___birdMoveUp         ; $d049: b0 16     
            inc vBirdDirection            ; $d04b: e6 5d     
___birdFreeFall:     
			jmp ____birdFreeFall         ; $d04d: 4c 36 d1  

;-------------------------------------------------------------------------------
__birdMoveDown:     
			jmp ___birdMoveDown         ; $d050: 4c 9b d0  

;-------------------------------------------------------------------------------
__birdMoveLeft:     
			lda #$00           ; $d053: a9 00     
            sta vBirdIsRight            ; $d055: 85 5a     
            jmp ___birdMoveLeft         ; $d057: 4c f4 d0  

;-------------------------------------------------------------------------------
__birdMoveRight:     
			lda #$01           ; $d05a: a9 01     
            sta vBirdIsRight            ; $d05c: 85 5a     
            jmp ___birdMoveRight         ; $d05e: 4c 18 d1  

;-------------------------------------------------------------------------------
___birdMoveUp:     
			lda $60            ; $d061: a5 60     
            bne __d068         ; $d063: d0 03     
            dec vBirdSpritePosY          ; $d065: ce 00 07  
__d068:     jsr __setXEvery8Cycle         ; $d068: 20 8b d0  
            lda vBirdIsRight            ; $d06b: a5 5a     
            bne __d072         ; $d06d: d0 03     
            jsr __c83f         ; $d06f: 20 3f c8  
__d072:     jsr __d084         ; $d072: 20 84 d0  
            jsr __isOddCycle         ; $d075: 20 58 d6  
            bne __d08a         ; $d078: d0 10     
            lda vBirdIsRight            ; $d07a: a5 5a     
            bne __d081         ; $d07c: d0 03     
            jmp __d17b         ; $d07e: 4c 7b d1  

;-------------------------------------------------------------------------------
__d081:     jmp __d16e         ; $d081: 4c 6e d1  

;-------------------------------------------------------------------------------
__d084:     lda __d1be,x       ; $d084: bd be d1  
            sta $0701          ; $d087: 8d 01 07  
__d08a:     rts                ; $d08a: 60        

;-------------------------------------------------------------------------------
__setXEvery8Cycle:     
			lda vCycleCounter            ; $d08b: a5 09     
            and #$18           ; $d08d: 29 18     
            lsr                ; $d08f: 4a        
            jmp ___setXEveryCycleNext         ; $d090: 4c 97 d0  

;-------------------------------------------------------------------------------
__setXEvery4Cycle:     
			lda vCycleCounter            ; $d093: a5 09     
            and #$0c           ; $d095: 29 0c     
___setXEveryCycleNext:     
			lsr                ; $d097: 4a        
            lsr                ; $d098: 4a        
            tax                ; $d099: aa        
            rts                ; $d09a: 60        

;-------------------------------------------------------------------------------
___birdMoveDown:     
			lda vIsBirdLanded            ; $d09b: a5 61     
            bne __d0c5         ; $d09d: d0 26     
            lda vIsBirdLanding            ; $d09f: a5 62     
            bne __d0d3         ; $d0a1: d0 30     
            inc vBirdSpritePosY          ; $d0a3: ee 00 07  
            inc vBirdSpritePosY          ; $d0a6: ee 00 07  
            jsr __setXEvery8Cycle         ; $d0a9: 20 8b d0  
            txa                ; $d0ac: 8a        
            clc                ; $d0ad: 18        
            adc #$08           ; $d0ae: 69 08     
            tax                ; $d0b0: aa        
            lda vBirdIsRight            ; $d0b1: a5 5a     
            bne __d0b8         ; $d0b3: d0 03     
            jsr __c83f         ; $d0b5: 20 3f c8  
__d0b8:     jsr __d084         ; $d0b8: 20 84 d0  
__d0bb:     lda vBirdIsRight            ; $d0bb: a5 5a     
            bne __d0c2         ; $d0bd: d0 03     
            jmp __d17b         ; $d0bf: 4c 7b d1  

;-------------------------------------------------------------------------------
__d0c2:     jmp __d16e         ; $d0c2: 4c 6e d1  

;-------------------------------------------------------------------------------
__d0c5:     lda vBirdIsRight            ; $d0c5: a5 5a     
            bne __d0ce         ; $d0c7: d0 05     
            ldx #$11           ; $d0c9: a2 11     
            jmp __d084         ; $d0cb: 4c 84 d0  

;-------------------------------------------------------------------------------
__d0ce:     ldx #$15           ; $d0ce: a2 15     
            jmp __d084         ; $d0d0: 4c 84 d0  

;-------------------------------------------------------------------------------
__d0d3:     jsr __getCycleModulo4         ; $d0d3: 20 5d d6  
            bne __d0db         ; $d0d6: d0 03     
            inc vBirdSpritePosY          ; $d0d8: ee 00 07  
__d0db:     jsr __setXEvery4Cycle         ; $d0db: 20 93 d0  
            txa                ; $d0de: 8a        
            clc                ; $d0df: 18        
            adc #$08           ; $d0e0: 69 08     
            tax                ; $d0e2: aa        
            lda vBirdIsRight            ; $d0e3: a5 5a     
            bne __d0ea         ; $d0e5: d0 03     
            jsr __c83f         ; $d0e7: 20 3f c8  
__d0ea:     jsr __d084         ; $d0ea: 20 84 d0  
            lda vCycleCounter            ; $d0ed: a5 09     
            and #$07           ; $d0ef: 29 07     
            beq __d0bb         ; $d0f1: f0 c8     
            rts                ; $d0f3: 60        

;-------------------------------------------------------------------------------
___birdMoveLeft:     
			lda vIsBirdLanded            ; $d0f4: a5 61     
            bne __d107         ; $d0f6: d0 0f     
            jsr __setXEvery8Cycle         ; $d0f8: 20 8b d0  
            jsr __c83f         ; $d0fb: 20 3f c8  
            lda __d1be,x       ; $d0fe: bd be d1  
            sta $0701          ; $d101: 8d 01 07  
__d104:     jmp __d17b         ; $d104: 4c 7b d1  

;-------------------------------------------------------------------------------
__d107:     jsr __setXEvery8Cycle         ; $d107: 20 8b d0  
            txa                ; $d10a: 8a        
            clc                ; $d10b: 18        
            adc #$10           ; $d10c: 69 10     
            tax                ; $d10e: aa        
            jsr __d084         ; $d10f: 20 84 d0  
            jsr __getCycleModulo4         ; $d112: 20 5d d6  
            beq __d104         ; $d115: f0 ed     
            rts                ; $d117: 60        

;-------------------------------------------------------------------------------
___birdMoveRight:     
			lda vIsBirdLanded            ; $d118: a5 61     
            bne __d125         ; $d11a: d0 09     
            jsr __setXEvery8Cycle         ; $d11c: 20 8b d0  
            jsr __d084         ; $d11f: 20 84 d0  
__d122:     jmp __d16e         ; $d122: 4c 6e d1  

;-------------------------------------------------------------------------------
__d125:     jsr __setXEvery8Cycle         ; $d125: 20 8b d0  
            txa                ; $d128: 8a        
            clc                ; $d129: 18        
            adc #$14           ; $d12a: 69 14     
            tax                ; $d12c: aa        
            jsr __d084         ; $d12d: 20 84 d0  
            jsr __getCycleModulo4         ; $d130: 20 5d d6  
            beq __d122         ; $d133: f0 ed     
            rts                ; $d135: 60        

;-------------------------------------------------------------------------------
____birdFreeFall:     
			lda vIsBirdLanded            ; $d136: a5 61     
            bne __d15d         ; $d138: d0 23     
            lda vIsBirdLanding            ; $d13a: a5 62     
            bne __d16b         ; $d13c: d0 2d     
            jsr __setXEvery8Cycle         ; $d13e: 20 8b d0  
            lda vBirdIsRight            ; $d141: a5 5a     
            bne __d148         ; $d143: d0 03     
            jsr __c83f         ; $d145: 20 3f c8  
__d148:     jsr __d084         ; $d148: 20 84 d0  
            jsr __isOddCycle         ; $d14b: 20 58 d6  
            bne __d153         ; $d14e: d0 03     
            inc vBirdSpritePosY          ; $d150: ee 00 07  
__d153:     lda vBirdIsRight            ; $d153: a5 5a     
            bne __d15a         ; $d155: d0 03     
            jmp __d17b         ; $d157: 4c 7b d1  

;-------------------------------------------------------------------------------
__d15a:     jmp __d16e         ; $d15a: 4c 6e d1  

;-------------------------------------------------------------------------------
__d15d:     lda vBirdIsRight            ; $d15d: a5 5a     
            bne __d166         ; $d15f: d0 05     
            ldx #$11           ; $d161: a2 11     
__d163:     jmp __d084         ; $d163: 4c 84 d0  

;-------------------------------------------------------------------------------
__d166:     ldx #$15           ; $d166: a2 15     
            jmp __d163         ; $d168: 4c 63 d1  

;-------------------------------------------------------------------------------
__d16b:     jmp __d0d3         ; $d16b: 4c d3 d0  

;-------------------------------------------------------------------------------
__d16e:     inc vBirdPPUX            ; $d16e: e6 03     
            bne __d174         ; $d170: d0 02     
            inc vBirdPPUNametable            ; $d172: e6 02     
__d174:     lda vBirdPPUNametable            ; $d174: a5 02     
            and #$01           ; $d176: 29 01     
            sta vBirdPPUNametable            ; $d178: 85 02     
            rts                ; $d17a: 60        

;-------------------------------------------------------------------------------
__d17b:     lda vBirdPPUX            ; $d17b: a5 03     
            bne __d181         ; $d17d: d0 02     
            dec vBirdPPUNametable            ; $d17f: c6 02     
__d181:     dec vBirdPPUX            ; $d181: c6 03     
            jmp __d174         ; $d183: 4c 74 d1  

;-------------------------------------------------------------------------------
__d186:     jsr __d4fc         ; $d186: 20 fc d4  
            sta vBirdX            ; $d189: 85 5b     
            lda vBirdOffsetX            ; $d18b: a5 5c     
            clc                ; $d18d: 18        
            adc vBirdX            ; $d18e: 65 5b     
            cmp #$7c           ; $d190: c9 7c     
            bcs __d198         ; $d192: b0 04     
            asl                ; $d194: 0a        
__d195:     sta vBirdOffsetX            ; $d195: 85 5c     
            rts                ; $d197: 60        

;-------------------------------------------------------------------------------
__d198:     lda #$01           ; $d198: a9 01     
            jmp __d195         ; $d19a: 4c 95 d1  

;-------------------------------------------------------------------------------
__d19d:     inc $0227          ; $d19d: ee 27 02  
            lda $0227          ; $d1a0: ad 27 02  
            and #$7f           ; $d1a3: 29 7f     
            beq __d1bb         ; $d1a5: f0 14     
            jsr __setXEvery4Cycle         ; $d1a7: 20 93 d0  
            lda vBirdIsRight            ; $d1aa: a5 5a     
            beq __d1b5         ; $d1ac: f0 07     
__d1ae:     lda __d1d6,x       ; $d1ae: bd d6 d1  
            sta $0701          ; $d1b1: 8d 01 07  
            rts                ; $d1b4: 60        

;-------------------------------------------------------------------------------
__d1b5:     jsr __c83f         ; $d1b5: 20 3f c8  
            jmp __d1ae         ; $d1b8: 4c ae d1  

;-------------------------------------------------------------------------------
__d1bb:     jmp __e023         ; $d1bb: 4c 23 e0  

;-------------------------------------------------------------------------------
__d1be:     .hex 00 01 02 01   ; $d1be: 00 01 02 01   Data
__d1c2:     .hex 03 04 05 04   ; $d1c2: 03 04 05 04   Data
            .hex 06 07 08 07   ; $d1c6: 06 07 08 07   Data
            .hex 09 0a 0b 0a   ; $d1ca: 09 0a 0b 0a   Data
            .hex 0f 10 11 10   ; $d1ce: 0f 10 11 10   Data
            .hex 0c 0d 0e 0d   ; $d1d2: 0c 0d 0e 0d   Data
__d1d6:     .hex 81 83 81 83   ; $d1d6: 81 83 81 83   Data
            .hex 82 84 82 84   ; $d1da: 82 84 82 84   Data
__d1de:     .hex 74 b4 34 00   ; $d1de: 74 b4 34 00   Data
            .hex 74 b4 34 00   ; $d1e2: 74 b4 34 00   Data
__d1e6:     .hex 9c dc 5c 00   ; $d1e6: 9c dc 5c 00   Data
            .hex ac ec 6c 00   ; $d1ea: ac ec 6c 00   Data
__d1ee:     .hex 68 58 58 00   ; $d1ee: 68 58 58 00   Data
            .hex 68 58 58 00   ; $d1f2: 68 58 58 00   Data
__d1f6:     .hex 70 60 60 00   ; $d1f6: 70 60 60 00   Data
            .hex 70 60 60 00   ; $d1fa: 70 60 60 00   Data
__d1fe:     .hex 78 b8 38 00   ; $d1fe: 78 b8 38 00   Data
            .hex 78 b8 38 00   ; $d202: 78 b8 38 00   Data
__d206:     .hex 98 d8 58 00   ; $d206: 98 d8 58 00   Data
            .hex a8 e8 68 00   ; $d20a: a8 e8 68 00   Data
__spriteData1:     
			.hex 08 0c 10 0a   ; $d20e: 08 0c 10 0a   Data
            .hex 0e 12 14 18   ; $d212: 0e 12 14 18   Data
            .hex 1c 16 1a 1e   ; $d216: 1c 16 1a 1e   Data
            .hex 28 2c 30 2a   ; $d21a: 28 2c 30 2a   Data
            .hex 2e 32 34 36   ; $d21e: 2e 32 34 36   Data
            .hex 38 3c 40 44   ; $d222: 38 3c 40 44   Data
            .hex 46 44 46 46   ; $d226: 46 44 46 46   Data
            .hex 48 4a 4c 4e   ; $d22a: 48 4a 4c 4e   Data
            .hex 50 52 54 56   ; $d22e: 50 52 54 56   Data
            .hex 58 5a 5c 5e   ; $d232: 58 5a 5c 5e   Data
            .hex 60 62 64 66   ; $d236: 60 62 64 66   Data
            .hex 68 6a 6c 6e   ; $d23a: 68 6a 6c 6e   Data
            .hex 70 74 78 7c   ; $d23e: 70 74 78 7c   Data
            .hex 24 00 04 06   ; $d242: 24 00 04 06   Data
            .hex 24 48 26 4a   ; $d246: 24 48 26 4a   Data
            .hex 88 8a 8c 8e   ; $d24a: 88 8a 8c 8e   Data
            .hex 90 92 94 96   ; $d24e: 90 92 94 96   Data
            .hex 98 9a 9c 9e   ; $d252: 98 9a 9c 9e   Data
            .hex a0 a2 a4 a6   ; $d256: a0 a2 a4 a6   Data
            .hex a8 aa ac ae   ; $d25a: a8 aa ac ae   Data
            .hex b0 b4 b8 bc   ; $d25e: b0 b4 b8 bc   Data
            .hex be bc be c0   ; $d262: be bc be c0   Data
            .hex c2 c4 c6 c8   ; $d266: c2 c4 c6 c8   Data
            .hex 08 0c 10 0a   ; $d26a: 08 0c 10 0a   Data
            .hex 0e 12 14 18   ; $d26e: 0e 12 14 18   Data
            .hex 1c 16 1a 1e   ; $d272: 1c 16 1a 1e   Data
            .hex 28 2c 30 2a   ; $d276: 28 2c 30 2a   Data
            .hex 2e 32 34 36   ; $d27a: 2e 32 34 36   Data
            .hex 38 f4 f8 fc   ; $d27e: 38 f4 f8 fc   Data
            .hex 20 22 c1 c3   ; $d282: 20 22 c1 c3   Data
            .hex c5 c7 c9 cd   ; $d286: c5 c7 c9 cd   Data
            .hex cf d1 d3 d4   ; $d28a: cf d1 d3 d4   Data
            .hex d8 d9 db dd   ; $d28e: d8 d9 db dd   Data
            .hex df e0 e2 e4   ; $d292: df e0 e2 e4   Data
            .hex e6 dc de d0   ; $d296: e6 dc de d0   Data
            .hex d2 cc ce d0   ; $d29a: d2 cc ce d0   Data
            .hex d2 c8 e8 ea   ; $d29e: d2 c8 e8 ea   Data
            .hex ec ee f0 bd   ; $d2a2: ec ee f0 bd   Data
            .hex 80 84 88 d5   ; $d2a6: 80 84 88 d5   Data
            .hex 79 7b 7e      ; $d2aa: 79 7b 7e      Data
__spriteAtrrib1:     
			.hex 00 00 00 40   ; $d2ad: 00 00 00 40   Data
            .hex 40 40 00 00   ; $d2b1: 40 40 00 00   Data
            .hex 00 40 40 40   ; $d2b5: 00 40 40 40   Data
            .hex 00 00 00 40   ; $d2b9: 00 00 00 40   Data
            .hex 40 40 00 40   ; $d2bd: 40 40 00 40   Data
            .hex 00 03 03 03   ; $d2c1: 00 03 03 03   Data
            .hex 43 83 43 c3   ; $d2c5: 43 83 43 c3   Data
            .hex 03 43 03 43   ; $d2c9: 03 43 03 43   Data
            .hex 03 43 03 43   ; $d2cd: 03 43 03 43   Data
            .hex 03 43 02 42   ; $d2d1: 03 43 02 42   Data
            .hex 02 42 02 42   ; $d2d5: 02 42 02 42   Data
            .hex 02 42 02 42   ; $d2d9: 02 42 02 42   Data
            .hex 03 03 03 03   ; $d2dd: 03 03 03 03   Data
            .hex 00 02 01 41   ; $d2e1: 00 02 01 41   Data
            .hex 00 00 40 40   ; $d2e5: 00 00 40 40   Data
            .hex 02 42 01 41   ; $d2e9: 02 42 01 41   Data
            .hex 01 41 01 41   ; $d2ed: 01 41 01 41   Data
            .hex 01 41 01 41   ; $d2f1: 01 41 01 41   Data
            .hex 01 41 01 41   ; $d2f5: 01 41 01 41   Data
            .hex 01 41 01 41   ; $d2f9: 01 41 01 41   Data
            .hex 01 01 01 01   ; $d2fd: 01 01 01 01   Data
            .hex 41 01 41 03   ; $d301: 41 01 41 03   Data
            .hex 43 03 43 03   ; $d305: 43 03 43 03   Data
            .hex 03 03 03 43   ; $d309: 03 03 03 43   Data
            .hex 43 43 03 03   ; $d30d: 43 43 03 03   Data
            .hex 03 43 43 43   ; $d311: 03 43 43 43   Data
            .hex 03 03 03 43   ; $d315: 03 03 03 43   Data
            .hex 43 43 03 43   ; $d319: 43 43 03 43   Data
            .hex 03 00 00 00   ; $d31d: 03 00 00 00   Data
            .hex 00 40 02 42   ; $d321: 00 40 02 42   Data
            .hex 02 42 02 02   ; $d325: 02 42 02 02   Data
            .hex 42 02 42 00   ; $d329: 42 02 42 00   Data
            .hex 00 00 40 00   ; $d32d: 00 00 40 00   Data
            .hex 40 03 43 03   ; $d331: 40 03 43 03   Data
            .hex 43 03 43 82   ; $d335: 43 03 43 82   Data
            .hex c2 02 42 02   ; $d339: c2 02 42 02   Data
            .hex 42 02 01 41   ; $d33d: 42 02 01 41   Data
            .hex 01 41 01 00   ; $d341: 01 41 01 00   Data
            .hex 00 00 00 01   ; $d345: 00 00 00 01   Data
            .hex 03 43 43      ; $d349: 03 43 43      Data
__spriteData2:     
			.hex 0a 0e 12 08   ; $d34c: 0a 0e 12 08   Data
            .hex 0c 10 16 1a   ; $d350: 0c 10 16 1a   Data
            .hex 1e 14 18 1c   ; $d354: 1e 14 18 1c   Data
            .hex 2a 2e 32 28   ; $d358: 2a 2e 32 28   Data
            .hex 2c 30 36 34   ; $d35c: 2c 30 36 34   Data
            .hex 3a 3e 42 46   ; $d360: 3a 3e 42 46   Data
            .hex 44 46 44 44   ; $d364: 44 46 44 44   Data
            .hex 4a 48 4e 4c   ; $d368: 4a 48 4e 4c   Data
            .hex 52 50 56 54   ; $d36c: 52 50 56 54   Data
            .hex 5a 58 5e 5c   ; $d370: 5a 58 5e 5c   Data
            .hex 62 60 66 64   ; $d374: 62 60 66 64   Data
            .hex 6a 68 6e 6c   ; $d378: 6a 68 6e 6c   Data
            .hex 72 76 7a 7e   ; $d37c: 72 76 7a 7e   Data
            .hex 26 02 06 04   ; $d380: 26 02 06 04   Data
            .hex 26 4a 24 48   ; $d384: 26 4a 24 48   Data
            .hex 8a 88 8e 8c   ; $d388: 8a 88 8e 8c   Data
            .hex 92 90 96 94   ; $d38c: 92 90 96 94   Data
            .hex 9a 98 9e 9c   ; $d390: 9a 98 9e 9c   Data
            .hex a2 a0 a6 a4   ; $d394: a2 a0 a6 a4   Data
            .hex aa a8 ae ac   ; $d398: aa a8 ae ac   Data
            .hex b2 b6 ba be   ; $d39c: b2 b6 ba be   Data
            .hex bc be bc c2   ; $d3a0: bc be bc c2   Data
            .hex c0 c6 c4 ca   ; $d3a4: c0 c6 c4 ca   Data
            .hex 0a 0e 12 08   ; $d3a8: 0a 0e 12 08   Data
            .hex 0c 10 16 1a   ; $d3ac: 0c 10 16 1a   Data
            .hex 1e 14 18 1c   ; $d3b0: 1e 14 18 1c   Data
            .hex 2a 2e 32 28   ; $d3b4: 2a 2e 32 28   Data
            .hex 2c 30 36 34   ; $d3b8: 2c 30 36 34   Data
            .hex 3a f6 fa fe   ; $d3bc: 3a f6 fa fe   Data
            .hex 22 20 c3 c1   ; $d3c0: 22 20 c3 c1   Data
            .hex c7 c5 c9 cf   ; $d3c4: c7 c5 c9 cf   Data
            .hex cd d3 d1 d6   ; $d3c8: cd d3 d1 d6   Data
            .hex da db d9 df   ; $d3cc: da db d9 df   Data
            .hex dd e2 e0 e6   ; $d3d0: dd e2 e0 e6   Data
            .hex e4 de dc d2   ; $d3d4: e4 de dc d2   Data
            .hex d0 ce cc d2   ; $d3d8: d0 ce cc d2   Data
            .hex d0 ca ea e8   ; $d3dc: d0 ca ea e8   Data
            .hex ee ec f2 bf   ; $d3e0: ee ec f2 bf   Data
            .hex 82 86 8a d7   ; $d3e4: 82 86 8a d7   Data
            .hex 7b 79 7c      ; $d3e8: 7b 79 7c      Data
__spriteAtrrib2:     
			.hex 00 00 00 40   ; $d3eb: 00 00 00 40   Data
            .hex 40 40 00 00   ; $d3ef: 40 40 00 00   Data
            .hex 00 40 40 40   ; $d3f3: 00 40 40 40   Data
            .hex 00 00 00 40   ; $d3f7: 00 00 00 40   Data
            .hex 40 40 00 40   ; $d3fb: 40 40 00 40   Data
            .hex 00 03 03 03   ; $d3ff: 00 03 03 03   Data
            .hex 43 83 43 c3   ; $d403: 43 83 43 c3   Data
            .hex 03 43 03 43   ; $d407: 03 43 03 43   Data
            .hex 03 43 03 43   ; $d40b: 03 43 03 43   Data
            .hex 03 43 02 42   ; $d40f: 03 43 02 42   Data
            .hex 02 42 02 42   ; $d413: 02 42 02 42   Data
            .hex 02 42 02 42   ; $d417: 02 42 02 42   Data
            .hex 03 03 03 03   ; $d41b: 03 03 03 03   Data
            .hex 00 02 01 41   ; $d41f: 00 02 01 41   Data
            .hex 00 00 40 40   ; $d423: 00 00 40 40   Data
            .hex 02 42 01 41   ; $d427: 02 42 01 41   Data
            .hex 01 41 01 41   ; $d42b: 01 41 01 41   Data
            .hex 01 41 01 41   ; $d42f: 01 41 01 41   Data
            .hex 01 41 01 41   ; $d433: 01 41 01 41   Data
            .hex 01 41 01 41   ; $d437: 01 41 01 41   Data
            .hex 01 01 01 01   ; $d43b: 01 01 01 01   Data
            .hex 41 01 41 03   ; $d43f: 41 01 41 03   Data
            .hex 43 03 43 03   ; $d443: 43 03 43 03   Data
            .hex 03 03 03 43   ; $d447: 03 03 03 43   Data
            .hex 43 43 03 03   ; $d44b: 43 43 03 03   Data
            .hex 03 43 43 43   ; $d44f: 03 43 43 43   Data
            .hex 03 03 03 43   ; $d453: 03 03 03 43   Data
            .hex 43 43 03 43   ; $d457: 43 43 03 43   Data
            .hex 03 00 00 00   ; $d45b: 03 00 00 00   Data
            .hex 00 40 02 42   ; $d45f: 00 40 02 42   Data
            .hex 02 42 42 02   ; $d463: 02 42 42 02   Data
            .hex 42 02 42 00   ; $d467: 42 02 42 00   Data
            .hex 00 00 40 00   ; $d46b: 00 00 40 00   Data
            .hex 40 03 43 03   ; $d46f: 40 03 43 03   Data
            .hex 43 03 43 82   ; $d473: 43 03 43 82   Data
            .hex c2 02 42 02   ; $d477: c2 02 42 02   Data
            .hex 42 02 01 41   ; $d47b: 42 02 01 41   Data
            .hex 01 41 01 00   ; $d47f: 01 41 01 00   Data
            .hex 00 00 00 01   ; $d483: 00 00 00 01   Data
            .hex 03 43 43      ; $d487: 03 43 43      Data

;-------------------------------------------------------------------------------
__d48a:     jsr __clearXY         ; $d48a: 20 16 d7  
__d48d:     lda vBeeX,x          ; $d48d: b5 70     
            sta vBirdOffsetX            ; $d48f: 85 5c     
            jsr __d4e5         ; $d491: 20 e5 d4  
            lda vBirdOffsetX            ; $d494: a5 5c     
            and #$01           ; $d496: 29 01     
            bne __d4cc         ; $d498: d0 32     
            lda vBirdPPUX            ; $d49a: a5 03     
            and #$01           ; $d49c: 29 01     
            bne __d4a8         ; $d49e: d0 08     
            lda vBirdOffsetX            ; $d4a0: a5 5c     
            clc                ; $d4a2: 18        
            adc #$01           ; $d4a3: 69 01     
            jmp __d4aa         ; $d4a5: 4c aa d4  

;-------------------------------------------------------------------------------
__d4a8:     lda vBirdOffsetX            ; $d4a8: a5 5c     
__d4aa:     sta $0707,y        ; $d4aa: 99 07 07  
            lda vBeeY,x          ; $d4ad: b5 90     
            cmp #$18           ; $d4af: c9 18     
            beq __d4d1         ; $d4b1: f0 1e     
            cmp #$d8           ; $d4b3: c9 d8     
            beq __d4d1         ; $d4b5: f0 1a     
            lda vBirdOffsetX            ; $d4b7: a5 5c     
            and #$01           ; $d4b9: 29 01     
            bne __d4e0         ; $d4bb: d0 23     
            lda vBeeY,x          ; $d4bd: b5 90     
__d4bf:     sta $0704,y        ; $d4bf: 99 04 07  
            iny                ; $d4c2: c8        
            iny                ; $d4c3: c8        
            iny                ; $d4c4: c8        
            iny                ; $d4c5: c8        
            inx                ; $d4c6: e8        
            cpx #$13           ; $d4c7: e0 13     
            bne __d48d         ; $d4c9: d0 c2     
            rts                ; $d4cb: 60        

;-------------------------------------------------------------------------------
__d4cc:     lda #$f0           ; $d4cc: a9 f0     
            jmp __d4aa         ; $d4ce: 4c aa d4  

;-------------------------------------------------------------------------------
__d4d1:     jsr __d4fc         ; $d4d1: 20 fc d4  
            clc                ; $d4d4: 18        
            adc #$c0           ; $d4d5: 69 c0     
            sta vBeeX,x          ; $d4d7: 95 70     
            lda #$90           ; $d4d9: a9 90     
            sta vBeeY,x          ; $d4db: 95 90     
            jmp __d48d         ; $d4dd: 4c 8d d4  

;-------------------------------------------------------------------------------
__d4e0:     lda #$f0           ; $d4e0: a9 f0     
            jmp __d4bf         ; $d4e2: 4c bf d4  

;-------------------------------------------------------------------------------
__d4e5:     jsr __d4fc         ; $d4e5: 20 fc d4  
            sta vBirdX            ; $d4e8: 85 5b     
            lda vBirdOffsetX            ; $d4ea: a5 5c     
            sec                ; $d4ec: 38        
            sbc vBirdX            ; $d4ed: e5 5b     
            cmp #$7c           ; $d4ef: c9 7c     
            bcs __d4f7         ; $d4f1: b0 04     
            asl                ; $d4f3: 0a        
__d4f4:     sta vBirdOffsetX            ; $d4f4: 85 5c     
            rts                ; $d4f6: 60        

;-------------------------------------------------------------------------------
__d4f7:     lda #$01           ; $d4f7: a9 01     
            jmp __d4f4         ; $d4f9: 4c f4 d4  

;-------------------------------------------------------------------------------
__d4fc:     lda vBirdPPUNametable            ; $d4fc: a5 02     
            ror                ; $d4fe: 6a        
            lda vBirdPPUX            ; $d4ff: a5 03     
            ror                ; $d501: 6a        
            rts                ; $d502: 60        

;-------------------------------------------------------------------------------
__d503:     lda vCycleCounter            ; $d503: a5 09     
            and #$3f           ; $d505: 29 3f     
            bne __d511         ; $d507: d0 08     
            lda $6c            ; $d509: a5 6c     
            cmp #$b8           ; $d50b: c9 b8     
            beq __d511         ; $d50d: f0 02     
            inc $6c            ; $d50f: e6 6c     
__d511:     lda $6b            ; $d511: a5 6b     
            clc                ; $d513: 18        
            adc $6c            ; $d514: 65 6c     
            bcs __d51b         ; $d516: b0 03     
            sta $6b            ; $d518: 85 6b     
            rts                ; $d51a: 60        

;-------------------------------------------------------------------------------
__d51b:     sta $6b            ; $d51b: 85 6b     
            lda $0211          ; $d51d: ad 11 02  
            bne __d53a         ; $d520: d0 18     
            lda $86            ; $d522: a5 86     
            bne __d53a         ; $d524: d0 14     
            lda vKiteRiseAfterDeath            ; $d526: a5 67     
				bne __kiteRiseAfterDeath         ; $d528: d0 13     
            lda vKiteYChange            ; $d52a: a5 68     
				bne __d540         ; $d52c: d0 12     
            lda vRandomVar            ; $d52e: a5 08     
            bne __d534         ; $d530: d0 02     
            inc vKiteYChange            ; $d532: e6 68     
__d534:     lda vKiteDirection            ; $d534: a5 6a     
            beq ___kiteFlyRight         ; $d536: f0 36     
            bne __kiteFlyLeft         ; $d538: d0 54     
__d53a:     jmp __d5af         ; $d53a: 4c af d5  

;-------------------------------------------------------------------------------
__kiteRiseAfterDeath:     
			jmp ___kiteRiseAfterDeath         ; $d53d: 4c 18 d6  

;-------------------------------------------------------------------------------
__d540:     lda vKiteYChange            ; $d540: a5 68     
            cmp vKiteMaxYChange            ; $d542: c5 69     
				beq __stopKiteYChange         ; $d544: f0 62     
            inc vKiteYChange            ; $d546: e6 68     
            lda vKiteY1            ; $d548: a5 98     
            cmp #$1a           ; $d54a: c9 1a     
            bcc __d588         ; $d54c: 90 3a     
            cmp #$c0           ; $d54e: c9 c0     
            bcs __d55b         ; $d550: b0 09     
            lda vBirdSpritePosY          ; $d552: ad 00 07  
            cmp vKiteY1            ; $d555: c5 98     
            beq __stopKiteYChange         ; $d557: f0 4f     
            bcs __d588         ; $d559: b0 2d     
__d55b:     dec vKiteY1            ; $d55b: c6 98     
            dec vKiteY2            ; $d55d: c6 99     
__d55f:     lda vKiteX1            ; $d55f: a5 78     
            sta vBirdX            ; $d561: 85 5b     
            jsr __d5fc         ; $d563: 20 fc d5  
            lda vBirdX            ; $d566: a5 5b     
            beq __stopKiteYChange         ; $d568: f0 3e     
            cmp #$01           ; $d56a: c9 01     
            beq __kiteFlyLeft         ; $d56c: f0 20     
___kiteFlyRight:     
			inc vKiteX1            ; $d56e: e6 78     
            inc vKiteX2            ; $d570: e6 79     
            lda #$00           ; $d572: a9 00     
            sta vKiteDirection            ; $d574: 85 6a     
            jsr __setXEvery8Cycle         ; $d576: 20 8b d0  
            lda __kiteRightAnim1,x       ; $d579: bd 67 d6  
            sta $0725          ; $d57c: 8d 25 07  
            lda __kiteRightAnim2,x       ; $d57f: bd 6b d6  
            sta $0729          ; $d582: 8d 29 07  
            jmp __kiteHoverUpDown         ; $d585: 4c 30 d6  

;-------------------------------------------------------------------------------
__d588:     jsr __kiteHoverDown         ; $d588: 20 4a d6  
            jmp __d55f         ; $d58b: 4c 5f d5  

;-------------------------------------------------------------------------------
__kiteFlyLeft:     
			dec vKiteX1            ; $d58e: c6 78     
            dec vKiteX2            ; $d590: c6 79     
            lda #$01           ; $d592: a9 01     
            sta vKiteDirection            ; $d594: 85 6a     
            jsr __setXEvery8Cycle         ; $d596: 20 8b d0  
            lda __kiteLeftAnim1,x       ; $d599: bd 6f d6  
            sta $0725          ; $d59c: 8d 25 07  
            lda __kiteLeftAnim2,x       ; $d59f: bd 73 d6  
            sta $0729          ; $d5a2: 8d 29 07  
            jmp __kiteHoverUpDown         ; $d5a5: 4c 30 d6  

;-------------------------------------------------------------------------------
__stopKiteYChange:     
			lda #$00           ; $d5a8: a9 00     
            sta vKiteYChange            ; $d5aa: 85 68     
            jmp __d534         ; $d5ac: 4c 34 d5  

;-------------------------------------------------------------------------------
__d5af:     lda $025b          ; $d5af: ad 5b 02  
            beq __d5f0         ; $d5b2: f0 3c     
__d5b4:     lda vKiteY1            ; $d5b4: a5 98     
            cmp #$c8           ; $d5b6: c9 c8     
            bcs __d5d0         ; $d5b8: b0 16     
            jsr __kiteHoverDown         ; $d5ba: 20 4a d6  
            jsr __kiteHoverDown         ; $d5bd: 20 4a d6  
            jsr __setXEvery4Cycle         ; $d5c0: 20 93 d0  
__d5c3:     lda __d677,x       ; $d5c3: bd 77 d6  
            sta $0725          ; $d5c6: 8d 25 07  
            lda __d67c,x       ; $d5c9: bd 7c d6  
            sta $0729          ; $d5cc: 8d 29 07  
            rts                ; $d5cf: 60        

;-------------------------------------------------------------------------------
__d5d0:     lda $6e            ; $d5d0: a5 6e     
            cmp #$a0           ; $d5d2: c9 a0     
            beq __d5dd         ; $d5d4: f0 07     
            inc $6e            ; $d5d6: e6 6e     
            ldx #$04           ; $d5d8: a2 04     
            jmp __d5c3         ; $d5da: 4c c3 d5  

;-------------------------------------------------------------------------------
__d5dd:     lda #$00           ; $d5dd: a9 00     
            sta $6e            ; $d5df: 85 6e     
            sta $b8            ; $d5e1: 85 b8     
            sta $b9            ; $d5e3: 85 b9     
            sta $0211          ; $d5e5: 8d 11 02  
            sta $025b          ; $d5e8: 8d 5b 02  
            sta $86            ; $d5eb: 85 86     
            inc vKiteRiseAfterDeath            ; $d5ed: e6 67     
            rts                ; $d5ef: 60        

;-------------------------------------------------------------------------------
__d5f0:     jsr __d652         ; $d5f0: 20 52 d6  
            inc $025b          ; $d5f3: ee 5b 02  
            jsr __c545         ; $d5f6: 20 45 c5  
            jmp __d5b4         ; $d5f9: 4c b4 d5  

;-------------------------------------------------------------------------------
__d5fc:     jsr __d4fc         ; $d5fc: 20 fc d4  
            clc                ; $d5ff: 18        
            adc #$3c           ; $d600: 69 3c     
            sec                ; $d602: 38        
            sbc vBirdX            ; $d603: e5 5b     
            beq __d60e         ; $d605: f0 07     
            bpl __d613         ; $d607: 10 0a     
            lda #$01           ; $d609: a9 01     
__d60b:     sta vBirdX            ; $d60b: 85 5b     
            rts                ; $d60d: 60        

;-------------------------------------------------------------------------------
__d60e:     lda #$00           ; $d60e: a9 00     
            jmp __d60b         ; $d610: 4c 0b d6  

;-------------------------------------------------------------------------------
__d613:     lda #$02           ; $d613: a9 02     
            jmp __d60b         ; $d615: 4c 0b d6  

;-------------------------------------------------------------------------------
___kiteRiseAfterDeath:     
			lda vKiteY1            ; $d618: a5 98     
            cmp #$80           ; $d61a: c9 80     
				bcc __kiteStopRising         ; $d61c: 90 0e     
            dec vKiteY1            ; $d61e: c6 98     
            dec vKiteY2            ; $d620: c6 99     
            lda vKiteDirection            ; $d622: a5 6a     
            beq __kiteFlyRight         ; $d624: f0 03     
            jmp __kiteFlyLeft         ; $d626: 4c 8e d5  

;-------------------------------------------------------------------------------
__kiteFlyRight:     jmp ___kiteFlyRight         ; $d629: 4c 6e d5  

;-------------------------------------------------------------------------------
__kiteStopRising:     
			lda #$00           ; $d62c: a9 00     
            sta vKiteRiseAfterDeath            ; $d62e: 85 67     
__kiteHoverUpDown:     
			jsr __getCycleModulo8         ; $d630: 20 62 d6  
				bne __return8         ; $d633: d0 14     
            lda vKiteY1            ; $d635: a5 98     
            cmp #$20           ; $d637: c9 20     
				bcc __return8         ; $d639: 90 0e     
            cmp #$c8           ; $d63b: c9 c8     
				bcs __return8         ; $d63d: b0 0a     
            lda vRandomVar            ; $d63f: a5 08     
            and #$01           ; $d641: 29 01     
				bne __kiteHoverDown         ; $d643: d0 05     
            dec vKiteY1            ; $d645: c6 98     
            dec vKiteY2            ; $d647: c6 99     
__return8:     
			rts                ; $d649: 60        

;-------------------------------------------------------------------------------
__kiteHoverDown:     
			inc vKiteY1            ; $d64a: e6 98     
            inc vKiteY2            ; $d64c: e6 99     
            rts                ; $d64e: 60        

;-------------------------------------------------------------------------------
__d64f:     jsr __give100Score         ; $d64f: 20 15 ff  
__d652:     jsr __give100Score         ; $d652: 20 15 ff  
            jmp __give100Score         ; $d655: 4c 15 ff  

;-------------------------------------------------------------------------------
__isOddCycle:     
			lda vCycleCounter            ; $d658: a5 09     
            and #$01           ; $d65a: 29 01     
            rts                ; $d65c: 60        

;-------------------------------------------------------------------------------
__getCycleModulo4:     
			lda vCycleCounter            ; $d65d: a5 09     
            and #$03           ; $d65f: 29 03     
            rts                ; $d661: 60        

;-------------------------------------------------------------------------------
__getCycleModulo8:     
			lda vCycleCounter            ; $d662: a5 09     
            and #$07           ; $d664: 29 07     
            rts                ; $d666: 60        

;-------------------------------------------------------------------------------
__kiteRightAnim1:     
			.hex 45 47 49 47   ; $d667: 45 47 49 47   Data
__kiteRightAnim2:     
			.hex 3f 41 43 41   ; $d66b: 3f 41 43 41   Data
__kiteLeftAnim1:     
			.hex 3e 40 42 40   ; $d66f: 3e 40 42 40   Data
__kiteLeftAnim2:     
			.hex 44 46 48 46   ; $d673: 44 46 48 46   Data
__d677:     .hex 4a 4c 4a 4c   ; $d677: 4a 4c 4a 4c   Data
            .hex 4c            ; $d67b: 4c            Data
__d67c:     .hex 4b 4d 4b 4d   ; $d67c: 4b 4d 4b 4d   Data
            .hex 4d            ; $d680: 4d            Data

;-------------------------------------------------------------------------------
__d681:     lda $b7            ; $d681: a5 b7     
            bne __d68c         ; $d683: d0 07     
            lda $de            ; $d685: a5 de     
            bne __d6cb         ; $d687: d0 42     
            jmp __d6ab         ; $d689: 4c ab d6  

;-------------------------------------------------------------------------------
__d68c:     lda $eb            ; $d68c: a5 eb     
            bne __d696         ; $d68e: d0 06     
            lda #$07           ; $d690: a9 07     
            sta vSoundPlayerState            ; $d692: 85 2a     
            inc $eb            ; $d694: e6 eb     
__d696:     lda vCycleCounter            ; $d696: a5 09     
            and #$0f           ; $d698: 29 0f     
            bne __d6aa         ; $d69a: d0 0e     
            ldx $df            ; $d69c: a6 df     
            cpx #$08           ; $d69e: e0 08     
            beq __d6e0         ; $d6a0: f0 3e     
            lda __d706,x       ; $d6a2: bd 06 d7  
            sta $0721          ; $d6a5: 8d 21 07  
            inc $df            ; $d6a8: e6 df     
__d6aa:     rts                ; $d6aa: 60        

;-------------------------------------------------------------------------------
__d6ab:     lda vRandomVar2            ; $d6ab: a5 17     
            bne __d6ca         ; $d6ad: d0 1b     
            lda vCycleCounter            ; $d6af: a5 09     
            cmp #$40           ; $d6b1: c9 40     
            bcs __d6ca         ; $d6b3: b0 15     
            inc $de            ; $d6b5: e6 de     
            lda vRandomVar            ; $d6b7: a5 08     
            and #$07           ; $d6b9: 29 07     
            tay                ; $d6bb: a8        
            lda __d70e,y       ; $d6bc: b9 0e d7  
            sta $77            ; $d6bf: 85 77     
            lda #$c8           ; $d6c1: a9 c8     
            sta $97            ; $d6c3: 85 97     
            lda #$4e           ; $d6c5: a9 4e     
            sta $0721          ; $d6c7: 8d 21 07  
__d6ca:     rts                ; $d6ca: 60        

;-------------------------------------------------------------------------------
__d6cb:     lda vCycleCounter            ; $d6cb: a5 09     
            and #$0f           ; $d6cd: 29 0f     
            bne __d6df         ; $d6cf: d0 0e     
            ldx $e0            ; $d6d1: a6 e0     
            cpx #$10           ; $d6d3: e0 10     
            beq __d6e9         ; $d6d5: f0 12     
            lda __d6f6,x       ; $d6d7: bd f6 d6  
            inc $e0            ; $d6da: e6 e0     
            sta $0721          ; $d6dc: 8d 21 07  
__d6df:     rts                ; $d6df: 60        

;-------------------------------------------------------------------------------
__d6e0:     lda #$00           ; $d6e0: a9 00     
            sta $b7            ; $d6e2: 85 b7     
            sta $eb            ; $d6e4: 85 eb     
            jsr __d64f         ; $d6e6: 20 4f d6  
__d6e9:     lda #$f8           ; $d6e9: a9 f8     
            sta $97            ; $d6eb: 85 97     
            lda #$00           ; $d6ed: a9 00     
            sta $de            ; $d6ef: 85 de     
            sta $df            ; $d6f1: 85 df     
            sta $e0            ; $d6f3: 85 e0     
            rts                ; $d6f5: 60        

;-------------------------------------------------------------------------------
__d6f6:     .hex 4e 4f 4e 4f   ; $d6f6: 4e 4f 4e 4f   Data
            .hex 50 51 52 51   ; $d6fa: 50 51 52 51   Data
            .hex 52 51 50 51   ; $d6fe: 52 51 50 51   Data
            .hex 4e 4f 4e 4f   ; $d702: 4e 4f 4e 4f   Data
__d706:     .hex 53 54 53 54   ; $d706: 53 54 53 54   Data
            .hex 53 54 53 54   ; $d70a: 53 54 53 54   Data
__d70e:     .hex 00 20 40 60   ; $d70e: 00 20 40 60   Data
            .hex 80 a0 c0 e0   ; $d712: 80 a0 c0 e0   Data

;-------------------------------------------------------------------------------
__clearXY:     ldx #$00           ; $d716: a2 00     
            ldy #$00           ; $d718: a0 00     
            rts                ; $d71a: 60        

;-------------------------------------------------------------------------------
___bestEndingLoop:     
			jsr __handleStartButton         ; $d71b: 20 2c c2  
            jmp __c248         ; $d71e: 4c 48 c2  

;-------------------------------------------------------------------------------
__d721:     lda $0295          ; $d721: ad 95 02  
            beq __d742         ; $d724: f0 1c     
            lda vMusicPlayerState            ; $d726: a5 20     
            beq __d73f         ; $d728: f0 15     
            jsr __d79d         ; $d72a: 20 9d d7  
            jsr __d7cc         ; $d72d: 20 cc d7  
            jsr __d846         ; $d730: 20 46 d8  
            jsr __d852         ; $d733: 20 52 d8  
            jsr __d875         ; $d736: 20 75 d8  
            jsr __d48a         ; $d739: 20 8a d4  
            jmp __c122         ; $d73c: 4c 22 c1  

;-------------------------------------------------------------------------------
__d73f:     jmp __d835         ; $d73f: 4c 35 d8  

;-------------------------------------------------------------------------------
__d742:     jsr __showSprites         ; $d742: 20 e0 fd  
            lda #$13           ; $d745: a9 13     
            sta vMusicPlayerState            ; $d747: 85 20     
            inc $0295          ; $d749: ee 95 02  
            jsr __d752         ; $d74c: 20 52 d7  
            jmp __d762         ; $d74f: 4c 62 d7  

;-------------------------------------------------------------------------------
__d752:     ldx #$00           ; $d752: a2 00     
__d754:     lda #$00           ; $d754: a9 00     
            sta $b0,x          ; $d756: 95 b0     
            lda #$f0           ; $d758: a9 f0     
            sta vBeeY,x          ; $d75a: 95 90     
            inx                ; $d75c: e8        
            cpx #$13           ; $d75d: e0 13     
            bne __d754         ; $d75f: d0 f3     
            rts                ; $d761: 60        

;-------------------------------------------------------------------------------
__d762:     jsr __clearXY         ; $d762: 20 16 d7  
__d765:     lda __d789,x       ; $d765: bd 89 d7  
            sta vBeeY,x          ; $d768: 95 90     
            lda __d793,x       ; $d76a: bd 93 d7  
            sta vBeeX,x          ; $d76d: 95 70     
            lda __d77f,x       ; $d76f: bd 7f d7  
            sta $0705,y        ; $d772: 99 05 07  
            inx                ; $d775: e8        
            iny                ; $d776: c8        
            iny                ; $d777: c8        
            iny                ; $d778: c8        
            iny                ; $d779: c8        
            cpx #$0a           ; $d77a: e0 0a     
            bne __d765         ; $d77c: d0 e7     
            rts                ; $d77e: 60        

;-------------------------------------------------------------------------------
__d77f:     .hex 0f 38 38 38   ; $d77f: 0f 38 38 38   Data
            .hex 38 38 38 38   ; $d783: 38 38 38 38   Data
            .hex 38 38         ; $d787: 38 38         Data
__d789:     .hex 50 40 60 30   ; $d789: 50 40 60 30   Data
            .hex 50 70 20 40   ; $d78d: 50 70 20 40   Data
            .hex 60 80         ; $d791: 60 80         Data
__d793:     .hex f0 a0 a0 b0   ; $d793: f0 a0 a0 b0   Data
            .hex b0 b0 c0 c0   ; $d797: b0 b0 c0 c0   Data
            .hex c0 c0         ; $d79b: c0 c0         Data
__d79d:     lda $02c1          ; $d79d: ad c1 02  
            cmp #$09           ; $d7a0: c9 09     
            beq __d7c2         ; $d7a2: f0 1e     
            lda vCycleCounter            ; $d7a4: a5 09     
            and #$7f           ; $d7a6: 29 7f     
            bne __d7c2         ; $d7a8: d0 18     
            ldx #$00           ; $d7aa: a2 00     
            ldy $02c1          ; $d7ac: ac c1 02  
            lda __d7c3,y       ; $d7af: b9 c3 d7  
__d7b2:     sta vPaletteData,x          ; $d7b2: 95 30     
            inx                ; $d7b4: e8        
            inx                ; $d7b5: e8        
            inx                ; $d7b6: e8        
            inx                ; $d7b7: e8        
            cpx #$20           ; $d7b8: e0 20     
            bne __d7b2         ; $d7ba: d0 f6     
            jsr __uploadPalettesToPPU         ; $d7bc: 20 64 fe  
            inc $02c1          ; $d7bf: ee c1 02  
__d7c2:     rts                ; $d7c2: 60        

;-------------------------------------------------------------------------------
__d7c3:     .hex 32 33 34 35   ; $d7c3: 32 33 34 35   Data
            .hex 36 37 38 39   ; $d7c7: 36 37 38 39   Data
            .hex 3a            ; $d7cb: 3a            Data
__d7cc:     jsr __setPPUIncrementBy32         ; $d7cc: 20 e4 fe  
            lda $02c2          ; $d7cf: ad c2 02  
            cmp #$20           ; $d7d2: c9 20     
            beq __d812         ; $d7d4: f0 3c     
            lda vCycleCounter            ; $d7d6: a5 09     
            and #$1f           ; $d7d8: 29 1f     
            bne __d812         ; $d7da: d0 36     
            lda $02c2          ; $d7dc: ad c2 02  
            tax                ; $d7df: aa        
            lda #$23           ; $d7e0: a9 23     
            sta ppuAddress          ; $d7e2: 8d 06 20  
            lda __d815,x       ; $d7e5: bd 15 d8  
            sta ppuAddress          ; $d7e8: 8d 06 20  
            lda #$b0           ; $d7eb: a9 b0     
            sta ppuData          ; $d7ed: 8d 07 20  
            lda #$b1           ; $d7f0: a9 b1     
            sta ppuData          ; $d7f2: 8d 07 20  
            lda #$23           ; $d7f5: a9 23     
            sta ppuAddress          ; $d7f7: 8d 06 20  
            lda __d815,x       ; $d7fa: bd 15 d8  
            tay                ; $d7fd: a8        
            iny                ; $d7fe: c8        
            sty ppuAddress          ; $d7ff: 8c 06 20  
            lda #$b2           ; $d802: a9 b2     
            sta ppuData          ; $d804: 8d 07 20  
            lda #$b3           ; $d807: a9 b3     
            sta ppuData          ; $d809: 8d 07 20  
            inc $02c2          ; $d80c: ee c2 02  
            jsr __scrollScreen         ; $d80f: 20 b6 fd  
__d812:     jmp __setPPUIncrementBy1         ; $d812: 4c da fe  

;-------------------------------------------------------------------------------
__d815:     .hex 04 50 18 5c   ; $d815: 04 50 18 5c   Data
            .hex 14 4a 46 00   ; $d819: 14 4a 46 00   Data
            .hex 56 0c 1e 5a   ; $d81d: 56 0c 1e 5a   Data
            .hex 42 4e 12 54   ; $d821: 42 4e 12 54   Data
            .hex 08 40 44 10   ; $d825: 08 40 44 10   Data
            .hex 1c 5e 06 0e   ; $d829: 1c 5e 06 0e   Data
            .hex 58 4c 16 1a   ; $d82d: 58 4c 16 1a   Data
            .hex 48 0a 02 52   ; $d831: 48 0a 02 52   Data
__d835:     jsr __d752         ; $d835: 20 52 d7  
            lda #$00           ; $d838: a9 00     
            sta $0295          ; $d83a: 8d 95 02  
            sta $02c1          ; $d83d: 8d c1 02  
            sta $02c2          ; $d840: 8d c2 02  
            jmp __c90e         ; $d843: 4c 0e c9  

;-------------------------------------------------------------------------------
__d846:     lda vBeeX            ; $d846: a5 70     
            cmp #$90           ; $d848: c9 90     
            beq __d84d         ; $d84a: f0 01     
            rts                ; $d84c: 60        

;-------------------------------------------------------------------------------
__d84d:     lda #$01           ; $d84d: a9 01     
            sta $b0            ; $d84f: 85 b0     
            rts                ; $d851: 60        

;-------------------------------------------------------------------------------
__d852:     jsr __setXEvery8Cycle         ; $d852: 20 8b d0  
            lda $b0            ; $d855: a5 b0     
            bne __d867         ; $d857: d0 0e     
            lda __d1be,x       ; $d859: bd be d1  
            sta $0705          ; $d85c: 8d 05 07  
            jsr __getCycleModulo4         ; $d85f: 20 5d d6  
            bne __d866         ; $d862: d0 02     
            inc vBeeX            ; $d864: e6 70     
__d866:     rts                ; $d866: 60        

;-------------------------------------------------------------------------------
__d867:     lda __d1c2,x       ; $d867: bd c2 d1  
            sta $0705          ; $d86a: 8d 05 07  
            jsr __getCycleModulo4         ; $d86d: 20 5d d6  
            bne __d866         ; $d870: d0 f4     
            dec vBeeX            ; $d872: c6 70     
            rts                ; $d874: 60        

;-------------------------------------------------------------------------------
__d875:     jsr __clearXY         ; $d875: 20 16 d7  
__d878:     lda $b0            ; $d878: a5 b0     
            beq __d899         ; $d87a: f0 1d     
            stx $1e            ; $d87c: 86 1e     
            jsr __setXEvery4Cycle         ; $d87e: 20 93 d0  
            lda __d89a,x       ; $d881: bd 9a d8  
            sta $0709,y        ; $d884: 99 09 07  
            ldx $1e            ; $d887: a6 1e     
            jsr __getCycleModulo4         ; $d889: 20 5d d6  
            bne __d890         ; $d88c: d0 02     
            dec $71,x          ; $d88e: d6 71     
__d890:     inx                ; $d890: e8        
            iny                ; $d891: c8        
            iny                ; $d892: c8        
            iny                ; $d893: c8        
            iny                ; $d894: c8        
            cpx #$09           ; $d895: e0 09     
            bne __d878         ; $d897: d0 df     
__d899:     rts                ; $d899: 60        

;-------------------------------------------------------------------------------
__d89a:     .hex 3a 3b 3a 3b   ; $d89a: 3a 3b 3a 3b   Data

;-------------------------------------------------------------------------------
__d89e:     jsr __levelModulo4         ; $d89e: 20 5e c3  
            cpx #$03           ; $d8a1: e0 03     
				beq __return2         ; $d8a3: f0 5c   
			
            ldx #$00           ; $d8a5: a2 00     
__d8a7:     lda vButterflyXCaught,x          ; $d8a7: b5 b3     
            bne __d902         ; $d8a9: d0 57     
            .hex ad a6 00      ; $d8ab: ad a6 00  Bad Addr Mode - LDA $00a6
            bne __d8c8         ; $d8ae: d0 18     
            lda $d6,x          ; $d8b0: b5 d6     
            tay                ; $d8b2: a8        
            lda __e0a7,y       ; $d8b3: b9 a7 e0  
            clc                ; $d8b6: 18        
            adc $da,x          ; $d8b7: 75 da     
            tay                ; $d8b9: a8        
            lda __e02f,y       ; $d8ba: b9 2f e0  
            jsr __d915         ; $d8bd: 20 15 d9  
            tay                ; $d8c0: a8        
            dey                ; $d8c1: 88        
            lda __da3b,y       ; $d8c2: b9 3b da  
__d8c5:     sta vButterfly1Timer,x        ; $d8c5: 9d 00 02  
__d8c8:     inx                ; $d8c8: e8        
            cpx #$04           ; $d8c9: e0 04     
            bne __d8a7         ; $d8cb: d0 da     
__d8cd:     lda vCurrentLevel            ; $d8cd: a5 55     
            and #$03           ; $d8cf: 29 03     
            beq __d8d9         ; $d8d1: f0 06     
            lda vCycleCounter            ; $d8d3: a5 09     
            and #$01           ; $d8d5: 29 01     
            bne __d8ee         ; $d8d7: d0 15     
__d8d9:     ldx #$00           ; $d8d9: a2 00     
__d8db:     inc $da,x          ; $d8db: f6 da     
            lda $da,x          ; $d8dd: b5 da     
            cmp #$08           ; $d8df: c9 08     
            beq __d90c         ; $d8e1: f0 29     
__d8e3:     lda $d6,x          ; $d8e3: b5 d6     
            cmp #$a8           ; $d8e5: c9 a8     
            beq __d905         ; $d8e7: f0 1c     
__d8e9:     inx                ; $d8e9: e8        
            cpx #$04           ; $d8ea: e0 04     
            bne __d8db         ; $d8ec: d0 ed     
__d8ee:     ldx #$00           ; $d8ee: a2 00     
            ldy #$00           ; $d8f0: a0 00     
__d8f2:     lda vButterfly1Timer,x        ; $d8f2: bd 00 02  
            sta $0711,y        ; $d8f5: 99 11 07  
            inx                ; $d8f8: e8        
            iny                ; $d8f9: c8        
            iny                ; $d8fa: c8        
            iny                ; $d8fb: c8        
            iny                ; $d8fc: c8        
            cpx #$04           ; $d8fd: e0 04     
            bne __d8f2         ; $d8ff: d0 f1     
__return2:     
			rts                ; $d901: 60        

;-------------------------------------------------------------------------------
__d902:     jmp __d934         ; $d902: 4c 34 d9  

;-------------------------------------------------------------------------------
__d905:     lda #$00           ; $d905: a9 00     
            sta $d6,x          ; $d907: 95 d6     
            jmp __d8e9         ; $d909: 4c e9 d8  

;-------------------------------------------------------------------------------
__d90c:     lda #$00           ; $d90c: a9 00     
            sta $da,x          ; $d90e: 95 da     
            inc $d6,x          ; $d910: f6 d6     
            jmp __d8e3         ; $d912: 4c e3 d8  

;-------------------------------------------------------------------------------
__d915:     lsr                ; $d915: 4a        
            bcs __d922         ; $d916: b0 0a     
__d918:     lsr                ; $d918: 4a        
            bcs __d927         ; $d919: b0 0c     
__d91b:     lsr                ; $d91b: 4a        
            bcs __d92c         ; $d91c: b0 0e     
__d91e:     lsr                ; $d91e: 4a        
            bcs __d931         ; $d91f: b0 10     
            rts                ; $d921: 60        

;-------------------------------------------------------------------------------
__d922:     inc vButterfly1X,x          ; $d922: f6 73     
            jmp __d918         ; $d924: 4c 18 d9  

;-------------------------------------------------------------------------------
__d927:     dec vButterfly1X,x          ; $d927: d6 73     
            jmp __d91b         ; $d929: 4c 1b d9  

;-------------------------------------------------------------------------------
__d92c:     dec vButterfly1Y,x          ; $d92c: d6 93     
            jmp __d91e         ; $d92e: 4c 1e d9  

;-------------------------------------------------------------------------------
__d931:     inc vButterfly1Y,x          ; $d931: f6 93     
            rts                ; $d933: 60        

;-------------------------------------------------------------------------------
__d934:     lda $ea            ; $d934: a5 ea     
            bne __d945         ; $d936: d0 0d     
            lda #$01           ; $d938: a9 01     
            sta vSoundPlayerState            ; $d93a: 85 2a     
            sta $ea            ; $d93c: 85 ea     
            stx vBirdOffsetX            ; $d93e: 86 5c     
            jsr __give10Score         ; $d940: 20 fa fe  
            ldx vBirdOffsetX            ; $d943: a6 5c     
__d945:     jsr __d4fc         ; $d945: 20 fc d4  
            clc                ; $d948: 18        
            adc #$3c           ; $d949: 69 3c     
            sta vBirdOffsetX            ; $d94b: 85 5c     
            lda vBirdIsRight            ; $d94d: a5 5a     
            bne __d960         ; $d94f: d0 0f     
            lda vBirdOffsetX            ; $d951: a5 5c     
            sec                ; $d953: 38        
            sbc #$04           ; $d954: e9 04     
__d956:     sta vButterfly1X,x          ; $d956: 95 73     
            lda vCurrentLevel            ; $d958: a5 55     
            and #$03           ; $d95a: 29 03     
            tay                ; $d95c: a8        
            jmp __d9a4         ; $d95d: 4c a4 d9  

;-------------------------------------------------------------------------------
__d960:     lda vBirdOffsetX            ; $d960: a5 5c     
            clc                ; $d962: 18        
            adc #$04           ; $d963: 69 04     
            jmp __d956         ; $d965: 4c 56 d9  

;-------------------------------------------------------------------------------
__d968:     lda vNestling1Timer          ; $d968: ad 05 02  
            cmp #$40           ; $d96b: c9 40     
            bcc __d9d4         ; $d96d: 90 65     
            cmp vNestlingAwayState            ; $d96f: c5 65     
            beq __d9d4         ; $d971: f0 61     
            inc vNestling1State            ; $d973: e6 8c     
            jsr __d9f6         ; $d975: 20 f6 d9  
            lda #$00           ; $d978: a9 00     
            sta vNestling1Timer          ; $d97a: 8d 05 02  
__d97d:     sta vButterflyXCaught,x          ; $d97d: 95 b3     
            sta vButterfly1Y,x          ; $d97f: 95 93     
            lda #$05           ; $d981: a9 05     
            sta vSoundPlayerState            ; $d983: 85 2a     
            lda #$00           ; $d985: a9 00     
            sta $ea            ; $d987: 85 ea     
            jmp __d8c5         ; $d989: 4c c5 d8  

;-------------------------------------------------------------------------------
__d98c:     lda vNestling2Timer          ; $d98c: ad 06 02  
            cmp #$40           ; $d98f: c9 40     
            bcc __d9d4         ; $d991: 90 41     
            cmp vNestlingAwayState            ; $d993: c5 65     
            beq __d9d4         ; $d995: f0 3d     
            inc vNestling2State            ; $d997: e6 8d     
            jsr __d9fd         ; $d999: 20 fd d9  
            lda #$00           ; $d99c: a9 00     
            sta vNestling2Timer          ; $d99e: 8d 06 02  
            jmp __d97d         ; $d9a1: 4c 7d d9  

;-------------------------------------------------------------------------------
__d9a4:     lda vBirdSpritePosY          ; $d9a4: ad 00 07  
            cmp __da43,y       ; $d9a7: d9 43 da  
            bne __d9d7         ; $d9aa: d0 2b     
            lda vButterfly1X,x          ; $d9ac: b5 73     
            cmp __da46,y       ; $d9ae: d9 46 da  
            bcc __d9d4         ; $d9b1: 90 21     
            cmp __da49,y       ; $d9b3: d9 49 da  
            bcc __d968         ; $d9b6: 90 b0     
            cmp __da4c,y       ; $d9b8: d9 4c da  
            bcc __d9d4         ; $d9bb: 90 17     
            cmp __da4f,y       ; $d9bd: d9 4f da  
            bcc __d98c         ; $d9c0: 90 ca     
            lda vCurrentLevel            ; $d9c2: a5 55     
            cmp #$10           ; $d9c4: c9 10     
            bcc __d9d4         ; $d9c6: 90 0c     
            lda vButterfly1X,x          ; $d9c8: b5 73     
            cmp __da52,y       ; $d9ca: d9 52 da  
            bcc __d9d4         ; $d9cd: 90 05     
            cmp __da55,y       ; $d9cf: d9 55 da  
            bcc __d9de         ; $d9d2: 90 0a     
__d9d4:     lda vBirdSpritePosY          ; $d9d4: ad 00 07  
__d9d7:     sta vButterfly1Y,x          ; $d9d7: 95 93     
            lda #$1e           ; $d9d9: a9 1e     
            jmp __d8c5         ; $d9db: 4c c5 d8  

;-------------------------------------------------------------------------------
__d9de:     lda vNestling3Timer          ; $d9de: ad 07 02  
            cmp #$40           ; $d9e1: c9 40     
            bcc __d9d4         ; $d9e3: 90 ef     
            cmp vNestlingAwayState            ; $d9e5: c5 65     
            beq __d9d4         ; $d9e7: f0 eb     
            inc vNestling3State            ; $d9e9: e6 8e     
            jsr __da04         ; $d9eb: 20 04 da  
            lda #$00           ; $d9ee: a9 00     
            sta vNestling3Timer          ; $d9f0: 8d 07 02  
            jmp __d97d         ; $d9f3: 4c 7d d9  

;-------------------------------------------------------------------------------
__d9f6:     stx vBirdOffsetX            ; $d9f6: 86 5c     
            ldx #$00           ; $d9f8: a2 00     
            jmp __da08         ; $d9fa: 4c 08 da  

;-------------------------------------------------------------------------------
__d9fd:     stx vBirdOffsetX            ; $d9fd: 86 5c     
            ldx #$01           ; $d9ff: a2 01     
            jmp __da08         ; $da01: 4c 08 da  

;-------------------------------------------------------------------------------
__da04:     stx vBirdOffsetX            ; $da04: 86 5c     
            ldx #$02           ; $da06: a2 02     
__da08:     lda vNestling1Timer,x        ; $da08: bd 05 02  
            cmp #$a0           ; $da0b: c9 a0     
            bcc __da26         ; $da0d: 90 17     
            cmp #$e0           ; $da0f: c9 e0     
            bcc __da32         ; $da11: 90 1f     
            cmp #$f0           ; $da13: c9 f0     
            bcc __da1d         ; $da15: 90 06     
            inc $022b          ; $da17: ee 2b 02  
            ldx vBirdOffsetX            ; $da1a: a6 5c     
            rts                ; $da1c: 60        

;-------------------------------------------------------------------------------
__da1d:     inc $022a          ; $da1d: ee 2a 02  
__da20:     jsr __give10Score         ; $da20: 20 fa fe  
            ldx vBirdOffsetX            ; $da23: a6 5c     
__da25:     rts                ; $da25: 60        

;-------------------------------------------------------------------------------
__da26:     jsr __give10Score         ; $da26: 20 fa fe  
            jsr __give10Score         ; $da29: 20 fa fe  
            inc $0228          ; $da2c: ee 28 02  
            jmp __da20         ; $da2f: 4c 20 da  

;-------------------------------------------------------------------------------
__da32:     jsr __give10Score         ; $da32: 20 fa fe  
            inc $0229          ; $da35: ee 29 02  
            jmp __da20         ; $da38: 4c 20 da  

;-------------------------------------------------------------------------------
__da3b:     .hex 20 1e 1e 20   ; $da3b: 20 1e 1e 20   Data
            .hex 21 1f 1f 21   ; $da3f: 21 1f 1f 21   Data
__da43:     .hex 70 60 60      ; $da43: 70 60 60      Data
__da46:     .hex 3e 5e 1e      ; $da46: 3e 5e 1e      Data
__da49:     .hex 42 62 22      ; $da49: 42 62 22      Data
__da4c:     .hex 46 66 26      ; $da4c: 46 66 26      Data
__da4f:     .hex 4a 6a 2a      ; $da4f: 4a 6a 2a      Data
__da52:     .hex 4e 6e 2e      ; $da52: 4e 6e 2e      Data
__da55:     .hex 52 72 32      ; $da55: 52 72 32      Data

;-------------------------------------------------------------------------------
__da58:     lda vCurrentLevel            ; $da58: a5 55     
            and #$07           ; $da5a: 29 07     
            cmp #$03           ; $da5c: c9 03     
            bne __da25         ; $da5e: d0 c5     
            ldx #$00           ; $da60: a2 00     
__da62:     lda vButterflyXCaught,x          ; $da62: b5 b3     
            bne __da98         ; $da64: d0 32     
            lda vButterfly1Y,x          ; $da66: b5 93     
            cmp #$d4           ; $da68: c9 d4     
            bcs __dac3         ; $da6a: b0 57     
__da6c:     lda $d6,x          ; $da6c: b5 d6     
            tay                ; $da6e: a8        
            lda __dc14,y       ; $da6f: b9 14 dc  
            sta $51            ; $da72: 85 51     
            lda $da,x          ; $da74: b5 da     
            clc                ; $da76: 18        
            adc $51            ; $da77: 65 51     
            tay                ; $da79: a8        
            lda __dba4,y       ; $da7a: b9 a4 db  
            lsr                ; $da7d: 4a        
            bcs __daa1         ; $da7e: b0 21     
__da80:     lsr                ; $da80: 4a        
            bcs __daa6         ; $da81: b0 23     
__da83:     lsr                ; $da83: 4a        
            bcs __daab         ; $da84: b0 25     
__da86:     lsr                ; $da86: 4a        
            bcs __dab0         ; $da87: b0 27     
__da89:     tay                ; $da89: a8        
            lda __dba0,y       ; $da8a: b9 a0 db  
            sta vButterfly1Timer,x        ; $da8d: 9d 00 02  
            inx                ; $da90: e8        
            cpx #$04           ; $da91: e0 04     
            bne __da62         ; $da93: d0 cd     
            jmp __d8cd         ; $da95: 4c cd d8  

;-------------------------------------------------------------------------------
__da98:     jsr __dab5         ; $da98: 20 b5 da  
            jsr __dac3         ; $da9b: 20 c3 da  
            jmp __da6c         ; $da9e: 4c 6c da  

;-------------------------------------------------------------------------------
__daa1:     inc vButterfly1X,x          ; $daa1: f6 73     
            jmp __da80         ; $daa3: 4c 80 da  

;-------------------------------------------------------------------------------
__daa6:     dec vButterfly1X,x          ; $daa6: d6 73     
            jmp __da83         ; $daa8: 4c 83 da  

;-------------------------------------------------------------------------------
__daab:     dec vButterfly1Y,x          ; $daab: d6 93     
            jmp __da86         ; $daad: 4c 86 da  

;-------------------------------------------------------------------------------
__dab0:     inc vButterfly1Y,x          ; $dab0: f6 93     
            jmp __da89         ; $dab2: 4c 89 da  

;-------------------------------------------------------------------------------
__dab5:     lda #$00           ; $dab5: a9 00     
            sta vButterflyXCaught,x          ; $dab7: 95 b3     
            sta $0310,x        ; $dab9: 9d 10 03  
            lda #$06           ; $dabc: a9 06     
            sta vSoundPlayerState            ; $dabe: 85 2a     
            inc vBonusItemsCaught            ; $dac0: e6 8b     
            rts                ; $dac2: 60        

;-------------------------------------------------------------------------------
__dac3:     lda #$00           ; $dac3: a9 00     
            sta $da,x          ; $dac5: 95 da     
            lda #$d3           ; $dac7: a9 d3     
            sta vButterfly1Y,x          ; $dac9: 95 93     
            lda vRandomVar2            ; $dacb: a5 17     
            and #$01           ; $dacd: 29 01     
            bne __dae3         ; $dacf: d0 12     
            lda vRandomVar            ; $dad1: a5 08     
            and #$03           ; $dad3: 29 03     
            beq __daf3         ; $dad5: f0 1c     
            cmp #$01           ; $dad7: c9 01     
            beq __dafa         ; $dad9: f0 1f     
            cmp #$02           ; $dadb: c9 02     
            beq __db03         ; $dadd: f0 24     
            cmp #$03           ; $dadf: c9 03     
            beq __db0c         ; $dae1: f0 29     
__dae3:     lda vCycleCounter            ; $dae3: a5 09     
            and #$03           ; $dae5: 29 03     
            beq __db15         ; $dae7: f0 2c     
            cmp #$01           ; $dae9: c9 01     
            beq __db1e         ; $daeb: f0 31     
            cmp #$02           ; $daed: c9 02     
            beq __db27         ; $daef: f0 36     
            bne __db30         ; $daf1: d0 3d     
__daf3:     lda #$00           ; $daf3: a9 00     
            sta vButterfly1X,x          ; $daf5: 95 73     
__daf7:     sta $d6,x          ; $daf7: 95 d6     
__daf9:     rts                ; $daf9: 60        

;-------------------------------------------------------------------------------
__dafa:     lda #$20           ; $dafa: a9 20     
            sta vButterfly1X,x          ; $dafc: 95 73     
            lda #$10           ; $dafe: a9 10     
            jmp __daf7         ; $db00: 4c f7 da  

;-------------------------------------------------------------------------------
__db03:     lda #$40           ; $db03: a9 40     
            sta vButterfly1X,x          ; $db05: 95 73     
            lda #$20           ; $db07: a9 20     
            jmp __daf7         ; $db09: 4c f7 da  

;-------------------------------------------------------------------------------
__db0c:     lda #$60           ; $db0c: a9 60     
            sta vButterfly1X,x          ; $db0e: 95 73     
            lda #$30           ; $db10: a9 30     
            jmp __daf7         ; $db12: 4c f7 da  

;-------------------------------------------------------------------------------
__db15:     lda #$80           ; $db15: a9 80     
            sta vButterfly1X,x          ; $db17: 95 73     
            lda #$38           ; $db19: a9 38     
            jmp __daf7         ; $db1b: 4c f7 da  

;-------------------------------------------------------------------------------
__db1e:     lda #$a0           ; $db1e: a9 a0     
            sta vButterfly1X,x          ; $db20: 95 73     
            lda #$48           ; $db22: a9 48     
            jmp __daf7         ; $db24: 4c f7 da  

;-------------------------------------------------------------------------------
__db27:     lda #$c0           ; $db27: a9 c0     
            sta vButterfly1X,x          ; $db29: 95 73     
            lda #$58           ; $db2b: a9 58     
            jmp __daf7         ; $db2d: 4c f7 da  

;-------------------------------------------------------------------------------
__db30:     lda #$e0           ; $db30: a9 e0     
            sta vButterfly1X,x          ; $db32: 95 73     
            lda #$68           ; $db34: a9 68     
            jmp __daf7         ; $db36: 4c f7 da  

;-------------------------------------------------------------------------------
__db39:     lda vCurrentLevel            ; $db39: a5 55     
            and #$07           ; $db3b: 29 07     
            cmp #$07           ; $db3d: c9 07     
            bne __daf9         ; $db3f: d0 b8     
            ldx #$00           ; $db41: a2 00     
__db43:     lda vButterflyXCaught,x          ; $db43: b5 b3     
            bne __db6e         ; $db45: d0 27     
            lda vButterfly1Y,x          ; $db47: b5 93     
            cmp #$d0           ; $db49: c9 d0     
            bcs __db71         ; $db4b: b0 24     
            lda $0310,x        ; $db4d: bd 10 03  
            beq __db71         ; $db50: f0 1f     
            cmp #$20           ; $db52: c9 20     
            bcc __db58         ; $db54: 90 02     
            inc vButterfly1Y,x          ; $db56: f6 93     
__db58:     lda vCycleCounter            ; $db58: a5 09     
            and #$01           ; $db5a: 29 01     
            bne __db61         ; $db5c: d0 03     
            inc $0310,x        ; $db5e: fe 10 03  
__db61:     lda #$89           ; $db61: a9 89     
            sta vButterfly1Timer,x        ; $db63: 9d 00 02  
            inx                ; $db66: e8        
            cpx #$04           ; $db67: e0 04     
            bne __db43         ; $db69: d0 d8     
            jmp __d8ee         ; $db6b: 4c ee d8  

;-------------------------------------------------------------------------------
__db6e:     jsr __dab5         ; $db6e: 20 b5 da  
__db71:     lda #$01           ; $db71: a9 01     
            sta $0310,x        ; $db73: 9d 10 03  
            jsr __dac3         ; $db76: 20 c3 da  
            jmp __db7c         ; $db79: 4c 7c db  

;-------------------------------------------------------------------------------
__db7c:     lda vRandomVar            ; $db7c: a5 08     
            and #$03           ; $db7e: 29 03     
            beq __db91         ; $db80: f0 0f     
            cmp #$01           ; $db82: c9 01     
            beq __db96         ; $db84: f0 10     
            cmp #$02           ; $db86: c9 02     
            beq __db9b         ; $db88: f0 11     
            lda #$30           ; $db8a: a9 30     
__db8c:     sta vButterfly1Y,x          ; $db8c: 95 93     
            jmp __db61         ; $db8e: 4c 61 db  

;-------------------------------------------------------------------------------
__db91:     lda #$40           ; $db91: a9 40     
            jmp __db8c         ; $db93: 4c 8c db  

;-------------------------------------------------------------------------------
__db96:     lda #$50           ; $db96: a9 50     
            jmp __db8c         ; $db98: 4c 8c db  

;-------------------------------------------------------------------------------
__db9b:     lda #$60           ; $db9b: a9 60     
            jmp __db8c         ; $db9d: 4c 8c db  

;-------------------------------------------------------------------------------
__dba0:     .hex 22 23 25 24   ; $dba0: 22 23 25 24   Data
__dba4:     .hex 01 01 01 05   ; $dba4: 01 01 01 05   Data
            .hex 01 01 01 05   ; $dba8: 01 01 01 05   Data
            .hex 12 12 12 16   ; $dbac: 12 12 12 16   Data
            .hex 12 12 12 16   ; $dbb0: 12 12 12 16   Data
            .hex 05 05 05 04   ; $dbb4: 05 05 05 04   Data
            .hex 05 05 05 04   ; $dbb8: 05 05 05 04   Data
            .hex 16 16 16 14   ; $dbbc: 16 16 16 14   Data
            .hex 16 16 16 14   ; $dbc0: 16 16 16 14   Data
            .hex 04 05 04 05   ; $dbc4: 04 05 04 05   Data
            .hex 04 05 04 05   ; $dbc8: 04 05 04 05   Data
            .hex 14 16 14 16   ; $dbcc: 14 16 14 16   Data
            .hex 14 16 14 16   ; $dbd0: 14 16 14 16   Data
            .hex 01 05 01 05   ; $dbd4: 01 05 01 05   Data
            .hex 01 05 01 05   ; $dbd8: 01 05 01 05   Data
            .hex 12 16 12 16   ; $dbdc: 12 16 12 16   Data
            .hex 12 16 12 16   ; $dbe0: 12 16 12 16   Data
            .hex 2a 2a 2a 28   ; $dbe4: 2a 2a 2a 28   Data
            .hex 2a 2a 2a 28   ; $dbe8: 2a 2a 2a 28   Data
            .hex 39 39 39 38   ; $dbec: 39 39 39 38   Data
            .hex 39 39 39 38   ; $dbf0: 39 39 39 38   Data
            .hex 28 2a 28 2a   ; $dbf4: 28 2a 28 2a   Data
            .hex 28 2a 28 2a   ; $dbf8: 28 2a 28 2a   Data
            .hex 38 39 38 39   ; $dbfc: 38 39 38 39   Data
            .hex 38 39 38 39   ; $dc00: 38 39 38 39   Data
            .hex 22 2a 22 2a   ; $dc04: 22 2a 22 2a   Data
            .hex 22 2a 22 2a   ; $dc08: 22 2a 22 2a   Data
            .hex 31 39 31 39   ; $dc0c: 31 39 31 39   Data
            .hex 31 39 31 39   ; $dc10: 31 39 31 39   Data
__dc14:     .hex 20 20 20 20   ; $dc14: 20 20 20 20   Data
            .hex 10 10 00 00   ; $dc18: 10 10 00 00   Data
            .hex 00 48 48 58   ; $dc1c: 00 48 48 58   Data
            .hex 58 58 58 58   ; $dc20: 58 58 58 58   Data
            .hex 10 10 10 30   ; $dc24: 10 10 10 30   Data
            .hex 30 30 00 00   ; $dc28: 30 30 00 00   Data
            .hex 00 00 68 68   ; $dc2c: 00 00 68 68   Data
            .hex 48 58 58 58   ; $dc30: 48 58 58 58   Data
            .hex 20 20 20 20   ; $dc34: 20 20 20 20   Data
            .hex 20 20 10 30   ; $dc38: 20 20 10 30   Data
            .hex 48 58 58 58   ; $dc3c: 48 58 58 58   Data
            .hex 58 58 58 58   ; $dc40: 58 58 58 58   Data
            .hex 20 20 10 30   ; $dc44: 20 20 10 30   Data
            .hex 48 58 58 58   ; $dc48: 48 58 58 58   Data
            .hex 28 28 28 28   ; $dc4c: 28 28 28 28   Data
            .hex 18 18 08 08   ; $dc50: 18 18 08 08   Data
            .hex 08 40 40 50   ; $dc54: 08 40 40 50   Data
            .hex 50 50 50 50   ; $dc58: 50 50 50 50   Data
            .hex 18 18 18 38   ; $dc5c: 18 18 18 38   Data
            .hex 38 38 08 08   ; $dc60: 38 38 08 08   Data
            .hex 08 08 60 60   ; $dc64: 08 08 60 60   Data
            .hex 40 50 50 50   ; $dc68: 40 50 50 50   Data
            .hex 28 28 28 28   ; $dc6c: 28 28 28 28   Data
            .hex 28 28 18 38   ; $dc70: 28 28 18 38   Data
            .hex 40 50 50 50   ; $dc74: 40 50 50 50   Data
            .hex 50 50 50 50   ; $dc78: 50 50 50 50   Data
            .hex 28 28 18 38   ; $dc7c: 28 28 18 38   Data
            .hex 40 50 50 50   ; $dc80: 40 50 50 50   Data

;-------------------------------------------------------------------------------
__dc84:     lda vPlayerInput            ; $dc84: a5 0a     
            and #$01           ; $dc86: 29 01     
            bne __dcb2         ; $dc88: d0 28     
            ldx #$00           ; $dc8a: a2 00     
__dc8c:     lda vIsCreatureDead,x        ; $dc8c: bd 10 02  
            bne __dcb8         ; $dc8f: d0 27     
__dc91:     inx                ; $dc91: e8        
            cpx #$06           ; $dc92: e0 06     
            bne __dc8c         ; $dc94: d0 f6     
            lda vIsBirdLanded            ; $dc96: a5 61     
            bne __dcc9         ; $dc98: d0 2f     
            lda $ba            ; $dc9a: a5 ba     
            bne __dcd0         ; $dc9c: d0 32     
__dc9e:     lda $9a            ; $dc9e: a5 9a     
            cmp #$cc           ; $dca0: c9 cc     
            bcs __dca9         ; $dca2: b0 05     
            .hex e6            ; $dca4: e6        Suspected data
__dca5:     txs                ; $dca5: 9a        
            inc $9a            ; $dca6: e6 9a     
            rts                ; $dca8: 60        

;-------------------------------------------------------------------------------
__dca9:     .hex a9            ; $dca9: a9        Suspected data
__dcaa:     brk                ; $dcaa: 00        
            .hex 85            ; $dcab: 85        Suspected data
__dcac:     .hex e7 a9         ; $dcac: e7 a9     Invalid Opcode - ISC $a9
            cpy $9a85          ; $dcae: cc 85 9a  
            rts                ; $dcb1: 60        

;-------------------------------------------------------------------------------
__dcb2:     jsr __dcc2         ; $dcb2: 20 c2 dc  
            jmp __dc9e         ; $dcb5: 4c 9e dc  

;-------------------------------------------------------------------------------
__dcb8:     lda $9a            ; $dcb8: a5 9a     
            .hex c9            ; $dcba: c9        Suspected data
__dcbb:     cpy __e690         ; $dcbb: cc 90 e6  
            lda #$f0           ; $dcbe: a9 f0     
            sta $9a            ; $dcc0: 85 9a     
__dcc2:     lda #$00           ; $dcc2: a9 00     
            sta $ba            ; $dcc4: 85 ba     
            .hex 85            ; $dcc6: 85        Suspected data
__dcc7:     .hex e7 60         ; $dcc7: e7 60     Invalid Opcode - ISC $60
__dcc9:     lda #$00           ; $dcc9: a9 00     
__dccb:     sta $ba            ; $dccb: 85 ba     
            jmp __dc9e         ; $dccd: 4c 9e dc  

;-------------------------------------------------------------------------------
__dcd0:     lda vBirdSpritePosY          ; $dcd0: ad 00 07  
__dcd3:     cmp #$c8           ; $dcd3: c9 c8     
            bcs __dcdc         ; $dcd5: b0 05     
            clc                ; $dcd7: 18        
            adc #$0c           ; $dcd8: 69 0c     
            sta $9a            ; $dcda: 85 9a     
__dcdc:     jsr __d4fc         ; $dcdc: 20 fc d4  
            clc                ; $dcdf: 18        
            adc #$3c           ; $dce0: 69 3c     
            sta $7a            ; $dce2: 85 7a     
            rts                ; $dce4: 60        

;-------------------------------------------------------------------------------
__dce5:     jsr __levelModulo4         ; $dce5: 20 5e c3  
            cpx #$02           ; $dce8: e0 02     
            bne __dd1b         ; $dcea: d0 2f     
            ldy $0261          ; $dcec: ac 61 02  
            lda $0214          ; $dcef: ad 14 02  
            bne __dcff         ; $dcf2: d0 0b     
            lda $88            ; $dcf4: a5 88     
            bne __dcff         ; $dcf6: d0 07     
            tya                ; $dcf8: 98        
            lsr                ; $dcf9: 4a        
            bne __dd4b         ; $dcfa: d0 4f     
            jmp __dd6f         ; $dcfc: 4c 6f dd  

;-------------------------------------------------------------------------------
__dcff:     lda $025a          ; $dcff: ad 5a 02  
            beq __dd1c         ; $dd02: f0 18     
__dd04:     tya                ; $dd04: 98        
            and #$01           ; $dd05: 29 01     
            bne __dd28         ; $dd07: d0 1f     
            lda #$7b           ; $dd09: a9 7b     
            sta vWoodPeckerSprite          ; $dd0b: 8d 3d 07  
            lda vWoodpeckerSquirrelY            ; $dd0e: a5 9e     
            cmp #$b0           ; $dd10: c9 b0     
            bcs __dd3a         ; $dd12: b0 26     
            jsr __isOddCycle         ; $dd14: 20 58 d6  
            bne __dd1b         ; $dd17: d0 02     
            inc vWoodpeckerSquirrelY            ; $dd19: e6 9e     
__dd1b:     rts                ; $dd1b: 60        

;-------------------------------------------------------------------------------
__dd1c:     inc $025a          ; $dd1c: ee 5a 02  
            jsr __d64f         ; $dd1f: 20 4f d6  
            jsr __c545         ; $dd22: 20 45 c5  
            jmp __dd04         ; $dd25: 4c 04 dd  

;-------------------------------------------------------------------------------
__dd28:     tya                ; $dd28: 98        
            and #$08           ; $dd29: 29 08     
            bne __dd35         ; $dd2b: d0 08     
            lda #$79           ; $dd2d: a9 79     
__dd2f:     sta vWoodPeckerSprite          ; $dd2f: 8d 3d 07  
            jmp __dd4b         ; $dd32: 4c 4b dd  

;-------------------------------------------------------------------------------
__dd35:     lda #$78           ; $dd35: a9 78     
            jmp __dd2f         ; $dd37: 4c 2f dd  

;-------------------------------------------------------------------------------
__dd3a:     lda vInvulnTimer            ; $dd3a: a5 bf     
            bne __dd1b         ; $dd3c: d0 dd     
            lda #$00           ; $dd3e: a9 00     
            sta $88            ; $dd40: 85 88     
            sta $be            ; $dd42: 85 be     
            sta $0214          ; $dd44: 8d 14 02  
            sta $025a          ; $dd47: 8d 5a 02  
            rts                ; $dd4a: 60        

;-------------------------------------------------------------------------------
__dd4b:     lda vWoodpeckerSquirrelX            ; $dd4b: a5 7e     
            and #$1f           ; $dd4d: 29 1f     
            cmp #$18           ; $dd4f: c9 18     
            beq __dd65         ; $dd51: f0 12     
            jsr __getCycleModulo4         ; $dd53: 20 5d d6  
            bne __dd5a         ; $dd56: d0 02     
            inc vWoodpeckerSquirrelY            ; $dd58: e6 9e     
__dd5a:     tya                ; $dd5a: 98        
            and #$08           ; $dd5b: 29 08     
            bne __dd62         ; $dd5d: d0 03     
            dec vWoodpeckerSquirrelX            ; $dd5f: c6 7e     
            rts                ; $dd61: 60        

;-------------------------------------------------------------------------------
__dd62:     inc vWoodpeckerSquirrelX            ; $dd62: e6 7e     
            rts                ; $dd64: 60        

;-------------------------------------------------------------------------------
__dd65:     lda #$00           ; $dd65: a9 00     
            sta $0261          ; $dd67: 8d 61 02  
            rts                ; $dd6a: 60        

;-------------------------------------------------------------------------------
            ror $7f7a,x        ; $dd6b: 7e 7a 7f  
            .hex 7a            ; $dd6e: 7a        Invalid Opcode - NOP 
__dd6f:     lda vWoodpeckerSquirrelY            ; $dd6f: a5 9e     
            cmp #$a0           ; $dd71: c9 a0     
            bcs __dd79         ; $dd73: b0 04     
            lda vRandomVar            ; $dd75: a5 08     
            beq __dd91         ; $dd77: f0 18     
__dd79:     jsr __getCycleModulo4         ; $dd79: 20 5d d6  
            bne __ddb3         ; $dd7c: d0 35     
            lda vWoodpeckerSquirrelY            ; $dd7e: a5 9e     
            cmp #$30           ; $dd80: c9 30     
            bcc __ddc4         ; $dd82: 90 40     
            cmp #$90           ; $dd84: c9 90     
            bcs __ddd0         ; $dd86: b0 48     
            lda vWoodpeckerSquirrelY            ; $dd88: a5 9e     
            cmp vBirdSpritePosY          ; $dd8a: cd 00 07  
            bcc __ddc4         ; $dd8d: 90 35     
            bcs __ddd0         ; $dd8f: b0 3f     
__dd91:     tya                ; $dd91: 98        
            ora #$01           ; $dd92: 09 01     
            sta $0261          ; $dd94: 8d 61 02  
            lda vWoodpeckerSquirrelX            ; $dd97: a5 7e     
            sta vBirdX            ; $dd99: 85 5b     
            jsr __d5fc         ; $dd9b: 20 fc d5  
            lda vBirdX            ; $dd9e: a5 5b     
            cmp #$01           ; $dda0: c9 01     
            bne __ddb4         ; $dda2: d0 10     
            lda $0261          ; $dda4: ad 61 02  
            ora #$f7           ; $dda7: 09 f7     
            sta $0261          ; $dda9: 8d 61 02  
            lda #$77           ; $ddac: a9 77     
            sta vWoodPeckerSprite          ; $ddae: 8d 3d 07  
            dec vWoodpeckerSquirrelX            ; $ddb1: c6 7e     
__ddb3:     rts                ; $ddb3: 60        

;-------------------------------------------------------------------------------
__ddb4:     lda $0261          ; $ddb4: ad 61 02  
            ora #$08           ; $ddb7: 09 08     
            sta $0261          ; $ddb9: 8d 61 02  
            lda #$76           ; $ddbc: a9 76     
            sta vWoodPeckerSprite          ; $ddbe: 8d 3d 07  
            inc vWoodpeckerSquirrelX            ; $ddc1: e6 7e     
            rts                ; $ddc3: 60        

;-------------------------------------------------------------------------------
__ddc4:     jsr __setXEvery8Cycle         ; $ddc4: 20 8b d0  
            lda __dddc,x       ; $ddc7: bd dc dd  
            sta vWoodPeckerSprite          ; $ddca: 8d 3d 07  
            inc vWoodpeckerSquirrelY            ; $ddcd: e6 9e     
            rts                ; $ddcf: 60        

;-------------------------------------------------------------------------------
__ddd0:     jsr __setXEvery8Cycle         ; $ddd0: 20 8b d0  
            lda __dddc,x       ; $ddd3: bd dc dd  
            sta vWoodPeckerSprite          ; $ddd6: 8d 3d 07  
            dec vWoodpeckerSquirrelY            ; $ddd9: c6 9e     
            rts                ; $dddb: 60        

;-------------------------------------------------------------------------------
__dddc:     .hex 7c 7a 7d 7a   ; $dddc: 7c 7a 7d 7a   Data

;-------------------------------------------------------------------------------
__dde0:     jsr __levelModulo4         ; $dde0: 20 5e c3  
            cpx #$01           ; $dde3: e0 01     
            beq __ddf4         ; $dde5: f0 0d     
            lda vCurrentLevel            ; $dde7: a5 55     
            and #$0f           ; $dde9: 29 0f     
            cmp #$0c           ; $ddeb: c9 0c     
            beq __ddf3         ; $dded: f0 04     
            cmp #$09           ; $ddef: c9 09     
            bcs __ddf4         ; $ddf1: b0 01     
__ddf3:     rts                ; $ddf3: 60        

;-------------------------------------------------------------------------------
__ddf4:     lda $0212          ; $ddf4: ad 12 02  
            bne __de07         ; $ddf7: d0 0e     
            lda $a8            ; $ddf9: a5 a8     
            bne __de07         ; $ddfb: d0 0a     
            lda $a7            ; $ddfd: a5 a7     
            bne __de07         ; $ddff: d0 06     
            jsr __de78         ; $de01: 20 78 de  
            jmp __de78         ; $de04: 4c 78 de  

;-------------------------------------------------------------------------------
__de07:     lda $a7            ; $de07: a5 a7     
            beq __de1d         ; $de09: f0 12     
            lda vFoxY            ; $de0b: a5 9b     
            cmp #$c8           ; $de0d: c9 c8     
            bcs __de25         ; $de0f: b0 14     
            inc vFoxY            ; $de11: e6 9b     
            jsr __setXEvery4Cycle         ; $de13: 20 93 d0  
            lda __df13,x       ; $de16: bd 13 df  
            sta $0731          ; $de19: 8d 31 07  
            rts                ; $de1c: 60        

;-------------------------------------------------------------------------------
__de1d:     jsr __d64f         ; $de1d: 20 4f d6  
            inc $a7            ; $de20: e6 a7     
            jmp __c545         ; $de22: 4c 45 c5  

;-------------------------------------------------------------------------------
__de25:     lda #$91           ; $de25: a9 91     
            sta $0731          ; $de27: 8d 31 07  
            inc $a7            ; $de2a: e6 a7     
            lda $a7            ; $de2c: a5 a7     
            cmp #$f0           ; $de2e: c9 f0     
            bne __de3d         ; $de30: d0 0b     
            lda #$00           ; $de32: a9 00     
            sta $a7            ; $de34: 85 a7     
            sta $a8            ; $de36: 85 a8     
            sta $0212          ; $de38: 8d 12 02  
            sta $bb            ; $de3b: 85 bb     
__de3d:     rts                ; $de3d: 60        

;-------------------------------------------------------------------------------
__de3e:     lda vRandomVar            ; $de3e: a5 08     
            and #$03           ; $de40: 29 03     
            beq __de59         ; $de42: f0 15     
            lda vFoxX            ; $de44: a5 7b     
            sta vBirdX            ; $de46: 85 5b     
            jsr __d5fc         ; $de48: 20 fc d5  
            cmp #$01           ; $de4b: c9 01     
            beq __de54         ; $de4d: f0 05     
            lda #$00           ; $de4f: a9 00     
            jmp __de66         ; $de51: 4c 66 de  

;-------------------------------------------------------------------------------
__de54:     lda #$10           ; $de54: a9 10     
            jmp __de66         ; $de56: 4c 66 de  

;-------------------------------------------------------------------------------
__de59:     lda vFoxX            ; $de59: a5 7b     
            sta vBirdX            ; $de5b: 85 5b     
            jsr __d5fc         ; $de5d: 20 fc d5  
            cmp #$01           ; $de60: c9 01     
            beq __de73         ; $de62: f0 0f     
            lda #$05           ; $de64: a9 05     
__de66:     sta $0290          ; $de66: 8d 90 02  
            lda #$00           ; $de69: a9 00     
            sta $0291          ; $de6b: 8d 91 02  
            lda #$c4           ; $de6e: a9 c4     
            sta vFoxY            ; $de70: 85 9b     
            rts                ; $de72: 60        

;-------------------------------------------------------------------------------
__de73:     lda #$15           ; $de73: a9 15     
            jmp __de66         ; $de75: 4c 66 de  

;-------------------------------------------------------------------------------
__de78:     lda vFoxY            ; $de78: a5 9b     
            cmp #$c8           ; $de7a: c9 c8     
            bcs __de3e         ; $de7c: b0 c0     
            lda $0290          ; $de7e: ad 90 02  
            tay                ; $de81: a8        
            lda __deb3,y       ; $de82: b9 b3 de  
            clc                ; $de85: 18        
            adc $0291          ; $de86: 6d 91 02  
            tay                ; $de89: a8        
            lda __ded3,y       ; $de8a: b9 d3 de  
            ldx #$08           ; $de8d: a2 08     
            jsr __d915         ; $de8f: 20 15 d9  
            tay                ; $de92: a8        
            lda __df17,y       ; $de93: b9 17 df  
            sta $0731          ; $de96: 8d 31 07  
            jsr __isOddCycle         ; $de99: 20 58 d6  
            bne __deb2         ; $de9c: d0 14     
            inc $0291          ; $de9e: ee 91 02  
            lda $0291          ; $dea1: ad 91 02  
            cmp #$08           ; $dea4: c9 08     
            beq __deaa         ; $dea6: f0 02     
            bne __deb2         ; $dea8: d0 08     
__deaa:     lda #$00           ; $deaa: a9 00     
            sta $0291          ; $deac: 8d 91 02  
            inc $0290          ; $deaf: ee 90 02  
__deb2:     rts                ; $deb2: 60        

;-------------------------------------------------------------------------------
__deb3:     .hex 00 08 10 18   ; $deb3: 00 08 10 18   Data
            .hex 18 00 00 00   ; $deb7: 18 00 00 00   Data
            .hex 00 08 10 18   ; $debb: 00 08 10 18   Data
            .hex 18 18 18 18   ; $debf: 18 18 18 18   Data
            .hex 20 28 30 38   ; $dec3: 20 28 30 38   Data
            .hex 38 20 20 20   ; $dec7: 38 20 20 20   Data
            .hex 20 28 30 38   ; $decb: 20 28 30 38   Data
            .hex 38 38 38 38   ; $decf: 38 38 38 38   Data
__ded3:     .hex 04 04 04 04   ; $ded3: 04 04 04 04   Data
            .hex 04 04 04 04   ; $ded7: 04 04 04 04   Data
            .hex 05 00 05 00   ; $dedb: 05 00 05 00   Data
            .hex 05 00 05 00   ; $dedf: 05 00 05 00   Data
            .hex 10 19 10 19   ; $dee3: 10 19 10 19   Data
            .hex 10 19 10 19   ; $dee7: 10 19 10 19   Data
            .hex 18 18 18 18   ; $deeb: 18 18 18 18   Data
            .hex 18 18 18 18   ; $deef: 18 18 18 18   Data
            .hex 24 24 24 24   ; $def3: 24 24 24 24   Data
            .hex 24 24 24 24   ; $def7: 24 24 24 24   Data
            .hex 26 20 26 20   ; $defb: 26 20 26 20   Data
            .hex 26 20 26 20   ; $deff: 26 20 26 20   Data
            .hex 30 3a 30 3a   ; $df03: 30 3a 30 3a   Data
            .hex 30 3a 30 3a   ; $df07: 30 3a 30 3a   Data
            .hex 38 38 38 38   ; $df0b: 38 38 38 38   Data
            .hex 38 38 38 38   ; $df0f: 38 38 38 38   Data
__df13:     .hex 8b 8c 8b 8c   ; $df13: 8b 8c 8b 8c   Data
__df17:     .hex 90 8e 8f 8d   ; $df17: 90 8e 8f 8d   Data

;-------------------------------------------------------------------------------
__df1b:     lda vCurrentLevel            ; $df1b: a5 55     
            and #$0f           ; $df1d: 29 0f     
            cmp #$0c           ; $df1f: c9 0c     
            bcc __df4e         ; $df21: 90 2b     
            lda $025d          ; $df23: ad 5d 02  
            bne __df40         ; $df26: d0 18     
            lda $66            ; $df28: a5 66     
            bne __df40         ; $df2a: d0 14     
            lda vIsCreatureDead          ; $df2c: ad 10 02  
            bne __df40         ; $df2f: d0 0f     
            lda vCycleCounter            ; $df31: a5 09     
            and #$0f           ; $df33: 29 0f     
            bne __df71         ; $df35: d0 3a     
            jsr __df43         ; $df37: 20 43 df  
            jsr __df52         ; $df3a: 20 52 df  
            jmp __df71         ; $df3d: 4c 71 df  

;-------------------------------------------------------------------------------
__df40:     jmp __dfcd         ; $df40: 4c cd df  

;-------------------------------------------------------------------------------
__df43:     lda vBeeY            ; $df43: a5 90     
            cmp vBirdSpritePosY          ; $df45: cd 00 07  
            beq __df4e         ; $df48: f0 04     
            bcs __df4f         ; $df4a: b0 03     
            inc vBeeY            ; $df4c: e6 90     
__df4e:     rts                ; $df4e: 60        

;-------------------------------------------------------------------------------
__df4f:     dec vBeeY            ; $df4f: c6 90     
            rts                ; $df51: 60        

;-------------------------------------------------------------------------------
__df52:     lda vBeeX            ; $df52: a5 70     
            sta vBirdX            ; $df54: 85 5b     
            jsr __d5fc         ; $df56: 20 fc d5  
            lda vBirdX            ; $df59: a5 5b     
            beq __df68         ; $df5b: f0 0b     
            cmp #$01           ; $df5d: c9 01     
            beq __df69         ; $df5f: f0 08     
            inc vBeeX            ; $df61: e6 70     
            lda #$00           ; $df63: a9 00     
            sta $0255          ; $df65: 8d 55 02  
__df68:     rts                ; $df68: 60        

;-------------------------------------------------------------------------------
__df69:     dec vBeeX            ; $df69: c6 70     
            lda #$01           ; $df6b: a9 01     
            sta $0255          ; $df6d: 8d 55 02  
            rts                ; $df70: 60        

;-------------------------------------------------------------------------------
__df71:     jsr __getCycleModulo4         ; $df71: 20 5d d6  
            beq __df8a         ; $df74: f0 14     
            lda $0256          ; $df76: ad 56 02  
            tay                ; $df79: a8        
            lda __e0a7,y       ; $df7a: b9 a7 e0  
            clc                ; $df7d: 18        
            adc $0257          ; $df7e: 6d 57 02  
            tay                ; $df81: a8        
            lda __e02f,y       ; $df82: b9 2f e0  
            ldx #$fd           ; $df85: a2 fd     
            jsr __d915         ; $df87: 20 15 d9  
__df8a:     jsr __dfc4         ; $df8a: 20 c4 df  
            lda $0255          ; $df8d: ad 55 02  
            bne __dfa8         ; $df90: d0 16     
            lda __dff6,x       ; $df92: bd f6 df  
__df95:     sta $0705          ; $df95: 8d 05 07  
            jsr __getCycleModulo4         ; $df98: 20 5d d6  
            bne __dfa7         ; $df9b: d0 0a     
            inc $0257          ; $df9d: ee 57 02  
            lda $0257          ; $dfa0: ad 57 02  
            cmp #$08           ; $dfa3: c9 08     
            beq __dfae         ; $dfa5: f0 07     
__dfa7:     rts                ; $dfa7: 60        

;-------------------------------------------------------------------------------
__dfa8:     lda __dffa,x       ; $dfa8: bd fa df  
            jmp __df95         ; $dfab: 4c 95 df  

;-------------------------------------------------------------------------------
__dfae:     lda #$00           ; $dfae: a9 00     
            sta $0257          ; $dfb0: 8d 57 02  
            inc $0256          ; $dfb3: ee 56 02  
            lda $0256          ; $dfb6: ad 56 02  
            cmp #$a8           ; $dfb9: c9 a8     
            beq __dfbe         ; $dfbb: f0 01     
            rts                ; $dfbd: 60        

;-------------------------------------------------------------------------------
__dfbe:     lda #$00           ; $dfbe: a9 00     
            sta $0256          ; $dfc0: 8d 56 02  
            rts                ; $dfc3: 60        

;-------------------------------------------------------------------------------
__dfc4:     lda vCycleCounter            ; $dfc4: a5 09     
            and #$06           ; $dfc6: 29 06     
            lsr                ; $dfc8: 4a        
            and #$01           ; $dfc9: 29 01     
            tax                ; $dfcb: aa        
            rts                ; $dfcc: 60        

;-------------------------------------------------------------------------------
__dfcd:     inc $025d          ; $dfcd: ee 5d 02  
            lda $025d          ; $dfd0: ad 5d 02  
            cmp #$01           ; $dfd3: c9 01     
            beq __dfed         ; $dfd5: f0 16     
            inc vBeeY            ; $dfd7: e6 90     
            lda vBeeY            ; $dfd9: a5 90     
            cmp #$d8           ; $dfdb: c9 d8     
            bcs __dfe0         ; $dfdd: b0 01     
            rts                ; $dfdf: 60        

;-------------------------------------------------------------------------------
__dfe0:     lda #$00           ; $dfe0: a9 00     
            sta $025d          ; $dfe2: 8d 5d 02  
            sta $b0            ; $dfe5: 85 b0     
            sta $66            ; $dfe7: 85 66     
            sta vIsCreatureDead          ; $dfe9: 8d 10 02  
            rts                ; $dfec: 60        

;-------------------------------------------------------------------------------
__dfed:     jsr __d64f         ; $dfed: 20 4f d6  
            inc $025d          ; $dff0: ee 5d 02  
            jmp __c545         ; $dff3: 4c 45 c5  

;-------------------------------------------------------------------------------
__dff6:     .hex 85 87 85 87   ; $dff6: 85 87 85 87   Data
__dffa:     .hex 86 88 86 88   ; $dffa: 86 88 86 88   Data
__dffe:     jsr __getCycleModulo4         ; $dffe: 20 5d d6  
            bne __e011         ; $e001: d0 0e     
            inc $ec            ; $e003: e6 ec     
            lda vCurrentLevel            ; $e005: a5 55     
            cmp #$07           ; $e007: c9 07     
            beq __e012         ; $e009: f0 07     
            lda $ec            ; $e00b: a5 ec     
            cmp #$8d           ; $e00d: c9 8d     
            beq __e019         ; $e00f: f0 08     
__e011:     rts                ; $e011: 60        

;-------------------------------------------------------------------------------
__e012:     lda $ec            ; $e012: a5 ec     
            cmp #$81           ; $e014: c9 81     
            beq __e019         ; $e016: f0 01     
            rts                ; $e018: 60        

;-------------------------------------------------------------------------------
__e019:     inc $0274          ; $e019: ee 74 02  
            lda $0274          ; $e01c: ad 74 02  
            cmp #$02           ; $e01f: c9 02     
            bne __e011         ; $e021: d0 ee     
__e023:     lda #$00           ; $e023: a9 00     
            sta $0274          ; $e025: 8d 74 02  
            sta vScoreScreenState            ; $e028: 85 d3     
            lda #$fe           ; $e02a: a9 fe     
            sta vGameState            ; $e02c: 85 50     
            rts                ; $e02e: 60        

;-------------------------------------------------------------------------------
__e02f:     .hex 25 11 11 11   ; $e02f: 25 11 11 11   Data
            .hex 39 11 11 11   ; $e033: 39 11 11 11   Data
            .hex 39 11 11 11   ; $e037: 39 11 11 11   Data
            .hex 25 11 11 11   ; $e03b: 25 11 11 11   Data
            .hex 66 52 52 52   ; $e03f: 66 52 52 52   Data
            .hex 7a 52 52 52   ; $e043: 7a 52 52 52   Data
            .hex 7a 52 52 52   ; $e047: 7a 52 52 52   Data
            .hex 66 52 52 52   ; $e04b: 66 52 52 52   Data
            .hex 44 25 44 44   ; $e04f: 44 25 44 44   Data
            .hex 66 66 44 25   ; $e053: 66 66 44 25   Data
            .hex 88 7a 88 88   ; $e057: 88 7a 88 88   Data
            .hex 39 39 88 7a   ; $e05b: 39 39 88 7a   Data
            .hex 44 66 52 66   ; $e05f: 44 66 52 66   Data
            .hex 52 52 7a 52   ; $e063: 52 52 7a 52   Data
            .hex 52 7a 52 7a   ; $e067: 52 7a 52 7a   Data
            .hex 88 7a 88 88   ; $e06b: 88 7a 88 88   Data
            .hex 88 7a 11 39   ; $e06f: 88 7a 11 39   Data
            .hex 11 11 39 11   ; $e073: 11 11 39 11   Data
            .hex 52 7a 52 52   ; $e077: 52 7a 52 52   Data
            .hex 66 52 66 44   ; $e07b: 66 52 66 44   Data
            .hex 44 25 44 25   ; $e07f: 44 25 44 25   Data
            .hex 25 11 25 11   ; $e083: 25 11 25 11   Data
            .hex 11 11 39 11   ; $e087: 11 11 39 11   Data
            .hex 39 88 39 88   ; $e08b: 39 88 39 88   Data
            .hex 88 7a 88 7a   ; $e08f: 88 7a 88 7a   Data
            .hex 88 7a 52 52   ; $e093: 88 7a 52 52   Data
            .hex 11 25 39 7a   ; $e097: 11 25 39 7a   Data
            .hex 7a 66 25 11   ; $e09b: 7a 66 25 11   Data
            .hex 52 7a 66 25   ; $e09f: 52 7a 66 25   Data
            .hex 11 7a 52 52   ; $e0a3: 11 7a 52 52   Data
__e0a7:     .hex 00 38 08 50   ; $e0a7: 00 38 08 50   Data
            .hex 00 38 08 38   ; $e0ab: 00 38 08 38   Data
            .hex 20 20 30 10   ; $e0af: 20 20 30 10   Data
            .hex 18 48 18 10   ; $e0b3: 18 48 18 10   Data
            .hex 48 48 10 48   ; $e0b7: 48 48 10 48   Data
            .hex 18 18 48 20   ; $e0bb: 18 18 48 20   Data
            .hex 38 10 50 00   ; $e0bf: 38 10 50 00   Data
            .hex 10 10 10 28   ; $e0c3: 10 10 10 28   Data
            .hex 00 00 28 28   ; $e0c7: 00 00 28 28   Data
            .hex 50 50 20 20   ; $e0cb: 50 50 20 20   Data
            .hex 10 18 18 10   ; $e0cf: 10 18 18 10   Data
            .hex 30 38 20 48   ; $e0d3: 30 38 20 48   Data
            .hex 10 18 38 48   ; $e0d7: 10 18 38 48   Data
            .hex 30 48 60 60   ; $e0db: 30 48 60 60   Data
            .hex 38 10 18 28   ; $e0df: 38 10 18 28   Data
            .hex 38 18 28 60   ; $e0e3: 38 18 28 60   Data
            .hex 10 18 10 18   ; $e0e7: 10 18 10 18   Data
            .hex 30 38 18 10   ; $e0eb: 30 38 18 10   Data
            .hex 48 50 58 00   ; $e0ef: 48 50 58 00   Data
            .hex 08 00 08 58   ; $e0f3: 08 00 08 58   Data
            .hex 28 30 40 00   ; $e0f7: 28 30 40 00   Data
            .hex 08 00 08 20   ; $e0fb: 08 00 08 20   Data
            .hex 68 00 08 20   ; $e0ff: 68 00 08 20   Data
            .hex 40 50 58 28   ; $e103: 40 50 58 28   Data
            .hex 28 00 08 40   ; $e107: 28 00 08 40   Data
            .hex 40 50 50 20   ; $e10b: 40 50 50 20   Data
            .hex 20 10 18 10   ; $e10f: 20 10 18 10   Data
            .hex 18 10 18 30   ; $e113: 18 10 18 30   Data
            .hex 30 10 18 38   ; $e117: 30 10 18 38   Data
            .hex 10 18 10 30   ; $e11b: 10 18 10 30   Data
            .hex 70 10 18 28   ; $e11f: 70 10 18 28   Data
            .hex 38 10 38 38   ; $e123: 38 10 38 38   Data
            .hex 10 30 38 70   ; $e127: 10 30 38 70   Data
            .hex 10 18 10 18   ; $e12b: 10 18 10 18   Data
            .hex 38 20 40 20   ; $e12f: 38 20 40 20   Data
            .hex 40 50 50 50   ; $e133: 40 50 50 50   Data
            .hex 00 08 00 08   ; $e137: 00 08 00 08   Data
            .hex 40 00 08 58   ; $e13b: 40 00 08 58   Data
            .hex 58 00 58 40   ; $e13f: 58 00 58 40   Data
            .hex 00 08 58 00   ; $e143: 00 08 58 00   Data
            .hex 08 48 58 00   ; $e147: 08 48 58 00   Data
            .hex 40 48 20 40   ; $e14b: 40 48 20 40   Data
            .hex 00 08 40 00   ; $e14f: 00 08 40 00   Data
            .hex 58 08 00 68   ; $e153: 58 08 00 68   Data
__e157:     .hex f3            ; $e157: f3            Data
__e158:     .hex e5            ; $e158: e5            Data
__e159:     .hex eb            ; $e159: eb            Data
__e15a:     .hex e8            ; $e15a: e8            Data

;-------------------------------------------------------------------------------
___initGame:     
			jsr __disableNMI         ; $e15b: 20 d0 fe  
            jsr __disableDrawing         ; $e15e: 20 ee fe  
            lda #$24           ; $e161: a9 24     
            jsr __clearNametable         ; $e163: 20 f5 fd  
            lda #$09           ; $e166: a9 09     
            ldx #$20           ; $e168: a2 20     
            jsr __e2b6         ; $e16a: 20 b6 e2  
            jsr __drawMainMenuLabels         ; $e16d: 20 8a e1  
            jsr __setNametableColor         ; $e170: 20 31 e2  
            jsr __drawHiScoreLabel         ; $e173: 20 fc e1  
            jsr __hideSpritesInTable         ; $e176: 20 94 fe  
            jsr __hideSpritesInOAM         ; $e179: 20 5a e2  
            jsr __drawBirdInMainMenu         ; $e17c: 20 65 e2  
            jsr __composeOAMTable         ; $e17f: 20 3b ff  
            inc vGameState            ; $e182: e6 50     
            jsr __scrollScreen         ; $e184: 20 b6 fd  
            jmp __enableNMI         ; $e187: 4c c6 fe  

;-------------------------------------------------------------------------------
__drawMainMenuLabels:    
			; draw "study mode"
			ldx #$00           ; $e18a: a2 00     
            lda #$22           ; $e18c: a9 22     
            sta ppuAddress          ; $e18e: 8d 06 20  
            lda #$cd           ; $e191: a9 cd     
            sta ppuAddress          ; $e193: 8d 06 20  
__e196:     lda __studyModeLabel,x       ; $e196: bd d0 e1  
            sta ppuData          ; $e199: 8d 07 20  
            inx                ; $e19c: e8        
            cpx #$0a           ; $e19d: e0 0a     
            bne __e196         ; $e19f: d0 f5     
			; draw "game start"
            ldx #$00           ; $e1a1: a2 00     
            lda #$22           ; $e1a3: a9 22     
            sta ppuAddress          ; $e1a5: 8d 06 20  
            lda #$8d           ; $e1a8: a9 8d     
            sta ppuAddress          ; $e1aa: 8d 06 20  
__e1ad:     lda __gameStartLabel,x       ; $e1ad: bd da e1  
            sta ppuData          ; $e1b0: 8d 07 20  
            inx                ; $e1b3: e8        
            cpx #$0a           ; $e1b4: e0 0a     
            bne __e1ad         ; $e1b6: d0 f5     
			; draw copyright
            ldx #$00           ; $e1b8: a2 00     
            lda #$23           ; $e1ba: a9 23     
            sta ppuAddress          ; $e1bc: 8d 06 20  
            lda #$24           ; $e1bf: a9 24     
            sta ppuAddress          ; $e1c1: 8d 06 20  
__e1c4:     lda __copyrightLabel,x       ; $e1c4: bd e4 e1  
            sta ppuData          ; $e1c7: 8d 07 20  
            inx                ; $e1ca: e8        
            cpx #$18           ; $e1cb: e0 18     
            bne __e1c4         ; $e1cd: d0 f5     
			
            rts                ; $e1cf: 60        

;-------------------------------------------------------------------------------
__studyModeLabel:     
			.hex 1c 1d 1e 0d   ; $e1d0: 1c 1d 1e 0d   Data
            .hex 22 24 10 0a   ; $e1d4: 22 24 10 0a   Data
            .hex 16 0e         ; $e1d8: 16 0e         Data
__gameStartLabel:     
			.hex 10 0a 16 0e   ; $e1da: 10 0a 16 0e   Data
            .hex 24 1c 1d 0a   ; $e1de: 24 1c 1d 0a   Data
            .hex 1b 1d         ; $e1e2: 1b 1d         Data
__copyrightLabel:     
			.hex 25 24 01 09   ; $e1e4: 25 24 01 09   Data
            .hex 08 06 24 1d   ; $e1e8: 08 06 24 1d   Data
            .hex 18 1c 11 12   ; $e1ec: 18 1c 11 12   Data
            .hex 0b 0a 24 0e   ; $e1f0: 0b 0a 24 0e   Data
            .hex 16 12 4f 15   ; $e1f4: 16 12 4f 15   Data
            .hex 0e 17 0a 1b   ; $e1f8: 0e 17 0a 1b   Data

;-------------------------------------------------------------------------------
__drawHiScoreLabel:
			; set position
			lda #$20           ; $e1fc: a9 20     
            sta ppuAddress          ; $e1fe: 8d 06 20  
            lda #$68           ; $e201: a9 68     
            sta ppuAddress          ; $e203: 8d 06 20  
			
            ldy #$00           ; $e206: a0 00     
__drawHiScoreLabelLoop:     
			lda __hiScoreLabel,y       ; $e208: b9 75 e2  
            sta ppuData          ; $e20b: 8d 07 20  
            iny                ; $e20e: c8        
            cpy #$07           ; $e20f: c0 07     
            bne __drawHiScoreLabelLoop         ; $e211: d0 f5     
			
__drawHiScoreLoop:     
			lda $0110,y        ; $e213: b9 10 01  
            bne __drawHiScoreNumber         ; $e216: d0 0e     
            lda #$24           ; $e218: a9 24     
            sta ppuData          ; $e21a: 8d 07 20  
            dey                ; $e21d: 88        
            bne __drawHiScoreLoop         ; $e21e: d0 f3  
			
__drawHiScoreEnd:     
			lda #$00           ; $e220: a9 00     
            sta ppuData          ; $e222: 8d 07 20  
            rts                ; $e225: 60        

;-------------------------------------------------------------------------------
__drawHiScoreNumber:     
			lda $0110,y        ; $e226: b9 10 01  
            sta ppuData          ; $e229: 8d 07 20  
            dey                ; $e22c: 88        
            bne __drawHiScoreNumber         ; $e22d: d0 f7     
            beq __drawHiScoreEnd         ; $e22f: f0 ef     
			
__setNametableColor:  
			; set address
			lda #$23           ; $e231: a9 23     
            sta ppuAddress          ; $e233: 8d 06 20  
            ldy #$f8           ; $e236: a0 f8     
            sty ppuAddress          ; $e238: 8c 06 20  
			
            lda #$55           ; $e23b: a9 55     
            ldx #$00           ; $e23d: a2 00     
__setNametable1ColorLoop:     
			sta ppuData          ; $e23f: 8d 07 20  
            inx                ; $e242: e8        
            cpx #$08           ; $e243: e0 08     
            bne __setNametable1ColorLoop         ; $e245: d0 f8  
			
			; set address
            lda #$27           ; $e247: a9 27     
            sta ppuAddress          ; $e249: 8d 06 20  
            sty ppuAddress          ; $e24c: 8c 06 20  
			
            lda #$55           ; $e24f: a9 55     
__setNametable2ColorLoop:     
			sta ppuData          ; $e251: 8d 07 20  
            inx                ; $e254: e8        
            cpx #$10           ; $e255: e0 10     
            bne __setNametable2ColorLoop         ; $e257: d0 f8     
            rts                ; $e259: 60        

;-------------------------------------------------------------------------------
__hideSpritesInOAM:     
			ldx #$00           ; $e25a: a2 00     
            lda #$f0           ; $e25c: a9 f0     
__hideSpritesInOAMLoop:     
			sta vOAMTable,x        ; $e25e: 9d 00 06  
            inx                ; $e261: e8        
            bne __hideSpritesInOAMLoop         ; $e262: d0 fa     
            rts                ; $e264: 60        

;-------------------------------------------------------------------------------
__drawBirdInMainMenu:     lda #$34           ; $e265: a9 34     
            sta vBirdSpritePosY          ; $e267: 8d 00 07  
            lda #$05           ; $e26a: a9 05     
            sta $0701          ; $e26c: 8d 01 07  
            lda #$b0           ; $e26f: a9 b0     
            sta $0703          ; $e271: 8d 03 07  
            rts                ; $e274: 60        

;-------------------------------------------------------------------------------
__hiScoreLabel:     
			.hex 11 12 1c 0c   ; $e275: 11 12 1c 0c   Data
            .hex 18 1b 0e      ; $e279: 18 1b 0e      Data

;-------------------------------------------------------------------------------
___initGameLoop:     
			; some initialization
			jsr __disableNMI         ; $e27c: 20 d0 fe  
            jsr __disableDrawing         ; $e27f: 20 ee fe  
            jsr __setPPUIncrementBy1         ; $e282: 20 da fe  
            jsr __loadPaletteFromLevel         ; $e285: 20 aa e3  
            jsr __uploadPalettesToPPU         ; $e288: 20 64 fe  
            jsr __clearStatusBar         ; $e28b: 20 ca e4  
			
            lda vCurrentLevel            ; $e28e: a5 55     
            and #$07           ; $e290: 29 07     
            asl                ; $e292: 0a        
            tax                ; $e293: aa        
			
            lda __e4e1,x       ; $e294: bd e1 e4  
            ldx #$20           ; $e297: a2 20     
            jsr __e2b6         ; $e299: 20 b6 e2  
			
            lda vCurrentLevel            ; $e29c: a5 55     
            and #$07           ; $e29e: 29 07     
            asl                ; $e2a0: 0a        
            tax                ; $e2a1: aa      
			
            lda __e4e2,x       ; $e2a2: bd e2 e4  
            ldx #$24           ; $e2a5: a2 24     
            jsr __e2b6         ; $e2a7: 20 b6 e2  
            jsr __drawNestlingBranch         ; $e2aa: 20 7e e4  
            jsr __drawBottom         ; $e2ad: 20 4a e4  
            jsr __scrollScreen         ; $e2b0: 20 b6 fd  
            jmp __c086         ; $e2b3: 4c 86 c0  

;-------------------------------------------------------------------------------
__e2b6:     jsr __e2d4         ; $e2b6: 20 d4 e2  
            ldx #$00           ; $e2b9: a2 00     
            stx vDataAddress            ; $e2bb: 86 53     
            stx $51            ; $e2bd: 86 51     
            jsr __e301         ; $e2bf: 20 01 e3  
            jsr __e301         ; $e2c2: 20 01 e3  
            jsr __e301         ; $e2c5: 20 01 e3  
            jsr __e301         ; $e2c8: 20 01 e3  
            jsr __e301         ; $e2cb: 20 01 e3  
            jsr __e301         ; $e2ce: 20 01 e3  
            jmp __e367         ; $e2d1: 4c 67 e3  

;-------------------------------------------------------------------------------
__e2d4:     stx vDataAddressHi            ; $e2d4: 86 54     
            stx ppuAddress          ; $e2d6: 8e 06 20  
            ldx #$80           ; $e2d9: a2 80     
            stx ppuAddress          ; $e2db: 8e 06 20
			
            sta $1c            ; $e2de: 85 1c     
            lda #$30           ; $e2e0: a9 30     
            sta $1d            ; $e2e2: 85 1d     
            jsr __e394         ; $e2e4: 20 94 e3  
            lda __e157         ; $e2e7: ad 57 e1  
            sta $1c            ; $e2ea: 85 1c     
            lda __e158         ; $e2ec: ad 58 e1  
            sta $1d            ; $e2ef: 85 1d     
            jsr __e386         ; $e2f1: 20 86 e3  
            ldy #$00           ; $e2f4: a0 00     
__e2f6:     lda ($1e),y        ; $e2f6: b1 1e     
            sta $0300,y        ; $e2f8: 99 00 03  
            iny                ; $e2fb: c8        
            cpy #$30           ; $e2fc: c0 30     
            bne __e2f6         ; $e2fe: d0 f6     
            rts                ; $e300: 60        

;-------------------------------------------------------------------------------
__e301:     jsr __e321         ; $e301: 20 21 e3  
            cpx #$80           ; $e304: e0 80     
            bne __e301         ; $e306: d0 f9     
            ldx #$00           ; $e308: a2 00     
            jsr __e351         ; $e30a: 20 51 e3  
            ldx #$04           ; $e30d: a2 04     
            jsr __e351         ; $e30f: 20 51 e3  
            ldx #$08           ; $e312: a2 08     
            jsr __e351         ; $e314: 20 51 e3  
            ldx #$0c           ; $e317: a2 0c     
            jsr __e351         ; $e319: 20 51 e3  
            ldx #$00           ; $e31c: a2 00     
            stx vDataAddress            ; $e31e: 86 53     
            rts                ; $e320: 60        

;-------------------------------------------------------------------------------
__e321:     ldy $51            ; $e321: a4 51     
            lda $0300,y        ; $e323: b9 00 03  
            sta $1c            ; $e326: 85 1c     
            lda #$10           ; $e328: a9 10     
            sta $1d            ; $e32a: 85 1d     
            jsr __e394         ; $e32c: 20 94 e3  
            lda __e159         ; $e32f: ad 59 e1  
            sta $1c            ; $e332: 85 1c     
            lda __e15a         ; $e334: ad 5a e1  
            sta $1d            ; $e337: 85 1d     
            jsr __e386         ; $e339: 20 86 e3  
            iny                ; $e33c: c8        
            sty $51            ; $e33d: 84 51     
            ldx vDataAddress            ; $e33f: a6 53     
            ldy #$00           ; $e341: a0 00     
__e343:     lda ($1e),y        ; $e343: b1 1e     
            sta $0400,x        ; $e345: 9d 00 04  
            inx                ; $e348: e8        
            iny                ; $e349: c8        
            cpy #$10           ; $e34a: c0 10     
            bne __e343         ; $e34c: d0 f5     
            stx vDataAddress            ; $e34e: 86 53     
            rts                ; $e350: 60        

;-------------------------------------------------------------------------------
__e351:     lda $0400,x        ; $e351: bd 00 04  
            sta ppuData          ; $e354: 8d 07 20  
            inx                ; $e357: e8        
            txa                ; $e358: 8a        
            and #$03           ; $e359: 29 03     
            bne __e351         ; $e35b: d0 f4     
            txa                ; $e35d: 8a        
            clc                ; $e35e: 18        
            adc #$0c           ; $e35f: 69 0c     
            tax                ; $e361: aa        
            cpx #$80           ; $e362: e0 80     
            bcc __e351         ; $e364: 90 eb     
            rts                ; $e366: 60        

;-------------------------------------------------------------------------------
__e367:     lda vDataAddressHi            ; $e367: a5 54     
            clc                ; $e369: 18        
            adc #$03           ; $e36a: 69 03     
            sta ppuAddress          ; $e36c: 8d 06 20  
            lda #$c8           ; $e36f: a9 c8     
            sta ppuAddress          ; $e371: 8d 06 20  
            ldy #$00           ; $e374: a0 00     
__e376:     lda $0300,y        ; $e376: b9 00 03  
            tax                ; $e379: aa        
            lda __e893,x       ; $e37a: bd 93 e8  
            sta ppuData          ; $e37d: 8d 07 20  
            iny                ; $e380: c8        
            cpy #$30           ; $e381: c0 30     
            bne __e376         ; $e383: d0 f1     
            rts                ; $e385: 60        

;-------------------------------------------------------------------------------
__e386:     lda $1e            ; $e386: a5 1e     
            clc                ; $e388: 18        
            adc $1c            ; $e389: 65 1c     
            sta $1e            ; $e38b: 85 1e     
            lda $1f            ; $e38d: a5 1f     
            adc $1d            ; $e38f: 65 1d     
            sta $1f            ; $e391: 85 1f     
            rts                ; $e393: 60        

;-------------------------------------------------------------------------------
__e394:     lda #$00           ; $e394: a9 00     
            sta $1e            ; $e396: 85 1e     
            ldx #$08           ; $e398: a2 08     
__e39a:     lsr $1c            ; $e39a: 46 1c     
            bcc __e3a1         ; $e39c: 90 03     
            clc                ; $e39e: 18        
            adc $1d            ; $e39f: 65 1d     
__e3a1:     ror                ; $e3a1: 6a        
            ror $1e            ; $e3a2: 66 1e     
            dex                ; $e3a4: ca        
            bne __e39a         ; $e3a5: d0 f3     
            sta $1f            ; $e3a7: 85 1f     
            rts                ; $e3a9: 60        

;-------------------------------------------------------------------------------
__loadPaletteFromLevel:     
			lda vCurrentLevel            ; $e3aa: a5 55     
            and #$07           ; $e3ac: 29 07     
            asl                ; $e3ae: 0a        
            tax                ; $e3af: aa      
			
__loadPalette:     
			lda __e3c7,x       ; $e3b0: bd c7 e3  
            sta vDataAddress            ; $e3b3: 85 53     
            lda __e3c8,x       ; $e3b5: bd c8 e3  
            sta vDataAddressHi            ; $e3b8: 85 54     
            ldy #$00           ; $e3ba: a0 00     

__loadPaletteLoop:     
			lda ($53),y        ; $e3bc: b1 53     
            sta vPaletteDataAbs,y        ; $e3be: 99 30 00  
            iny                ; $e3c1: c8        
            cpy #$20           ; $e3c2: c0 20     
            bne __loadPaletteLoop         ; $e3c4: d0 f6     
            rts                ; $e3c6: 60        

;-------------------------------------------------------------------------------
__e3c7:     .hex f3            ; $e3c7: f3            Data
__e3c8:     .hex e4 33 e5 53   ; $e3c8: e4 33 e5 53   Data
            .hex e5 73 e5 93   ; $e3cc: e5 73 e5 93   Data
            .hex e5 b3 e5 d3   ; $e3d0: e5 b3 e5 d3   Data
            .hex e5 13 e5      ; $e3d4: e5 13 e5      Data
__e3d7:     jmp __f49e         ; $e3d7: 4c 9e f4  

;-------------------------------------------------------------------------------
__e3da:     
			lda vDemoSequenceActive          ; $e3da: ad 73 02  
				bne __e3d7         ; $e3dd: d0 f8     
            lda vGameState            ; $e3df: a5 50     
            cmp #$02           ; $e3e1: c9 02     
				beq __clearRoundScreenLabels         ; $e3e3: f0 33     
				
__e3e5:     jsr __disableNMI         ; $e3e5: 20 d0 fe  
            jsr __disableDrawing         ; $e3e8: 20 ee fe  
            jsr __hideSpritesInTable         ; $e3eb: 20 94 fe  
            jsr __setPPUIncrementBy1         ; $e3ee: 20 da fe  
            ldx #$0a           ; $e3f1: a2 0a     
            jsr __loadPalette         ; $e3f3: 20 b0 e3  
            jsr __uploadPalettesToPPU         ; $e3f6: 20 64 fe  
            jsr __clearStatusBar         ; $e3f9: 20 ca e4  
            lda #$0a           ; $e3fc: a9 0a     
            ldx #$20           ; $e3fe: a2 20     
            jsr __e2b6         ; $e400: 20 b6 e2  
            ldy #$af           ; $e403: a0 af     
            jsr __drawBottomNext         ; $e405: 20 54 e4  
            lda #$f0           ; $e408: a9 f0     
            sta vOAMTable          ; $e40a: 8d 00 06  
            inc vScoreScreenState            ; $e40d: e6 d3     
            jsr __scrollScreen         ; $e40f: 20 b6 fd  
            jsr __composeOAMTable         ; $e412: 20 3b ff  
            jmp __enableNMI         ; $e415: 4c c6 fe  

;-------------------------------------------------------------------------------
__clearRoundScreenLabels:     
			lda vRoundNumber            ; $e418: a5 f2     
            cmp #$01           ; $e41a: c9 01     
				beq __e3e5         ; $e41c: f0 c7    
				
            lda #$20           ; $e41e: a9 20     
            sta ppuAddress          ; $e420: 8d 06 20  
            lda #$c8           ; $e423: a9 c8     
            sta ppuAddress          ; $e425: 8d 06 20  
			
            ldx #$00           ; $e428: a2 00     
            ldy #$24           ; $e42a: a0 24     
__clearLabelsLine1:     
			sty ppuData          ; $e42c: 8c 07 20  
            inx                ; $e42f: e8        
            cpx #$10           ; $e430: e0 10     
            bne __clearLabelsLine1         ; $e432: d0 f8    
			
            lda #$21           ; $e434: a9 21     
            sta ppuAddress          ; $e436: 8d 06 20  
            lda #$08           ; $e439: a9 08     
            sta ppuAddress          ; $e43b: 8d 06 20  
			
__clearLabelsLine2:     
			sty ppuData          ; $e43e: 8c 07 20  
            inx                ; $e441: e8        
            cpx #$20           ; $e442: e0 20     
            bne __clearLabelsLine2         ; $e444: d0 f8   
			
            jsr __scrollScreen         ; $e446: 20 b6 fd  
            rts                ; $e449: 60        

;-------------------------------------------------------------------------------
__drawBottom:     
			lda vCurrentLevel            ; $e44a: a5 55     
            and #$07           ; $e44c: 29 07     
            cmp #$03           ; $e44e: c9 03  
				; bonus level
				beq __drawBottomBonus         ; $e450: f0 1c    
				
            ldy #$af           ; $e452: a0 af     
__drawBottomNext:     
			lda #$23           ; $e454: a9 23     
            sta ppuAddress          ; $e456: 8d 06 20  
            lda #$80           ; $e459: a9 80     
            sta ppuAddress          ; $e45b: 8d 06 20  
			
            jsr __drawBottomTiles         ; $e45e: 20 73 e4  
            lda #$27           ; $e461: a9 27     
            sta ppuAddress          ; $e463: 8d 06 20  
            lda #$80           ; $e466: a9 80     
            sta ppuAddress          ; $e468: 8d 06 20  
            jmp __drawBottomTiles         ; $e46b: 4c 73 e4  

;-------------------------------------------------------------------------------
__drawBottomBonus:     
			ldy #$7d           ; $e46e: a0 7d     
            jmp __drawBottomNext         ; $e470: 4c 54 e4  

;-------------------------------------------------------------------------------
__drawBottomTiles:     
			ldx #$00           ; $e473: a2 00     
__drawBottomTilesLoop:     
			sty ppuData          ; $e475: 8c 07 20  
            inx                ; $e478: e8        
            cpx #$40           ; $e479: e0 40     
            bne __drawBottomTilesLoop         ; $e47b: d0 f8     
            rts                ; $e47d: 60        

;-------------------------------------------------------------------------------
__drawNestlingBranch:     
			lda vCurrentLevel            ; $e47e: a5 55     
            and #$03           ; $e480: 29 03     
            cmp #$03           ; $e482: c9 03     
				; is bonus level
				beq __return6         ; $e484: f0 27   
			
			; 3 level repeating pattern
            lda vCurrentLevel            ; $e486: a5 55     
            tay                ; $e488: a8        
            and #$03           ; $e489: 29 03     
            asl                ; $e48b: 0a        
            tax                ; $e48c: aa   
			
			; set position
            lda __nestlingBranchPos,x       ; $e48d: bd ba e4  
            sta ppuAddress          ; $e490: 8d 06 20  
            inx                ; $e493: e8        
            lda __nestlingBranchPos,x       ; $e494: bd ba e4  
            sta ppuAddress          ; $e497: 8d 06 20  
			
            ldx #$00           ; $e49a: a2 00     
            lda vCurrentLevel            ; $e49c: a5 55     
            cmp #$10           ; $e49e: c9 10 
				; 3 nestlings
				bcs __draw3NestlingBranch         ; $e4a0: b0 0c 
				
			; 2 nestlings
__draw2NestlingBranch:     
			lda __branchFor2Nestlings,x       ; $e4a2: bd c0 e4  
            sta ppuData          ; $e4a5: 8d 07 20  
            inx                ; $e4a8: e8        
            cpx #$04           ; $e4a9: e0 04     
            bne __draw2NestlingBranch         ; $e4ab: d0 f5     
__return6:     
			rts                ; $e4ad: 60        

;-------------------------------------------------------------------------------
__draw3NestlingBranch:     
			lda __branchFor3Nestlings,x       ; $e4ae: bd c4 e4  
            sta ppuData          ; $e4b1: 8d 07 20  
            inx                ; $e4b4: e8        
            cpx #$06           ; $e4b5: e0 06     
            bne __draw3NestlingBranch         ; $e4b7: d0 f5     
            rts                ; $e4b9: 60        

;-------------------------------------------------------------------------------
__nestlingBranchPos:     
			.hex 22 10 21 d8   ; $e4ba: 22 10 21 d8   Data
            .hex 21 c8         ; $e4be: 21 c8         Data
__branchFor2Nestlings:     
			.hex 75 7c 7c 77   ; $e4c0: 75 7c 7c 77   Data
__branchFor3Nestlings:     
			.hex 75 7c 7c 7c   ; $e4c4: 75 7c 7c 7c   Data
            .hex 7c 77         ; $e4c8: 7c 77         Data

;-------------------------------------------------------------------------------
__clearStatusBar:     
			lda #$20           ; $e4ca: a9 20     
            sta ppuAddress          ; $e4cc: 8d 06 20  
            lda #$64           ; $e4cf: a9 64     
            sta ppuAddress          ; $e4d1: 8d 06 20  
            ldx #$00           ; $e4d4: a2 00     
            lda #$24           ; $e4d6: a9 24     
	__clearStatusBarLoop:     
				sta ppuData          ; $e4d8: 8d 07 20  
				inx                ; $e4db: e8        
				cpx #$14           ; $e4dc: e0 14     
				bne __clearStatusBarLoop         ; $e4de: d0 f8     
            rts                ; $e4e0: 60        

;-------------------------------------------------------------------------------
__e4e1:     .hex 02            ; $e4e1: 02            Data
__e4e2:     .hex 03 0b 05 01   ; $e4e2: 03 0b 05 01   Data
            .hex 0c 07 08 02   ; $e4e6: 0c 07 08 02   Data
            .hex 06 0d 04 01   ; $e4ea: 06 0d 04 01   Data
            .hex 0c 00 00 09   ; $e4ee: 0c 00 00 09   Data
            .hex 0a 31 17 29   ; $e4f2: 0a 31 17 29   Data
            .hex 12 31 18 29   ; $e4f6: 12 31 18 29   Data
            .hex 1a 31 1a 29   ; $e4fa: 1a 31 1a 29   Data
            .hex 18 31 01 30   ; $e4fe: 18 31 01 30   Data
            .hex 21 31 12 30   ; $e502: 21 31 12 30   Data
            .hex 17 31 0f 30   ; $e506: 17 31 0f 30   Data
            .hex 16 31 13 30   ; $e50a: 16 31 13 30   Data
            .hex 16 31 0f 38   ; $e50e: 16 31 0f 38   Data
            .hex 26 31 17 27   ; $e512: 26 31 17 27   Data
            .hex 12 31 18 39   ; $e516: 12 31 18 39   Data
            .hex 1a 31 29 26   ; $e51a: 1a 31 29 26   Data
            .hex 17 31 01 30   ; $e51e: 17 31 01 30   Data
            .hex 21 31 12 30   ; $e522: 21 31 12 30   Data
            .hex 17 31 0f 30   ; $e526: 17 31 0f 30   Data
            .hex 16 31 0f 30   ; $e52a: 16 31 0f 30   Data
            .hex 12 31 0f 38   ; $e52e: 12 31 0f 38   Data
            .hex 16 31 17 34   ; $e532: 16 31 17 34   Data
            .hex 12 31 18 1b   ; $e536: 12 31 18 1b   Data
            .hex 29 31 15 34   ; $e53a: 29 31 15 34   Data
            .hex 18 31 10 30   ; $e53e: 18 31 10 30   Data
            .hex 21 31 12 30   ; $e542: 21 31 12 30   Data
            .hex 17 31 0f 30   ; $e546: 17 31 0f 30   Data
            .hex 16 31 18 30   ; $e54a: 16 31 18 30   Data
            .hex 0f 31 0f 38   ; $e54e: 0f 31 0f 38   Data
            .hex 26 31 17 27   ; $e552: 26 31 17 27   Data
            .hex 12 31 18 28   ; $e556: 12 31 18 28   Data
            .hex 29 31 16 27   ; $e55a: 29 31 16 27   Data
            .hex 18 31 01 30   ; $e55e: 18 31 01 30   Data
            .hex 21 31 12 30   ; $e562: 21 31 12 30   Data
            .hex 17 31 0f 30   ; $e566: 17 31 0f 30   Data
            .hex 16 31 10 30   ; $e56a: 16 31 10 30   Data
            .hex 0f 31 0f 38   ; $e56e: 0f 31 0f 38   Data
            .hex 26 31 17 2a   ; $e572: 26 31 17 2a   Data
            .hex 12 31 30 11   ; $e576: 12 31 30 11   Data
            .hex 24 31 30 11   ; $e57a: 24 31 30 11   Data
            .hex 10 31 2a 30   ; $e57e: 10 31 2a 30   Data
            .hex 10 31 12 30   ; $e582: 10 31 12 30   Data
            .hex 17 31 21 31   ; $e586: 17 31 21 31   Data
            .hex 15 31 0f 30   ; $e58a: 15 31 0f 30   Data
            .hex 12 31 21 03   ; $e58e: 12 31 21 03   Data
            .hex 2c 31 17 28   ; $e592: 2c 31 17 28   Data
            .hex 12 31 18 28   ; $e596: 12 31 18 28   Data
            .hex 36 31 17 28   ; $e59a: 36 31 17 28   Data
            .hex 18 31 07 30   ; $e59e: 18 31 07 30   Data
            .hex 21 31 12 30   ; $e5a2: 21 31 12 30   Data
            .hex 17 31 0f 30   ; $e5a6: 17 31 0f 30   Data
            .hex 16 31 13 30   ; $e5aa: 16 31 13 30   Data
            .hex 16 31 0f 38   ; $e5ae: 16 31 0f 38   Data
            .hex 26 31 17 29   ; $e5b2: 26 31 17 29   Data
            .hex 12 31 16 29   ; $e5b6: 12 31 16 29   Data
            .hex 1b 31 1a 29   ; $e5ba: 1b 31 1a 29   Data
            .hex 18 31 01 30   ; $e5be: 18 31 01 30   Data
            .hex 21 31 12 30   ; $e5c2: 21 31 12 30   Data
            .hex 17 31 0f 30   ; $e5c6: 17 31 0f 30   Data
            .hex 16 31 17 30   ; $e5ca: 16 31 17 30   Data
            .hex 0f 31 0f 38   ; $e5ce: 0f 31 0f 38   Data
            .hex 26 31 17 29   ; $e5d2: 26 31 17 29   Data
            .hex 12 31 18 28   ; $e5d6: 12 31 18 28   Data
            .hex 36 31 1b 29   ; $e5da: 36 31 1b 29   Data
            .hex 18 31 01 30   ; $e5de: 18 31 01 30   Data
            .hex 28 31 12 30   ; $e5e2: 28 31 12 30   Data
            .hex 17 31 0f 30   ; $e5e6: 17 31 0f 30   Data
            .hex 16 31 10 30   ; $e5ea: 16 31 10 30   Data
            .hex 0f 31 0f 38   ; $e5ee: 0f 31 0f 38   Data
            .hex 26 10 0f 10   ; $e5f2: 26 10 0f 10   Data
            .hex 0f 10 0f 10   ; $e5f6: 0f 10 0f 10   Data
            .hex 0f 0c 0e 0b   ; $e5fa: 0f 0c 0e 0b   Data
            .hex 0d 0d 0e 0c   ; $e5fe: 0d 0d 0e 0c   Data
            .hex 0d 0e 0b 0c   ; $e602: 0d 0e 0b 0c   Data
            .hex 0b 0b 0d 0d   ; $e606: 0b 0b 0d 0d   Data
            .hex 0d 0c 12 0d   ; $e60a: 0d 0c 12 0d   Data
            .hex 12 0d 12 0c   ; $e60e: 12 0d 12 0c   Data
            .hex 12 31 13 31   ; $e612: 12 31 13 31   Data
            .hex 13 31 13 31   ; $e616: 13 31 13 31   Data
            .hex 13 07 07 08   ; $e61a: 13 07 07 08   Data
            .hex 07 0a 07 07   ; $e61e: 07 0a 07 07   Data
            .hex 08 10 0f 10   ; $e622: 08 10 0f 10   Data
            .hex 0f 10 0f 10   ; $e626: 0f 10 0f 10   Data
            .hex 0f 0c 21 0c   ; $e62a: 0f 0c 21 0c   Data
            .hex 21 0b 21 0d   ; $e62e: 21 0b 21 0d   Data
            .hex 21 0d 20 4f   ; $e632: 21 0d 20 4f   Data
            .hex 20 0e 20 0b   ; $e636: 20 0e 20 0b   Data
            .hex 20 11 1f 11   ; $e63a: 20 11 1f 11   Data
            .hex 1f 11 1f 11   ; $e63e: 1f 11 1f 11   Data
            .hex 1f 00 1e 51   ; $e642: 1f 00 1e 51   Data
            .hex 1e 50 1e 50   ; $e646: 1e 50 1e 50   Data
            .hex 1e 07 08 0a   ; $e64a: 1e 07 08 0a   Data
            .hex 07 08 09 07   ; $e64e: 07 08 09 07   Data
            .hex 08 02 00 22   ; $e652: 08 02 00 22   Data
            .hex 0f 26 00 00   ; $e656: 0f 26 00 00   Data
            .hex 00 00 23 0c   ; $e65a: 00 00 23 0c   Data
            .hex 21 0b 27 00   ; $e65e: 21 0b 27 00   Data
            .hex 01 00 24 0d   ; $e662: 01 00 24 0d   Data
            .hex 20 4e 28 00   ; $e666: 20 4e 28 00   Data
            .hex 00 00 00 25   ; $e66a: 00 00 00 25   Data
            .hex 1f 29 4d 00   ; $e66e: 1f 29 4d 00   Data
            .hex 00 05 05 50   ; $e672: 00 05 05 50   Data
            .hex 1e 00 14 15   ; $e676: 1e 00 14 15   Data
            .hex 1d 08 0a 08   ; $e67a: 1d 08 0a 08   Data
            .hex 07 09 07 0a   ; $e67e: 07 09 07 0a   Data
            .hex 08 00 03 04   ; $e682: 08 00 03 04   Data
            .hex 00 00 00 00   ; $e686: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e68a: 00 00 00 00   Data
            .hex 00 00         ; $e68e: 00 00         Data
__e690:     .hex 01 00 00 00   ; $e690: 01 00 00 00   Data
            .hex 00 00 00 00   ; $e694: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e698: 00 00 00 00   Data
            .hex 00 17 18 15   ; $e69c: 00 17 18 15   Data
            .hex 1c 1b 00 14   ; $e6a0: 1c 1b 00 14   Data
            .hex 15 16 19 30   ; $e6a4: 15 16 19 30   Data
            .hex 30 30 1d 08   ; $e6a8: 30 30 1d 08   Data
            .hex 0a 07 09 07   ; $e6ac: 0a 07 09 07   Data
            .hex 07 0a 07 02   ; $e6b0: 07 0a 07 02   Data
            .hex 00 00 00 03   ; $e6b4: 00 00 00 03   Data
            .hex 04 00 00 00   ; $e6b8: 04 00 00 00   Data
            .hex 00 00 01 00   ; $e6bc: 00 00 01 00   Data
            .hex 00 00 01 00   ; $e6c0: 00 00 01 00   Data
            .hex 00 00 00 00   ; $e6c4: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e6c8: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e6cc: 00 00 00 00   Data
            .hex 00 00 00 52   ; $e6d0: 00 00 00 52   Data
            .hex 50 53 52 53   ; $e6d4: 50 53 52 53   Data
            .hex 51 52 52 0a   ; $e6d8: 51 52 52 0a   Data
            .hex 54 54 55 0a   ; $e6dc: 54 54 55 0a   Data
            .hex 55 0a 0a 03   ; $e6e0: 55 0a 0a 03   Data
            .hex 04 00 00 00   ; $e6e4: 04 00 00 00   Data
            .hex 00 00 00 00   ; $e6e8: 00 00 00 00   Data
            .hex 00 00 00 02   ; $e6ec: 00 00 00 02   Data
            .hex 01 00 00 00   ; $e6f0: 01 00 00 00   Data
            .hex 00 00 00 00   ; $e6f4: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e6f8: 00 00 00 00   Data
            .hex 00 2b 2f 00   ; $e6fc: 00 2b 2f 00   Data
            .hex 00 00 00 2a   ; $e700: 00 00 00 2a   Data
            .hex 2c 2d 2e 2a   ; $e704: 2c 2d 2e 2a   Data
            .hex 2a 2f 00 08   ; $e708: 2a 2f 00 08   Data
            .hex 07 07 08 08   ; $e70c: 07 07 08 08   Data
            .hex 07 07 07 00   ; $e710: 07 07 07 00   Data
            .hex 03 04 00 00   ; $e714: 03 04 00 00   Data
            .hex 00 00 00 00   ; $e718: 00 00 00 00   Data
            .hex 00 00 00 02   ; $e71c: 00 00 00 02   Data
            .hex 00 02 00 00   ; $e720: 00 02 00 00   Data
            .hex 01 00 00 00   ; $e724: 01 00 00 00   Data
            .hex 00 00 00 00   ; $e728: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e72c: 00 00 00 00   Data
            .hex 00 00 00 17   ; $e730: 00 00 00 17   Data
            .hex 18 15 1c 1b   ; $e734: 18 15 1c 1b   Data
            .hex 00 00 00 07   ; $e738: 00 00 00 07   Data
            .hex 0a 09 0a 0a   ; $e73c: 0a 09 0a 0a   Data
            .hex 0a 0a 08 00   ; $e740: 0a 0a 08 00   Data
            .hex 00 00 03 04   ; $e744: 00 00 03 04   Data
            .hex 00 00 00 00   ; $e748: 00 00 00 00   Data
            .hex 02 00 00 00   ; $e74c: 02 00 00 00   Data
            .hex 00 01 00 00   ; $e750: 00 01 00 00   Data
            .hex 00 00 00 00   ; $e754: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e758: 00 00 00 00   Data
            .hex 00 00 36 00   ; $e75c: 00 00 36 00   Data
            .hex 00 00 00 00   ; $e760: 00 00 00 00   Data
            .hex 00 2c 30 2e   ; $e764: 00 2c 30 2e   Data
            .hex 00 00 00 32   ; $e768: 00 00 00 32   Data
            .hex 32 33 34 34   ; $e76c: 32 33 34 34   Data
            .hex 35 32 32 00   ; $e770: 35 32 32 00   Data
            .hex 03 04 00 00   ; $e774: 03 04 00 00   Data
            .hex 03 04 00 00   ; $e778: 03 04 00 00   Data
            .hex 00 00 00 00   ; $e77c: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e780: 00 00 00 00   Data
            .hex 00 00 00 01   ; $e784: 00 00 00 01   Data
            .hex 00 00 00 00   ; $e788: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e78c: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e790: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e794: 00 00 00 00   Data
            .hex 00 00 00 32   ; $e798: 00 00 00 32   Data
            .hex 32 32 32 32   ; $e79c: 32 32 32 32   Data
            .hex 32 32 32 00   ; $e7a0: 32 32 32 00   Data
            .hex 3f 40 41 42   ; $e7a4: 3f 40 41 42   Data
            .hex 3c 39 00 00   ; $e7a8: 3c 39 00 00   Data
            .hex 43 44 45 46   ; $e7ac: 43 44 45 46   Data
            .hex 47 48 00 00   ; $e7b0: 47 48 00 00   Data
            .hex 3e 49 4a 4b   ; $e7b4: 3e 49 4a 4b   Data
            .hex 4c 56 00 00   ; $e7b8: 4c 56 00 00   Data
            .hex 3a 38 38 38   ; $e7bc: 3a 38 38 38   Data
            .hex 38 3b 00 00   ; $e7c0: 38 3b 00 00   Data
            .hex 00 00 00 00   ; $e7c4: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e7c8: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e7cc: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e7d0: 00 00 00 00   Data
            .hex 37 3c 3c 3c   ; $e7d4: 37 3c 3c 3c   Data
            .hex 3c 39 00 00   ; $e7d8: 3c 39 00 00   Data
            .hex 3e 57 57 57   ; $e7dc: 3e 57 57 57   Data
            .hex 57 3d 00 00   ; $e7e0: 57 3d 00 00   Data
            .hex 3a 38 38 38   ; $e7e4: 3a 38 38 38   Data
            .hex 38 3b 00 00   ; $e7e8: 38 3b 00 00   Data
            .hex 00 00 17 18   ; $e7ec: 00 00 17 18   Data
            .hex 1b 00 00 17   ; $e7f0: 1b 00 00 17   Data
            .hex 18 15 16 19   ; $e7f4: 18 15 16 19   Data
            .hex 30 1d 06 07   ; $e7f8: 30 1d 06 07   Data
            .hex 08 07 0a 08   ; $e7fc: 08 07 0a 08   Data
            .hex 09 07 08 00   ; $e800: 09 07 08 00   Data
            .hex 03 04 00 22   ; $e804: 03 04 00 22   Data
            .hex 0f 26 00 01   ; $e808: 0f 26 00 01   Data
            .hex 00 00 23 0d   ; $e80c: 00 00 23 0d   Data
            .hex 21 0e 27 00   ; $e810: 21 0e 27 00   Data
            .hex 00 00 24 0c   ; $e814: 00 00 24 0c   Data
            .hex 20 4f 28 00   ; $e818: 20 4f 28 00   Data
            .hex 2b 2f 00 25   ; $e81c: 2b 2f 00 25   Data
            .hex 1f 29 4d 2c   ; $e820: 1f 29 4d 2c   Data
            .hex 2d 2e 05 00   ; $e824: 2d 2e 05 00   Data
            .hex 1e 00 00 07   ; $e828: 1e 00 00 07   Data
            .hex 0a 08 0a 09   ; $e82c: 0a 08 0a 09   Data
            .hex 07 08 07 10   ; $e830: 07 08 07 10   Data
            .hex 0f 10 0f 10   ; $e834: 0f 10 0f 10   Data
            .hex 0f 10 0f 0c   ; $e838: 0f 10 0f 0c   Data
            .hex 21 0c 21 0b   ; $e83c: 21 0c 21 0b   Data
            .hex 21 0d 21 0d   ; $e840: 21 0d 21 0d   Data
            .hex 20 0b 20 0e   ; $e844: 20 0b 20 0e   Data
            .hex 20 0b 20 11   ; $e848: 20 0b 20 11   Data
            .hex 1f 11 1f 11   ; $e84c: 1f 11 1f 11   Data
            .hex 1f 11 1f 00   ; $e850: 1f 11 1f 00   Data
            .hex 1e 50 1e 00   ; $e854: 1e 50 1e 00   Data
            .hex 1e 51 1e 0a   ; $e858: 1e 51 1e 0a   Data
            .hex 08 07 09 08   ; $e85c: 08 07 09 08   Data
            .hex 0a 07 08 00   ; $e860: 0a 07 08 00   Data
            .hex 03 04 00 22   ; $e864: 03 04 00 22   Data
            .hex 0f 26 00 01   ; $e868: 0f 26 00 01   Data
            .hex 00 00 23 0d   ; $e86c: 00 00 23 0d   Data
            .hex 21 0e 27 00   ; $e870: 21 0e 27 00   Data
            .hex 00 00 24 0c   ; $e874: 00 00 24 0c   Data
            .hex 20 4f 28 00   ; $e878: 20 4f 28 00   Data
            .hex 00 00 00 25   ; $e87c: 00 00 00 25   Data
            .hex 1f 29 4d 52   ; $e880: 1f 29 4d 52   Data
            .hex 50 53 53 52   ; $e884: 50 53 53 52   Data
            .hex 1e 50 52 0a   ; $e888: 1e 50 52 0a   Data
            .hex 54 55 0a 55   ; $e88c: 54 55 0a 55   Data
            .hex 54 54 55      ; $e890: 54 54 55      Data
__e893:     .hex ff ff ff ff   ; $e893: ff ff ff ff   Data
            .hex ff 55 55 55   ; $e897: ff 55 55 55   Data
            .hex 55 55 55 aa   ; $e89b: 55 55 55 aa   Data
            .hex aa aa aa aa   ; $e89f: aa aa aa aa   Data
            .hex aa aa aa aa   ; $e8a3: aa aa aa aa   Data
            .hex ff ff ff ff   ; $e8a7: ff ff ff ff   Data
            .hex ff ff ff ff   ; $e8ab: ff ff ff ff   Data
            .hex ff ff aa aa   ; $e8af: ff ff aa aa   Data
            .hex aa aa aa aa   ; $e8b3: aa aa aa aa   Data
            .hex aa aa aa aa   ; $e8b7: aa aa aa aa   Data
            .hex aa aa ff ff   ; $e8bb: aa aa ff ff   Data
            .hex ff ff ff ff   ; $e8bf: ff ff ff ff   Data
            .hex ff aa aa aa   ; $e8c3: ff aa aa aa   Data
            .hex aa aa 55 00   ; $e8c7: aa aa 55 00   Data
            .hex 00 00 00 00   ; $e8cb: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e8cf: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e8d3: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e8d7: 00 00 00 00   Data
            .hex 00 00 00 00   ; $e8db: 00 00 00 00   Data
            .hex 00 aa 0a a0   ; $e8df: 00 aa 0a a0   Data
            .hex 55 55 55 55   ; $e8e3: 55 55 55 55   Data
            .hex 55 55 00 00   ; $e8e7: 55 55 00 00   Data
            .hex 24 24 24 24   ; $e8eb: 24 24 24 24   Data
            .hex 24 24 24 24   ; $e8ef: 24 24 24 24   Data
            .hex 24 24 24 24   ; $e8f3: 24 24 24 24   Data
            .hex 24 24 24 24   ; $e8f7: 24 24 24 24   Data
            .hex a0 a2 24 24   ; $e8fb: a0 a2 24 24   Data
            .hex a1 a3 24 24   ; $e8ff: a1 a3 24 24   Data
            .hex 24 24 24 24   ; $e903: 24 24 24 24   Data
            .hex 24 24 24 24   ; $e907: 24 24 24 24   Data
            .hex 24 85 85 24   ; $e90b: 24 85 85 24   Data
            .hex a0 3e 3e a6   ; $e90f: a0 3e 3e a6   Data
            .hex a1 3e 3e a3   ; $e913: a1 3e 3e a3   Data
            .hex 24 a8 a8 24   ; $e917: 24 a8 a8 24   Data
            .hex 24 a4 a6 a4   ; $e91b: 24 a4 a6 a4   Data
            .hex 87 7f 4e 3e   ; $e91f: 87 7f 4e 3e   Data
            .hex 24 a1 a7 a1   ; $e923: 24 a1 a7 a1   Data
            .hex 24 24 24 24   ; $e927: 24 24 24 24   Data
            .hex a6 a4 a6 24   ; $e92b: a6 a4 a6 24   Data
            .hex 3e 3e 3e ab   ; $e92f: 3e 3e 3e ab   Data
            .hex a3 a5 a7 24   ; $e933: a3 a5 a7 24   Data
            .hex 24 24 24 24   ; $e937: 24 24 24 24   Data
            .hex 6c 6e 24 24   ; $e93b: 6c 6e 24 24   Data
            .hex 61 61 24 24   ; $e93f: 61 61 24 24   Data
            .hex 70 72 24 24   ; $e943: 70 72 24 24   Data
            .hex 71 73 24 24   ; $e947: 71 73 24 24   Data
            .hex 6c 6e 6c 6e   ; $e94b: 6c 6e 6c 6e   Data
            .hex 61 61 61 61   ; $e94f: 61 61 61 61   Data
            .hex 70 72 70 72   ; $e953: 70 72 70 72   Data
            .hex 71 73 71 73   ; $e957: 71 73 71 73   Data
            .hex 74 af 74 af   ; $e95b: 74 af 74 af   Data
            .hex af 76 74 af   ; $e95f: af 76 74 af   Data
            .hex af af af 76   ; $e963: af af af 76   Data
            .hex 76 af af af   ; $e967: 76 af af af   Data
            .hex af 76 74 af   ; $e96b: af 76 74 af   Data
            .hex 74 af af af   ; $e96f: 74 af af af   Data
            .hex 74 af af af   ; $e973: 74 af af af   Data
            .hex af af 76 af   ; $e977: af af 76 af   Data
            .hex af 74 af af   ; $e97b: af 74 af af   Data
            .hex af af af af   ; $e97f: af af af af   Data
            .hex 74 af 74 af   ; $e983: 74 af 74 af   Data
            .hex af af b8 ba   ; $e987: af af b8 ba   Data
            .hex b8 af 74 af   ; $e98b: b8 af 74 af   Data
            .hex 76 74 af af   ; $e98f: 76 74 af af   Data
            .hex 74 af af af   ; $e993: 74 af af af   Data
            .hex af af 76 af   ; $e997: af af 76 af   Data
            .hex 62 62 63 60   ; $e99b: 62 62 63 60   Data
            .hex 62 62 60 60   ; $e99f: 62 62 60 60   Data
            .hex 62 60 63 61   ; $e9a3: 62 60 63 61   Data
            .hex 63 63 62 61   ; $e9a7: 63 63 62 61   Data
            .hex 62 62 63 62   ; $e9ab: 62 62 63 62   Data
            .hex 60 62 63 61   ; $e9af: 60 62 63 61   Data
            .hex 62 63 63 63   ; $e9b3: 62 63 63 63   Data
            .hex 61 63 62 61   ; $e9b7: 61 63 62 61   Data
            .hex 62 63 63 61   ; $e9bb: 62 63 63 61   Data
            .hex 60 62 61 61   ; $e9bf: 60 62 61 61   Data
            .hex 61 62 60 62   ; $e9c3: 61 62 60 62   Data
            .hex 61 62 61 62   ; $e9c7: 61 62 61 62   Data
            .hex 63 62 63 63   ; $e9cb: 63 62 63 63   Data
            .hex 62 63 63 63   ; $e9cf: 62 63 63 63   Data
            .hex 62 60 63 62   ; $e9d3: 62 60 63 62   Data
            .hex 63 63 62 62   ; $e9d7: 63 63 62 62   Data
            .hex 24 24 68 6a   ; $e9db: 24 24 68 6a   Data
            .hex 68 64 63 63   ; $e9df: 68 64 63 63   Data
            .hex 60 60 63 62   ; $e9e3: 60 60 63 62   Data
            .hex 63 63 62 62   ; $e9e7: 63 63 62 62   Data
            .hex 24 24 24 24   ; $e9eb: 24 24 24 24   Data
            .hex 6e aa 24 24   ; $e9ef: 6e aa 24 24   Data
            .hex 63 62 6a 68   ; $e9f3: 63 62 6a 68   Data
            .hex 63 63 62 62   ; $e9f7: 63 63 62 62   Data
            .hex 62 63 63 61   ; $e9fb: 62 63 63 61   Data
            .hex 60 62 60 61   ; $e9ff: 60 62 60 61   Data
            .hex 61 62 6b 69   ; $ea03: 61 62 6b 69   Data
            .hex 69 6b 24 24   ; $ea07: 69 6b 24 24   Data
            .hex 63 63 63 61   ; $ea0b: 63 63 63 61   Data
            .hex 60 63 60 60   ; $ea0f: 60 63 60 60   Data
            .hex 62 63 5c 5e   ; $ea13: 62 63 5c 5e   Data
            .hex 63 63 59 5b   ; $ea17: 63 63 59 5b   Data
            .hex a8 69 49 4a   ; $ea1b: a8 69 49 4a   Data
            .hex 24 24 45 47   ; $ea1f: 24 24 45 47   Data
            .hex 24 24 40 42   ; $ea23: 24 24 40 42   Data
            .hex 24 24 41 43   ; $ea27: 24 24 41 43   Data
            .hex 24 24 24 24   ; $ea2b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ea2f: 24 24 24 24   Data
            .hex 24 24 88 8a   ; $ea33: 24 24 88 8a   Data
            .hex 88 8a af af   ; $ea37: 88 8a af af   Data
            .hex 24 24 88 8a   ; $ea3b: 24 24 88 8a   Data
            .hex 88 8a af af   ; $ea3f: 88 8a af af   Data
            .hex af af af af   ; $ea43: af af af af   Data
            .hex af af af af   ; $ea47: af af af af   Data
            .hex af af 8d 3c   ; $ea4b: af af 8d 3c   Data
            .hex af 8d 91 93   ; $ea4f: af 8d 91 93   Data
            .hex af af af af   ; $ea53: af af af af   Data
            .hex af af af af   ; $ea57: af af af af   Data
            .hex 24 24 24 24   ; $ea5b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ea5f: 24 24 24 24   Data
            .hex 24 24 88 8e   ; $ea63: 24 24 88 8e   Data
            .hex 88 8a af 8f   ; $ea67: 88 8a af 8f   Data
            .hex 24 24 24 24   ; $ea6b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ea6f: 24 24 24 24   Data
            .hex 92 24 24 90   ; $ea73: 92 24 24 90   Data
            .hex 3c 92 90 af   ; $ea77: 3c 92 90 af   Data
            .hex 91 93 af af   ; $ea7b: 91 93 af af   Data
            .hex af af af af   ; $ea7f: af af af af   Data
            .hex af af af af   ; $ea83: af af af af   Data
            .hex af af af af   ; $ea87: af af af af   Data
            .hex 24 24 88 8a   ; $ea8b: 24 24 88 8a   Data
            .hex 24 90 af af   ; $ea8f: 24 90 af af   Data
            .hex 90 af af af   ; $ea93: 90 af af af   Data
            .hex af af af af   ; $ea97: af af af af   Data
            .hex 24 24 24 24   ; $ea9b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ea9f: 24 24 24 24   Data
            .hex 89 8b 24 24   ; $eaa3: 89 8b 24 24   Data
            .hex af af 89 8b   ; $eaa7: af af 89 8b   Data
            .hex 89 8b 24 24   ; $eaab: 89 8b 24 24   Data
            .hex af af 89 8b   ; $eaaf: af af 89 8b   Data
            .hex af af af af   ; $eab3: af af af af   Data
            .hex af af af af   ; $eab7: af af af af   Data
            .hex 97 24 24 24   ; $eabb: 97 24 24 24   Data
            .hex af 97 24 24   ; $eabf: af 97 24 24   Data
            .hex af af 97 24   ; $eac3: af af 97 24   Data
            .hex af af af 97   ; $eac7: af af af 97   Data
            .hex 24 24 44 46   ; $eacb: 24 24 44 46   Data
            .hex 24 24 45 47   ; $eacf: 24 24 45 47   Data
            .hex 24 24 40 42   ; $ead3: 24 24 40 42   Data
            .hex 24 24 41 43   ; $ead7: 24 24 41 43   Data
            .hex 62 62 48 4b   ; $eadb: 62 62 48 4b   Data
            .hex 63 63 48 4b   ; $eadf: 63 63 48 4b   Data
            .hex 69 63 48 4b   ; $eae3: 69 63 48 4b   Data
            .hex 24 a8 44 46   ; $eae7: 24 a8 44 46   Data
            .hex 60 62 50 52   ; $eaeb: 60 62 50 52   Data
            .hex 60 63 51 4a   ; $eaef: 60 63 51 4a   Data
            .hex 62 4c 48 4b   ; $eaf3: 62 4c 48 4b   Data
            .hex 61 4d 49 4b   ; $eaf7: 61 4d 49 4b   Data
            .hex 62 62 63 60   ; $eafb: 62 62 63 60   Data
            .hex 63 63 5c 5e   ; $eaff: 63 63 5c 5e   Data
            .hex 63 62 5d 5f   ; $eb03: 63 62 5d 5f   Data
            .hex 61 63 58 5a   ; $eb07: 61 63 58 5a   Data
            .hex 24 24 24 24   ; $eb0b: 24 24 24 24   Data
            .hex 24 24 24 68   ; $eb0f: 24 24 24 68   Data
            .hex 24 24 64 60   ; $eb13: 24 24 64 60   Data
            .hex 64 60 60 62   ; $eb17: 64 60 60 62   Data
            .hex 24 24 24 64   ; $eb1b: 24 24 24 64   Data
            .hex 24 24 64 60   ; $eb1f: 24 24 64 60   Data
            .hex 24 6c 60 61   ; $eb23: 24 6c 60 61   Data
            .hex 24 6d 60 61   ; $eb27: 24 6d 60 61   Data
            .hex 24 24 64 62   ; $eb2b: 24 24 64 62   Data
            .hex 24 24 65 60   ; $eb2f: 24 24 65 60   Data
            .hex 24 24 a9 61   ; $eb33: 24 24 a9 61   Data
            .hex 24 24 24 6d   ; $eb37: 24 24 24 6d   Data
            .hex 65 65 62 62   ; $eb3b: 65 65 62 62   Data
            .hex 24 69 62 60   ; $eb3f: 24 69 62 60   Data
            .hex 24 24 a8 69   ; $eb43: 24 24 a8 69   Data
            .hex 24 24 24 24   ; $eb47: 24 24 24 24   Data
            .hex 24 24 24 24   ; $eb4b: 24 24 24 24   Data
            .hex 66 24 24 24   ; $eb4f: 66 24 24 24   Data
            .hex 62 66 6a 24   ; $eb53: 62 66 6a 24   Data
            .hex 63 62 63 6e   ; $eb57: 63 62 63 6e   Data
            .hex 6e 24 24 24   ; $eb5b: 6e 24 24 24   Data
            .hex 61 66 24 24   ; $eb5f: 61 66 24 24   Data
            .hex 62 61 6e 24   ; $eb63: 62 61 6e 24   Data
            .hex 63 62 6f 24   ; $eb67: 63 62 6f 24   Data
            .hex 60 62 66 24   ; $eb6b: 60 62 66 24   Data
            .hex 61 63 62 ab   ; $eb6f: 61 63 62 ab   Data
            .hex 61 62 67 24   ; $eb73: 61 62 67 24   Data
            .hex 61 61 ab 24   ; $eb77: 61 61 ab 24   Data
            .hex 61 62 61 67   ; $eb7b: 61 62 61 67   Data
            .hex 62 61 63 61   ; $eb7f: 62 61 63 61   Data
            .hex 62 63 67 a8   ; $eb83: 62 63 67 a8   Data
            .hex 6b a8 24 24   ; $eb87: 6b a8 24 24   Data
            .hex 24 98 9c 9a   ; $eb8b: 24 98 9c 9a   Data
            .hex 24 99 af 9b   ; $eb8f: 24 99 af 9b   Data
            .hex 98 9f af 9b   ; $eb93: 98 9f af 9b   Data
            .hex 99 9b af 9b   ; $eb97: 99 9b af 9b   Data
            .hex 24 24 24 24   ; $eb9b: 24 24 24 24   Data
            .hex 24 98 9c 9a   ; $eb9f: 24 98 9c 9a   Data
            .hex 98 af 9d 9f   ; $eba3: 98 af 9d 9f   Data
            .hex 99 9d 9f 9b   ; $eba7: 99 9d 9f 9b   Data
            .hex 24 24 98 9c   ; $ebab: 24 24 98 9c   Data
            .hex 24 24 99 af   ; $ebaf: 24 24 99 af   Data
            .hex 24 98 9f af   ; $ebb3: 24 98 9f af   Data
            .hex 24 99 9b 99   ; $ebb7: 24 99 9b 99   Data
            .hex af 99 9b 9b   ; $ebbb: af 99 9b 9b   Data
            .hex 9d 9f 9b 9b   ; $ebbf: 9d 9f 9b 9b   Data
            .hex 99 9d 9f 9b   ; $ebc3: 99 9d 9f 9b   Data
            .hex 99 99 9b 9b   ; $ebc7: 99 99 9b 9b   Data
            .hex af 9b 24 24   ; $ebcb: af 9b 24 24   Data
            .hex af 9b 9c 9a   ; $ebcf: af 9b 9c 9a   Data
            .hex af 9b af 9b   ; $ebd3: af 9b af 9b   Data
            .hex af 9b af 9b   ; $ebd7: af 9b af 9b   Data
            .hex 24 24 24 24   ; $ebdb: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ebdf: 24 24 24 24   Data
            .hex 9c 9a 24 24   ; $ebe3: 9c 9a 24 24   Data
            .hex af 9b 24 24   ; $ebe7: af 9b 24 24   Data
            .hex af af af af   ; $ebeb: af af af af   Data
            .hex af af af af   ; $ebef: af af af af   Data
            .hex af af af af   ; $ebf3: af af af af   Data
            .hex af af af af   ; $ebf7: af af af af   Data
            .hex 6b 69 6b a8   ; $ebfb: 6b 69 6b a8   Data
            .hex 24 24 24 24   ; $ebff: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ec03: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ec07: 24 24 24 24   Data
            .hex aa aa aa aa   ; $ec0b: aa aa aa aa   Data
            .hex 7d 7d 7d 7d   ; $ec0f: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec13: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec17: 7d 7d 7d 7d   Data
            .hex ac ad ad ad   ; $ec1b: ac ad ad ad   Data
            .hex 7d 7d 7d 7d   ; $ec1f: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec23: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec27: 7d 7d 7d 7d   Data
            .hex ad ad ad ad   ; $ec2b: ad ad ad ad   Data
            .hex 7d 7d 7d 7d   ; $ec2f: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec33: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec37: 7d 7d 7d 7d   Data
            .hex ae aa aa aa   ; $ec3b: ae aa aa aa   Data
            .hex 7d 7d 7d 7d   ; $ec3f: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec43: 7d 7d 7d 7d   Data
            .hex 7d 7d 7d 7d   ; $ec47: 7d 7d 7d 7d   Data
            .hex 24 24 24 24   ; $ec4b: 24 24 24 24   Data
            .hex 80 82 24 24   ; $ec4f: 80 82 24 24   Data
            .hex 81 83 24 24   ; $ec53: 81 83 24 24   Data
            .hex 84 86 24 24   ; $ec57: 84 86 24 24   Data
            .hex 34 3a 3a 3a   ; $ec5b: 34 3a 3a 3a   Data
            .hex 38 24 24 24   ; $ec5f: 38 24 24 24   Data
            .hex 38 24 24 24   ; $ec63: 38 24 24 24   Data
            .hex 38 24 24 24   ; $ec67: 38 24 24 24   Data
            .hex 39 39 39 39   ; $ec6b: 39 39 39 39   Data
            .hex 24 24 24 24   ; $ec6f: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ec73: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ec77: 24 24 24 24   Data
            .hex 3a 3a 3a 36   ; $ec7b: 3a 3a 3a 36   Data
            .hex 24 24 24 3b   ; $ec7f: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ec83: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ec87: 24 24 24 3b   Data
            .hex 35 39 39 39   ; $ec8b: 35 39 39 39   Data
            .hex 24 24 24 24   ; $ec8f: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ec93: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ec97: 24 24 24 24   Data
            .hex 39 39 39 37   ; $ec9b: 39 39 39 37   Data
            .hex 24 24 24 24   ; $ec9f: 24 24 24 24   Data
            .hex 24 24 24 24   ; $eca3: 24 24 24 24   Data
            .hex 24 24 24 24   ; $eca7: 24 24 24 24   Data
            .hex 3a 3a 3a 3a   ; $ecab: 3a 3a 3a 3a   Data
            .hex 24 24 24 24   ; $ecaf: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ecb3: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ecb7: 24 24 24 24   Data
            .hex 24 24 24 3b   ; $ecbb: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ecbf: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ecc3: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ecc7: 24 24 24 3b   Data
            .hex 38 24 24 24   ; $eccb: 38 24 24 24   Data
            .hex 38 24 24 24   ; $eccf: 38 24 24 24   Data
            .hex 38 24 24 24   ; $ecd3: 38 24 24 24   Data
            .hex 38 24 24 24   ; $ecd7: 38 24 24 24   Data
            .hex 34 3a 3a 3a   ; $ecdb: 34 3a 3a 3a   Data
            .hex 38 24 2c 31   ; $ecdf: 38 24 2c 31   Data
            .hex 38 24 2e 24   ; $ece3: 38 24 2e 24   Data
            .hex 38 24 2d 31   ; $ece7: 38 24 2d 31   Data
            .hex 3a 3a 3a 3a   ; $eceb: 3a 3a 3a 3a   Data
            .hex 2a 24 30 24   ; $ecef: 2a 24 30 24   Data
            .hex 2e 24 2e 24   ; $ecf3: 2e 24 2e 24   Data
            .hex 1f 24 2e 24   ; $ecf7: 1f 24 2e 24   Data
            .hex 3a 3a 3a 3a   ; $ecfb: 3a 3a 3a 3a   Data
            .hex 2c 31 2a 24   ; $ecff: 2c 31 2a 24   Data
            .hex 2e 24 2e 24   ; $ed03: 2e 24 2e 24   Data
            .hex 2d 31 2b 24   ; $ed07: 2d 31 2b 24   Data
            .hex 3a 3a 3a 3a   ; $ed0b: 3a 3a 3a 3a   Data
            .hex 2c 31 2a 24   ; $ed0f: 2c 31 2a 24   Data
            .hex 2e 24 2e 24   ; $ed13: 2e 24 2e 24   Data
            .hex 2e 24 2e 24   ; $ed17: 2e 24 2e 24   Data
            .hex 38 24 2e 24   ; $ed1b: 38 24 2e 24   Data
            .hex 38 24 23 31   ; $ed1f: 38 24 23 31   Data
            .hex 38 24 24 24   ; $ed23: 38 24 24 24   Data
            .hex 38 24 24 24   ; $ed27: 38 24 24 24   Data
            .hex 2e 24 2e 24   ; $ed2b: 2e 24 2e 24   Data
            .hex 2b 24 2f 24   ; $ed2f: 2b 24 2f 24   Data
            .hex 24 24 24 24   ; $ed33: 24 24 24 24   Data
            .hex 24 30 24 30   ; $ed37: 24 30 24 30   Data
            .hex 2e 24 20 24   ; $ed3b: 2e 24 20 24   Data
            .hex 2f 24 2f 24   ; $ed3f: 2f 24 2f 24   Data
            .hex 24 24 24 24   ; $ed43: 24 24 24 24   Data
            .hex 24 30 24 2c   ; $ed47: 24 30 24 2c   Data
            .hex 2e 24 2e 24   ; $ed4b: 2e 24 2e 24   Data
            .hex 23 31 2b 24   ; $ed4f: 23 31 2b 24   Data
            .hex 24 24 24 24   ; $ed53: 24 24 24 24   Data
            .hex 31 33 24 2c   ; $ed57: 31 33 24 2c   Data
            .hex 24 24 24 24   ; $ed5b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ed5f: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ed63: 24 24 24 24   Data
            .hex 31 33 24 30   ; $ed67: 31 33 24 30   Data
            .hex 24 24 24 3b   ; $ed6b: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ed6f: 24 24 24 3b   Data
            .hex 24 24 24 3b   ; $ed73: 24 24 24 3b   Data
            .hex 24 30 24 3b   ; $ed77: 24 30 24 3b   Data
            .hex 24 2e 24 2e   ; $ed7b: 24 2e 24 2e   Data
            .hex 24 2e 24 2e   ; $ed7f: 24 2e 24 2e   Data
            .hex 24 2e 24 2e   ; $ed83: 24 2e 24 2e   Data
            .hex 24 29 31 21   ; $ed87: 24 29 31 21   Data
            .hex 24 2e 24 2e   ; $ed8b: 24 2e 24 2e   Data
            .hex 24 2e 24 2d   ; $ed8f: 24 2e 24 2d   Data
            .hex 24 2e 24 2e   ; $ed93: 24 2e 24 2e   Data
            .hex 31 2b 24 23   ; $ed97: 31 2b 24 23   Data
            .hex 24 24 24 2e   ; $ed9b: 24 24 24 2e   Data
            .hex 31 33 24 2d   ; $ed9f: 31 33 24 2d   Data
            .hex 24 24 24 2e   ; $eda3: 24 24 24 2e   Data
            .hex 31 33 24 23   ; $eda7: 31 33 24 23   Data
            .hex 24 24 24 2e   ; $edab: 24 24 24 2e   Data
            .hex 31 33 24 2d   ; $edaf: 31 33 24 2d   Data
            .hex 24 24 24 2e   ; $edb3: 24 24 24 2e   Data
            .hex 31 33 24 2f   ; $edb7: 31 33 24 2f   Data
            .hex 60 67 24 24   ; $edbb: 60 67 24 24   Data
            .hex 6b 24 24 24   ; $edbf: 6b 24 24 24   Data
            .hex 24 24 24 24   ; $edc3: 24 24 24 24   Data
            .hex 24 24 24 24   ; $edc7: 24 24 24 24   Data
            .hex 60 62 63 60   ; $edcb: 60 62 63 60   Data
            .hex 61 63 60 60   ; $edcf: 61 63 60 60   Data
            .hex 63 61 61 63   ; $edd3: 63 61 61 63   Data
            .hex 63 63 63 63   ; $edd7: 63 63 63 63   Data
            .hex 60 62 63 60   ; $eddb: 60 62 63 60   Data
            .hex 61 63 60 60   ; $eddf: 61 63 60 60   Data
            .hex 63 61 61 63   ; $ede3: 63 61 61 63   Data
            .hex 63 63 63 63   ; $ede7: 63 63 63 63   Data
            .hex 24 24 24 24   ; $edeb: 24 24 24 24   Data
            .hex 24 24 24 24   ; $edef: 24 24 24 24   Data
            .hex 24 24 24 24   ; $edf3: 24 24 24 24   Data
            .hex b9 bb b9 bb   ; $edf7: b9 bb b9 bb   Data
            .hex 24 24 24 24   ; $edfb: 24 24 24 24   Data
            .hex 24 24 24 24   ; $edff: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ee03: 24 24 24 24   Data
            .hex b9 bb 24 24   ; $ee07: b9 bb 24 24   Data
            .hex 24 24 24 24   ; $ee0b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ee0f: 24 24 24 24   Data
            .hex b4 b6 24 24   ; $ee13: b4 b6 24 24   Data
            .hex b5 b7 24 24   ; $ee17: b5 b7 24 24   Data
            .hex 24 24 24 24   ; $ee1b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ee1f: 24 24 24 24   Data
            .hex b4 b6 b4 b6   ; $ee23: b4 b6 b4 b6   Data
            .hex b5 b7 b5 b7   ; $ee27: b5 b7 b5 b7   Data
            .hex b0 b2 b0 b2   ; $ee2b: b0 b2 b0 b2   Data
            .hex b1 b3 b1 b3   ; $ee2f: b1 b3 b1 b3   Data
            .hex 74 af b0 b2   ; $ee33: 74 af b0 b2   Data
            .hex b8 b8 b1 b3   ; $ee37: b8 b8 b1 b3   Data
            .hex b0 b2 af af   ; $ee3b: b0 b2 af af   Data
            .hex b1 b3 b8 ba   ; $ee3f: b1 b3 b8 ba   Data
            .hex 74 af b0 b2   ; $ee43: 74 af b0 b2   Data
            .hex af af b1 b3   ; $ee47: af af b1 b3   Data
            .hex 24 2e 24 3b   ; $ee4b: 24 2e 24 3b   Data
            .hex 31 2b 24 3b   ; $ee4f: 31 2b 24 3b   Data
            .hex 24 20 24 3b   ; $ee53: 24 20 24 3b   Data
            .hex 24 2f 24 3b   ; $ee57: 24 2f 24 3b   Data
            .hex 24 24 24 24   ; $ee5b: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ee5f: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ee63: 24 24 24 24   Data
            .hex 24 24 24 24   ; $ee67: 24 24 24 24   Data

;-------------------------------------------------------------------------------
__ee6b:     lda $89            ; $ee6b: a5 89     
            bne __ee7c         ; $ee6d: d0 0d     
            lda $0213          ; $ee6f: ad 13 02  
            clc                ; $ee72: 18        
            adc vIsCreatureDead          ; $ee73: 6d 10 02  
            adc $0215          ; $ee76: 6d 15 02  
            bne __ee7f         ; $ee79: d0 04     
            rts                ; $ee7b: 60        

;-------------------------------------------------------------------------------
__ee7c:     jmp __eee1         ; $ee7c: 4c e1 ee  

;-------------------------------------------------------------------------------
__ee7f:     lda $0214          ; $ee7f: ad 14 02  
            bne __eebc         ; $ee82: d0 38     
            lda $0211          ; $ee84: ad 11 02  
            bne __eec9         ; $ee87: d0 40     
            lda vInvulnTimer            ; $ee89: a5 bf     
            bne __eebb         ; $ee8b: d0 2e     
__ee8d:     lda $02e4          ; $ee8d: ad e4 02  
            and #$7f           ; $ee90: 29 7f     
            inc $02e4          ; $ee92: ee e4 02  
            beq __ee98         ; $ee95: f0 01     
            rts                ; $ee97: 60        

;-------------------------------------------------------------------------------
__ee98:     lda vCycleCounter            ; $ee98: a5 09     
            and #$80           ; $ee9a: 29 80     
            sta $89            ; $ee9c: 85 89     
            inc $89            ; $ee9e: e6 89     
            jsr __levelModulo4         ; $eea0: 20 5e c3  
            lda __ef5b,x       ; $eea3: bd 5b ef  
            sta vWhaleCaterpillarX            ; $eea6: 85 7f     
            lda __ef5e,x       ; $eea8: bd 5e ef  
            sta vWhaleCaterpillarY            ; $eeab: 85 9f     
            lda vStageSelect10s          ; $eead: ad e1 02  
            clc                ; $eeb0: 18        
            adc vStageSelectOnes          ; $eeb1: 6d e2 02  
            bne __eedc         ; $eeb4: d0 26     
            lda #$57           ; $eeb6: a9 57     
__eeb8:     sta $0741          ; $eeb8: 8d 41 07  
__eebb:     rts                ; $eebb: 60        

;-------------------------------------------------------------------------------
__eebc:     lda $02e4          ; $eebc: ad e4 02  
            and #$7f           ; $eebf: 29 7f     
            bne __ee8d         ; $eec1: d0 ca     
            inc vStageSelect10s          ; $eec3: ee e1 02  
            jmp __eed6         ; $eec6: 4c d6 ee  

;-------------------------------------------------------------------------------
__eec9:     lda $02e4          ; $eec9: ad e4 02  
            and #$7f           ; $eecc: 29 7f     
            bne __ee8d         ; $eece: d0 bd     
            inc vStageSelectOnes          ; $eed0: ee e2 02  
            jsr __give1000Score         ; $eed3: 20 1a ff  
__eed6:     jsr __give1000Score         ; $eed6: 20 1a ff  
            jmp __ee8d         ; $eed9: 4c 8d ee  

;-------------------------------------------------------------------------------
__eedc:     lda #$16           ; $eedc: a9 16     
            jmp __eeb8         ; $eede: 4c b8 ee  

;-------------------------------------------------------------------------------
__eee1:     lda vInvulnTimer            ; $eee1: a5 bf     
            bne __ef09         ; $eee3: d0 24     
            lda $89            ; $eee5: a5 89     
            and #$7f           ; $eee7: 29 7f     
            cmp #$01           ; $eee9: c9 01     
            beq __eef2         ; $eeeb: f0 05     
            cmp #$02           ; $eeed: c9 02     
            beq __eefe         ; $eeef: f0 0d     
            rts                ; $eef1: 60        

;-------------------------------------------------------------------------------
__eef2:     inc vWhaleCaterpillarY            ; $eef2: e6 9f     
            lda vWhaleCaterpillarY            ; $eef4: a5 9f     
            cmp #$c8           ; $eef6: c9 c8     
            bcs __eefb         ; $eef8: b0 01     
            rts                ; $eefa: 60        

;-------------------------------------------------------------------------------
__eefb:     inc $89            ; $eefb: e6 89     
            rts                ; $eefd: 60        

;-------------------------------------------------------------------------------
__eefe:     jsr __ef12         ; $eefe: 20 12 ef  
            lda $0740          ; $ef01: ad 40 07  
            cmp #$f0           ; $ef04: c9 f0     
            beq __ef09         ; $ef06: f0 01     
            rts                ; $ef08: 60        

;-------------------------------------------------------------------------------
__ef09:     lda #$00           ; $ef09: a9 00     
            sta $89            ; $ef0b: 85 89     
            lda #$f0           ; $ef0d: a9 f0     
            sta vWhaleCaterpillarY            ; $ef0f: 85 9f     
            rts                ; $ef11: 60        

;-------------------------------------------------------------------------------
__ef12:     lda vStageSelect10s          ; $ef12: ad e1 02  
            clc                ; $ef15: 18        
            adc vStageSelectOnes          ; $ef16: 6d e2 02  
            bne __ef3b         ; $ef19: d0 20     
            lda $89            ; $ef1b: a5 89     
            and #$80           ; $ef1d: 29 80     
            bne __ef31         ; $ef1f: d0 10     
            jsr __getCycleModulo4         ; $ef21: 20 5d d6  
            bne __ef28         ; $ef24: d0 02     
            inc vWhaleCaterpillarX            ; $ef26: e6 7f     
__ef28:     jsr __setXEvery8Cycle         ; $ef28: 20 8b d0  
            lda __ef61,x       ; $ef2b: bd 61 ef  
            jmp __eeb8         ; $ef2e: 4c b8 ee  

;-------------------------------------------------------------------------------
__ef31:     jsr __getCycleModulo4         ; $ef31: 20 5d d6  
            bne __ef28         ; $ef34: d0 f2     
            dec vWhaleCaterpillarX            ; $ef36: c6 7f     
            jmp __ef28         ; $ef38: 4c 28 ef  

;-------------------------------------------------------------------------------
__ef3b:     lda $89            ; $ef3b: a5 89     
            and #$80           ; $ef3d: 29 80     
            bne __ef51         ; $ef3f: d0 10     
            jsr __getCycleModulo4         ; $ef41: 20 5d d6  
            bne __ef48         ; $ef44: d0 02     
            inc vWhaleCaterpillarX            ; $ef46: e6 7f     
__ef48:     jsr __setXEvery8Cycle         ; $ef48: 20 8b d0  
            lda __ef65,x       ; $ef4b: bd 65 ef  
            jmp __eeb8         ; $ef4e: 4c b8 ee  

;-------------------------------------------------------------------------------
__ef51:     jsr __getCycleModulo4         ; $ef51: 20 5d d6  
            bne __ef48         ; $ef54: d0 f2     
            dec vWhaleCaterpillarX            ; $ef56: c6 7f     
            jmp __ef48         ; $ef58: 4c 48 ef  

;-------------------------------------------------------------------------------
__ef5b:     .hex 30 50 10      ; $ef5b: 30 50 10      Data
__ef5e:     .hex 30 30 30      ; $ef5e: 30 30 30      Data
__ef61:     .hex 59 5a 59 5a   ; $ef61: 59 5a 59 5a   Data
__ef65:     .hex 17 18 17 18   ; $ef65: 17 18 17 18   Data

;-------------------------------------------------------------------------------
__ef69:     lda vInvulnTimer            ; $ef69: a5 bf     
				beq __efad         ; $ef6b: f0 40     
            cmp #$01           ; $ef6d: c9 01     
				bne __ef7c         ; $ef6f: d0 0b     
            lda vDemoSequenceActive          ; $ef71: ad 73 02  
				bne __ef7a         ; $ef74: d0 04     
            lda #$10           ; $ef76: a9 10     
            sta vMusicPlayerState            ; $ef78: 85 20     
__ef7a:     inc vInvulnTimer            ; $ef7a: e6 bf     
__ef7c:     lda vStageSelect10s          ; $ef7c: ad e1 02  
            bne __efae         ; $ef7f: d0 2d     
            lda vStageSelectOnes          ; $ef81: ad e2 02  
            bne __efb7         ; $ef84: d0 31     
__ef86:     .hex ad a6 00      ; $ef86: ad a6 00  Bad Addr Mode - LDA $00a6
            bne __efa4         ; $ef89: d0 19     
            lda vCycleCounter            ; $ef8b: a5 09     
            and #$08           ; $ef8d: 29 08     
            beq __efad         ; $ef8f: f0 1c     
            bne __ef93         ; $ef91: d0 00     
__ef93:     jsr __efa4         ; $ef93: 20 a4 ef  
            jsr __isOddCycle         ; $ef96: 20 58 d6  
            bne __efad         ; $ef99: d0 12     
            inc vInvulnTimer            ; $ef9b: e6 bf     
            lda vInvulnTimer            ; $ef9d: a5 bf     
            cmp #$fa           ; $ef9f: c9 fa     
            beq __efc5         ; $efa1: f0 22     
            rts                ; $efa3: 60        

;-------------------------------------------------------------------------------
__efa4:     lda $0701          ; $efa4: ad 01 07  
            clc                ; $efa7: 18        
            adc #$5c           ; $efa8: 69 5c     
            sta $0701          ; $efaa: 8d 01 07  
__efad:     rts                ; $efad: 60        

;-------------------------------------------------------------------------------
__efae:     jsr __cf54         ; $efae: 20 54 cf  
            jsr __cff5         ; $efb1: 20 f5 cf  
            jmp __ef86         ; $efb4: 4c 86 ef  

;-------------------------------------------------------------------------------
__efb7:     jsr __isOddCycle         ; $efb7: 20 58 d6  
            bne __ef86         ; $efba: d0 ca     
            jsr __cf54         ; $efbc: 20 54 cf  
            jsr __cff5         ; $efbf: 20 f5 cf  
            jmp __ef86         ; $efc2: 4c 86 ef  

;-------------------------------------------------------------------------------
__efc5:     lda #$00           ; $efc5: a9 00     
            sta vInvulnTimer            ; $efc7: 85 bf     
            sta $59            ; $efc9: 85 59     
            sta $66            ; $efcb: 85 66     
            sta $6e            ; $efcd: 85 6e     
            sta $86            ; $efcf: 85 86     
            sta $87            ; $efd1: 85 87     
            sta $88            ; $efd3: 85 88     
            sta $8a            ; $efd5: 85 8a     
            sta $ae            ; $efd7: 85 ae     
            sta $a8            ; $efd9: 85 a8     
            sta $a7            ; $efdb: 85 a7     
            jsr __eff8         ; $efdd: 20 f8 ef  
            sta $bc            ; $efe0: 85 bc     
            sta $be            ; $efe2: 85 be     
            sta $c0            ; $efe4: 85 c0     
            sta $c5            ; $efe6: 85 c5     
            sta $be            ; $efe8: 85 be     
            jsr __c7a5         ; $efea: 20 a5 c7  
            sta vStageSelect10s          ; $efed: 8d e1 02  
            sta vStageSelectOnes          ; $eff0: 8d e2 02  
            sta vMusicPlayerState            ; $eff3: 85 20     
            inc vKiteRiseAfterDeath            ; $eff5: e6 67     
            rts                ; $eff7: 60        

;-------------------------------------------------------------------------------
__eff8:     sta $b0            ; $eff8: 85 b0     
            sta $b1            ; $effa: 85 b1     
            sta $b2            ; $effc: 85 b2     
            sta $b8            ; $effe: 85 b8     
            sta $b9            ; $f000: 85 b9     
            sta $bb            ; $f002: 85 bb     
            rts                ; $f004: 60        

;-------------------------------------------------------------------------------
__f005:     lda vCurrentLevel            ; $f005: a5 55     
            and #$0f           ; $f007: 29 0f     
            cmp #$06           ; $f009: c9 06     
				bcc __return3         ; $f00b: 90 40
				
            lda $c5            ; $f00d: a5 c5     
            bne __f04e         ; $f00f: d0 3d     
            lda $8a            ; $f011: a5 8a     
            bne __f04e         ; $f013: d0 39     
            lda $0213          ; $f015: ad 13 02  
            bne __f04e         ; $f018: d0 34     
            jsr __f0ac         ; $f01a: 20 ac f0  
            jsr __f074         ; $f01d: 20 74 f0  
            jsr __f051         ; $f020: 20 51 f0  
            lda vHawkState            ; $f023: a5 c6     
            and #$c0           ; $f025: 29 c0     
            bne __return3         ; $f027: d0 24     
            lda vBirdSpritePosY          ; $f029: ad 00 07  
            cmp vHawkY            ; $f02c: c5 a0     
            bcc __return3         ; $f02e: 90 1d     
            lda vRandomVar2            ; $f030: a5 17     
            cmp #$05           ; $f032: c9 05     
            bne __return3         ; $f034: d0 17     
            lda #$00           ; $f036: a9 00     
            sta vHawkState            ; $f038: 85 c6     
            lda $80            ; $f03a: a5 80     
            sta vBirdX            ; $f03c: 85 5b     
            jsr __d5fc         ; $f03e: 20 fc d5  
            cmp #$01           ; $f041: c9 01     
            beq __f047         ; $f043: f0 02     
            inc vHawkState            ; $f045: e6 c6     
__f047:     lda vHawkState            ; $f047: a5 c6     
            ora #$04           ; $f049: 09 04     
            sta vHawkState            ; $f04b: 85 c6     
__return3:     
			rts                ; $f04d: 60        

;-------------------------------------------------------------------------------
__f04e:     jmp __f0cf         ; $f04e: 4c cf f0  

;-------------------------------------------------------------------------------
__f051:     lda vHawkState            ; $f051: a5 c6     
            and #$0c           ; $f053: 29 0c     
            bne __f068         ; $f055: d0 11     
            lda vHawkState            ; $f057: a5 c6     
            and #$01           ; $f059: 29 01     
            bne __f069         ; $f05b: d0 0c     
            dec $80            ; $f05d: c6 80     
            jsr __setXEvery4Cycle         ; $f05f: 20 93 d0  
            lda __f105,x       ; $f062: bd 05 f1  
__f065:     sta $0745          ; $f065: 8d 45 07  
__f068:     rts                ; $f068: 60        

;-------------------------------------------------------------------------------
__f069:     inc $80            ; $f069: e6 80     
            jsr __setXEvery4Cycle         ; $f06b: 20 93 d0  
            lda __f109,x       ; $f06e: bd 09 f1  
            jmp __f065         ; $f071: 4c 65 f0  

;-------------------------------------------------------------------------------
__f074:     lda vHawkY            ; $f074: a5 a0     
            cmp #$20           ; $f076: c9 20     
            beq __f0a5         ; $f078: f0 2b     
            lda vHawkState            ; $f07a: a5 c6     
            and #$08           ; $f07c: 29 08     
            bne __f082         ; $f07e: d0 02     
            beq __f068         ; $f080: f0 e6     
__f082:     jsr __isOddCycle         ; $f082: 20 58 d6  
            beq __f089         ; $f085: f0 02     
            dec vHawkY            ; $f087: c6 a0     
__f089:     lda vHawkState            ; $f089: a5 c6     
            and #$01           ; $f08b: 29 01     
            bne __f09a         ; $f08d: d0 0b     
            dec $80            ; $f08f: c6 80     
            jsr __setXEvery8Cycle         ; $f091: 20 8b d0  
            lda __f105,x       ; $f094: bd 05 f1  
            jmp __f065         ; $f097: 4c 65 f0  

;-------------------------------------------------------------------------------
__f09a:     inc $80            ; $f09a: e6 80     
            jsr __setXEvery8Cycle         ; $f09c: 20 8b d0  
            lda __f109,x       ; $f09f: bd 09 f1  
            jmp __f065         ; $f0a2: 4c 65 f0  

;-------------------------------------------------------------------------------
__f0a5:     lda vHawkState            ; $f0a5: a5 c6     
            and #$01           ; $f0a7: 29 01     
            sta vHawkState            ; $f0a9: 85 c6     
            rts                ; $f0ab: 60        

;-------------------------------------------------------------------------------
__f0ac:     lda $8a            ; $f0ac: a5 8a     
            bne __f0bc         ; $f0ae: d0 0c     
            lda vHawkY            ; $f0b0: a5 a0     
            cmp #$b0           ; $f0b2: c9 b0     
            bcs __f0c6         ; $f0b4: b0 10     
            lda vHawkState            ; $f0b6: a5 c6     
            and #$04           ; $f0b8: 29 04     
            bne __f0bd         ; $f0ba: d0 01     
__f0bc:     rts                ; $f0bc: 60        

;-------------------------------------------------------------------------------
__f0bd:     inc vHawkY            ; $f0bd: e6 a0     
            inc vHawkY            ; $f0bf: e6 a0     
            lda #$96           ; $f0c1: a9 96     
            jmp __f065         ; $f0c3: 4c 65 f0  

;-------------------------------------------------------------------------------
__f0c6:     lda vHawkState            ; $f0c6: a5 c6     
            ora #$08           ; $f0c8: 09 08     
            and #$09           ; $f0ca: 29 09     
            sta vHawkState            ; $f0cc: 85 c6     
            rts                ; $f0ce: 60        

;-------------------------------------------------------------------------------
__f0cf:     jsr __f0f9         ; $f0cf: 20 f9 f0  
            lda vHawkY            ; $f0d2: a5 a0     
            cmp #$c8           ; $f0d4: c9 c8     
            bcc __f0bd         ; $f0d6: 90 e5     
            lda #$9b           ; $f0d8: a9 9b     
            sta $0745          ; $f0da: 8d 45 07  
            inc $c5            ; $f0dd: e6 c5     
            lda $c5            ; $f0df: a5 c5     
            cmp #$ff           ; $f0e1: c9 ff     
            bne __f0bc         ; $f0e3: d0 d7     
            lda #$00           ; $f0e5: a9 00     
            sta $c0            ; $f0e7: 85 c0     
            sta $8a            ; $f0e9: 85 8a     
            sta $c5            ; $f0eb: 85 c5     
            sta $0213          ; $f0ed: 8d 13 02  
            lda vHawkState            ; $f0f0: a5 c6     
            ora #$08           ; $f0f2: 09 08     
            and #$09           ; $f0f4: 29 09     
            sta vHawkState            ; $f0f6: 85 c6     
__f0f8:     rts                ; $f0f8: 60        

;-------------------------------------------------------------------------------
__f0f9:     lda $c5            ; $f0f9: a5 c5     
            bne __f0f8         ; $f0fb: d0 fb     
            inc $c5            ; $f0fd: e6 c5     
            jsr __c545         ; $f0ff: 20 45 c5  
            jmp __d64f         ; $f102: 4c 4f d6  

;-------------------------------------------------------------------------------
__f105:     .hex 92 94 92 94   ; $f105: 92 94 92 94   Data
__f109:     .hex 93 95 93 95   ; $f109: 93 95 93 95   Data

;-------------------------------------------------------------------------------
__f10d:     jsr __levelModulo4         ; $f10d: 20 5e c3  
            cpx #$03           ; $f110: e0 03     
            beq __f146         ; $f112: f0 32     
            jsr __f11a         ; $f114: 20 1a f1  
            jmp __f15a         ; $f117: 4c 5a f1  

;-------------------------------------------------------------------------------
__f11a:     .hex ad a6 00      ; $f11a: ad a6 00  Bad Addr Mode - LDA $00a6
            bne __f146         ; $f11d: d0 27     
            lda $0296          ; $f11f: ad 96 02  
            bne __f147         ; $f122: d0 23     
            lda vIsCreatureDead          ; $f124: ad 10 02  
            clc                ; $f127: 18        
            adc $0211          ; $f128: 6d 11 02  
            adc $0212          ; $f12b: 6d 12 02  
            beq __f146         ; $f12e: f0 16     
            jsr __getCycleModulo4         ; $f130: 20 5d d6  
            tax                ; $f133: aa        
            lda #$c8           ; $f134: a9 c8     
            sta $a1            ; $f136: 85 a1     
            lda __d70e,x       ; $f138: bd 0e d7  
            sta $81            ; $f13b: 85 81     
            lda __f156,x       ; $f13d: bd 56 f1  
            sta $0749          ; $f140: 8d 49 07  
            inc $0296          ; $f143: ee 96 02  
__f146:     rts                ; $f146: 60        

;-------------------------------------------------------------------------------
__f147:     jsr __isOddCycle         ; $f147: 20 58 d6  
            bne __f146         ; $f14a: d0 fa     
            inc $0296          ; $f14c: ee 96 02  
            lda $0296          ; $f14f: ad 96 02  
            beq __f174         ; $f152: f0 20     
            bne __f146         ; $f154: d0 f0     
__f156:     .hex 97 98 99 9a   ; $f156: 97 98 99 9a   Data

;-------------------------------------------------------------------------------
__f15a:     lda $c1            ; $f15a: a5 c1     
            beq __f190         ; $f15c: f0 32     
            lda $0749          ; $f15e: ad 49 07  
            cmp #$98           ; $f161: c9 98     
            beq __f197         ; $f163: f0 32     
            cmp #$99           ; $f165: c9 99     
            beq __f194         ; $f167: f0 2b     
            cmp #$9a           ; $f169: c9 9a     
            beq __f191         ; $f16b: f0 24     
__f16d:     jsr __give100Score         ; $f16d: 20 15 ff  
            lda #$06           ; $f170: a9 06     
            sta vSoundPlayerState            ; $f172: 85 2a     
__f174:     lda #$f0           ; $f174: a9 f0     
            sta $a1            ; $f176: 85 a1     
            lda #$00           ; $f178: a9 00     
            sta $c1            ; $f17a: 85 c1     
            sta $0296          ; $f17c: 8d 96 02  
            sta vIsCreatureDead          ; $f17f: 8d 10 02  
            sta $0211          ; $f182: 8d 11 02  
            sta $0212          ; $f185: 8d 12 02  
            sta $025b          ; $f188: 8d 5b 02  
            sta $025c          ; $f18b: 8d 5c 02  
            inc vKiteRiseAfterDeath            ; $f18e: e6 67     
__f190:     rts                ; $f190: 60        

;-------------------------------------------------------------------------------
__f191:     jsr __give100Score         ; $f191: 20 15 ff  
__f194:     jsr __give100Score         ; $f194: 20 15 ff  
__f197:     jsr __give100Score         ; $f197: 20 15 ff  
            jmp __f16d         ; $f19a: 4c 6d f1  

;-------------------------------------------------------------------------------
__f19d:     jsr __levelModulo4         ; $f19d: 20 5e c3  
            cpx #$03           ; $f1a0: e0 03     
            bne __f1a5         ; $f1a2: d0 01     
            rts                ; $f1a4: 60        

;-------------------------------------------------------------------------------
__f1a5:     jsr __f1b1         ; $f1a5: 20 b1 f1  
            jsr __f1db         ; $f1a8: 20 db f1  
            jsr __f21e         ; $f1ab: 20 1e f2  
            jmp __f22f         ; $f1ae: 4c 2f f2  

;-------------------------------------------------------------------------------
__f1b1:     lda vTimeFreezeTimer            ; $f1b1: a5 a6     
            bne __f1d2         ; $f1b3: d0 1d     
            lda $b7            ; $f1b5: a5 b7     
            beq __f1d2         ; $f1b7: f0 19     
            lda $a5            ; $f1b9: a5 a5     
            bne __f1d2         ; $f1bb: d0 15     
            lda vRandomVar            ; $f1bd: a5 08     
            and #$07           ; $f1bf: 29 07     
            tax                ; $f1c1: aa        
            lda __f1d3,x       ; $f1c2: bd d3 f1  
            sta $82            ; $f1c5: 85 82     
            lda #$c8           ; $f1c7: a9 c8     
            sta $a2            ; $f1c9: 85 a2     
            lda #$33           ; $f1cb: a9 33     
            sta $074d          ; $f1cd: 8d 4d 07  
            inc $a5            ; $f1d0: e6 a5     
__f1d2:     rts                ; $f1d2: 60        

;-------------------------------------------------------------------------------
__f1d3:     .hex 00 30 80 a0   ; $f1d3: 00 30 80 a0   Data
            .hex c0 d0 f0 60   ; $f1d7: c0 d0 f0 60   Data

;-------------------------------------------------------------------------------
__f1db:     lda $a5            ; $f1db: a5 a5     
            beq __f1d2         ; $f1dd: f0 f3     
            jsr __getCycleModulo4         ; $f1df: 20 5d d6  
            bne __f1d2         ; $f1e2: d0 ee     
            inc $a5            ; $f1e4: e6 a5     
            lda $a5            ; $f1e6: a5 a5     
            cmp #$f0           ; $f1e8: c9 f0     
            beq __f213         ; $f1ea: f0 27     
            lda $0295          ; $f1ec: ad 95 02  
            and #$01           ; $f1ef: 29 01     
            bne __f1ff         ; $f1f1: d0 0c     
            inc $82            ; $f1f3: e6 82     
            jsr __setXEvery8Cycle         ; $f1f5: 20 8b d0  
            lda __f20b,x       ; $f1f8: bd 0b f2  
            sta $074d          ; $f1fb: 8d 4d 07  
            rts                ; $f1fe: 60        

;-------------------------------------------------------------------------------
__f1ff:     dec $82            ; $f1ff: c6 82     
            jsr __setXEvery8Cycle         ; $f201: 20 8b d0  
            lda __f20f,x       ; $f204: bd 0f f2  
            sta $074d          ; $f207: 8d 4d 07  
            rts                ; $f20a: 60        

;-------------------------------------------------------------------------------
__f20b:     .hex 9d 9e 9d 9e   ; $f20b: 9d 9e 9d 9e   Data
__f20f:     .hex 33 9c 33 9c   ; $f20f: 33 9c 33 9c   Data

;-------------------------------------------------------------------------------
__f213:     lda #$f0           ; $f213: a9 f0     
            sta $a2            ; $f215: 85 a2     
            lda #$00           ; $f217: a9 00     
            sta $a5            ; $f219: 85 a5     
            sta $c2            ; $f21b: 85 c2     
            rts                ; $f21d: 60        

;-------------------------------------------------------------------------------
__f21e:     lda $a5            ; $f21e: a5 a5     
            beq __f1d2         ; $f220: f0 b0     
            lda $c2            ; $f222: a5 c2     
            beq __f1d2         ; $f224: f0 ac     
            inc vTimeFreezeTimer            ; $f226: e6 a6     
            lda #$12           ; $f228: a9 12     
            sta vMusicPlayerState            ; $f22a: 85 20     
            jmp __f213         ; $f22c: 4c 13 f2  

;-------------------------------------------------------------------------------
__f22f:     lda vTimeFreezeTimer            ; $f22f: a5 a6     
            beq __f26b         ; $f231: f0 38     
            lda vMusicPlayerState            ; $f233: a5 20     
            bne __f23b         ; $f235: d0 04     
            lda #$12           ; $f237: a9 12     
            sta vMusicPlayerState            ; $f239: 85 20     
__f23b:     jsr __getCycleModulo4         ; $f23b: 20 5d d6  
            bne __f26b         ; $f23e: d0 2b     
            inc vTimeFreezeTimer            ; $f240: e6 a6     
            lda vTimeFreezeTimer            ; $f242: a5 a6     
            cmp #$b0           ; $f244: c9 b0     
            beq __f24a         ; $f246: f0 02     
            bne __f25a         ; $f248: d0 10     
__f24a:     lda #$00           ; $f24a: a9 00     
            sta vTimeFreezeTimer            ; $f24c: 85 a6     
            sta $b7            ; $f24e: 85 b7     
            sta $eb            ; $f250: 85 eb     
            jsr __d6e9         ; $f252: 20 e9 d6  
            sta vMusicPlayerState            ; $f255: 85 20     
            jsr __f213         ; $f257: 20 13 f2  
__f25a:     lda #$00           ; $f25a: a9 00     
            jsr __eff8         ; $f25c: 20 f8 ef  
            sta $a7            ; $f25f: 85 a7     
            sta $a8            ; $f261: 85 a8     
            sta $a5            ; $f263: 85 a5     
            sta $ba            ; $f265: 85 ba     
            sta $bd            ; $f267: 85 bd     
            sta $c0            ; $f269: 85 c0     
__f26b:     rts                ; $f26b: 60        

;-------------------------------------------------------------------------------
__f26c:     lda vCurrentLevel            ; $f26c: a5 55     
            and #$03           ; $f26e: 29 03     
            cmp #$02           ; $f270: c9 02     
            beq __f2ab         ; $f272: f0 37     
            lda vCurrentLevel            ; $f274: a5 55     
            and #$0f           ; $f276: 29 0f     
            cmp #$03           ; $f278: c9 03     
            bcc __f2ab         ; $f27a: 90 2f     
            lda $0214          ; $f27c: ad 14 02  
            bne __f292         ; $f27f: d0 11     
            lda $88            ; $f281: a5 88     
            bne __f292         ; $f283: d0 0d     
            lda $59            ; $f285: a5 59     
            bne __f292         ; $f287: d0 09     
            jsr __f2ef         ; $f289: 20 ef f2  
            jsr __f2c1         ; $f28c: 20 c1 f2  
            jmp __f35c         ; $f28f: 4c 5c f3  

;-------------------------------------------------------------------------------
__f292:     lda vWoodpeckerSquirrelY            ; $f292: a5 9e     
            cmp #$c8           ; $f294: c9 c8     
            beq __f29e         ; $f296: f0 06     
            inc vWoodpeckerSquirrelY            ; $f298: e6 9e     
            lda $59            ; $f29a: a5 59     
            beq __f2ac         ; $f29c: f0 0e     
__f29e:     inc $59            ; $f29e: e6 59     
            lda $59            ; $f2a0: a5 59     
            cmp #$ff           ; $f2a2: c9 ff     
            beq __f2b5         ; $f2a4: f0 0f     
            lda #$2e           ; $f2a6: a9 2e     
__f2a8:     sta vWoodPeckerSprite          ; $f2a8: 8d 3d 07  
__f2ab:     rts                ; $f2ab: 60        

;-------------------------------------------------------------------------------
__f2ac:     jsr __d652         ; $f2ac: 20 52 d6  
            jsr __c545         ; $f2af: 20 45 c5  
            jmp __f29e         ; $f2b2: 4c 9e f2  

;-------------------------------------------------------------------------------
__f2b5:     lda #$00           ; $f2b5: a9 00     
            sta $be            ; $f2b7: 85 be     
            sta $88            ; $f2b9: 85 88     
            sta $0214          ; $f2bb: 8d 14 02  
            sta $59            ; $f2be: 85 59     
            rts                ; $f2c0: 60        

;-------------------------------------------------------------------------------
__f2c1:     lda vWoodpeckerState            ; $f2c1: a5 58     
            and #$02           ; $f2c3: 29 02     
            bne __f307         ; $f2c5: d0 40     
            lda vCycleCounter            ; $f2c7: a5 09     
            and #$40           ; $f2c9: 29 40     
            bne __f2e5         ; $f2cb: d0 18     
            lda vWoodpeckerState            ; $f2cd: a5 58     
            and #$01           ; $f2cf: 29 01     
            bne __f2dc         ; $f2d1: d0 09     
__f2d3:     jsr __setXEvery4Cycle         ; $f2d3: 20 93 d0  
__f2d6:     lda __f38b,x       ; $f2d6: bd 8b f3  
            jmp __f2a8         ; $f2d9: 4c a8 f2  

;-------------------------------------------------------------------------------
__f2dc:     jsr __setXEvery4Cycle         ; $f2dc: 20 93 d0  
__f2df:     lda __f38f,x       ; $f2df: bd 8f f3  
            jmp __f2a8         ; $f2e2: 4c a8 f2  

;-------------------------------------------------------------------------------
__f2e5:     ldx #$00           ; $f2e5: a2 00     
            lda vWoodpeckerState            ; $f2e7: a5 58     
            and #$01           ; $f2e9: 29 01     
            beq __f2d6         ; $f2eb: f0 e9     
            bne __f2df         ; $f2ed: d0 f0     
__f2ef:     lda vWoodpeckerSquirrelY            ; $f2ef: a5 9e     
            cmp #$a0           ; $f2f1: c9 a0     
            bcc __f300         ; $f2f3: 90 0b     
            beq __f300         ; $f2f5: f0 09     
            lda vCycleCounter            ; $f2f7: a5 09     
            and #$01           ; $f2f9: 29 01     
            bne __f2ff         ; $f2fb: d0 02     
            dec vWoodpeckerSquirrelY            ; $f2fd: c6 9e     
__f2ff:     rts                ; $f2ff: 60        

;-------------------------------------------------------------------------------
__f300:     lda vWoodpeckerState            ; $f300: a5 58     
            and #$03           ; $f302: 29 03     
            sta vWoodpeckerState            ; $f304: 85 58     
            rts                ; $f306: 60        

;-------------------------------------------------------------------------------
__f307:     jsr __f368         ; $f307: 20 68 f3  
            lda vWoodpeckerState            ; $f30a: a5 58     
            and #$01           ; $f30c: 29 01     
            bne __f336         ; $f30e: d0 26     
            inc vWoodpeckerSquirrelX            ; $f310: e6 7e     
            lda vCurrentLevel            ; $f312: a5 55     
            and #$03           ; $f314: 29 03     
            cmp #$01           ; $f316: c9 01     
            beq __f327         ; $f318: f0 0d     
            lda vWoodpeckerSquirrelX            ; $f31a: a5 7e     
            cmp #$31           ; $f31c: c9 31     
            bne __f32d         ; $f31e: d0 0d     
__f320:     lda #$01           ; $f320: a9 01     
            sta vWoodpeckerState            ; $f322: 85 58     
            jmp __f2dc         ; $f324: 4c dc f2  

;-------------------------------------------------------------------------------
__f327:     lda vWoodpeckerSquirrelX            ; $f327: a5 7e     
            cmp #$51           ; $f329: c9 51     
            beq __f320         ; $f32b: f0 f3     
__f32d:     jsr __setXEvery8Cycle         ; $f32d: 20 8b d0  
            lda __f397,x       ; $f330: bd 97 f3  
            jmp __f2a8         ; $f333: 4c a8 f2  

;-------------------------------------------------------------------------------
__f336:     dec vWoodpeckerSquirrelX            ; $f336: c6 7e     
            lda vCurrentLevel            ; $f338: a5 55     
            and #$03           ; $f33a: 29 03     
            cmp #$01           ; $f33c: c9 01     
            beq __f34d         ; $f33e: f0 0d     
            lda vWoodpeckerSquirrelX            ; $f340: a5 7e     
            cmp #$3d           ; $f342: c9 3d     
            bne __f353         ; $f344: d0 0d     
__f346:     lda #$00           ; $f346: a9 00     
            sta vWoodpeckerState            ; $f348: 85 58     
            jmp __f2d3         ; $f34a: 4c d3 f2  

;-------------------------------------------------------------------------------
__f34d:     lda vWoodpeckerSquirrelX            ; $f34d: a5 7e     
            cmp #$5d           ; $f34f: c9 5d     
            beq __f346         ; $f351: f0 f3     
__f353:     jsr __setXEvery8Cycle         ; $f353: 20 8b d0  
            lda __f393,x       ; $f356: bd 93 f3  
            jmp __f2a8         ; $f359: 4c a8 f2  

;-------------------------------------------------------------------------------
__f35c:     lda vRandomVar2            ; $f35c: a5 17     
            bne __f383         ; $f35e: d0 23     
            lda vCycleCounter            ; $f360: a5 09     
            cmp #$80           ; $f362: c9 80     
            bcc __setWoodpeckerFlyAway         ; $f364: 90 1e     
            bcs __f383         ; $f366: b0 1b     
__f368:     jsr __getCycleModulo4         ; $f368: 20 5d d6  
            bne __f383         ; $f36b: d0 16     
            lda vWoodpeckerSquirrelY            ; $f36d: a5 9e     
            cmp vBirdSpritePosY          ; $f36f: cd 00 07  
            bcc __f37b         ; $f372: 90 07     
            cmp #$48           ; $f374: c9 48     
            beq __f383         ; $f376: f0 0b     
            dec vWoodpeckerSquirrelY            ; $f378: c6 9e     
            rts                ; $f37a: 60        

;-------------------------------------------------------------------------------
__f37b:     lda vWoodpeckerSquirrelY            ; $f37b: a5 9e     
            cmp #$a0           ; $f37d: c9 a0     
            beq __f383         ; $f37f: f0 02     
            inc vWoodpeckerSquirrelY            ; $f381: e6 9e     
__f383:     rts                ; $f383: 60        

;-------------------------------------------------------------------------------
__setWoodpeckerFlyAway:     
			lda vWoodpeckerState            ; $f384: a5 58     
            ora #$02           ; $f386: 09 02     
            sta vWoodpeckerState            ; $f388: 85 58     
            rts                ; $f38a: 60        

;-------------------------------------------------------------------------------
__f38b:     .hex 26 28 26 28   ; $f38b: 26 28 26 28   Data
__f38f:     .hex 27 29 27 29   ; $f38f: 27 29 27 29   Data
__f393:     .hex 2a 2c 2a 2c   ; $f393: 2a 2c 2a 2c   Data
__f397:     .hex 2b 2d 2b 2d   ; $f397: 2b 2d 2b 2d   Data

;-------------------------------------------------------------------------------
__f39b:     lda vCurrentLevel            ; $f39b: a5 55     
            cmp #$10           ; $f39d: c9 10     
            bcc __f3dc         ; $f39f: 90 3b     
            lda vCurrentLevel            ; $f3a1: a5 55     
            and #$0f           ; $f3a3: 29 0f     
            cmp #$0b           ; $f3a5: c9 0b     
            bcc __f3dc         ; $f3a7: 90 33     
            lda $0294          ; $f3a9: ad 94 02  
            clc                ; $f3ac: 18        
            adc $0215          ; $f3ad: 6d 15 02  
            beq __f3b5         ; $f3b0: f0 03     
            jmp __f41d         ; $f3b2: 4c 1d f4  

;-------------------------------------------------------------------------------
__f3b5:     jsr __f3be         ; $f3b5: 20 be f3  
            jsr __f3dd         ; $f3b8: 20 dd f3  
            jmp __f411         ; $f3bb: 4c 11 f4  

;-------------------------------------------------------------------------------
__f3be:     lda $0292          ; $f3be: ad 92 02  
            and #$01           ; $f3c1: 29 01     
            bne __f3dc         ; $f3c3: d0 17     
            lda vCycleCounter            ; $f3c5: a5 09     
            lsr                ; $f3c7: 4a        
            and #$0f           ; $f3c8: 29 0f     
            tax                ; $f3ca: aa        
            lda __f457,x       ; $f3cb: bd 57 f4  
            ldx #$fe           ; $f3ce: a2 fe     
            jsr __d915         ; $f3d0: 20 15 d9  
__f3d3:     jsr __setXEvery4Cycle         ; $f3d3: 20 93 d0  
            lda __f453,x       ; $f3d6: bd 53 f4  
__f3d9:     sta $0709          ; $f3d9: 8d 09 07  
__f3dc:     rts                ; $f3dc: 60        

;-------------------------------------------------------------------------------
__f3dd:     lda $0292          ; $f3dd: ad 92 02  
            and #$01           ; $f3e0: 29 01     
            beq __f3dc         ; $f3e2: f0 f8     
            inc $0293          ; $f3e4: ee 93 02  
            lda $0293          ; $f3e7: ad 93 02  
            and #$07           ; $f3ea: 29 07     
            beq __f419         ; $f3ec: f0 2b     
            lda vBirdSpritePosY          ; $f3ee: ad 00 07  
            cmp $91            ; $f3f1: c5 91     
            bcc __f407         ; $f3f3: 90 12     
            inc $91            ; $f3f5: e6 91     
__f3f7:     lda $71            ; $f3f7: a5 71     
            sta vBirdX            ; $f3f9: 85 5b     
            jsr __d5fc         ; $f3fb: 20 fc d5  
            cmp #$01           ; $f3fe: c9 01     
            beq __f40c         ; $f400: f0 0a     
            inc $71            ; $f402: e6 71     
            jmp __f3d3         ; $f404: 4c d3 f3  

;-------------------------------------------------------------------------------
__f407:     dec $91            ; $f407: c6 91     
            jmp __f3f7         ; $f409: 4c f7 f3  

;-------------------------------------------------------------------------------
__f40c:     dec $71            ; $f40c: c6 71     
            jmp __f3d3         ; $f40e: 4c d3 f3  

;-------------------------------------------------------------------------------
__f411:     lda vCycleCounter            ; $f411: a5 09     
            and #$3f           ; $f413: 29 3f     
            beq __f419         ; $f415: f0 02     
            bne __f41c         ; $f417: d0 03     
__f419:     inc $0292          ; $f419: ee 92 02  
__f41c:     rts                ; $f41c: 60        

;-------------------------------------------------------------------------------
__f41d:     lda $0295          ; $f41d: ad 95 02  
            beq __f42f         ; $f420: f0 0d     
            lda $91            ; $f422: a5 91     
            cmp #$c8           ; $f424: c9 c8     
            beq __f439         ; $f426: f0 11     
            inc $91            ; $f428: e6 91     
            lda #$32           ; $f42a: a9 32     
            jmp __f3d9         ; $f42c: 4c d9 f3  

;-------------------------------------------------------------------------------
__f42f:     jsr __d652         ; $f42f: 20 52 d6  
            jsr __c545         ; $f432: 20 45 c5  
            inc $0295          ; $f435: ee 95 02  
__f438:     rts                ; $f438: 60        

;-------------------------------------------------------------------------------
__f439:     inc $0295          ; $f439: ee 95 02  
            lda $0295          ; $f43c: ad 95 02  
            cmp #$ff           ; $f43f: c9 ff     
            beq __f445         ; $f441: f0 02     
            bne __f438         ; $f443: d0 f3     
__f445:     lda #$00           ; $f445: a9 00     
            sta $0294          ; $f447: 8d 94 02  
            sta $0295          ; $f44a: 8d 95 02  
            sta $0215          ; $f44d: 8d 15 02  
            sta $b1            ; $f450: 85 b1     
            rts                ; $f452: 60        

;-------------------------------------------------------------------------------
__f453:     .hex 30 31 30 31   ; $f453: 30 31 30 31   Data
__f457:     .hex 02 02 0a 0a   ; $f457: 02 02 0a 0a   Data
            .hex 02 02 06 05   ; $f45b: 02 02 06 05   Data
            .hex 01 01 09 09   ; $f45f: 01 01 09 09   Data
            .hex 01 01 05 06   ; $f463: 01 01 05 06   Data

;-------------------------------------------------------------------------------
__f467:    	lda vDemoSequenceActive          ; $f467: ad 73 02  
				bne __f49e         ; $f46a: d0 32     
			
            lda vNestlingIsDead            ; $f46c: a5 e9     
				bne __f4b2         ; $f46e: d0 42     
            lda vBirdLives            ; $f470: a5 56     
				bne __f49b         ; $f472: d0 27     
				
__drawGameOverLabel:     
			jsr __clearBirdNametable         ; $f474: 20 a2 c6  
            sta vNestlingIsDead            ; $f477: 85 e9     
            tax                ; $f479: aa        
            lda #$21           ; $f47a: a9 21     
            sta ppuAddress          ; $f47c: 8d 06 20  
            lda #$2c           ; $f47f: a9 2c     
            sta ppuAddress          ; $f481: 8d 06 20  
__drawGameOverLabelLoop:     
			lda __gameOverLabel,x       ; $f484: bd a9 f4  
            sta ppuData          ; $f487: 8d 07 20  
            inx                ; $f48a: e8        
            cpx #$09           ; $f48b: e0 09     
            bne __drawGameOverLabelLoop         ; $f48d: d0 f5     
			
            jsr __showNestlingCountLabel         ; $f48f: 20 df c1  
            jsr __f618         ; $f492: 20 18 f6  
            jsr __f5e8         ; $f495: 20 e8 f5  
            jmp __f546         ; $f498: 4c 46 f5  

;-------------------------------------------------------------------------------
__f49b:     jmp __f4f9         ; $f49b: 4c f9 f4  

;-------------------------------------------------------------------------------
__f49e:     jsr __f5bb         ; $f49e: 20 bb f5  
            jsr __f549         ; $f4a1: 20 49 f5  
            lda #$00           ; $f4a4: a9 00     
            sta vGameState            ; $f4a6: 85 50     
            rts                ; $f4a8: 60        

;-------------------------------------------------------------------------------
__gameOverLabel:     
			.hex 10 0a 16 0e   ; $f4a9: 10 0a 16 0e   Data
            .hex 24 18 1a 0e   ; $f4ad: 24 18 1a 0e   Data
            .hex 1b            ; $f4b1: 1b            Data

;-------------------------------------------------------------------------------
__f4b2:     jsr __setXEvery8Cycle         ; $f4b2: 20 8b d0  
            lda __f542,x       ; $f4b5: bd 42 f5  
            sta $0739          ; $f4b8: 8d 39 07  
            jsr __isOddCycle         ; $f4bb: 20 58 d6  
            bne __f4c2         ; $f4be: d0 02     
            dec $9d            ; $f4c0: c6 9d     
__f4c2:     lda $9d            ; $f4c2: a5 9d     
            cmp #$1a           ; $f4c4: c9 1a     
            beq __f4d9         ; $f4c6: f0 11     
            jsr __c29f         ; $f4c8: 20 9f c2  
            jsr __d48a         ; $f4cb: 20 8a d4  
            lda vMusicPlayerState            ; $f4ce: a5 20     
            bne __f4d6         ; $f4d0: d0 04     
            lda #$0a           ; $f4d2: a9 0a     
            sta vMusicPlayerState            ; $f4d4: 85 20     
__f4d6:     jmp __c122         ; $f4d6: 4c 22 c1  

;-------------------------------------------------------------------------------
__f4d9:     lda #$f0           ; $f4d9: a9 f0     
            sta $9d            ; $f4db: 85 9d     
            lda vBirdLives            ; $f4dd: a5 56     
            cmp #$01           ; $f4df: c9 01     
            bne __f4e6         ; $f4e1: d0 03     
            jmp __drawGameOverLabel         ; $f4e3: 4c 74 f4  

;-------------------------------------------------------------------------------
__f4e6:     jsr __c29f         ; $f4e6: 20 9f c2  
            jsr __d48a         ; $f4e9: 20 8a d4  
            dec vBirdLives            ; $f4ec: c6 56     
            lda #$03           ; $f4ee: a9 03     
            sta vGameState            ; $f4f0: 85 50     
            lda #$00           ; $f4f2: a9 00     
            sta vNestlingIsDead            ; $f4f4: 85 e9     
            sta vMusicPlayerState            ; $f4f6: 85 20     
            rts                ; $f4f8: 60        

;-------------------------------------------------------------------------------
__f4f9:     jsr __f618         ; $f4f9: 20 18 f6  
            jsr __f5e8         ; $f4fc: 20 e8 f5  
            lda vCurrentLevel            ; $f4ff: a5 55     
            and #$03           ; $f501: 29 03     
            tay                ; $f503: a8        
            lda __c879,y       ; $f504: b9 79 c8  
            sta $9d            ; $f507: 85 9d     
            lda vNestling1Timer          ; $f509: ad 05 02  
            cmp #$ff           ; $f50c: c9 ff     
            bne __f516         ; $f50e: d0 06     
            lda __c87d,y       ; $f510: b9 7d c8  
            jmp __f526         ; $f513: 4c 26 f5  

;-------------------------------------------------------------------------------
__f516:     lda vNestling2Timer          ; $f516: ad 06 02  
            cmp #$ff           ; $f519: c9 ff     
            bne __f523         ; $f51b: d0 06     
            lda __c881,y       ; $f51d: b9 81 c8  
            jmp __f526         ; $f520: 4c 26 f5  

;-------------------------------------------------------------------------------
__f523:     lda __c885,y       ; $f523: b9 85 c8  
__f526:     sta $7d            ; $f526: 85 7d     
            jsr __d48a         ; $f528: 20 8a d4  
            lda vBirdLives            ; $f52b: a5 56     
            cmp #$01           ; $f52d: c9 01     
            beq __f539         ; $f52f: f0 08     
            lda #$00           ; $f531: a9 00     
            sta $008c,y        ; $f533: 99 8c 00  
            sta vNestling1Timer,y        ; $f536: 99 05 02  
__f539:     inc vNestlingIsDead            ; $f539: e6 e9     
            lda #$0a           ; $f53b: a9 0a     
            sta vMusicPlayerState            ; $f53d: 85 20     
            jmp __handleMusicAndSound         ; $f53f: 4c dd f6  

;-------------------------------------------------------------------------------
__f542:     .hex 74 75 74 75   ; $f542: 74 75 74 75   Data

;-------------------------------------------------------------------------------
__f546:     jsr __f570         ; $f546: 20 70 f5  
__f549:     lda #$00           ; $f549: a9 00     
            sta vNestlingOnes            ; $f54b: 85 10     
            sta vNestling10s            ; $f54d: 85 11     
            sta vNestling100s            ; $f54f: 85 12     
            sta vStageSelectState          ; $f551: 8d e0 02  
            sta vStageSelect10s          ; $f554: 8d e1 02  
            sta vStageSelectOnes          ; $f557: 8d e2 02  
            tax                ; $f55a: aa        
__f55b:     sta vDataAddress,x          ; $f55b: 95 53     
            sta vButterfly1Timer,x        ; $f55d: 9d 00 02  
            inx                ; $f560: e8        
            cpx #$ad           ; $f561: e0 ad     
            bne __f55b         ; $f563: d0 f6     
            inc vGameState            ; $f565: e6 50     
            jsr __hideSpritesInTable         ; $f567: 20 94 fe  
            jsr __ce94         ; $f56a: 20 94 ce  
            jmp __c122         ; $f56d: 4c 22 c1  

;-------------------------------------------------------------------------------
__f570:     lda vStageSelectState          ; $f570: ad e0 02  
            bne __f595         ; $f573: d0 20     
            ldx #$08           ; $f575: a2 08     
__f577:     lda $0110,x        ; $f577: bd 10 01  
            cmp vPlayerScore,x        ; $f57a: dd 00 01  
            bne __f584         ; $f57d: d0 05     
            dex                ; $f57f: ca        
            beq __f595         ; $f580: f0 13     
            bne __f577         ; $f582: d0 f3     
__f584:     lda $0110,x        ; $f584: bd 10 01  
            cmp vPlayerScore,x        ; $f587: dd 00 01  
            bcs __f595         ; $f58a: b0 09     
__f58c:     lda vPlayerScore,x        ; $f58c: bd 00 01  
            sta $0110,x        ; $f58f: 9d 10 01  
            dex                ; $f592: ca        
            bne __f58c         ; $f593: d0 f7     
__f595:     rts                ; $f595: 60        

;-------------------------------------------------------------------------------
__f596:     ldx #$00           ; $f596: a2 00     
            txa                ; $f598: 8a        
__f599:     sta vPlayerScore,x        ; $f599: 9d 00 01  
            inx                ; $f59c: e8        
            cpx #$08           ; $f59d: e0 08     
            bne __f599         ; $f59f: d0 f8     
            rts                ; $f5a1: 60        

;-------------------------------------------------------------------------------
__f5a2:     lda vDataAddress            ; $f5a2: a5 53     
            beq __f5b2         ; $f5a4: f0 0c     
            lda vPlayerInput            ; $f5a6: a5 0a     
            and #$0c           ; $f5a8: 29 0c     
            bne __f5bb         ; $f5aa: d0 0f     
            lda vMusicPlayerState            ; $f5ac: a5 20     
            bne __f5b8         ; $f5ae: d0 08     
            beq __f5bb         ; $f5b0: f0 09     
__f5b2:     lda #$0b           ; $f5b2: a9 0b     
            sta vMusicPlayerState            ; $f5b4: 85 20     
            inc vDataAddress            ; $f5b6: e6 53     
__f5b8:     jmp __c122         ; $f5b8: 4c 22 c1  

;-------------------------------------------------------------------------------
__f5bb:     jsr __disableDrawing         ; $f5bb: 20 ee fe  
            lda #$00           ; $f5be: a9 00     
            sta vGameState            ; $f5c0: 85 50     
            sta vMusicPlayerState            ; $f5c2: 85 20     
            tax                ; $f5c4: aa        
__f5c5:     lda __mainMenuPalette,x       ; $f5c5: bd 00 c0  
            sta vPaletteData,x          ; $f5c8: 95 30     
            inx                ; $f5ca: e8        
            cpx #$20           ; $f5cb: e0 20     
            bne __f5c5         ; $f5cd: d0 f6     
            jsr __uploadPalettesToPPU         ; $f5cf: 20 64 fe  
            lda #$20           ; $f5d2: a9 20     
            jsr __clearNametable         ; $f5d4: 20 f5 fd  
            jsr __scrollScreen         ; $f5d7: 20 b6 fd  
            jsr __hideSpritesInOAM         ; $f5da: 20 5a e2  
            jsr __showSprites         ; $f5dd: 20 e0 fd  
            lda #$f0           ; $f5e0: a9 f0     
            sta vNestlingCountSprite          ; $f5e2: 8d 60 07  
            jmp __c122         ; $f5e5: 4c 22 c1  

;-------------------------------------------------------------------------------
__f5e8:     lda vCurrentLevel            ; $f5e8: a5 55     
            and #$03           ; $f5ea: 29 03     
            cmp #$03           ; $f5ec: c9 03     
            beq __f610         ; $f5ee: f0 20     
            lda vPPUController            ; $f5f0: a5 06     
            and #$fc           ; $f5f2: 29 fc     
            sta ppuControl          ; $f5f4: 8d 00 20  
            stx ppuScroll          ; $f5f7: 8e 05 20  
            stx ppuScroll          ; $f5fa: 8e 05 20  
__f5fd:     nop                ; $f5fd: ea        
            dex                ; $f5fe: ca        
            bne __f5fd         ; $f5ff: d0 fc     
__f601:     lda ppuStatus          ; $f601: ad 02 20  
            and #$40           ; $f604: 29 40     
            beq __f601         ; $f606: f0 f9     
__f608:     dex                ; $f608: ca        
            cpx #$91           ; $f609: e0 91     
            bne __f608         ; $f60b: d0 fb     
            jmp __scrollScreen         ; $f60d: 4c b6 fd  

;-------------------------------------------------------------------------------
__f610:     lda #$f0           ; $f610: a9 f0     
            sta vOAMTable          ; $f612: 8d 00 06  
            jmp __scrollScreen         ; $f615: 4c b6 fd  

;-------------------------------------------------------------------------------
__f618:     lda #$fc           ; $f618: a9 fc     
            sta $0601          ; $f61a: 8d 01 06  
            lda #$68           ; $f61d: a9 68     
            sta $0603          ; $f61f: 8d 03 06  
            lda #$17           ; $f622: a9 17     
            sta vOAMTable          ; $f624: 8d 00 06  
            lda #$20           ; $f627: a9 20     
            sta $0602          ; $f629: 8d 02 06  
            rts                ; $f62c: 60        

;-------------------------------------------------------------------------------
__f62d:     jsr __levelModulo4         ; $f62d: 20 5e c3  
            cpx #$03           ; $f630: e0 03     
            beq __f64e         ; $f632: f0 1a     
            lda vCurrentLevel            ; $f634: a5 55     
            cmp #$10           ; $f636: c9 10     
            bcc __f64e         ; $f638: 90 14     
            and #$03           ; $f63a: 29 03     
            tax                ; $f63c: aa        
            lda #$23           ; $f63d: a9 23     
            sta ppuAddress          ; $f63f: 8d 06 20  
            lda __c229,x       ; $f642: bd 29 c2  
            sta ppuAddress          ; $f645: 8d 06 20  
            lda __f64f,x       ; $f648: bd 4f f6  
            sta ppuData          ; $f64b: 8d 07 20  
__f64e:     rts                ; $f64e: 60        

;-------------------------------------------------------------------------------
__f64f:     .hex 8a a8 a8      ; $f64f: 8a a8 a8      Data
___initAPUshowGraphics:     
			lda #$1e           ; $f652: a9 1e     
            sta vPPUMask            ; $f654: 85 07     
            jmp __initSound         ; $f656: 4c 3a f8  

;-------------------------------------------------------------------------------
__handleSecretCreatures:     
			lda vCurrentLevel            ; $f659: a5 55     
            cmp #$0e           ; $f65b: c9 0e     
				beq __handleCaterpillar         ; $f65d: f0 38     
            cmp #$0b           ; $f65f: c9 0b     
				bne __return16         ; $f661: d0 1d     
            lda vBonusItemsCaught            ; $f663: a5 8b     
            cmp #$01           ; $f665: c9 01     
				bne __hideWhale         ; $f667: d0 29     
            lda vWhaleCounter          ; $f669: ad 52 02  
            cmp #$03           ; $f66c: c9 03     
				bcs __showAndMoveWhale         ; $f66e: b0 11     
				
            lda #$3c           ; $f670: a9 3c     
            sta vBirdOffsetX            ; $f672: 85 5c     
            jsr __d186         ; $f674: 20 86 d1  
            lda vBirdOffsetX            ; $f677: a5 5c     
            cmp #$98           ; $f679: c9 98     
				bne __return16         ; $f67b: d0 03     
            inc vWhaleCounter          ; $f67d: ee 52 02  
__return16:     
			rts                ; $f680: 60        

;-------------------------------------------------------------------------------
__showAndMoveWhale:     
			lda #$35           ; $f681: a9 35     
            sta $0741          ; $f683: 8d 41 07  
            lda #$c0           ; $f686: a9 c0     
            sta vWhaleCaterpillarY            ; $f688: 85 9f     
            jsr __getCycleModulo4         ; $f68a: 20 5d d6  
				bne __return16         ; $f68d: d0 f1     
            dec vWhaleCaterpillarX            ; $f68f: c6 7f     
            rts                ; $f691: 60        

;-------------------------------------------------------------------------------
__hideWhale:     
			lda #$f0           ; $f692: a9 f0     
            sta vWhaleCaterpillarY            ; $f694: 85 9f     
            rts                ; $f696: 60        

;-------------------------------------------------------------------------------
__handleCaterpillar:     
			lda $0253          ; $f697: ad 53 02  
				bne __return12         ; $f69a: d0 30     
            lda $0254          ; $f69c: ad 54 02  
				bne __f6ae         ; $f69f: d0 0d     
            lda $0211          ; $f6a1: ad 11 02  
				beq __return12         ; $f6a4: f0 26     
            lda $0212          ; $f6a6: ad 12 02  
				beq __return12         ; $f6a9: f0 21     
            inc $0254          ; $f6ab: ee 54 02  
__f6ae:     lda $0254          ; $f6ae: ad 54 02  
				beq __return12         ; $f6b1: f0 19     
            cmp #$02           ; $f6b3: c9 02     
				bcs __f6d3         ; $f6b5: b0 1c     
            lda vInvulnTimer            ; $f6b7: a5 bf     
				bne __f6cd         ; $f6b9: d0 12     
            lda #$40           ; $f6bb: a9 40     
            sta vWhaleCaterpillarY            ; $f6bd: 85 9f     
            lda #$8f           ; $f6bf: a9 8f     
            sta vWhaleCaterpillarX            ; $f6c1: 85 7f     
            jsr __setXEvery8Cycle         ; $f6c3: 20 8b d0  
            lda __f6d9,x       ; $f6c6: bd d9 f6  
            sta $0741          ; $f6c9: 8d 41 07  
__return12:     
			rts                ; $f6cc: 60        

;-------------------------------------------------------------------------------
__f6cd:     jsr __give1000Score         ; $f6cd: 20 1a ff  
            jsr __c545         ; $f6d0: 20 45 c5  
__f6d3:     inc $0253          ; $f6d3: ee 53 02  
            jmp __hideWhale         ; $f6d6: 4c 92 f6  

;-------------------------------------------------------------------------------
__f6d9:     .hex 36 37 36 37   ; $f6d9: 36 37 36 37   Data

;-------------------------------------------------------------------------------
__handleMusicAndSound:     
			jsr __handleMusicPlayer         ; $f6dd: 20 e3 f6  
            jmp __handleSoundPlayer         ; $f6e0: 4c 93 f7  

;-------------------------------------------------------------------------------
__handleMusicPlayer:     
			ldx vMusicPlayerState            ; $f6e3: a6 20     
				beq __return13         ; $f6e5: f0 33     
            cpx #$ff           ; $f6e7: e0 ff     
				beq __increaseMusicCounter         ; $f6e9: f0 27     
				
            dex                ; $f6eb: ca        
            lda __musicSpeed,x       ; $f6ec: bd 58 f8  
            sta vMusicSpeed            ; $f6ef: 85 23     
            cpx #$0f           ; $f6f1: e0 0f     
            beq __f70d         ; $f6f3: f0 18     
            lda #$08           ; $f6f5: a9 08     
__f6f7:     sta vPulseLengthCounterLoad            ; $f6f7: 85 24     
            txa                ; $f6f9: 8a        
            asl                ; $f6fa: 0a        
            tax                ; $f6fb: aa        
            lda __f86c,x       ; $f6fc: bd 6c f8  
            sta $21            ; $f6ff: 85 21     
            lda __f86d,x       ; $f701: bd 6d f8  
            sta $22            ; $f704: 85 22     
            ldx #$ff           ; $f706: a2 ff     
            stx vMusicPlayerState            ; $f708: 86 20     
            jmp __playMusic         ; $f70a: 4c 1b f7  

;-------------------------------------------------------------------------------
__f70d:     lda #$68           ; $f70d: a9 68     
            jmp __f6f7         ; $f70f: 4c f7 f6  

;-------------------------------------------------------------------------------
__increaseMusicCounter:     
			inc vMusicCounter            ; $f712: e6 25     
            lda vMusicCounter            ; $f714: a5 25     
            cmp vMusicSpeed            ; $f716: c5 23     
            beq __playMusic         ; $f718: f0 01     
__return13:     
			rts                ; $f71a: 60        

;-------------------------------------------------------------------------------
__playMusic:     
			ldy #$00           ; $f71b: a0 00     
            sty vMusicCounter            ; $f71d: 84 25     
            lda ($21),y        ; $f71f: b1 21     
            sta $26            ; $f721: 85 26     
            cmp #$ff           ; $f723: c9 ff     
				beq __setMusicPlayerState         ; $f725: f0 37     
            cmp #$f0           ; $f727: c9 f0     
				beq __f752         ; $f729: f0 27     
            cmp #$f1           ; $f72b: c9 f1     
				beq __f761         ; $f72d: f0 32     
            cmp #$f2           ; $f72f: c9 f2     
				beq __f773         ; $f731: f0 40     
            lsr                ; $f733: 4a        
            lsr                ; $f734: 4a        
            lsr                ; $f735: 4a        
            lsr                ; $f736: 4a        
            and #$0c           ; $f737: 29 0c     
            tax                ; $f739: aa        
            cpx #$04           ; $f73a: e0 04     
            bne __f73e         ; $f73c: d0 00     
__f73e:     lda $26            ; $f73e: a5 26     
            asl                ; $f740: 0a        
            and #$3e           ; $f741: 29 3e     
            tay                ; $f743: a8        
            lda __f7fb,y       ; $f744: b9 fb f7  
            sta apu1PulseTLow,x        ; $f747: 9d 02 40  
            lda __f7fa,y       ; $f74a: b9 fa f7  
            ora vPulseLengthCounterLoad            ; $f74d: 05 24     
            sta apu1PulseTHigh,x        ; $f74f: 9d 03 40  
__f752:     jsr __f78c         ; $f752: 20 8c f7  
            lda $26            ; $f755: a5 26     
            and #$20           ; $f757: 29 20     
				bne __return7         ; $f759: d0 05     
            jmp __playMusic         ; $f75b: 4c 1b f7  

;-------------------------------------------------------------------------------
__setMusicPlayerState:     
			sty vMusicPlayerState            ; $f75e: 84 20     
__return7:     
			rts                ; $f760: 60        

;-------------------------------------------------------------------------------
__f761:     jsr __f78c         ; $f761: 20 8c f7  
            lda $21            ; $f764: a5 21     
            sta $27            ; $f766: 85 27     
            lda $22            ; $f768: a5 22     
            sta $28            ; $f76a: 85 28     
            lda #$01           ; $f76c: a9 01     
            sta $29            ; $f76e: 85 29     
            jmp __playMusic         ; $f770: 4c 1b f7  

;-------------------------------------------------------------------------------
__f773:     lda $29            ; $f773: a5 29     
            cmp #$01           ; $f775: c9 01     
            beq __f77f         ; $f777: f0 06     
            jsr __f78c         ; $f779: 20 8c f7  
            jmp __playMusic         ; $f77c: 4c 1b f7  

;-------------------------------------------------------------------------------
__f77f:     sty $29            ; $f77f: 84 29     
            lda $27            ; $f781: a5 27     
            sta $21            ; $f783: 85 21     
            lda $28            ; $f785: a5 28     
            sta $22            ; $f787: 85 22     
            jmp __playMusic         ; $f789: 4c 1b f7  

;-------------------------------------------------------------------------------
__f78c:     inc $21            ; $f78c: e6 21     
            bne __f792         ; $f78e: d0 02     
            inc $22            ; $f790: e6 22     
__f792:     rts                ; $f792: 60        

;-------------------------------------------------------------------------------
__handleSoundPlayer:     
			ldx vSoundPlayerState            ; $f793: a6 2a  
				; no sound playing
				beq __return15         ; $f795: f0 2a     
            cpx #$ff           ; $f797: e0 ff     
				; sound playing
				beq __increaseSoundCounter         ; $f799: f0 1e   
				
            dex                ; $f79b: ca        
            lda __soundSpeed,x       ; $f79c: bd 64 fc  
            sta vSoundSpeed            ; $f79f: 85 2d     
            lda #$08           ; $f7a1: a9 08     
            sta vTriangleLengthCounterLoad            ; $f7a3: 85 2e     
			
            txa                ; $f7a5: 8a        
            asl                ; $f7a6: 0a        
            tax                ; $f7a7: aa        
            lda __soundAddr,x       ; $f7a8: bd 4e fc  
            sta vSoundAddr            ; $f7ab: 85 2b     
            lda __soundHiAddr,x       ; $f7ad: bd 4f fc  
            sta vSoundHiAddr            ; $f7b0: 85 2c     
			
			; now player is active
            ldx #$ff           ; $f7b2: a2 ff     
            stx vSoundPlayerState            ; $f7b4: 86 2a     
            jmp __playSound         ; $f7b6: 4c c2 f7  

;-------------------------------------------------------------------------------
__increaseSoundCounter:     
			inc vSoundCounter            ; $f7b9: e6 2f     
            lda vSoundCounter            ; $f7bb: a5 2f     
            cmp vSoundSpeed            ; $f7bd: c5 2d     
            beq __playSound         ; $f7bf: f0 01     
__return15:     
			rts                ; $f7c1: 60        

;-------------------------------------------------------------------------------
__playSound:     
			ldy #$00           ; $f7c2: a0 00     
            sty vSoundCounter            ; $f7c4: 84 2f     
            lda (vSoundAddr),y        ; $f7c6: b1 2b     
            sta $26            ; $f7c8: 85 26     
            cmp #$ff           ; $f7ca: c9 ff     
				beq __saveSoundState         ; $f7cc: f0 1d     
            cmp #$f0           ; $f7ce: c9 f0     
				beq __f7e5         ; $f7d0: f0 13     
				
            asl                ; $f7d2: 0a        
            and #$3e           ; $f7d3: 29 3e     
            tay                ; $f7d5: a8        
            lda __f7fb,y       ; $f7d6: b9 fb f7  
            lsr                ; $f7d9: 4a        
            sta apuTriangleTLow          ; $f7da: 8d 0a 40  
            lda __f7fa,y       ; $f7dd: b9 fa f7  
            ora vTriangleLengthCounterLoad            ; $f7e0: 05 2e     
            sta apuTriangleTHigh          ; $f7e2: 8d 0b 40  
__f7e5:     jsr __iterateSoundAddress         ; $f7e5: 20 f3 f7  
				jmp __return15         ; $f7e8: 4c c1 f7  

;-------------------------------------------------------------------------------
__saveSoundState:     
			sty vSoundPlayerState            ; $f7eb: 84 2a     
            lda #$7f           ; $f7ed: a9 7f     
            sta $4009          ; $f7ef: 8d 09 40  
            rts                ; $f7f2: 60        

;-------------------------------------------------------------------------------
__iterateSoundAddress:     
			inc vSoundAddr            ; $f7f3: e6 2b     
            bne __return14         ; $f7f5: d0 02     
            inc vSoundHiAddr            ; $f7f7: e6 2c     
__return14:     
			rts                ; $f7f9: 60        

;-------------------------------------------------------------------------------
__f7fa:     .hex 02            ; $f7fa: 02            Data
__f7fb:     .hex 1b 01 fc 01   ; $f7fb: 1b 01 fc 01   Data
            .hex e0 01 c5 01   ; $f7ff: e0 01 c5 01   Data
            .hex ac 01 94 01   ; $f803: ac 01 94 01   Data
            .hex 7d 01 68 01   ; $f807: 7d 01 68 01   Data
            .hex 53 01 40 01   ; $f80b: 53 01 40 01   Data
            .hex 2e 01 1d 01   ; $f80f: 2e 01 1d 01   Data
            .hex 0d 00 fe 00   ; $f813: 0d 00 fe 00   Data
            .hex f0 00 e2 00   ; $f817: f0 00 e2 00   Data
            .hex d6 00 ca 00   ; $f81b: d6 00 ca 00   Data
            .hex be 00 b4 00   ; $f81f: be 00 b4 00   Data
            .hex aa 00 a0 00   ; $f823: aa 00 a0 00   Data
            .hex 97 00 8f 00   ; $f827: 97 00 8f 00   Data
            .hex 87 00 7f 00   ; $f82b: 87 00 7f 00   Data
            .hex 78 00 71 00   ; $f82f: 78 00 71 00   Data
            .hex 6b 00 65 00   ; $f833: 6b 00 65 00   Data
            .hex 5f 00 5a      ; $f837: 5f 00 5a      Data
			
__initSound:     
			lda #$0f           ; $f83a: a9 0f     
            sta apuStatus          ; $f83c: 8d 15 40  
            lda #$c0           ; $f83f: a9 c0     
            sta joy2port          ; $f841: 8d 17 40  
            lda #$0f           ; $f844: a9 0f     
            sta apu1Pulse1          ; $f846: 8d 00 40  
            sta apu2Pulse1          ; $f849: 8d 04 40  
            sta apuTriangle          ; $f84c: 8d 08 40  
            lda #$7f           ; $f84f: a9 7f     
            sta apu1PulseSweep          ; $f851: 8d 01 40  
            sta apu2PulseSweep          ; $f854: 8d 05 40  
            rts                ; $f857: 60        

;-------------------------------------------------------------------------------
__musicSpeed:     
			.hex 08 08 08 08   ; $f858: 08 08 08 08   Data
            .hex 05 08 08 08   ; $f85c: 05 08 08 08   Data
            .hex 0a 08 08 08   ; $f860: 0a 08 08 08   Data
            .hex 04 02 02 08   ; $f864: 04 02 02 08   Data
            .hex 08 08 08 08   ; $f868: 08 08 08 08   Data
__f86c:     .hex 92            ; $f86c: 92            Data
__f86d:     .hex f8 92 f8 92   ; $f86d: f8 92 f8 92   Data
            .hex f8 98 f9 27   ; $f871: f8 98 f9 27   Data
            .hex fb cb fa ad   ; $f875: fb cb fa ad   Data
            .hex fa f3 f9 66   ; $f879: fa f3 f9 66   Data
            .hex fa 0e fb ec   ; $f87d: fa 0e fb ec   Data
            .hex fa 30 fb 69   ; $f881: fa 30 fb 69   Data
            .hex fb 69 fb 49   ; $f885: fb 69 fb 49   Data
            .hex fc 80 fb af   ; $f889: fc 80 fb af   Data
            .hex fb 0f fc 6b   ; $f88d: fb 0f fc 6b   Data
            .hex fc f1 10 60   ; $f891: fc f1 10 60   Data
            .hex f0 64 f0 64   ; $f895: f0 64 f0 64   Data
            .hex f0 10 60 f0   ; $f899: f0 10 60 f0   Data
            .hex 64 f0 64 f0   ; $f89d: 64 f0 64 f0   Data
            .hex 10 60 f0 0f   ; $f8a1: 10 60 f0 0f   Data
            .hex 64 f0 10 64   ; $f8a5: 64 f0 10 64   Data
            .hex f0 13 60 f0   ; $f8a9: f0 13 60 f0   Data
            .hex 64 f0 64 f0   ; $f8ad: 64 f0 64 f0   Data
            .hex 17 62 35 17   ; $f8b1: 17 62 35 17   Data
            .hex 65 35 17 65   ; $f8b5: 65 35 17 65   Data
            .hex f0 62 f0 65   ; $f8b9: f0 62 f0 65   Data
            .hex f0 65 f0 17   ; $f8bd: f0 65 f0 17   Data
            .hex 62 36 15 65   ; $f8c1: 62 36 15 65   Data
            .hex 34 13 65 f0   ; $f8c5: 34 13 65 f0   Data
            .hex 62 f0 65 f0   ; $f8c9: 62 f0 65 f0   Data
            .hex 65 f0 f2 f1   ; $f8cd: 65 f0 f2 f1   Data
            .hex 0c 64 f0 1a   ; $f8d1: 0c 64 f0 1a   Data
            .hex 67 f0 67 f0   ; $f8d5: 67 f0 67 f0   Data
            .hex 18 64 f0 67   ; $f8d9: 18 64 f0 67   Data
            .hex f0 67 f0 13   ; $f8dd: f0 67 f0 13   Data
            .hex 64 f0 10 67   ; $f8e1: 64 f0 10 67   Data
            .hex f0 11 67 f0   ; $f8e5: f0 11 67 f0   Data
            .hex 13 64 f0 67   ; $f8e9: 13 64 f0 67   Data
            .hex f0 67 f0 17   ; $f8ed: f0 67 f0 17   Data
            .hex 65 35 17 69   ; $f8f1: 65 35 17 69   Data
            .hex 35 17 69 35   ; $f8f5: 35 17 69 35   Data
            .hex 0b 65 29 0b   ; $f8f9: 0b 65 29 0b   Data
            .hex 69 29 0b 69   ; $f8fd: 69 29 0b 69   Data
            .hex 29 17 65 35   ; $f901: 29 17 65 35   Data
            .hex 17 69 35 17   ; $f905: 17 69 35 17   Data
            .hex 69 35 0b 65   ; $f909: 69 35 0b 65   Data
            .hex 29 0b 69 29   ; $f90d: 29 0b 69 29   Data
            .hex 0b 69 29 f2   ; $f911: 0b 69 29 f2   Data
            .hex f1 1c 60 f0   ; $f915: f1 1c 60 f0   Data
            .hex 64 f0 64 f0   ; $f919: 64 f0 64 f0   Data
            .hex 18 60 f0 64   ; $f91d: 18 60 f0 64   Data
            .hex f0 64 f0 1c   ; $f921: f0 64 f0 1c   Data
            .hex 60 3b 1c 64   ; $f925: 60 3b 1c 64   Data
            .hex 3b 1c 64 f0   ; $f929: 3b 1c 64 f0   Data
            .hex 13 60 f0 64   ; $f92d: 13 60 f0 64   Data
            .hex f0 64 f0 1a   ; $f931: f0 64 f0 1a   Data
            .hex 62 3c 1d 65   ; $f935: 62 3c 1d 65   Data
            .hex 3f 1d 65 3c   ; $f939: 3f 1d 65 3c   Data
            .hex 1a 62 f0 65   ; $f93d: 1a 62 f0 65   Data
            .hex f0 65 f0 17   ; $f941: f0 65 f0 17   Data
            .hex 62 36 17 65   ; $f945: 62 36 17 65   Data
            .hex 38 1a 65 3a   ; $f949: 38 1a 65 3a   Data
            .hex 13 62 f0 65   ; $f94d: 13 62 f0 65   Data
            .hex f0 65 f0 0c   ; $f951: f0 65 f0 0c   Data
            .hex 64 2b 0c 67   ; $f955: 64 2b 0c 67   Data
            .hex f0 10 67 2f   ; $f959: f0 10 67 2f   Data
            .hex 10 64 f0 13   ; $f95d: 10 64 f0 13   Data
            .hex 67 32 13 67   ; $f961: 67 32 13 67   Data
            .hex f0 1f 64 f0   ; $f965: f0 1f 64 f0   Data
            .hex 67 f0 67 f0   ; $f969: 67 f0 67 f0   Data
            .hex 64 f0 67 f0   ; $f96d: 64 f0 67 f0   Data
            .hex 67 f0 15 65   ; $f971: 67 f0 15 65   Data
            .hex 34 15 69 f0   ; $f975: 34 15 69 f0   Data
            .hex 1a 69 39 1a   ; $f979: 1a 69 39 1a   Data
            .hex 65 f0 1d 69   ; $f97d: 65 f0 1d 69   Data
            .hex f0 1d 69 f0   ; $f981: f0 1d 69 f0   Data
            .hex 1a 65 f0 69   ; $f985: 1a 65 f0 69   Data
            .hex f0 0e 69 2d   ; $f989: f0 0e 69 2d   Data
            .hex 0e 65 2d 0e   ; $f98d: 0e 65 2d 0e   Data
            .hex 69 2d 0e 69   ; $f991: 69 2d 0e 69   Data
            .hex f0 f2 ff 13   ; $f995: f0 f2 ff 13   Data
            .hex 67 f0 15 69   ; $f999: 67 f0 15 69   Data
            .hex f0 17 6b f0   ; $f99d: f0 17 6b f0   Data
            .hex 18 60 f0 64   ; $f9a1: 18 60 f0 64   Data
            .hex f0 13 60 f0   ; $f9a5: f0 13 60 f0   Data
            .hex 64 f0 18 60   ; $f9a9: 64 f0 18 60   Data
            .hex f0 64 33 18   ; $f9ad: f0 64 33 18   Data
            .hex 60 38 13 64   ; $f9b1: 60 38 13 64   Data
            .hex 38 15 60 61   ; $f9b5: 38 15 60 61   Data
            .hex 62 63 10 64   ; $f9b9: 62 63 10 64   Data
            .hex f0 69 f0 15   ; $f9bd: f0 69 f0 15   Data
            .hex 64 f0 69 30   ; $f9c1: 64 f0 69 30   Data
            .hex 15 64 35 10   ; $f9c5: 15 64 35 10   Data
            .hex 69 35 11 65   ; $f9c9: 69 35 11 65   Data
            .hex 66 67 68 09   ; $f9cd: 66 67 68 09   Data
            .hex 65 f0 69 f0   ; $f9d1: 65 f0 69 f0   Data
            .hex 11 65 f0 69   ; $f9d5: 11 65 f0 69   Data
            .hex 29 11 65 31   ; $f9d9: 29 11 65 31   Data
            .hex 09 69 31 13   ; $f9dd: 09 69 31 13   Data
            .hex 67 13 66 67   ; $f9e1: 67 13 66 67   Data
            .hex 13 66 15 67   ; $f9e5: 13 66 15 67   Data
            .hex 68 16 69 6a   ; $f9e9: 68 16 69 6a   Data
            .hex 17 6b f0 3f   ; $f9ed: 17 6b f0 3f   Data
            .hex 33 ff 13 67   ; $f9f1: 33 ff 13 67   Data
            .hex f0 11 69 f0   ; $f9f5: f0 11 69 f0   Data
            .hex 10 6b f0 0c   ; $f9f9: 10 6b f0 0c   Data
            .hex 40 bc f0 44   ; $f9fd: 40 bc f0 44   Data
            .hex bf be 10 40   ; $fa01: bf be 10 40   Data
            .hex bf be 44 bf   ; $fa05: bf be 44 bf   Data
            .hex f0 0c 47 b8   ; $fa09: f0 0c 47 b8   Data
            .hex 66 67 10 66   ; $fa0d: 66 67 10 66   Data
            .hex 0c 67 10 66   ; $fa11: 0c 67 10 66   Data
            .hex 0e 45 bd f0   ; $fa15: 0e 45 bd f0   Data
            .hex 42 bd bc 11   ; $fa19: 42 bd bc 11   Data
            .hex 45 bd bc 42   ; $fa1d: 45 bd bc 42   Data
            .hex bd f0 0e 45   ; $fa21: bd f0 0e 45   Data
            .hex ba 64 65 11   ; $fa25: ba 64 65 11   Data
            .hex 64 0e 65 11   ; $fa29: 64 0e 65 11   Data
            .hex 64 09 42 bd   ; $fa2d: 64 09 42 bd   Data
            .hex f0 45 bd bc   ; $fa31: f0 45 bd bc   Data
            .hex 11 49 bd bc   ; $fa35: 11 49 bd bc   Data
            .hex 45 bd f0 09   ; $fa39: 45 bd f0 09   Data
            .hex 45 b5 64 65   ; $fa3d: 45 b5 64 65   Data
            .hex 11 64 09 65   ; $fa41: 11 64 09 65   Data
            .hex 11 64 0c 44   ; $fa45: 11 64 0c 44   Data
            .hex bc f0 40 bc   ; $fa49: bc f0 40 bc   Data
            .hex bb 10 44 bc   ; $fa4d: bb 10 44 bc   Data
            .hex bb 40 bc f0   ; $fa51: bb 40 bc f0   Data
            .hex 0c 44 b8 63   ; $fa55: 0c 44 b8 63   Data
            .hex 64 10 63 0c   ; $fa59: 64 10 63 0c   Data
            .hex 64 10 63 0c   ; $fa5d: 64 10 63 0c   Data
            .hex 64 f0 f0 f0   ; $fa61: 64 f0 f0 f0   Data
            .hex ff 18 60 37   ; $fa65: ff 18 60 37   Data
            .hex 18 64 30 1a   ; $fa69: 18 64 30 1a   Data
            .hex 64 38 18 40   ; $fa6d: 64 38 18 40   Data
            .hex b8 b7 44 b8   ; $fa71: b8 b7 44 b8   Data
            .hex b0 44 ae ac   ; $fa75: b0 44 ae ac   Data
            .hex 17 42 ae 35   ; $fa79: 17 42 ae 35   Data
            .hex 17 65 3a 17   ; $fa7d: 17 65 3a 17   Data
            .hex 65 35 1d 42   ; $fa81: 65 35 1d 42   Data
            .hex b7 b5 45 b7   ; $fa85: b7 b5 45 b7   Data
            .hex ba 45 b7 b5   ; $fa89: ba 45 b7 b5   Data
            .hex 15 49 bd f0   ; $fa8d: 15 49 bd f0   Data
            .hex 71 35 71 35   ; $fa91: 71 35 71 35   Data
            .hex 17 49 b5 13   ; $fa95: 17 49 b5 13   Data
            .hex b7 51 b5 b3   ; $fa99: b7 51 b5 b3   Data
            .hex 51 b5 b3 18   ; $fa9d: 51 b5 b3 18   Data
            .hex 4c ac ab 50   ; $faa1: 4c ac ab 50   Data
            .hex ac b0 50 b3   ; $faa5: ac b0 50 b3   Data
            .hex b7 4c b8 ff   ; $faa9: b7 4c b8 ff   Data
            .hex 13 47 ac 11   ; $faad: 13 47 ac 11   Data
            .hex 65 10 44 b3   ; $fab1: 65 10 44 b3   Data
            .hex 0e 62 0c 40   ; $fab5: 0e 62 0c 40   Data
            .hex ac f0 13 47   ; $fab9: ac f0 13 47   Data
            .hex b3 b0 0c 40   ; $fabd: b3 b0 0c 40   Data
            .hex ac f0 f0 f0   ; $fac1: ac f0 f0 f0   Data
            .hex f0 f0 f0 f0   ; $fac5: f0 f0 f0 f0   Data
            .hex f0 ff 1f 6c   ; $fac9: f0 ff 1f 6c   Data
            .hex 3e 3d 1c 6c   ; $facd: 3e 3d 1c 6c   Data
            .hex 1b 6c 3a 39   ; $fad1: 1b 6c 3a 39   Data
            .hex 18 6c 17 6c   ; $fad5: 18 6c 17 6c   Data
            .hex 36 35 14 6c   ; $fad9: 36 35 14 6c   Data
            .hex 13 6c 32 31   ; $fadd: 13 6c 32 31   Data
            .hex 10 6c 0f 6c   ; $fae1: 10 6c 0f 6c   Data
            .hex 2e 2d 0c 6c   ; $fae5: 2e 2d 0c 6c   Data
            .hex 2b 2a ff 1f   ; $fae9: 2b 2a ff 1f   Data
            .hex 60 62 64 65   ; $faed: 60 62 64 65   Data
            .hex 1c 67 1f 69   ; $faf1: 1c 67 1f 69   Data
            .hex 1d 6b 1c 6c   ; $faf5: 1d 6b 1c 6c   Data
            .hex 1a 6e 70 71   ; $faf9: 1a 6e 70 71   Data
            .hex 1c 73 1f 75   ; $fafd: 1c 73 1f 75   Data
            .hex 77 1c 78 18   ; $fb01: 77 1c 78 18   Data
            .hex 73 70 6c f0   ; $fb05: 73 70 6c f0   Data
            .hex f0 f0 f0 f0   ; $fb09: f0 f0 f0 f0   Data
            .hex ff 00 bf be   ; $fb0d: ff 00 bf be   Data
            .hex 24 0c bf be   ; $fb11: 24 0c bf be   Data
            .hex 30 18 bf be   ; $fb15: 30 18 bf be   Data
            .hex 3c 00 bf be   ; $fb19: 3c 00 bf be   Data
            .hex 23 0c bf be   ; $fb1d: 23 0c bf be   Data
            .hex 2f 18 bf be   ; $fb21: 2f 18 bf be   Data
            .hex 3b ff 1a 60   ; $fb25: 3b ff 1a 60   Data
            .hex 38 f0 1c 70   ; $fb29: 38 f0 1c 70   Data
            .hex 1f 67 ff 0c   ; $fb2d: 1f 67 ff 0c   Data
            .hex 40 bf f0 67   ; $fb31: 40 bf f0 67   Data
            .hex bc 0c 44 bf   ; $fb35: bc 0c 44 bf   Data
            .hex f0 67 bc 0c   ; $fb39: f0 67 bc 0c   Data
            .hex 40 bf 10 62   ; $fb3d: 40 bf 10 62   Data
            .hex 64 0c 45 bc   ; $fb41: 64 0c 45 bc   Data
            .hex 13 47 bf f0   ; $fb45: 13 47 bf f0   Data
            .hex 67 ba 0e 42   ; $fb49: 67 ba 0e 42   Data
            .hex bd f0 69 ba   ; $fb4d: bd f0 69 ba   Data
            .hex 0e 45 bd f0   ; $fb51: 0e 45 bd f0   Data
            .hex 69 ba 0e 42   ; $fb55: 69 ba 0e 42   Data
            .hex bd 10 64 11   ; $fb59: bd 10 64 11   Data
            .hex 65 13 47 ba   ; $fb5d: 65 13 47 ba   Data
            .hex 15 49 bd f0   ; $fb61: 15 49 bd f0   Data
            .hex 69 f0 f0 ff   ; $fb65: 69 f0 f0 ff   Data
            .hex 0b 47 ab 2e   ; $fb69: 0b 47 ab 2e   Data
            .hex 37 33 0b ae   ; $fb6d: 37 33 0b ae   Data
            .hex 2e 37 33 0b   ; $fb71: 2e 37 33 0b   Data
            .hex 47 b7 2e 37   ; $fb75: 47 b7 2e 37   Data
            .hex 33 0b b3 2e   ; $fb79: 33 0b b3 2e   Data
            .hex 37 33 ff f1   ; $fb7d: 37 33 ff f1   Data
            .hex 10 60 64 64   ; $fb81: 10 60 64 64   Data
            .hex 22 65 65 64   ; $fb85: 22 65 65 64   Data
            .hex 67 13 67 65   ; $fb89: 67 13 67 65   Data
            .hex 69 15 69 67   ; $fb8d: 69 15 69 67   Data
            .hex 17 6b 13 6b   ; $fb91: 17 6b 13 6b   Data
            .hex 4b f2 f1 18   ; $fb95: 4b f2 f1 18   Data
            .hex 6c 38 38 70   ; $fb99: 6c 38 38 70   Data
            .hex 37 35 17 6e   ; $fb9d: 37 35 17 6e   Data
            .hex f0 15 71 35   ; $fba1: f0 15 71 35   Data
            .hex 15 70 f0 33   ; $fba5: 15 70 f0 33   Data
            .hex 15 73 37 f0   ; $fba9: 15 73 37 f0   Data
            .hex f2 ff 60 67   ; $fbad: f2 ff 60 67   Data
            .hex 60 67 18 60   ; $fbb1: 60 67 18 60   Data
            .hex 67 60 17 67   ; $fbb5: 67 60 17 67   Data
            .hex 13 64 67 64   ; $fbb9: 13 64 67 64   Data
            .hex f0 64 67 6c   ; $fbbd: f0 64 67 6c   Data
            .hex 67 1a 62 69   ; $fbc1: 67 1a 62 69   Data
            .hex 62 1d 69 62   ; $fbc5: 62 1d 69 62   Data
            .hex 69 1c 62 1b   ; $fbc9: 69 1c 62 1b   Data
            .hex 69 1c 65 69   ; $fbcd: 69 1c 65 69   Data
            .hex 18 65 f0 65   ; $fbd1: 18 65 f0 65   Data
            .hex 69 6e 49 04   ; $fbd5: 69 6e 49 04   Data
            .hex 60 64 13 60   ; $fbd9: 60 64 13 60   Data
            .hex 64 10 60 0e   ; $fbdd: 64 10 60 0e   Data
            .hex 64 60 64 04   ; $fbe1: 64 60 64 04   Data
            .hex 60 05 64 07   ; $fbe5: 60 05 64 07   Data
            .hex 60 09 64 0b   ; $fbe9: 60 09 64 0b   Data
            .hex 60 0c 64 60   ; $fbed: 60 0c 64 60   Data
            .hex 64 05 62 65   ; $fbf1: 64 05 62 65   Data
            .hex 04 62 65 05   ; $fbf5: 04 62 65 05   Data
            .hex 62 04 65 62   ; $fbf9: 62 04 65 62   Data
            .hex 65 05 62 07   ; $fbfd: 65 05 62 07   Data
            .hex 65 09 62 0b   ; $fc01: 65 09 62 0b   Data
            .hex 65 0c 62 0e   ; $fc05: 65 0c 62 0e   Data
            .hex 65 0c 62 0e   ; $fc09: 65 0c 62 0e   Data
            .hex 65 ff b0 f0   ; $fc0d: 65 ff b0 f0   Data
            .hex ac f0 ff 3f   ; $fc11: ac f0 ff 3f   Data
            .hex 3d 38 f0 f0   ; $fc15: 3d 38 f0 f0   Data
            .hex ff bc bf b0   ; $fc19: ff bc bf b0   Data
            .hex af a8 ab ff   ; $fc1d: af a8 ab ff   Data
            .hex 2c 2d 27 20   ; $fc21: 2c 2d 27 20   Data
            .hex f0 f0 f0 ff   ; $fc25: f0 f0 f0 ff   Data
            .hex 3f 3e 3f f0   ; $fc29: 3f 3e 3f f0   Data
            .hex f0 f0 ff 3c   ; $fc2d: f0 f0 ff 3c   Data
            .hex 3d 3e 3f f0   ; $fc31: 3d 3e 3f f0   Data
            .hex f0 f0 ff 27   ; $fc35: f0 f0 ff 27   Data
            .hex 33 38 f0 f0   ; $fc39: 33 38 f0 f0   Data
            .hex f0 ff 3a 3c   ; $fc3d: f0 ff 3a 3c   Data
            .hex 2e 30 22 24   ; $fc41: 2e 30 22 24   Data
            .hex f0 f0 f0 ff   ; $fc45: f0 f0 f0 ff   Data
            .hex 3f 3e 3f f0   ; $fc49: 3f 3e 3f f0   Data
            .hex ff            ; $fc4d: ff            Data
__soundAddr:     
			.hex 30            ; $fc4e: 30            Data
__soundHiAddr:     
			.hex fc 21 fc 1a   ; $fc4f: fc 21 fc 1a   Data
            .hex fc 29 fc 14   ; $fc53: fc 29 fc 14   Data
            .hex fc 38 fc 3f   ; $fc57: fc 38 fc 3f   Data
            .hex fc 29 fc 30   ; $fc5b: fc 29 fc 30   Data
            .hex fc 38 fc 3f   ; $fc5f: fc 38 fc 3f   Data
            .hex fc            ; $fc63: fc            Data
__soundSpeed:     
			.hex 02 01 02 06   ; $fc64: 02 01 02 06   Data
            .hex 01 01 01 f1   ; $fc68: 01 01 01 f1   Data
            .hex f0 40 b8 f0   ; $fc6c: f0 40 b8 f0   Data
            .hex 44 ba b8 64   ; $fc70: 44 ba b8 64   Data
            .hex f0 40 bc bb   ; $fc74: f0 40 bc bb   Data
            .hex 44 bc f0 64   ; $fc78: 44 bc f0 64   Data
            .hex f0 62 f0 11   ; $fc7c: f0 62 f0 11   Data
            .hex 65 30 11 65   ; $fc80: 65 30 11 65   Data
            .hex f0 62 f0 65   ; $fc84: f0 62 f0 65   Data
            .hex f0 65 f0 44   ; $fc88: f0 65 f0 44   Data
            .hex bf be 47 bd   ; $fc8c: bf be 47 bd   Data
            .hex bc 47 bb ba   ; $fc90: bc 47 bb ba   Data
            .hex 44 bc f0 67   ; $fc94: 44 bc f0 67   Data
            .hex f0 67 f0 42   ; $fc98: f0 67 f0 42   Data
            .hex ba f0 11 65   ; $fc9c: ba f0 11 65   Data
            .hex 30 11 65 f0   ; $fca0: 30 11 65 f0   Data
            .hex 42 bc f0 65   ; $fca4: 42 bc f0 65   Data
            .hex f0 65 f2 10   ; $fca8: f0 65 f2 10   Data
            .hex 60 f0 64 f0   ; $fcac: 60 f0 64 f0   Data
            .hex 13 64 2c 60   ; $fcb0: 13 64 2c 60   Data
            .hex f0 13 64 f0   ; $fcb4: f0 13 64 f0   Data
            .hex 14 64 f0 15   ; $fcb8: 14 64 f0 15   Data
            .hex 62 f0 65 f0   ; $fcbc: 62 f0 65 f0   Data
            .hex 11 65 f0 0e   ; $fcc0: 11 65 f0 0e   Data
            .hex 62 f0 65 f0   ; $fcc4: 62 f0 65 f0   Data
            .hex 65 f0 10 64   ; $fcc8: 65 f0 10 64   Data
            .hex f0 67 f0 13   ; $fccc: f0 67 f0 13   Data
            .hex 67 2c 64 f0   ; $fcd0: 67 2c 64 f0   Data
            .hex 13 67 f0 14   ; $fcd4: 13 67 f0 14   Data
            .hex 67 f0 15 62   ; $fcd8: 67 f0 15 62   Data
            .hex f0 65 f0 65   ; $fcdc: f0 65 f0 65   Data
            .hex f0 62 f0 65   ; $fce0: f0 62 f0 65   Data
            .hex f0 65 f0 10   ; $fce4: f0 65 f0 10   Data
            .hex 67 f0 4c a7   ; $fce8: 67 f0 4c a7   Data
            .hex a6 4c a5 a4   ; $fcec: a6 4c a5 a4   Data
            .hex 13 47 a2 32   ; $fcf0: 13 47 a2 32   Data
            .hex 13 6c f0 6c   ; $fcf4: 13 6c f0 6c   Data
            .hex f0 11 65 f0   ; $fcf8: f0 11 65 f0   Data
            .hex 49 a4 a5 49   ; $fcfc: 49 a4 a5 49   Data
            .hex a6 a7 15 45   ; $fd00: a6 a7 15 45   Data
            .hex a9 34 15 69   ; $fd04: a9 34 15 69   Data
            .hex f0 69 f0 13   ; $fd08: f0 69 f0 13   Data
            .hex 47 a7 f0 15   ; $fd0c: 47 a7 f0 15   Data
            .hex 6b f0 17 6b   ; $fd10: 6b f0 17 6b   Data
            .hex f0 17 47 ab   ; $fd14: f0 17 47 ab   Data
            .hex f0 6b f0 1a   ; $fd18: f0 6b f0 1a   Data
            .hex 6e f0 18 4c   ; $fd1c: 6e f0 18 4c   Data
            .hex ac ab ac ae   ; $fd20: ac ab ac ae   Data
            .hex b0 f0 ff      ; $fd24: b0 f0 ff      Data

;-------------------------------------------------------------------------------
; reset vector
;-------------------------------------------------------------------------------
reset:      
;-------------------------------------------------------------------------------
; irq/brk vector
;-------------------------------------------------------------------------------
irq:        sei                ; $fd27: 78        
            cld                ; $fd28: d8        
            ldx #$30           ; $fd29: a2 30     
            stx ppuControl          ; $fd2b: 8e 00 20  
			
			; wait 2 vblanks
__firstVBlank:     
			lda ppuStatus          ; $fd2e: ad 02 20  
            bpl __firstVBlank         ; $fd31: 10 fb     
__secondVBlank:     
			lda ppuStatus          ; $fd33: ad 02 20  
            bpl __secondVBlank         ; $fd36: 10 fb 
			
			; hide everything
            ldx #$00           ; $fd38: a2 00     
            stx ppuMask          ; $fd3a: 8e 01 20  
			; init stack with FF
            dex                ; $fd3d: ca        
            txs                ; $fd3e: 9a      
			
            jsr __loadMainMenuPalette         ; $fd3f: 20 87 fe  
            jsr __uploadPalettesToPPU         ; $fd42: 20 64 fe  
            jsr __initZero_200_300         ; $fd45: 20 2a fe  
            lda #$20           ; $fd48: a9 20     
            jsr __clearNametable         ; $fd4a: 20 f5 fd  
            lda #$20           ; $fd4d: a9 20     
            jsr __clearAttributeTable         ; $fd4f: 20 13 fe  
            jsr __dummy         ; $fd52: 20 ea ff  
			
			; this mapper implements copy protection check
__copyProtectionCheck:     
			lda __c020         ; $fd55: ad 20 c0  
            sta __c020         ; $fd58: 8d 20 c0  
            jsr __copyProtection         ; $fd5b: 20 a3 fd  
            beq __copyProtectionCheck         ; $fd5e: f0 f5   
__copyProtectionCheck2:     
			lda __c021         ; $fd60: ad 21 c0  
            sta __c021         ; $fd63: 8d 21 c0  
            jsr __copyProtection         ; $fd66: 20 a3 fd  
            bne __copyProtectionCheck2         ; $fd69: d0 f5     
			
			; init video and sound
            lda #$b0           ; $fd6b: a9 b0     
            sta vPPUController            ; $fd6d: 85 06     
            lda #$1e           ; $fd6f: a9 1e     
            sta vPPUMask            ; $fd71: 85 07     
            jsr __initAPUshowGraphics         ; $fd73: 20 30 c0  
			
			; generate NMI on VBlank
            lda vPPUController            ; $fd76: a5 06     
            ora #$80           ; $fd78: 09 80     
            sta vPPUController            ; $fd7a: 85 06     
            sta ppuControl          ; $fd7c: 8d 00 20 
			
			; this will loop until NMI will be generated
__foreverLoop:     
			inc vRandomVar            ; $fd7f: e6 08     
            inc vRandomVar            ; $fd81: e6 08     
            inc vRandomVar2            ; $fd83: e6 17     
            inc vRandomVar            ; $fd85: e6 08     
            jmp __foreverLoop         ; $fd87: 4c 7f fd  

;-------------------------------------------------------------------------------
; nmi vector
;-------------------------------------------------------------------------------
nmi:        
			; DMA offset
			lda #$00           ; $fd8a: a9 00     
            sta ppuOAMAddr          ; $fd8c: 8d 03 20  
			
			; upload DMA data
            lda #$06           ; $fd8f: a9 06     
            sta OAMDMA          ; $fd91: 8d 14 40  
			; show everything (with sprites or not)
            lda vPPUMask            ; $fd94: a5 07     
            sta ppuMask          ; $fd96: 8d 01 20  
			
            lda ppuStatus          ; $fd99: ad 02 20  
            jsr __processGameState         ; $fd9c: 20 33 c0  
            jsr __getControllerInput         ; $fd9f: 20 a2 fe  
            rti                ; $fda2: 40        

;-------------------------------------------------------------------------------
__copyProtection:     
			lda #$1f           ; $fda3: a9 1f     
            sta ppuAddress          ; $fda5: 8d 06 20  
            lda #$f0           ; $fda8: a9 f0     
            sta ppuAddress          ; $fdaa: 8d 06 20  
            lda ppuData          ; $fdad: ad 07 20  
            lda ppuData          ; $fdb0: ad 07 20  
            cmp #$0c           ; $fdb3: c9 0c     
            rts                ; $fdb5: 60        

;-------------------------------------------------------------------------------
__scrollScreen:     
			lda vPPUController            ; $fdb6: a5 06     
            and #$fc           ; $fdb8: 29 fc     
            tax                ; $fdba: aa        
            lda vBirdPPUNametable            ; $fdbb: a5 02     
            beq __fdc0         ; $fdbd: f0 01     
            inx                ; $fdbf: e8        
__fdc0:     lda $04            ; $fdc0: a5 04     
            beq __fdc6         ; $fdc2: f0 02     
            inx                ; $fdc4: e8        
            inx                ; $fdc5: e8   
			
__fdc6:     stx vPPUController            ; $fdc6: 86 06     
            stx ppuControl          ; $fdc8: 8e 00 20  
			; current bird position
            lda vBirdPPUX            ; $fdcb: a5 03     
            sta ppuScroll          ; $fdcd: 8d 05 20  
			; y scroll is always zero
            lda $05            ; $fdd0: a5 05     
            sta ppuScroll          ; $fdd2: 8d 05 20  
            rts                ; $fdd5: 60        

;-------------------------------------------------------------------------------
__hideSprites:     
			lda vPPUMask            ; $fdd6: a5 07     
            and #$ef           ; $fdd8: 29 ef     
            sta vPPUMask            ; $fdda: 85 07     
            nop                ; $fddc: ea        
            nop                ; $fddd: ea        
            nop                ; $fdde: ea        
            rts                ; $fddf: 60        

;-------------------------------------------------------------------------------
__showSprites:     
			lda vPPUMask            ; $fde0: a5 07     
            ora #$10           ; $fde2: 09 10     
            sta vPPUMask            ; $fde4: 85 07     
            nop                ; $fde6: ea        
            nop                ; $fde7: ea        
            nop                ; $fde8: ea        
            rts                ; $fde9: 60        

;-------------------------------------------------------------------------------
__hideAllSpritesInTable:     
			ldx #$00           ; $fdea: a2 00     
            lda #$f0           ; $fdec: a9 f0     
__hideAllSpritesInTableLoop:     
			sta vSpriteTable,x        ; $fdee: 9d 00 07  
            inx                ; $fdf1: e8        
            bne __hideAllSpritesInTableLoop         ; $fdf2: d0 fa     
            rts                ; $fdf4: 60        

;-------------------------------------------------------------------------------
; register A - nametable to clear (#$20 - $2000-23BF, 3C0 iterations)
__clearNametable:      
			sta ppuAddress          ; $fdf5: 8d 06 20  
            ldx #$00           ; $fdf8: a2 00     
            stx ppuAddress          ; $fdfa: 8e 06 20  
            ldy #$03           ; $fdfd: a0 03
			; empty tile
            lda #$24           ; $fdff: a9 24     

__clearNametableLoop:     
			sta ppuData          ; $fe01: 8d 07 20  
            inx                ; $fe04: e8        
            bne __clearNametableLoop         ; $fe05: d0 fa     
            dey                ; $fe07: 88        
            bne __clearNametableLoop         ; $fe08: d0 f7    
			
__fe0a:     sta ppuData          ; $fe0a: 8d 07 20  
            inx                ; $fe0d: e8        
            cpx #$c0           ; $fe0e: e0 c0     
            bne __fe0a         ; $fe10: d0 f8     
            rts                ; $fe12: 60        

;-------------------------------------------------------------------------------
__clearAttributeTable:     
			clc                ; $fe13: 18        
            adc #$03           ; $fe14: 69 03     
            sta ppuAddress          ; $fe16: 8d 06 20  
            lda #$c0           ; $fe19: a9 c0     
            sta ppuAddress          ; $fe1b: 8d 06 20  
            lda #$00           ; $fe1e: a9 00     
            tax                ; $fe20: aa        
__clearAttributeTableLoop:     
			sta ppuData          ; $fe21: 8d 07 20  
            inx                ; $fe24: e8        
            cpx #$40           ; $fe25: e0 40     
            bne __clearAttributeTableLoop         ; $fe27: d0 f8     
            rts                ; $fe29: 60        

;-------------------------------------------------------------------------------
__initZero_200_300:     
			lda #$00           ; $fe2a: a9 00     
            tax                ; $fe2c: aa        
__initZero_200_300_Loop:     
			sta $00,x          ; $fe2d: 95 00     
            sta vPage200,x        ; $fe2f: 9d 00 02  
            sta $0300,x        ; $fe32: 9d 00 03  
            nop                ; $fe35: ea        
            inx                ; $fe36: e8        
            bne __initZero_200_300_Loop         ; $fe37: d0 f4    
			
            jsr __hideAllSpritesInTable         ; $fe39: 20 ea fd  
__fe3c:     lda $0130,x        ; $fe3c: bd 30 01  
            cmp __c020,x       ; $fe3f: dd 20 c0  
            bne __fe4a         ; $fe42: d0 06     
            inx                ; $fe44: e8        
            cpx #$10           ; $fe45: e0 10     
            bne __fe3c         ; $fe47: d0 f3     
            rts                ; $fe49: 60        

;-------------------------------------------------------------------------------
__fe4a:     ldx #$00           ; $fe4a: a2 00     
            txa                ; $fe4c: 8a        
__fe4d:     sta vPlayerScore,x        ; $fe4d: 9d 00 01  
            inx                ; $fe50: e8        
            bne __fe4d         ; $fe51: d0 fa     
__fe53:     lda __c020,x       ; $fe53: bd 20 c0  
            sta $0130,x        ; $fe56: 9d 30 01  
            inx                ; $fe59: e8        
            cpx #$10           ; $fe5a: e0 10     
            bne __fe53         ; $fe5c: d0 f5     
            lda #$03           ; $fe5e: a9 03     
            sta $0114          ; $fe60: 8d 14 01  
            rts                ; $fe63: 60        

;-------------------------------------------------------------------------------
__uploadPalettesToPPU:    
			; set palette address
			ldy #$3f           ; $fe64: a0 3f     
            sty ppuAddress          ; $fe66: 8c 06 20  
            ldx #$00           ; $fe69: a2 00     
            stx ppuAddress          ; $fe6b: 8e 06 20  
			
__uploadPalettesToPPULoop:     
			lda vPaletteData,x          ; $fe6e: b5 30     
            sta ppuData          ; $fe70: 8d 07 20  
            inx                ; $fe73: e8        
            cpx #$20           ; $fe74: e0 20     
            bne __uploadPalettesToPPULoop         ; $fe76: d0 f6     
			
            sty ppuAddress          ; $fe78: 8c 06 20  
            lda #$00           ; $fe7b: a9 00     
            sta ppuAddress          ; $fe7d: 8d 06 20  
            sta ppuAddress          ; $fe80: 8d 06 20  
            sta ppuAddress          ; $fe83: 8d 06 20  
            rts                ; $fe86: 60        

;-------------------------------------------------------------------------------
__loadMainMenuPalette:     
			ldx #$00           ; $fe87: a2 00     
__loadMainMenuPaletteLoop:     
			lda __mainMenuPalette,x       ; $fe89: bd 00 c0  
            sta vPaletteData,x          ; $fe8c: 95 30     
            inx                ; $fe8e: e8        
            cpx #$20           ; $fe8f: e0 20     
            bne __loadMainMenuPaletteLoop         ; $fe91: d0 f6     
            rts                ; $fe93: 60        

;-------------------------------------------------------------------------------
; writing f0 will hide sprite
__hideSpritesInTable:     
			ldx #$00           ; $fe94: a2 00     
            lda #$f0           ; $fe96: a9 f0     
__hideAllSpritesLoop:     
			sta vSpriteTable,x        ; $fe98: 9d 00 07  
            inx                ; $fe9b: e8        
            inx                ; $fe9c: e8        
            inx                ; $fe9d: e8        
            inx                ; $fe9e: e8        
            bne __hideAllSpritesLoop         ; $fe9f: d0 f7     
            rts                ; $fea1: 60        

;-------------------------------------------------------------------------------
; fills vPlayerInput and vPlayer2Input with input from joysticks
__getControllerInput:    
			; strobe
			ldx #$01           ; $fea2: a2 01     
            stx joy1port          ; $fea4: 8e 16 40  
            lda #$00           ; $fea7: a9 00     
            sta joy1port          ; $fea9: 8d 16 40  
			
			; now stack all buttons in vPlayerInput and vPlayer2Input by shifting bits
            ldx #$08           ; $feac: a2 08     
__inputStacking:     
			lda joy1port          ; $feae: ad 16 40  
            and #$03           ; $feb1: 29 03     
            cmp #$01           ; $feb3: c9 01     
            ror vPlayerInput            ; $feb5: 66 0a     
            lda joy2port          ; $feb7: ad 17 40  
            and #$03           ; $feba: 29 03     
            cmp #$01           ; $febc: c9 01     
            ror vPlayer2Input            ; $febe: 66 0b     
            dex                ; $fec0: ca        
            bne __inputStacking         ; $fec1: d0 eb  
			
			; advance to next game cycle
            inc vCycleCounter            ; $fec3: e6 09     
            rts                ; $fec5: 60        

;-------------------------------------------------------------------------------
__enableNMI:     
			lda vPPUController            ; $fec6: a5 06     
            ora #$80           ; $fec8: 09 80     
            sta vPPUController            ; $feca: 85 06     
            sta ppuControl          ; $fecc: 8d 00 20  
            rts                ; $fecf: 60        

;-------------------------------------------------------------------------------
__disableNMI:     
			lda vPPUController            ; $fed0: a5 06     
            and #$7f           ; $fed2: 29 7f     
            sta vPPUController            ; $fed4: 85 06     
            sta ppuControl          ; $fed6: 8d 00 20  
            rts                ; $fed9: 60        

;-------------------------------------------------------------------------------
__setPPUIncrementBy1:     
			lda vPPUController            ; $feda: a5 06     
            and #$fb           ; $fedc: 29 fb     
            sta vPPUController            ; $fede: 85 06     
            sta ppuControl          ; $fee0: 8d 00 20  
            rts                ; $fee3: 60        

;-------------------------------------------------------------------------------
__setPPUIncrementBy32:     
			lda vPPUController            ; $fee4: a5 06     
            ora #$04           ; $fee6: 09 04     
            sta vPPUController            ; $fee8: 85 06     
            sta ppuControl          ; $feea: 8d 00 20  
            rts                ; $feed: 60        

;-------------------------------------------------------------------------------
__disableDrawing:     
			lda #$00           ; $feee: a9 00     
            sta ppuMask          ; $fef0: 8d 01 20  
            rts                ; $fef3: 60        

;-------------------------------------------------------------------------------
; wow - another unused function
            lda vPPUMask            ; $fef4: a5 07     
            sta ppuMask          ; $fef6: 8d 01 20  
            rts                ; $fef9: 60        

;-------------------------------------------------------------------------------
__give10Score:     
			ldx #$01           ; $fefa: a2 01     
            jmp __addPlayerScore         ; $fefc: 4c 21 ff  

;-------------------------------------------------------------------------------
; wow - an unused function
            clc                ; $feff: 18        
            adc #$01           ; $ff00: 69 01     
            cmp #$0a           ; $ff02: c9 0a     
            bne __storePlayerScore         ; $ff04: d0 0b     
            lda #$00           ; $ff06: a9 00     
            sta vPlayerScore,x        ; $ff08: 9d 00 01  
            inx                ; $ff0b: e8        
            cpx #$08           ; $ff0c: e0 08     
            bne __addPlayerScore         ; $ff0e: d0 11     
            rts                ; $ff10: 60        

;-------------------------------------------------------------------------------
__storePlayerScore:     
			sta vPlayerScore,x        ; $ff11: 9d 00 01  
            rts                ; $ff14: 60        

;-------------------------------------------------------------------------------
__give100Score:     
			ldx #$02           ; $ff15: a2 02     
            jmp __addPlayerScore         ; $ff17: 4c 21 ff  

;-------------------------------------------------------------------------------
__give1000Score:     
			ldx #$03           ; $ff1a: a2 03     
            jmp __addPlayerScore         ; $ff1c: 4c 21 ff  

;-------------------------------------------------------------------------------
            ldx #$01           ; $ff1f: a2 01     
__addPlayerScore:     
			lda vDemoSequenceActive          ; $ff21: ad 73 02  
				bne __return9         ; $ff24: d0 14     
            lda vPlayerScore,x        ; $ff26: bd 00 01  
            clc                ; $ff29: 18        
            adc #$01           ; $ff2a: 69 01     
            cmp #$0a           ; $ff2c: c9 0a     
            bne __storePlayerScore         ; $ff2e: d0 e1     
            lda #$00           ; $ff30: a9 00     
            sta vPlayerScore,x        ; $ff32: 9d 00 01  
            inx                ; $ff35: e8        
            cpx #$08           ; $ff36: e0 08     
            bne __addPlayerScore         ; $ff38: d0 e7     
__return9:     
			rts                ; $ff3a: 60        

;-------------------------------------------------------------------------------
__composeOAMTable:     
			ldy #$00           ; $ff3b: a0 00     
            lda vCycleCounter            ; $ff3d: a5 09     
            and #$01           ; $ff3f: 29 01     
            bne __composeOAMPart2         ; $ff41: d0 03     
            jmp __composeOAMPart1         ; $ff43: 4c 98 ff  

;-------------------------------------------------------------------------------
__composeOAMPart2:     
			lda vSpriteTable,y        ; $ff46: b9 00 07  
			; sprite data is delayed by one scanline
            clc                ; $ff49: 18        
            adc #$ff           ; $ff4a: 69 ff     
            sta vOAMPosY,y        ; $ff4c: 99 04 06  
			
            ldx $0701,y        ; $ff4f: be 01 07  
            lda __spriteData2,x       ; $ff52: bd 4c d3  
            sta vOAMTileIndex,y        ; $ff55: 99 05 06  
            lda __spriteAtrrib2,x       ; $ff58: bd eb d3  
            sta vOAMAttributes,y        ; $ff5b: 99 06 06
			; shift sprites 8 pixels right to simulate partial drawn sprites
            lda $0703,y        ; $ff5e: b9 03 07  
            clc                ; $ff61: 18        
            adc #$08           ; $ff62: 69 08     
            sta vOAMPosX,y        ; $ff64: 99 07 06  
            iny                ; $ff67: c8        
            iny                ; $ff68: c8        
            iny                ; $ff69: c8        
            iny                ; $ff6a: c8        
            cpy #$7c           ; $ff6b: c0 7c     
            bne __composeOAMPart2         ; $ff6d: d0 d7     
			
            ldy #$80           ; $ff6f: a0 80     
			
__composeOAMPart2Next:     
			lda $0680,y        ; $ff71: b9 80 06  
            clc                ; $ff74: 18        
            adc #$ff           ; $ff75: 69 ff     
            sta vOAMPosY,y        ; $ff77: 99 04 06  
            ldx $0681,y        ; $ff7a: be 81 06  
            lda __spriteData1,x       ; $ff7d: bd 0e d2  
            sta vOAMTileIndex,y        ; $ff80: 99 05 06  
            lda __spriteAtrrib1,x       ; $ff83: bd ad d2  
            sta vOAMAttributes,y        ; $ff86: 99 06 06  
            lda $0683,y        ; $ff89: b9 83 06  
            sta vOAMPosX,y        ; $ff8c: 99 07 06  
            iny                ; $ff8f: c8        
            iny                ; $ff90: c8        
            iny                ; $ff91: c8        
            iny                ; $ff92: c8        
            cpy #$fc           ; $ff93: c0 fc     
            bne __composeOAMPart2Next         ; $ff95: d0 da     
            rts                ; $ff97: 60        

;-------------------------------------------------------------------------------
__composeOAMPart1:     
			lda vSpriteTable,y        ; $ff98: b9 00 07  
			; sprite data is delayed by one scanline
            clc                ; $ff9b: 18        
            adc #$ff           ; $ff9c: 69 ff     
            sta vOAMPosY,y        ; $ff9e: 99 04 06  
			
            ldx $0701,y        ; $ffa1: be 01 07  
            lda __spriteData1,x       ; $ffa4: bd 0e d2  
            sta vOAMTileIndex,y        ; $ffa7: 99 05 06  
            lda __spriteAtrrib1,x       ; $ffaa: bd ad d2  
            sta vOAMAttributes,y        ; $ffad: 99 06 06  
            lda $0703,y        ; $ffb0: b9 03 07  
            sta vOAMPosX,y        ; $ffb3: 99 07 06  
            iny                ; $ffb6: c8        
            iny                ; $ffb7: c8        
            iny                ; $ffb8: c8        
            iny                ; $ffb9: c8        
            cpy #$7c           ; $ffba: c0 7c     
            bne __composeOAMPart1         ; $ffbc: d0 da     
			
            ldy #$80           ; $ffbe: a0 80     
__composeOAMPart1Next:     
			lda $0680,y        ; $ffc0: b9 80 06  
            clc                ; $ffc3: 18        
            adc #$ff           ; $ffc4: 69 ff     
            sta vOAMPosY,y        ; $ffc6: 99 04 06  
            ldx $0681,y        ; $ffc9: be 81 06  
            lda __spriteData2,x       ; $ffcc: bd 4c d3  
            sta vOAMTileIndex,y        ; $ffcf: 99 05 06  
            lda __spriteAtrrib2,x       ; $ffd2: bd eb d3  
            sta vOAMAttributes,y        ; $ffd5: 99 06 06  
			
			; shift sprites 8 pixels right to simulate partial drawn sprites
            lda $0683,y        ; $ffd8: b9 83 06  
            clc                ; $ffdb: 18        
            adc #$08           ; $ffdc: 69 08     
            sta vOAMPosX,y        ; $ffde: 99 07 06  
            iny                ; $ffe1: c8        
            iny                ; $ffe2: c8        
            iny                ; $ffe3: c8        
            iny                ; $ffe4: c8        
            cpy #$fc           ; $ffe5: c0 fc     
            bne __composeOAMPart1Next         ; $ffe7: d0 d7     
            rts                ; $ffe9: 60        

;-------------------------------------------------------------------------------
__dummy:     rts                ; $ffea: 60        

;-------------------------------------------------------------------------------
            .hex ff ff ff      ; $ffeb: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $ffee: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $fff1: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $fff4: ff ff ff  Invalid Opcode - ISC $ffff,x
            .hex ff ff ff      ; $fff7: ff ff ff  Invalid Opcode - ISC $ffff,x

;-------------------------------------------------------------------------------
; Vector Table
;-------------------------------------------------------------------------------
vectors:    .dw nmi                        ; $fffa: 8a fd     Vector table
            .dw reset                      ; $fffc: 27 fd     Vector table
            .dw irq                        ; $fffe: 27 fd     Vector table

;-------------------------------------------------------------------------------
; CHR-ROM
;-------------------------------------------------------------------------------
            .incbin BirdWeek.chr ; Include CHR-ROM
