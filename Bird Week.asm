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

;-------------------------------------------------------------------------------
; Variables
;-------------------------------------------------------------------------------
		; Zero-page
			; Nametable bird currently in
			vBirdPPUNametable equ $02
			; Position of bird in nametable
			vBirdPPUX equ $03
			; PPU scrolling RAM mirrors (not used)
			vPPUScrollX equ $04
			vPPUScrollY equ $05
			; RAM mirror of PPU controller register
			vPPUController equ $06
			; RAM mirror of PPU mask register
			vPPUMask equ $07
			; Random variable, increments by 3 in forever loop
			vRandomVar equ $08
			; Game cycle counter
			vCycleCounter equ $09
			; Player input variable (format is described above)
			vPlayerInput equ $0a
			; not used
			vPlayer2Input equ $0b
			; What gets drawn on left upper corner of screen
			vNestlingCountLabel equ $0f
			vNestlingOnes equ $10
			vNestling10s equ $11
			vNestling100s equ $12
			; Another random variable, increments by 1 in forever loop
			vRandomVar2 equ $17
			; these are used to build background images
			vTileXOffset equ $1c
			vTileYOffset equ $1d
			vTileAddress equ $1e
			vTileAddressHi equ $1f
			; Music state, 00 - stopped, FF - playing, writing other numbers here will play a music track
			vMusicPlayerState equ $20
			; Address of music data
			vMusicAddr equ $21
			vMusicAddrHi equ $22
			; As it says
			vMusicSpeed equ $23
			; What we load in APU length counter load registers
			vPulseLengthCounterLoad equ $24
			; music note length counter
			vMusicCounter equ $25
			; which note to play
			vMusicNote equ $26
			; used for repeating patterns of music
			vMusicOldAddr equ $27
			vMusicOldAddrHi equ $28
			vMusicRepeatPrevPattern equ $29
			; sound player state (same as music player)
			vSoundPlayerState equ $2a
			; sound data address
			vSoundAddr equ $2b
			vSoundHiAddr equ $2c
			; sound speed
			vSoundSpeed equ $2d
			; triangle counter load to write in APU register
			vTriangleLengthCounterLoad equ $2e
			; note counter used for sounds
			vSoundCounter equ $2f
			
			; array of 0x20 bytes, first 0x10 for background palettes, next 0x10 are for sprite palettes
			vPaletteData equ $30
			; current game state (menu, game loop, game over, ...)
			vGameState equ $50
			; universal counter variable
			vCounter equ $51
			; even values are "game start", odd values are "study mode" 
			vGameMode equ $52
			; universal data pointer
			vDataAddress equ $53
			vDataAddressHi equ $54
			; this counts bonus levels as well
			vCurrentLevel equ $55
			; you wish that game could give you more of these
			vBirdLives equ $56
			; timer for main menu to start demo sequence
			vMainMenuCounter equ $57
			; state of woodpecker (on tree, in flight)
			vWoodpeckerState equ $58
			; counter for dead woodpecker to control revival
			vWoodpeckerDeadTimer equ $59
			; bird is heading right
			vBirdIsRight equ $5a
			; X coord in game world
			vBirdX equ $5b
			; offset between nametable 0 and the bird, also used for 2-actor direction "vector" calculation
			vBirdOffsetX equ $5c
			; 0-left, 1-right,2-down,3-up,4-freefall
			vBirdDirection equ $5d
			; used to calculate some effects while game is in frozen state
			vGameIsFrozen equ $5e
			; how much nestlings you have fed in current round
			vRisedNestlingCount equ $5f
			; this is true when bird hits top of the screen
			vBirdHitsTop equ $60
			; no comment
			vIsBirdLanded equ $61
			; when bird flaps its wings before landing
			vIsBirdLanding equ $62
			; how much nestlings you need to feed in current round
			vNestlingMaxFeed equ $64
			; state of nestling which currently flies away
			vNestlingAwayState equ $65
			; we hit bee somehow
			vBeeIsHit equ $66
			; when kite revives after death, it rises until its altitude will become #$80
			vKiteRiseAfterDeath equ $67
			; kite changes its altitude by small amounts, these 2 variables control the change
			vKiteYChange equ $68
			vKiteMaxYChange equ $69
			; 1 - left, 0 - right
			vKiteDirection equ $6a
			; kite speed ups eventually in rounds, these 2 variables control the speed up
			vKiteSpeedTimer equ $6b
			vKiteSpeed equ $6c
			; kite lying dead counter
			vKiteDeadTimer equ $6e
			; what it says
			vIsGamePaused equ $6f
			; array of X coordinates of game actors 
			vActorX equ $70
			vBestEndingBirdX equ $70
			vBeeX equ $70
			vBigBeeX equ $71
			vBestEndingNestlingX equ $71
			vButterfly1X equ $73
			vButterfly2X equ $74
			vButterfly3X equ $75
			vButterfly4X equ $76
			vMoleX equ $77
			vKiteX1 equ $78
			vKiteX2 equ $79
			vMushroomX equ $7a
			vFoxX equ $7b
			vRisingNestlingX equ $7d
			vWoodpeckerSquirrelX equ $7e
			vInvulnCreatureX equ $7f
			vHawkX equ $80
			vFlowerX equ $81
			vSnailX equ $82
			; we hit kite somehow
			vKiteHit equ $86
			; we hit woodpecker/squirrel
			vWoodpeckerSquirrelIsHit equ $88
			; state of creature, that gives temporal invulerability (falling, running away)
			vInvulnCreatureState equ $89
			; we hit hawk
			vHawkIsHit equ $8a
			; how much bonus items are caught
			vBonusItemsCaught equ $8b
			; array of nestling states (how much they are fed)
			vNestlingStates equ $008c
			vNestling1State equ $8c
			vNestling2State equ $8d
			vNestling3State equ $8e
			; Y coordinate of game actors 
			vActorY equ $90
			vBeeY equ $90
			vBigBeeY equ $91
			vButterfly1Y equ $93
			vButterfly2Y equ $94
			vButterfly3Y equ $95
			vButterfly4Y equ $96
			vMoleY equ $97
			vKiteY1 equ $98
			vKiteY2 equ $99
			vMushroomY equ $9a
			vFoxY equ $9b
			vRisingNestlingY equ $9d
			vWoodpeckerSquirrelY equ $9e
			vInvulnCreatureY equ $9f
			vHawkY equ $a0
			vFlowerY equ $a1
			vSnailY equ $a2
			; nestling is rising at the sky
			vNestlingIsRising equ $a4
			; snail's time before it disappears
			vSnailTimer equ $a5
			; time freeze counter
			vTimeFreezeTimer equ $a6
			vTimeFreezeTimerAbs equ $00a6
			; lying dead fox timer
			vFoxDeadTimer equ $a7
			; we hit fox
			vFoxIsHit equ $a8
			; bird is currently safe and cannot be hit
			vBirdOnBranch equ $ab
			; object collision check flags
			vObjectHitFlags equ $b0
			vBeeHit equ $b0
			; this is true when nestlings are moving from right ot left in best ending scene
			vBestEnding2Loop equ $b0
			vBigBeeCollision equ $b1
			; 4 variables b3-b6 for 4 butterflies
			vButterflyXCaught equ $b3
			vMoleCollision	equ $b7
			vKiteFrontCollision equ $b8
			vKiteBackCollision equ $b9
			vMushroomCollision equ $ba
			vFoxCollision equ $bb
			vWoodpeckerSquirrelCollision equ $be
			vInvulnTimer equ $bf
			vHawkHit equ $c0
			vFlowerHit equ $c1
			vSnailHit equ $c2
			
			; lying dead hawk timer
			vHawkDeadCounter equ $c5
			; whether it dives or rises up to the sky
			vHawkState equ $c6
			; what it says
			vIsStartPressed equ $d0
			; this is used for pause screen
			vStartPressedCount equ $d1
			; bird falls or fallen already
			vBirdFallState equ $d2
			; score/bonus/delay state on score screen
			vScoreScreenState equ $d3
			; used to time "next round" screen
			vScoreScreenCounter equ $d4
			; this controls butterfly animation and movement
			vButterfly1Timer equ $d6
			vButterfly2Timer equ $d7
			vButterfly3Timer equ $d8
			vButterfly4Timer equ $d9
			vButterflyFrameTimer equ $da
			; now it's time to hit it!
			vIsMoleOnSurface equ $de
			; mole is crying timer
			vMoleDeadCounter equ $df
			; mole laughs at player timer
			vMoleOnSurfaceTimer equ $e0
			; we hold mushroom
			vMushroomEngaged equ $e7
			; used to control nestling rising animation
			vNestlingHappyTimer equ $e8
			; true when nestling dies
			vNestlingIsDead equ $e9
			; we hold butterfly
			vButterflyIsCaught equ $ea
			; we hit the mole and it starts to cry
			vMoleIsDying equ $eb
			; used to control bonus level time
			vBonusLevelTimer equ $ec
			; when music on bonus score screen ends, this variable will count a delay before next level
			vBonusScoreScreenCounter equ $f1
			; array used to display current level number
			vRoundNumberArray equ $f1
			vRoundNumber equ $f2
			; game is currently loading
			vIsGameLoading equ $f6
			; used to time loading
			vGameLoadingCounter equ $f7
			
		; 0100 - player score and program stack
			; array that holds current player score (every decimal number kept in single byte)
			vPlayerScore equ $0100
			; same, but for high score
			vHiPlayerScore equ $0110
			
		; 0200 - additional variables
			vPage200 equ $0200
			; used for butterfly animation
			vButterflyFrames equ $0200
			vNestling1Timer equ $0205
			vNestling2Timer equ $0206
			vNestling3Timer equ $0207
			; flags for killed by mushroom
			vCreatureMushroomDead equ $0210
			vBeeMushroomDead equ $0210
			vKiteMushroomDead equ $0211
			vFoxMushroomDead equ $0212
			vHawkMushroomDead equ $0213
			vWoodpeckerMushroomDead equ $0214
			
			; we hit big bee
			vBigBeeDead equ $0215
			; bird is drowning on sea bonus level
			vBirdDrownTimer equ $0227
			; these controls bonus score given for fast nestling feeding
			vNestling3000Bonus equ $0228
			vNestling2000Bonus equ $0229
			vNestling1000Bonus equ $022a
			; when a near dying nestling is fed, you won't get bonus score
			vIsNestlingNoBonus equ $022b
			; flag to control extra life achievement
			vGotExtraLife equ $0230
			; give 1000 pts for collecting >=10 bonus items
			vBonusLevelExtraScore equ $0250
			; strange counter used to control whale spawning
			vWhaleCounter equ $0252
			; we took the caterpillar bonus
			vCaterpillarTaken equ $0253
			; caterpillar is in game world
			vCaterpillarSpawned equ $0254
			; bee is turned to left
			vBeeRotateLeft equ $0255
			; used to control bee animation and movement
			vBeeFrameCounter equ $0256
			vBeeFrameTimer equ $0257
			; used to control score given for kiling creatues
			vScoreForDeadWoodpecker equ $025a
			vScoreForDeadKite equ $025b
			; bee is dead counter
			vDeadBeeTimer equ $025d
			; squirrel flags (in flight, on tree)
			vSquirrelFlags equ $0261
			; current input delay on demo sequence screen  
			vDemoPlayerInputDelay equ $0271
			; current input processed on demo sequence screen
			vDemoPlayerInput equ $0272
			; is demo playing
			vDemoSequenceActive equ $0273
			; bonus level internally lasts for 2 time loops, with main counter on $ec
			vBonusLevel2Loop equ $0274
			; used to control fox jumping
			vFoxJumpFrame equ $0290
			; and its animation
			vFoxFrameTimer equ $0291
			; same for big bee
			vBigBeeFrameCounter equ $0292
			vBigBeeTimer equ $0293
			; we killed big bee
			vBigBeeIsDead equ $0294
			; these 3 share same variable
			vDeadBigBeeCounter equ $0295  ; counter for dead big bee
			vSnailIsLeft equ $0295        ; if snail is heading left
			vStartBestEnding equ $0295    ; used to control best ending
			; when you kill with mushroom, it will respawn after 0x200 cycles
			vMushroomRecoverTimer equ $0296
			; sky changes color on best ending
			vBestEndingSkyCounter equ $02c1
			; flowers are opening on best ending
			vBestEndingFlowerCounter equ $02c2
			; playing in study mode
			vIsStudyMode equ $02e0
			; in study mode, used to hold level number player chose to play
			vStageSelect10s equ $02e1
			vStageSelectOnes equ $02e2
			; when you kill hawk or big bee, this will count and then game will spawn invuln creature
			vInvulnSpawnTimer equ $02e4
			
		; 0300 - used for building macro tiles (32x32 pixels)
			vBonusItemCounter equ $0310
		; 0600 - OAM copy in RAM, used for DMA upload
			vOAMTable equ $0600
			vOAMPosY equ $0604
			vOAMTileIndex equ $0605
			vOAMAttributes equ $0606
			vOAMPosX equ $0607
			
		; 0700
			; sptite table, same as OAM table, but uses its own internal sprite numbers, which are later converted to OAM format
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
			
			; Sprite DMA controller
			OAMDMA equ $4014
			; Joysticks
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
			.hex 21 18 36 26   																		; $c000: 21 18 36 26   Data
			.hex 21 30 30 17   																		; $c004: 21 30 30 17   Data
			.hex 21 30 30 17   																		; $c008: 21 30 30 17   Data
			.hex 21 11 30 17   																		; $c00c: 21 11 30 17   Data
			.hex 21 12 30 17   																		; $c010: 21 12 30 17   Data
			.hex 21 0f 0f 0f   																		; $c014: 21 0f 0f 0f   Data
			.hex 21 0f 0f 0f   																		; $c018: 21 0f 0f 0f   Data
			.hex 21 0f 0f 0f   																		; $c01c: 21 0f 0f 0f   Data
__copyProtectionValues:     
			.hex f0            																		; $c020: f0            Data
__copyProtectionValues2:     
			.hex 0f 13 3f 00   																		; $c021: 0f 13 3f 00   Data
			.hex 01 02 03 04   																		; $c025: 01 02 03 04   Data
			.hex 05 06 07 08   																		; $c029: 05 06 07 08   Data
			.hex 09 0a 0b      																		; $c02d: 09 0a 0b      Data
__initAPUshowGraphics:     
			jmp ___initAPUshowGraphics         																		; $c030: 4c 52 f6  

;-------------------------------------------------------------------------------
; called every NMI interrupt, chooses game state and processes it
__processGameState:     
			lda vGameState            																		; $c033: a5 50  
			
				; is game starting
				beq __initGame         																		; $c035: f0 3d     
			; is main menu
			cmp #$01           																		; $c037: c9 01     
				beq __mainMenuLoop         																		; $c039: f0 3c     
			
			; is "Round X" label
			cmp #$02           																		; $c03b: c9 02     
				beq __gameLoadingLoop         																		; $c03d: f0 41    
			
			; is game loop
			cmp #$03           																		; $c03f: c9 03     
				beq __gameLoop         																		; $c041: f0 2e     
			; game over or dead nestling
			cmp #$04           																		; $c043: c9 04     
				beq __handleGameOver         																		; $c045: f0 15   
			; when real game over happens
			cmp #$05           																		; $c047: c9 05     
				beq __handleRealGameOver         																		; $c049: f0 14 
			; game freeze (bird is dead or nestling is rising)
			cmp #$ff           																		; $c04b: c9 ff     
				beq __handleGameFreeze         																		; $c04d: f0 13     
			; score screen
			cmp #$fe           																		; $c04f: c9 fe     
				beq __scoreScreenLoop         																		; $c051: f0 12     
			; f******cking best ending (bestyding)
			cmp #$fc           																		; $c053: c9 fc     
				beq __bestEndingLoop         																		; $c055: f0 14  
			
			; study mode
			cmp #$fb           																		; $c057: c9 fb     
				beq __studyModeStageSelectLoop         																		; $c059: f0 13    
			
			; have you done playing?
			rts                																		; $c05b: 60        

;-------------------------------------------------------------------------------
__handleGameOver:     jmp ___handleGameOver         																		; $c05c: 4c 67 f4  

;-------------------------------------------------------------------------------
__handleRealGameOver:     jmp ___handleRealGameOver         																		; $c05f: 4c a2 f5  

;-------------------------------------------------------------------------------
__handleGameFreeze:     jmp ___handleGameFreeze         																		; $c062: 4c 0a c6  

;-------------------------------------------------------------------------------
__scoreScreenLoop:     jmp ___scoreScreenLoop         																		; $c065: 4c 89 c8  

;-------------------------------------------------------------------------------
__processBestEnding:     jmp ___processBestEnding         																		; $c068: 4c 21 d7  

;-------------------------------------------------------------------------------
__bestEndingLoop:     jmp ___bestEndingLoop         																		; $c06b: 4c 1b d7  

;-------------------------------------------------------------------------------
__studyModeStageSelectLoop:     jmp ___studyModeStageSelectLoop         																		; $c06e: 4c 5e cc  

;-------------------------------------------------------------------------------
__gameLoop:     jmp ___gameLoop         																		; $c071: 4c a6 c0  

;-------------------------------------------------------------------------------
__initGame:     jmp ___initGame         																		; $c074: 4c 5b e1  

;-------------------------------------------------------------------------------
__mainMenuLoop:     
			jsr __mainMenuHandleSelect         																		; $c077: 20 15 cb  
			jsr __drawMainMenuBird         																		; $c07a: 20 2b cb  
			jmp __handleMainMenu         																		; $c07d: 4c 66 cb  

;-------------------------------------------------------------------------------
__gameLoadingLoop:     jmp ___gameLoadingLoop         																		; $c080: 4c 5b c1  

;-------------------------------------------------------------------------------
__initGameLoop:     jmp ___initGameLoop         																		; $c083: 4c 7c e2  

;-------------------------------------------------------------------------------
___initGameLoop2:     
			jsr __updateNestlings         																		; $c086: 20 09 c3  
			jsr __show3rdNestlingPlace         																		; $c089: 20 2d f6  
			jsr __initGameActors         																		; $c08c: 20 35 cd  
			jsr __showNestlingCountLabel         																		; $c08f: 20 df c1  
			jsr __showSprites         																		; $c092: 20 e0 fd  
			lda vGameState            																		; $c095: a5 50     
			cmp #$01           																		; $c097: c9 01     
				beq __skipSetRoundXState         																		; $c099: f0 02     
			inc vGameState            																		; $c09b: e6 50     
__skipSetRoundXState:     
			jsr __scrollScreen         																		; $c09d: 20 b6 fd  
			jsr __skipSomeLogic         																		; $c0a0: 20 d0 c0  
			jmp __enableNMI         																		; $c0a3: 4c c6 fe  

;-------------------------------------------------------------------------------
___gameLoop:     
			jsr __handleStartButton         																		; $c0a6: 20 2c c2  
			jmp __handleGameLoop         																		; $c0a9: 4c 48 c2  

;-------------------------------------------------------------------------------
; the whole ingame frame is processed here
___processGameFrame:     
			lda vGameState            																		; $c0ac: a5 50     
			cmp #$fc           																		; $c0ae: c9 fc     
				; best ending has separate handler
				beq __processBestEnding         																		; $c0b0: f0 b6     
			jsr __updateNestlings         																		; $c0b2: 20 09 c3  
			jsr __drawScoreLabel         																		; $c0b5: 20 91 ca  
			jsr __setSprite0         																		; $c0b8: 20 18 f6  
			jsr __statusBarSprite0Timing         																		; $c0bb: 20 e8 f5  
			jsr __increaseNestlingTimers         																		; $c0be: 20 b6 c2  
			jsr __checkFrozenGameState         																		; $c0c1: 20 44 c4  
			jsr __checkActorCollision         																		; $c0c4: 20 54 c4  
			jsr __checkMushroomKilled         																		; $c0c7: 20 d9 c4  
			jsr __checkHitActors         																		; $c0ca: 20 82 c5  
			jsr __checkFedNestlings         																		; $c0cd: 20 f6 c2  
__skipSomeLogic:     
			lda vGameIsFrozen            																		; $c0d0: a5 5e     
				bne __skipGameLogic         																		; $c0d2: d0 48 
			; lda vTimeFreezeTimerAbs
			.hex ad a6 00      																		; $c0d4: ad a6 00  Bad Addr Mode - LDA vTimeFreezeTimerAbs
				; skip most of the game logic when snail is collected
				bne __handleTimeFreezeLogic         																		; $c0d7: d0 2e     
			jsr __levelModulo4ToX         																		; $c0d9: 20 5e c3  
			cpx #$03           																		; $c0dc: e0 03     
				beq __handleBonusLevel         																		; $c0de: f0 1e     
			jsr __handleKite         																		; $c0e0: 20 03 d5  
			jsr __handleMushroom         																		; $c0e3: 20 84 dc  
			jsr __handleWoodpecker         																		; $c0e6: 20 6c f2  
			jsr __handleMole         																		; $c0e9: 20 81 d6  
			jsr __handleBee         																		; $c0ec: 20 1b df  
			jsr __handleSquirrel         																		; $c0ef: 20 e5 dc  
			jsr __handleFox         																		; $c0f2: 20 e0 dd  
			jsr __handleInvulnCreatures         																		; $c0f5: 20 6b ee  
			jsr __handleHawk         																		; $c0f8: 20 05 f0  
			jsr __handleBigBee         																		; $c0fb: 20 9b f3  
__handleBonusLevel:     
			jsr __handleTreeBonusLevel         																		; $c0fe: 20 39 db  
			jsr __handleSeaBonusLevel         																		; $c101: 20 58 da  
			jsr __handleSecretCreatures         																		; $c104: 20 59 f6  
__handleTimeFreezeLogic:     
			jsr __handleSnail         																		; $c107: 20 9d f1  
			jsr __handleFlowers         																		; $c10a: 20 0d f1  
			jsr __handleButterflies         																		; $c10d: 20 9e d8  
			jsr __drawGameActors         																		; $c110: 20 8a d4  
			jsr __handleBirdFlags         																		; $c113: 20 54 cf  
			jsr __handleBirdFlight         																		; $c116: 20 f5 cf  
			jsr __handleInvulerability         																		; $c119: 20 69 ef  
__skipGameLogic:     
			jsr __drawLives         																		; $c11c: 20 bc ca  
			jsr __handleGameMusic         																		; $c11f: 20 28 c1  
__frozenGameLoop:     
			jsr __handleMusicAndSound         																		; $c122: 20 dd f6  
			jmp __composeOAMTable         																		; $c125: 4c 3b ff  

;-------------------------------------------------------------------------------
__handleGameMusic:     
			lda vDemoSequenceActive          																		; $c128: ad 73 02  
				bne __return22         																		; $c12b: d0 1e     
			lda vGameIsFrozen            																		; $c12d: a5 5e     
				bne __playFrozenGameMusic         																		; $c12f: d0 1b     
			lda vMusicPlayerState            																		; $c131: a5 20     
				bne __return22         																		; $c133: d0 16     
			lda vInvulnTimer            																		; $c135: a5 bf     
				bne __playInvulnMusic         																		; $c137: d0 18     
				
			lda vCurrentLevel            																		; $c139: a5 55     
			and #$0f           																		; $c13b: 29 0f     
			cmp #$07           																		; $c13d: c9 07     
				beq __playBonusLevelMusic         																		; $c13f: f0 15     
			cmp #$0f           																		; $c141: c9 0f     
				beq __playBonusLevelMusic         																		; $c143: f0 11 
			; play ordinary or sea bonus level music
			jsr __levelModulo4ToX         																		; $c145: 20 5e c3  
			inx                																		; $c148: e8        
			stx vMusicPlayerState            																		; $c149: 86 20     
__return22:     
			rts                																		; $c14b: 60        

;-------------------------------------------------------------------------------
__playFrozenGameMusic:     
			lda #$00           																		; $c14c: a9 00     
__playMusicFromA:     
			sta vMusicPlayerState            																		; $c14e: 85 20     
			rts                																		; $c150: 60        

;-------------------------------------------------------------------------------
__playInvulnMusic:     
			lda #$10           																		; $c151: a9 10     
			jmp __playMusicFromA         																		; $c153: 4c 4e c1  

;-------------------------------------------------------------------------------
__playBonusLevelMusic:     
			lda #$11           																		; $c156: a9 11     
			jmp __playMusicFromA         																		; $c158: 4c 4e c1  

;-------------------------------------------------------------------------------
___gameLoadingLoop:     
			lda vIsGameLoading            																		; $c15b: a5 f6     
				beq __initGameLoading         																		; $c15d: f0 0c     
			lda vGameLoadingCounter            																		; $c15f: a5 f7  
			; wait for 0x40 cycles on "Round X" screen
			cmp #$40           																		; $c161: c9 40     
				bne __incGameLoadingCounter         																		; $c163: d0 03     
			
			jmp __initGameLoop         																		; $c165: 4c 83 c0  

;-------------------------------------------------------------------------------
__incGameLoadingCounter:     
			inc vGameLoadingCounter            																		; $c168: e6 f7     
			rts                																		; $c16a: 60        

;-------------------------------------------------------------------------------
__initGameLoading:     
			lda vIsStudyMode          																		; $c16b: ad e0 02  
				bne __gameLoadingDone         																		; $c16e: d0 3d     
			jsr __handleRoundSelectScoreScreen         																		; $c170: 20 da e3  
			lda vCurrentLevel            																		; $c173: a5 55     
			and #$03           																		; $c175: 29 03     
			cmp #$03           																		; $c177: c9 03     
				; if bonus round, display "bonus round"
				beq __drawBonusRoundLabel         																		; $c179: f0 35    
			
			ldx #$00           																		; $c17b: a2 00     
			stx vScoreScreenState            																		; $c17d: 86 d3     
			jsr __setRoundLabelPosition         																		; $c17f: 20 d4 c1  
__drawRoundXLabelLoop:     
			lda __roundXLabel,x       																		; $c182: bd 21 c2  
			sta ppuData          																		; $c185: 8d 07 20  
			inx                																		; $c188: e8        
			cpx #$08           																		; $c189: e0 08     
			bne __drawRoundXLabelLoop         																		; $c18b: d0 f5    
			
			ldx #$03           																		; $c18d: a2 03     
__drawRoundNumberLoop:     
			lda vRoundNumberArray,x          																		; $c18f: b5 f1     
				bne __drawRoundActualNumberLoop         																		; $c191: d0 10     
			lda #$24           																		; $c193: a9 24     
			sta ppuData          																		; $c195: 8d 07 20  
			dex                																		; $c198: ca        
				bne __drawRoundNumberLoop         																		; $c199: d0 f4     
				
__drawRoundNumberEnd:     
			inc vIsGameLoading            																		; $c19b: e6 f6     
			jsr __scrollScreen         																		; $c19d: 20 b6 fd  
			jmp __enableNMI         																		; $c1a0: 4c c6 fe  

;-------------------------------------------------------------------------------
__drawRoundActualNumberLoop:     
			lda vRoundNumberArray,x          																		; $c1a3: b5 f1     
			sta ppuData          																		; $c1a5: 8d 07 20  
			dex                																		; $c1a8: ca        
				bne __drawRoundActualNumberLoop         																		; $c1a9: d0 f8     
				beq __drawRoundNumberEnd         																		; $c1ab: f0 ee     
__gameLoadingDone:     
			inc vIsGameLoading            																		; $c1ad: e6 f6     
			rts                																		; $c1af: 60        

;-------------------------------------------------------------------------------
__drawBonusRoundLabel:     
			jsr __clearXY         																		; $c1b0: 20 16 d7  
			jsr __setRoundLabelPosition         																		; $c1b3: 20 d4 c1  
__drawBonusLabelLoop:     
			lda __bonusLabel,x       																		; $c1b6: bd 3e ca  
			sta ppuData          																		; $c1b9: 8d 07 20  
			inx                																		; $c1bc: e8        
			cpx #$06           																		; $c1bd: e0 06     
			bne __drawBonusLabelLoop         																		; $c1bf: d0 f5     
			
__drawRoundLabelLoop:     
			lda __roundXLabel,y       																		; $c1c1: b9 21 c2  
			sta ppuData          																		; $c1c4: 8d 07 20  
			iny                																		; $c1c7: c8        
			cpy #$05           																		; $c1c8: c0 05     
			bne __drawRoundLabelLoop         																		; $c1ca: d0 f5     
			
			inc vIsGameLoading            																		; $c1cc: e6 f6     
			jsr __scrollScreen         																		; $c1ce: 20 b6 fd  
			jmp __enableNMI         																		; $c1d1: 4c c6 fe  

;-------------------------------------------------------------------------------
__setRoundLabelPosition:     
			lda #$20           																		; $c1d4: a9 20     
			sta ppuAddress          																		; $c1d6: 8d 06 20  
			lda #$ca           																		; $c1d9: a9 ca     
			sta ppuAddress          																		; $c1db: 8d 06 20  c
			rts                																		; $c1de: 60        

;-------------------------------------------------------------------------------
__showNestlingCountLabel:     
			jsr __levelModulo4ToX         																		; $c1df: 20 5e c3  
			cpx #$03           																		; $c1e2: e0 03     
				; don't display in bonus level
				beq __return10         																		; $c1e4: f0 22     
			; set position
			lda #$20           																		; $c1e6: a9 20     
			sta ppuAddress          																		; $c1e8: 8d 06 20  
			lda #$65           																		; $c1eb: a9 65     
			sta ppuAddress          																		; $c1ed: 8d 06 20  
			
			ldx #$03           																		; $c1f0: a2 03     
__showNestlingCountLabelLoop:     
			lda vNestlingCountLabel,x          																		; $c1f2: b5 0f     
			bne __showNestlingCountLabelLoop2         																		; $c1f4: d0 0a     
			lda #$24           																		; $c1f6: a9 24     
			sta ppuData          																		; $c1f8: 8d 07 20  
			dex                																		; $c1fb: ca        
			cpx #$01           																		; $c1fc: e0 01     
			bne __showNestlingCountLabelLoop         																		; $c1fe: d0 f2     
			
__showNestlingCountLabelLoop2:     
			lda vNestlingCountLabel,x          																		; $c200: b5 0f     
			sta ppuData          																		; $c202: 8d 07 20  
			dex                																		; $c205: ca        
			bne __showNestlingCountLabelLoop2         																		; $c206: d0 f8     
__return10:     
			rts                																		; $c208: 60        

;-------------------------------------------------------------------------------
__increaseNestlingCount:     
			ldx #$00           																		; $c209: a2 00     
__increaseNestlingCountLoop:     
			lda vNestlingOnes,x          																		; $c20b: b5 10     
			clc                																		; $c20d: 18        
			adc #$01           																		; $c20e: 69 01     
			cmp #$0a           																		; $c210: c9 0a     
			bne __storeNestlingCount         																		; $c212: d0 0a     
			lda #$00           																		; $c214: a9 00     
			sta vNestlingOnes,x          																		; $c216: 95 10     
			inx                																		; $c218: e8        
			cpx #$03           																		; $c219: e0 03     
			bne __increaseNestlingCountLoop         																		; $c21b: d0 ee     
			rts                																		; $c21d: 60        

;-------------------------------------------------------------------------------
__storeNestlingCount:     
			sta vNestlingOnes,x          																		; $c21e: 95 10     
			rts                																		; $c220: 60        

;-------------------------------------------------------------------------------
__roundXLabel:     
			.hex 1b 18 1e 17   																		; $c221: 1b 18 1e 17   Data
			.hex 0d 24 24 24   																		; $c225: 0d 24 24 24   Data
__3rdNestlingPlaceTilePos:     
			.hex dd df db      																		; $c229: dd df db      Data

;-------------------------------------------------------------------------------
__handleStartButton:     
			lda vCycleCounter            																		; $c22c: a5 09     
			and #$07           																		; $c22e: 29 07     
				bne __return4         																		; $c230: d0 15     
			lda vPlayerInput            																		; $c232: a5 0a     
			and #$08           																		; $c234: 29 08     
				bne __pressStart         																		; $c236: d0 05     
			lda #$00           																		; $c238: a9 00     
			sta vIsStartPressed            																		; $c23a: 85 d0     
			rts                																		; $c23c: 60        

;-------------------------------------------------------------------------------
__pressStart:     
			lda vIsStartPressed            																		; $c23d: a5 d0     
				bne __return4         																		; $c23f: d0 06     
			inc vStartPressedCount            																		; $c241: e6 d1     
			lda #$01           																		; $c243: a9 01     
			sta vIsStartPressed            																		; $c245: 85 d0     
__return4:     
			rts                																		; $c247: 60        

;-------------------------------------------------------------------------------
__handleGameLoop:     
			lda vStartPressedCount            																		; $c248: a5 d1     
			and #$01           																		; $c24a: 29 01     
				bne __unPauseGame         																		; $c24c: d0 35     
			lda vIsGamePaused            																		; $c24e: a5 6f     
				bne __showPauseLabel         																		; $c250: d0 23     
			inc vIsGamePaused            																		; $c252: e6 6f     
			jsr __pauseSpriteTiming         																		; $c254: 20 9f c2  
			lda vGameState            																		; $c257: a5 50     
			cmp #$fc           																		; $c259: c9 fc     
				beq __playPauseSound         																		; $c25b: f0 11  
				
			; hide all enemies on pause
			jsr __clearXY         																		; $c25d: 20 16 d7  
			lda #$f0           																		; $c260: a9 f0     
__hideActorsOnPause:     
			sta $0704,x        																		; $c262: 9d 04 07  
			inx                																		; $c265: e8        
			inx                																		; $c266: e8        
			inx                																		; $c267: e8        
			inx                																		; $c268: e8        
			iny                																		; $c269: c8        
			cpy #$13           																		; $c26a: c0 13     
			bne __hideActorsOnPause         																		; $c26c: d0 f4     
__playPauseSound:     
			lda #$05           																		; $c26e: a9 05     
			sta vMusicPlayerState            																		; $c270: 85 20     
			jmp __frozenGameLoop         																		; $c272: 4c 22 c1  

;-------------------------------------------------------------------------------
__showPauseLabel:     
			lda #$40           																		; $c275: a9 40     
			sta $0764          																		; $c277: 8d 64 07  
			sta $0768          																		; $c27a: 8d 68 07  
			sta $076c          																		; $c27d: 8d 6c 07  
			jmp __processPausedGame         																		; $c280: 4c 8b c2  

;-------------------------------------------------------------------------------
__unPauseGame:     
			lda vIsGamePaused            																		; $c283: a5 6f     
				beq __hidePauseLabel         																		; $c285: f0 0a     
			lda #$00           																		; $c287: a9 00     
			sta vIsGamePaused            																		; $c289: 85 6f     
			
__processPausedGame:     
			jsr __pauseSpriteTiming         																		; $c28b: 20 9f c2  
			jmp __frozenGameLoop         																		; $c28e: 4c 22 c1  

;-------------------------------------------------------------------------------
__hidePauseLabel:     
			lda #$f0           																		; $c291: a9 f0     
			sta $0764          																		; $c293: 8d 64 07  
			sta $0768          																		; $c296: 8d 68 07  
			sta $076c          																		; $c299: 8d 6c 07  
			jmp ___processGameFrame         																		; $c29c: 4c ac c0  

;-------------------------------------------------------------------------------
__pauseSpriteTiming:     
			lda vGameState            																		; $c29f: a5 50     
			cmp #$fc           																		; $c2a1: c9 fc     
				beq __restartBestEnding         																		; $c2a3: f0 0b     
			ldx #$00           																		; $c2a5: a2 00     
__slightDelay:     
			dex                																		; $c2a7: ca        
				bne __slightDelay         																		; $c2a8: d0 fd     
			jsr __setSprite0         																		; $c2aa: 20 18 f6  
			jmp __statusBarSprite0Timing         																		; $c2ad: 4c e8 f5  

;-------------------------------------------------------------------------------
; what a hacky way to restart best ending scene in case of pause
__restartBestEnding:     
			lda #$00           																		; $c2b0: a9 00     
			sta vStartBestEnding          																		; $c2b2: 8d 95 02  
			rts                																		; $c2b5: 60        

;-------------------------------------------------------------------------------
__increaseNestlingTimers:     
			jsr __levelModulo4ToX         																		; $c2b6: 20 5e c3  
			cpx #$03           																		; $c2b9: e0 03     
				; for bonus levels, check time elapsed
				beq __checkBonusLevelTime         																		; $c2bb: f0 2c     
				
			lda vCycleCounter            																		; $c2bd: a5 09     
			and #$0f           																		; $c2bf: 29 0f     
				bne __return17         																		; $c2c1: d0 2b     

			ldx #$00           																		; $c2c3: a2 00     
__checkNestlingTimer:     
			lda vNestling1State,x          																		; $c2c5: b5 8c     
			cmp vNestlingAwayState            																		; $c2c7: c5 65     
				beq __increaseNextNestling         																		; $c2c9: f0 03     
			inc vNestling1Timer,x        																		; $c2cb: fe 05 02  
			
__increaseNextNestling:     
			lda vCurrentLevel            																		; $c2ce: a5 55     
			cmp #$10           																		; $c2d0: c9 10     
				bcc __only2Nestlings         																		; $c2d2: 90 1b     
			inx                																		; $c2d4: e8        
			cpx #$03           																		; $c2d5: e0 03     
				bne __checkNestlingTimer         																		; $c2d7: d0 ec   
				
__checkDeadNestlings:     
			ldx #$00           																		; $c2d9: a2 00     
__checkDeadNestlingsLoop:     
			lda vNestling1Timer,x        																		; $c2db: bd 05 02  
			cmp #$ff           																		; $c2de: c9 ff     
				beq __nestlingDie         																		; $c2e0: f0 0a     
			inx                																		; $c2e2: e8        
			cpx #$03           																		; $c2e3: e0 03     
				bne __checkDeadNestlingsLoop         																		; $c2e5: d0 f4     
			beq __return17         																		; $c2e7: f0 05     
			
__checkBonusLevelTime:     jmp ___checkBonusLevelTime         																		; $c2e9: 4c fe df  

;-------------------------------------------------------------------------------
__nestlingDie:     
			inc vGameState            																		; $c2ec: e6 50     
__return17:     
			rts                																		; $c2ee: 60        

__only2Nestlings:     
			inx                																		; $c2ef: e8        
			cpx #$02           																		; $c2f0: e0 02     
				bne __checkNestlingTimer         																		; $c2f2: d0 d1     
				beq __checkDeadNestlings         																		; $c2f4: f0 e3     
			
;-------------------------------------------------------------------------------		
__checkFedNestlings:     
			ldx #$00           																		; $c2f6: a2 00     
__checkFedNestlingsLoop:     
			lda vNestling1State,x          																		; $c2f8: b5 8c     
			cmp vNestlingMaxFeed            																		; $c2fa: c5 64     
				beq __anotherFedNestling         																		; $c2fc: f0 06     
__checkFedNestlingsNext:     
			inx                																		; $c2fe: e8        
			cpx #$03           																		; $c2ff: e0 03     
				bne __checkFedNestlingsLoop         																		; $c301: d0 f5     
			rts                																		; $c303: 60        

;-------------------------------------------------------------------------------
__anotherFedNestling:     
			inc vGameIsFrozen            																		; $c304: e6 5e     
			jmp __checkFedNestlingsNext         																		; $c306: 4c fe c2  

;-------------------------------------------------------------------------------
__updateNestlings:     
			jsr __setPPUIncrementBy32         																		; $c309: 20 e4 fe  
			jsr __levelModulo4ToX         																		; $c30c: 20 5e c3  
			cpx #$03           																		; $c30f: e0 03     
				; bonus level
				beq __return11         																		; $c311: f0 09     
			jsr __updateNestling1         																		; $c313: 20 1f c3  
			jsr __updateNestling2         																		; $c316: 20 33 c3  
			jsr __updateNestling3         																		; $c319: 20 46 c3  
__return11:     
			jmp __setPPUIncrementBy1         																		; $c31c: 4c da fe  

;-------------------------------------------------------------------------------
__updateNestling1:     
			lda #$21           																		; $c31f: a9 21     
			sta vDataAddress            																		; $c321: 85 53     
			ldy #$00           																		; $c323: a0 00     
			lda vNestling1State            																		; $c325: a5 8c     
			cmp vNestlingAwayState            																		; $c327: c5 65     
				beq __return5         																		; $c329: f0 1a     
			lda __nestling1Pos,x       																		; $c32b: bd 64 c3  
			sta vDataAddressHi            																		; $c32e: 85 54     
			jmp __updateNestlingState         																		; $c330: 4c 6d c3  

;-------------------------------------------------------------------------------
__updateNestling2:     
			iny                																		; $c333: c8        
			lda vNestling2State            																		; $c334: a5 8d     
			cmp vNestlingAwayState            																		; $c336: c5 65     
				beq __return5         																		; $c338: f0 0b     
			jsr __levelModulo4ToX         																		; $c33a: 20 5e c3  
			lda __nestling2Pos,x       																		; $c33d: bd 67 c3  
			sta vDataAddressHi            																		; $c340: 85 54     
			jsr __updateNestlingState         																		; $c342: 20 6d c3  
__return5:     
			rts                																		; $c345: 60        

;-------------------------------------------------------------------------------
__updateNestling3:     
			lda vCurrentLevel            																		; $c346: a5 55     
			; 3rd nestling only on level >=13
			cmp #$10           																		; $c348: c9 10     
				bcc __return5         																		; $c34a: 90 f9     
			iny                																		; $c34c: c8        
			lda vNestling3State            																		; $c34d: a5 8e     
			cmp vNestlingAwayState            																		; $c34f: c5 65     
				beq __return5         																		; $c351: f0 f2     
			jsr __levelModulo4ToX         																		; $c353: 20 5e c3  
			lda __nestling3Pos,x       																		; $c356: bd 6a c3  
			sta vDataAddressHi            																		; $c359: 85 54     
			jmp __updateNestlingState         																		; $c35b: 4c 6d c3  

;-------------------------------------------------------------------------------
; gets modulo 4 of current level
__levelModulo4ToX:     
			lda vCurrentLevel            																		; $c35e: a5 55     
			and #$03           																		; $c360: 29 03     
			tax                																		; $c362: aa        
			rts                																		; $c363: 60        

;-------------------------------------------------------------------------------
__nestling1Pos:     
			.hex d0 98 88      																		; $c364: d0 98 88      Data
__nestling2Pos:     
			.hex d2 9a 8a      																		; $c367: d2 9a 8a      Data
__nestling3Pos:     
			.hex d4 9c 8c      																		; $c36a: d4 9c 8c      Data

;-------------------------------------------------------------------------------
__updateNestlingState:
			jsr __setPPUAddressFromData         																		; $c36d: 20 04 c4  
			lda vNestling1Timer,y        																		; $c370: b9 05 02  
			cmp #$40           																		; $c373: c9 40     
				bcc __setNestlingFed         																		; $c375: 90 33     
			cmp #$a0           																		; $c377: c9 a0     
				bcc __setNestlingSlightlyHungry         																		; $c379: 90 0a     
			cmp #$e0           																		; $c37b: c9 e0     
				bcc __setNestlingHungry         																		; $c37d: 90 25     
			cmp #$f0           																		; $c37f: c9 f0     
				bcc __setNestlingDying1         																		; $c381: 90 31     
				bcs __setNestlingDying2         																		; $c383: b0 2a     
__setNestlingSlightlyHungry:     
			jsr __setXEvery8Cycle         																		; $c385: 20 8b d0  
__updateNestlingFrame:     
			lda __nestlingFrame1,x       																		; $c388: bd b9 c3  
			sta ppuData          																		; $c38b: 8d 07 20  
			lda __nestlingFrame2,x       																		; $c38e: bd bf c3  
			sta ppuData          																		; $c391: 8d 07 20  
			jsr __setPPUAddressIncrementFromData         																		; $c394: 20 0f c4  
			lda __nestlingFrame3,x       																		; $c397: bd c5 c3  
			sta ppuData          																		; $c39a: 8d 07 20  
			lda __nestlingFrame4,x       																		; $c39d: bd cb c3  
			sta ppuData          																		; $c3a0: 8d 07 20  
			rts                																		; $c3a3: 60        

;-------------------------------------------------------------------------------
__setNestlingHungry:     
			jsr __setXEvery4Cycle         																		; $c3a4: 20 93 d0  
			jmp __updateNestlingFrame         																		; $c3a7: 4c 88 c3  

;-------------------------------------------------------------------------------
__setNestlingFed:     
			ldx #$00           																		; $c3aa: a2 00     
			jmp __updateNestlingFrame         																		; $c3ac: 4c 88 c3  

;-------------------------------------------------------------------------------
__setNestlingDying2:     
			ldx #$05           																		; $c3af: a2 05     
			jmp __updateNestlingFrame         																		; $c3b1: 4c 88 c3  

;-------------------------------------------------------------------------------
__setNestlingDying1:     
			ldx #$04           																		; $c3b4: a2 04     
			jmp __updateNestlingFrame         																		; $c3b6: 4c 88 c3  

;-------------------------------------------------------------------------------
; Nestling 4-frame animation
__nestlingFrame1:     
			.hex e0 e4 ec e8   																		; $c3b9: e0 e4 ec e8   Data
			.hex 7e 7e         																		; $c3bd: 7e 7e         Data
__nestlingFrame2:     
			.hex e1 e5 ed e9   																		; $c3bf: e1 e5 ed e9   Data
			.hex f1 f0         																		; $c3c3: f1 f0         Data
__nestlingFrame3:     
			.hex e2 e6 ee ea   																		; $c3c5: e2 e6 ee ea   Data
			.hex 7e 7e         																		; $c3c9: 7e 7e         Data
__nestlingFrame4:     
			.hex e3 e7 ef eb   																		; $c3cb: e3 e7 ef eb   Data
			.hex f3 f2         																		; $c3cf: f3 f2         Data

;-------------------------------------------------------------------------------
__updateNestlingFedFrame:     
			jsr __setPPUIncrementBy32         																		; $c3d1: 20 e4 fe  
			jsr __setPPUAddressFromData         																		; $c3d4: 20 04 c4  
			lda ___nestlingFrame1,x       																		; $c3d7: bd 1c c4  
			sta ppuData          																		; $c3da: 8d 07 20  
			lda ___nestlingFrame2,x       																		; $c3dd: bd 26 c4  
			sta ppuData          																		; $c3e0: 8d 07 20  
			jsr __setPPUAddressIncrementFromData         																		; $c3e3: 20 0f c4  
			lda ___nestlingFrame3,x       																		; $c3e6: bd 30 c4  
			sta ppuData          																		; $c3e9: 8d 07 20  
			lda ___nestlingFrame4,x       																		; $c3ec: bd 3a c4  
			sta ppuData          																		; $c3ef: 8d 07 20  
			jsr __setPPUIncrementBy1         																		; $c3f2: 20 da fe  
			jsr __scrollScreen         																		; $c3f5: 20 b6 fd  
			
			; freeze game
			lda vGameState            																		; $c3f8: a5 50     
			cmp #$ff           																		; $c3fa: c9 ff     
				bne ___frozenGameLoop         																		; $c3fc: d0 03     
			jsr __pauseSpriteTiming         																		; $c3fe: 20 9f c2  
___frozenGameLoop:     
			jmp __frozenGameLoop         																		; $c401: 4c 22 c1  

;-------------------------------------------------------------------------------
__setPPUAddressFromData:     
			lda vDataAddress            																		; $c404: a5 53     
			sta ppuAddress          																		; $c406: 8d 06 20  
			lda vDataAddressHi            																		; $c409: a5 54     
			sta ppuAddress          																		; $c40b: 8d 06 20  
			rts                																		; $c40e: 60        

;-------------------------------------------------------------------------------
__setPPUAddressIncrementFromData:     
			lda vDataAddress            																		; $c40f: a5 53     
			sta ppuAddress          																		; $c411: 8d 06 20  
			inc vDataAddressHi            																		; $c414: e6 54     
			lda vDataAddressHi            																		; $c416: a5 54     
			sta ppuAddress          																		; $c418: 8d 06 20  
			rts                																		; $c41b: 60        

;-------------------------------------------------------------------------------
___nestlingFrame1:     
			.hex e0 e4 ec e8   																		; $c41c: e0 e4 ec e8   Data
			.hex f4 fc f8 fc   																		; $c420: f4 fc f8 fc   Data
			.hex 7e 7a         																		; $c424: 7e 7a         Data
___nestlingFrame2:     
			.hex e1 e5 ed e9   																		; $c426: e1 e5 ed e9   Data
			.hex f5 fd f9 fd   																		; $c42a: f5 fd f9 fd   Data
			.hex 7e 7a         																		; $c42e: 7e 7a         Data
___nestlingFrame3:     
			.hex e2 e6 ee ea   																		; $c430: e2 e6 ee ea   Data
			.hex f6 fe fa fe   																		; $c434: f6 fe fa fe   Data
			.hex 7e 7a         																		; $c438: 7e 7a         Data
___nestlingFrame4:     
			.hex e3 e7 ef eb   																		; $c43a: e3 e7 ef eb   Data
			.hex f7 ff fb ff   																		; $c43e: f7 ff fb ff   Data
			.hex 7e 7a         																		; $c442: 7e 7a         Data

;-------------------------------------------------------------------------------
; checks if game should be frozen (bird is dead, nestling is rising)
__checkFrozenGameState:     
			lda vGameIsFrozen            																		; $c444: a5 5e     
				bne __setFrozenGameState         																		; $c446: d0 01     
			rts                																		; $c448: 60        

;-------------------------------------------------------------------------------
__setFrozenGameState:     
			lda #$ff           																		; $c449: a9 ff     
			sta vGameState            																		; $c44b: 85 50     
			lda #$00           																		; $c44d: a9 00     
			sta vMusicPlayerState            																		; $c44f: 85 20     
			sta vSoundPlayerState            																		; $c451: 85 2a     
			rts                																		; $c453: 60        

;-------------------------------------------------------------------------------
__checkActorCollision:     
			lda vBirdOnBranch            																		; $c454: a5 ab     
				bne __return24         																		; $c456: d0 49     
				
			ldx #$00           																		; $c458: a2 00     
__checkThisActorCollision:     
			lda vActorX,x          																		; $c45a: b5 70     
			sta vBirdOffsetX            																		; $c45c: 85 5c     
			jsr __setBirdOffsetX         																		; $c45e: 20 e5 d4  
			
			lda vBirdOffsetX            																		; $c461: a5 5c     
			tay                																		; $c463: a8        
			and #$01           																		; $c464: 29 01     
				bne __checkNextActorCollision         																		; $c466: d0 1d     
			cpy #$74           																		; $c468: c0 74     
				bcc __checkNextActorCollision         																		; $c46a: 90 19     
			cpy #$7d           																		; $c46c: c0 7d     
				bcs __checkNextActorCollision         																		; $c46e: b0 15     
			lda vSpriteTable          																		; $c470: ad 00 07  
			sec                																		; $c473: 38        
			sbc #$0a           																		; $c474: e9 0a     
			cmp vActorY,x          																		; $c476: d5 90     
				bcs __checkNextActorCollision         																		; $c478: b0 0b     
			clc                																		; $c47a: 18        
			adc #$10           																		; $c47b: 69 10     
			cmp vActorY,x          																		; $c47d: d5 90     
				bcc __checkNextActorCollision         																		; $c47f: 90 04     
			lda #$01           																		; $c481: a9 01     
			sta vObjectHitFlags,x          																		; $c483: 95 b0     
__checkNextActorCollision:     
			inx                																		; $c485: e8        
			cpx #$03           																		; $c486: e0 03     
				beq __checkButterflyCollision         																		; $c488: f0 18     
			cpx #$07           																		; $c48a: e0 07     
				beq __checkMoleCollision         																		; $c48c: f0 29     
			cpx #$0a           																		; $c48e: e0 0a     
				beq __checkMushroomCollision         																		; $c490: f0 31     
			cpx #$13           																		; $c492: e0 13     
				bne __checkThisActorCollision         																		; $c494: d0 c4    
				
			jsr __levelModulo4ToX         																		; $c496: 20 5e c3  
			cpx #$03           																		; $c499: e0 03     
				bne __return24         																		; $c49b: d0 04     
			lda #$00           																		; $c49d: a9 00     
			sta vInvulnTimer            																		; $c49f: 85 bf     
__return24:     
			rts                																		; $c4a1: 60        

;-------------------------------------------------------------------------------
__checkButterflyCollision:     
			lda vObjectHitFlags,x          																		; $c4a2: b5 b0     
				; we need to check only one butterfly for collision
				beq __checkNextButterflyCollision         																		; $c4a4: f0 02     
				bne __collisionSkipOtherButterlies         																		; $c4a6: d0 0a     
__checkNextButterflyCollision:     
			inx                																		; $c4a8: e8        
			cpx #$07           																		; $c4a9: e0 07     
				bne __checkButterflyCollision         																		; $c4ab: d0 f5     
			
			ldx #$03           																		; $c4ad: a2 03     
			jmp __checkThisActorCollision         																		; $c4af: 4c 5a c4  

;-------------------------------------------------------------------------------
__collisionSkipOtherButterlies:     
			ldx #$06           																		; $c4b2: a2 06     
			jmp __checkNextActorCollision         																		; $c4b4: 4c 85 c4  

;-------------------------------------------------------------------------------
__checkMoleCollision:     
			lda vMoleOnSurfaceTimer            																		; $c4b7: a5 e0     
			cmp #$02           																		; $c4b9: c9 02     
				bcc __checkNextActorCollision         																		; $c4bb: 90 c8     
			cmp #$0c           																		; $c4bd: c9 0c     
				bcc __checkThisActorCollision         																		; $c4bf: 90 99     
				bcs __checkNextActorCollision         																		; $c4c1: b0 c2     
				
__checkMushroomCollision:     
			lda vMushroomEngaged            																		; $c4c3: a5 e7     
				bne __checkNextActorCollision         																		; $c4c5: d0 be     
			lda vMushroomCollision            																		; $c4c7: a5 ba     
				beq __checkThisActorCollision         																		; $c4c9: f0 8f
			; lda vTimeFreezeTimerAbs
			.hex ad a6 00      																		; $c4cb: ad a6 00  Bad Addr Mode - LDA vTimeFreezeTimerAbs
				bne __timeFreezeActive         																		; $c4ce: d0 06     
				
			lda #$02           																		; $c4d0: a9 02     
			sta vSoundPlayerState            																		; $c4d2: 85 2a     
			inc vMushroomEngaged            																		; $c4d4: e6 e7     
__timeFreezeActive:     
			jmp __checkNextActorCollision         																		; $c4d6: 4c 85 c4  

;-------------------------------------------------------------------------------
; check if mushroom hits an actor
__checkMushroomKilled:     
			lda vMushroomY            																		; $c4d9: a5 9a     
			cmp #$cc           																		; $c4db: c9 cc     
				bcs __return27         																		; $c4dd: b0 50     

			ldx vKiteMushroomDead          																		; $c4df: ae 11 02  
				bne __mushroomMissKite         																		; $c4e2: d0 0e     
			; mushroom collision hitbox is 20 pixels in height
			; first we check upper edge of box
			sec                																		; $c4e4: 38        
			sbc #$04           																		; $c4e5: e9 04     
			cmp vKiteY1            																		; $c4e7: c5 98     
				bcs __mushroomMissKite         																		; $c4e9: b0 07
			; then we check lower edge of box	
			clc                																		; $c4eb: 18        
			adc #$10           																		; $c4ec: 69 10     
			cmp vKiteY1            																		; $c4ee: c5 98     
				bcs __mushroomCheckHit         																		; $c4f0: b0 5a     
__mushroomMissKite:     
			lda vMushroomY            																		; $c4f2: a5 9a     
			ldx vBeeMushroomDead          																		; $c4f4: ae 10 02  
				bne __mushroomMissBee         																		; $c4f7: d0 06     
			jsr __clearXY         																		; $c4f9: 20 16 d7  
			jsr __mushroomCheckHitY         																		; $c4fc: 20 71 c5  
__mushroomMissBee:     
			ldx vHawkMushroomDead          																		; $c4ff: ae 13 02  
				bne __mushroomMissHawk         																		; $c502: d0 07     
			ldx #$10           																		; $c504: a2 10     
			ldy #$03           																		; $c506: a0 03     
			jsr __mushroomCheckHitY         																		; $c508: 20 71 c5  
__mushroomMissHawk:     
			ldx vWoodpeckerMushroomDead          																		; $c50b: ae 14 02  
				bne __mushroomMissWoodpecker         																		; $c50e: d0 07     
			ldx #$0e           																		; $c510: a2 0e     
			ldy #$04           																		; $c512: a0 04     
			jsr __mushroomCheckHitY         																		; $c514: 20 71 c5  
__mushroomMissWoodpecker:     
			ldx vBigBeeDead          																		; $c517: ae 15 02  
				bne __mushroomMissBigBee         																		; $c51a: d0 07     
			ldx #$01           																		; $c51c: a2 01     
			ldy #$05           																		; $c51e: a0 05     
			jsr __mushroomCheckHitY         																		; $c520: 20 71 c5  
__mushroomMissBigBee:     
			ldx vFoxMushroomDead          																		; $c523: ae 12 02  
				bne __return27         																		; $c526: d0 07     
			ldx #$0b           																		; $c528: a2 0b     
			ldy #$02           																		; $c52a: a0 02     
			jsr __mushroomCheckHitY         																		; $c52c: 20 71 c5  
__return27:     
			rts                																		; $c52f: 60        

;-------------------------------------------------------------------------------
__mushroomCheckHitX:     
			lda vActorX,x          																		; $c530: b5 70     
			sec                																		; $c532: 38        
			sbc #$04           																		; $c533: e9 04     
			cmp vMushroomX            																		; $c535: c5 7a     
				bpl __mushroomMissX         																		; $c537: 10 10     
			clc                																		; $c539: 18        
			adc #$08           																		; $c53a: 69 08     
			cmp vMushroomX            																		; $c53c: c5 7a     
				bmi __mushroomMissX         																		; $c53e: 30 09     
				
			; yay, we hit!
			lda #$01           																		; $c540: a9 01     
			sta vCreatureMushroomDead,y        																		; $c542: 99 10 02  
__killedCreatureSound:     
			lda #$03           																		; $c545: a9 03     
			sta vSoundPlayerState            																		; $c547: 85 2a     
__mushroomMissX:     
			jmp __mushroomMiss         																		; $c549: 4c 7f c5  

;-------------------------------------------------------------------------------
__mushroomCheckHit:     
			jsr __clearXY         																		; $c54c: 20 16 d7  
__mushroomCheckHitKite:     
			lda vKiteX1,x          																		; $c54f: b5 78     
			sec                																		; $c551: 38        
			sbc #$04           																		; $c552: e9 04     
			cmp vMushroomX            																		; $c554: c5 7a     
				bpl __mushroomMissKite         																		; $c556: 10 9a     
			clc                																		; $c558: 18        
			adc #$10           																		; $c559: 69 10     
			cmp vMushroomX            																		; $c55b: c5 7a     
				bmi __mushroomMissKite         																		; $c55d: 30 93     
			ldx vKiteMushroomDead,y        																		; $c55f: be 11 02  
			inx                																		; $c562: e8        
			txa                																		; $c563: 8a        
			sta vKiteMushroomDead,y        																		; $c564: 99 11 02  
			jmp __killedCreatureSound         																		; $c567: 4c 45 c5  

;-------------------------------------------------------------------------------
			ldx #$03           																		; $c56a: a2 03     
			ldy #$01           																		; $c56c: a0 01     
			jmp __mushroomCheckHitKite         																		; $c56e: 4c 4f c5  

;-------------------------------------------------------------------------------
__mushroomCheckHitY:     sec                																		; $c571: 38        
			sbc #$04           																		; $c572: e9 04     
			cmp vActorY,x          																		; $c574: d5 90     
				bcs __mushroomMiss         																		; $c576: b0 07     
			clc                																		; $c578: 18        
			adc #$10           																		; $c579: 69 10     
			cmp vActorY,x          																		; $c57b: d5 90     
				bcs __mushroomCheckHitX         																		; $c57d: b0 b1     
__mushroomMiss:     
			lda vMushroomY            																		; $c57f: a5 9a     
			rts                																		; $c581: 60        

;-------------------------------------------------------------------------------
; this checks if we collided somebody and should die
__checkHitActors:     
			ldx #$00           																		; $c582: a2 00     
			lda vObjectHitFlags,x          																		; $c584: b5 b0     
				beq __checkBigBeeHit         																		; $c586: f0 0d  
			; we hit bee
			lda #$01           																		; $c588: a9 01     
			sta vBeeIsHit            																		; $c58a: 85 66     
			lda vInvulnTimer            																		; $c58c: a5 bf     
				bne __birdInvulnerable2         																		; $c58e: d0 02     
			inc vGameIsFrozen            																		; $c590: e6 5e     
__birdInvulnerable2:     
			jsr ___checkHeldButterfly         																		; $c592: 20 eb c5  
__checkBigBeeHit:     
			lda vBigBeeCollision            																		; $c595: a5 b1     
				beq __checkKiteHit         																		; $c597: f0 0e     
			lda #$01           																		; $c599: a9 01     
			sta vBigBeeIsDead          																		; $c59b: 8d 94 02  
			lda vInvulnTimer            																		; $c59e: a5 bf     
				bne __birdInvulnerable3         																		; $c5a0: d0 02     
			inc vGameIsFrozen            																		; $c5a2: e6 5e     
__birdInvulnerable3:     
			jsr ___checkHeldButterfly         																		; $c5a4: 20 eb c5  

__checkKiteHit:     
			lda vKiteFrontCollision            																		; $c5a7: a5 b8     
			clc                																		; $c5a9: 18        
			adc vKiteBackCollision            																		; $c5aa: 65 b9     
				beq __checkFoxHit         																		; $c5ac: f0 0d     
				
			lda #$01           																		; $c5ae: a9 01     
			sta vKiteHit            																		; $c5b0: 85 86     
			lda vInvulnTimer            																		; $c5b2: a5 bf     
				bne __birdInvulnerable4         																		; $c5b4: d0 02     
			inc vGameIsFrozen            																		; $c5b6: e6 5e     
__birdInvulnerable4:     
			jsr ___checkHeldButterfly         																		; $c5b8: 20 eb c5  
__checkFoxHit:     
			lda vFoxCollision            																		; $c5bb: a5 bb     
				beq __checkWoodpeckerHit         																		; $c5bd: f0 0d     
			lda #$01           																		; $c5bf: a9 01     
			sta vFoxIsHit            																		; $c5c1: 85 a8     
			lda vInvulnTimer            																		; $c5c3: a5 bf     
				bne __birdInvulnerable5         																		; $c5c5: d0 02     
			inc vGameIsFrozen            																		; $c5c7: e6 5e     
__birdInvulnerable5:     
			jsr ___checkHeldButterfly         																		; $c5c9: 20 eb c5  
__checkWoodpeckerHit:     
			lda vWoodpeckerSquirrelCollision            																		; $c5cc: a5 be     
				beq __checkHawkHit         																		; $c5ce: f0 0a     
			lda #$01           																		; $c5d0: a9 01     
			sta vWoodpeckerSquirrelIsHit            																		; $c5d2: 85 88     
			lda vInvulnTimer            																		; $c5d4: a5 bf     
				bne __checkHawkHit         																		; $c5d6: d0 02     
			inc vGameIsFrozen            																		; $c5d8: e6 5e     
__checkHawkHit:     
			lda vHawkHit            																		; $c5da: a5 c0     
				beq __birdInvulnerable         																		; $c5dc: f0 1e     
			lda #$01           																		; $c5de: a9 01     
			sta vHawkIsHit            																		; $c5e0: 85 8a     
			lda vInvulnTimer            																		; $c5e2: a5 bf     
				bne __checkHeldButterfly         																		; $c5e4: d0 02     
			inc vGameIsFrozen            																		; $c5e6: e6 5e     
__checkHeldButterfly:     
			jmp ___checkHeldButterfly         																		; $c5e8: 4c eb c5  

;-------------------------------------------------------------------------------
; if bird held a butterfly while being hit, release it
___checkHeldButterfly:     
			stx vCounter            																		; $c5eb: 86 51     
			lda vInvulnTimer            																		; $c5ed: a5 bf     
				bne __birdInvulnerable         																		; $c5ef: d0 0b     
			ldx #$00           																		; $c5f1: a2 00     
__checkHeldLoop:     
			lda vButterflyXCaught,x          																		; $c5f3: b5 b3     
				bne __freeButterfly         																		; $c5f5: d0 08     
__checkHeldNext:     
			inx                																		; $c5f7: e8        
			cpx #$04           																		; $c5f8: e0 04     
				bne __checkHeldLoop         																		; $c5fa: d0 f7   
				
__birdInvulnerable:     
			ldx vCounter            																		; $c5fc: a6 51     
			rts                																		; $c5fe: 60        

;-------------------------------------------------------------------------------
__freeButterfly:     
			lda #$f0           																		; $c5ff: a9 f0     
			sta vButterfly1Y,x          																		; $c601: 95 93     
			lda #$00           																		; $c603: a9 00     
			sta vButterflyXCaught,x          																		; $c605: 95 b3     
			jmp __checkHeldNext         																		; $c607: 4c f7 c5  

;-------------------------------------------------------------------------------
___handleGameFreeze:     
			lda vDemoSequenceActive          																		; $c60a: ad 73 02  
				bne __unFreezeDemoSequence         																		; $c60d: d0 26     
____handleGameFreeze:     
			lda vInvulnTimer            																		; $c60f: a5 bf     
				bne __dontCheckHit         																		; $c611: d0 12     
			lda vBeeIsHit            																		; $c613: a5 66     
			clc                																		; $c615: 18        
			adc vKiteHit            																		; $c616: 65 86     
			adc $87            																		; $c618: 65 87     
			adc vWoodpeckerSquirrelIsHit            																		; $c61a: 65 88     
			adc vFoxIsHit            																		; $c61c: 65 a8     
			adc vHawkIsHit            																		; $c61e: 65 8a     
			adc vBigBeeIsDead          																		; $c620: 6d 94 02  
				bne __birdIsHit         																		; $c623: d0 1f     
__dontCheckHit:     
			lda vNestlingIsRising            																		; $c625: a5 a4     
				bne __updateRisingNestling         																		; $c627: d0 18     
			lda vCurrentLevel            																		; $c629: a5 55     
			cmp #$10           																		; $c62b: c9 10     
				bcc __check2NestlingsRising         																		; $c62d: 90 03     
			jmp __check3NestlingsRising         																		; $c62f: 4c e7 c7  

;-------------------------------------------------------------------------------
__check2NestlingsRising:     
			jmp ___check2NestlingsRising         																		; $c632: 4c b7 c6  

;-------------------------------------------------------------------------------
; frozen demo sequence could be broken by any input
__unFreezeDemoSequence:     
			lda vPlayerInput            																		; $c635: a5 0a     
				beq ____handleGameFreeze         																		; $c637: f0 d6     
			lda #$f0           																		; $c639: a9 f0     
			sta vNestlingCountSprite          																		; $c63b: 8d 60 07  
			jmp __startDemoSequenceEnd         																		; $c63e: 4c 9c c6  

;-------------------------------------------------------------------------------
__updateRisingNestling:     
			jmp ___updateRisingNestling         																		; $c641: 4c e5 c6  

;-------------------------------------------------------------------------------
__birdIsHit:     
			jsr __setSprite0         																		; $c644: 20 18 f6  
			jsr __statusBarSprite0Timing         																		; $c647: 20 e8 f5  
			lda vBirdFallState            																		; $c64a: a5 d2     
				beq __startBirdFall         																		; $c64c: f0 09     
			cmp #$01           																		; $c64e: c9 01     
				beq __birdFalling         																		; $c650: f0 13     
			cmp #$02           																		; $c652: c9 02     
				beq __birdFell         																		; $c654: f0 53     
			rts                																		; $c656: 60        

;-------------------------------------------------------------------------------
__startBirdFall:     
			lda vDemoSequenceActive          																		; $c657: ad 73 02  
				bne __birdFalls         																		; $c65a: d0 04 
			; start fird fall music
			lda #$06           																		; $c65c: a9 06     
			sta vMusicPlayerState            																		; $c65e: 85 20     
__birdFalls:     
			inc vBirdFallState            																		; $c660: e6 d2     
			jmp __frozenGameLoop         																		; $c662: 4c 22 c1  

;-------------------------------------------------------------------------------
__birdFalling:     
			jsr __mushroomCheckReachedLand         																		; $c665: 20 9e dc  
			jsr __drawGameActors         																		; $c668: 20 8a d4  
			lda vBirdSpritePosY          																		; $c66b: ad 00 07  
			cmp #$c8           																		; $c66e: c9 c8     
				beq __endBirdFalling         																		; $c670: f0 1c  
				
			inc vBirdSpritePosY          																		; $c672: ee 00 07  
			lda vMusicPlayerState            																		; $c675: a5 20     
				bne __updateFallingBirdFrame         																		; $c677: d0 09     
			lda vDemoSequenceActive          																		; $c679: ad 73 02  
				bne __updateFallingBirdFrame         																		; $c67c: d0 04     
			lda #$06           																		; $c67e: a9 06     
			sta vMusicPlayerState            																		; $c680: 85 20     
__updateFallingBirdFrame:     
			jsr __setXEvery8Cycle         																		; $c682: 20 8b d0  
___updateFallingBirdFrame:     
			lda __birdFallingFrames,x       																		; $c685: bd b2 c6  
			sta $0701          																		; $c688: 8d 01 07  
			jmp __frozenGameLoop         																		; $c68b: 4c 22 c1  

;-------------------------------------------------------------------------------
__endBirdFalling:     
			lda vDemoSequenceActive          																		; $c68e: ad 73 02  
				bne __startDemoSequenceEnd         																		; $c691: d0 09     
			inc vBirdFallState            																		; $c693: e6 d2     
			lda #$07           																		; $c695: a9 07     
			sta vMusicPlayerState            																		; $c697: 85 20     
			jmp __frozenGameLoop         																		; $c699: 4c 22 c1  

;-------------------------------------------------------------------------------
__startDemoSequenceEnd:     
			jsr __clearBirdNametable         																		; $c69c: 20 a2 c6  
			jmp ___handleGameOver         																		; $c69f: 4c 67 f4  

;-------------------------------------------------------------------------------
__clearBirdNametable:     
			lda #$00           																		; $c6a2: a9 00     
			sta vBirdPPUNametable            																		; $c6a4: 85 02     
			sta vBirdPPUX            																		; $c6a6: 85 03     
			rts                																		; $c6a8: 60        

;-------------------------------------------------------------------------------
__birdFell:     
			lda vMusicPlayerState            																		; $c6a9: a5 20     
				beq __recoverGameAfterDeath         																		; $c6ab: f0 5f     
			ldx #$04           																		; $c6ad: a2 04     
			jmp ___updateFallingBirdFrame         																		; $c6af: 4c 85 c6  

;-------------------------------------------------------------------------------
__birdFallingFrames:     
			.hex 12 13 12 13   																		; $c6b2: 12 13 12 13   Data
			.hex 14            																		; $c6b6: 14            Data

;-------------------------------------------------------------------------------
___check2NestlingsRising:     
			jsr __levelModulo4ToX         																		; $c6b7: 20 5e c3  
			lda vNestling1State            																		; $c6ba: a5 8c     
			cmp vNestlingMaxFeed            																		; $c6bc: c5 64     
				beq ___nestling1IsFed         																		; $c6be: f0 07     
			lda vNestling2State            																		; $c6c0: a5 8d     
			cmp vNestlingMaxFeed            																		; $c6c2: c5 64     
				beq ___nestling2IsFed         																		; $c6c4: f0 10     
			rts                																		; $c6c6: 60        

;-------------------------------------------------------------------------------
___nestling1IsFed:     
			lda #$21           																		; $c6c7: a9 21     
			sta vDataAddress            																		; $c6c9: 85 53     
			lda ___nestling1Pos,x       																		; $c6cb: bd 15 c8  
			sta vDataAddressHi            																		; $c6ce: 85 54     
			
			jsr __playNestlingFedAnimation         																		; $c6d0: 20 1e c8  
			jmp __updateNestlingFedFrame         																		; $c6d3: 4c d1 c3  

;-------------------------------------------------------------------------------
___nestling2IsFed:     
			lda #$21           																		; $c6d6: a9 21     
			sta vDataAddress            																		; $c6d8: 85 53     
			lda ___nestling2Pos,x       																		; $c6da: bd 18 c8  
			sta vDataAddressHi            																		; $c6dd: 85 54     
			jsr __playNestlingFedAnimation         																		; $c6df: 20 1e c8  
			jmp __updateNestlingFedFrame         																		; $c6e2: 4c d1 c3  

;-------------------------------------------------------------------------------
___updateRisingNestling:     
			lda vCycleCounter            																		; $c6e5: a5 09     
			and #$01           																		; $c6e7: 29 01     
				bne __risingNestlingDontChangeY         																		; $c6e9: d0 11     
			
			dec vRisingNestlingY            																		; $c6eb: c6 9d     
			lda vRisingNestlingY            																		; $c6ed: a5 9d     
			cmp #$1a           																		; $c6ef: c9 1a     
				beq __checkRoundComplete         																		; $c6f1: f0 12     
			jsr __setXEvery4Cycle         																		; $c6f3: 20 93 d0  
			lda __risingNestlingAnim,x       																		; $c6f6: bd 08 c7  
			sta $0739          																		; $c6f9: 8d 39 07  
__risingNestlingDontChangeY:     
			jsr __pauseSpriteTiming         																		; $c6fc: 20 9f c2  
			jsr __drawGameActors         																		; $c6ff: 20 8a d4  
			jmp __frozenGameLoop         																		; $c702: 4c 22 c1  

;-------------------------------------------------------------------------------
__checkRoundComplete:     
			jmp ___checkRoundComplete         																		; $c705: 4c 52 c7  

;-------------------------------------------------------------------------------
__risingNestlingAnim:     
			.hex 7f 80 7f 80   																		; $c708: 7f 80 7f 80   Data

;-------------------------------------------------------------------------------
__recoverGameAfterDeath:     
			jsr __clearBirdNametable         																		; $c70c: 20 a2 c6  
			jsr ___initGameActorVariables         																		; $c70f: 20 76 c7  
			sta vGameIsFrozen            																		; $c712: 85 5e     
			lda #$f0           																		; $c714: a9 f0     
			sta vInvulnCreatureY            																		; $c716: 85 9f     
			sta vSnailY            																		; $c718: 85 a2     
			sta vFlowerY            																		; $c71a: 85 a1     
			inc vKiteRiseAfterDeath            																		; $c71c: e6 67     
			lda #$a0           																		; $c71e: a9 a0     
			sta vFoxX            																		; $c720: 85 7b     
			lda #$a8           																		; $c722: a9 a8     
			sta $7c            																		; $c724: 85 7c     
			sta vHawkX            																		; $c726: 85 80     
			lda #$d8           																		; $c728: a9 d8     
			sta vBeeX            																		; $c72a: 85 70     
			sta vKiteX1            																		; $c72c: 85 78     
			sta vWoodpeckerSquirrelX            																		; $c72e: 85 7e     
			lda #$e0           																		; $c730: a9 e0     
			sta vBigBeeX            																		; $c732: 85 71     
			sta vKiteX2            																		; $c734: 85 79     
			lda #$e8           																		; $c736: a9 e8     
			sta $72            																		; $c738: 85 72     
			lda #$02           																		; $c73a: a9 02     
			sta vWoodpeckerState            																		; $c73c: 85 58     
			
			dec vBirdLives            																		; $c73e: c6 56     
			; if no lives left, start game over seqeuence
			lda vBirdLives            																		; $c740: a5 56     
				beq __setGameOver         																		; $c742: f0 07     
			; continue game
			lda #$03           																		; $c744: a9 03     
			sta vGameState            																		; $c746: 85 50     
			jmp __composeOAMTable         																		; $c748: 4c 3b ff  

;-------------------------------------------------------------------------------
__setGameOver:     
			lda #$04           																		; $c74b: a9 04     
			sta vGameState            																		; $c74d: 85 50     
			jmp __composeOAMTable         																		; $c74f: 4c 3b ff  

;-------------------------------------------------------------------------------
___checkRoundComplete:     
			inc vRisedNestlingCount            																		; $c752: e6 5f     
			lda #$00           																		; $c754: a9 00     
			sta vNestlingIsRising            																		; $c756: 85 a4     
			sta vMusicPlayerState            																		; $c758: 85 20     
			
			; hide risen nestling
			lda #$f0           																		; $c75a: a9 f0     
			sta vRisingNestlingY            																		; $c75c: 85 9d     
			lda vCurrentLevel            																		; $c75e: a5 55     
			cmp #$10           																		; $c760: c9 10     
				bcs __check3NesstlingRoundComplete         																		; $c762: b0 0d     
			lda #$02           																		; $c764: a9 02     
__checkIsRoundComplete:     
			cmp vRisedNestlingCount            																		; $c766: c5 5f     
				beq __roundComplete         																		; $c768: f0 4e     
			; no, continue game
			lda #$03           																		; $c76a: a9 03     
			sta vGameState            																		; $c76c: 85 50     
			jmp __continueGameState         																		; $c76e: 4c cc c7  

;-------------------------------------------------------------------------------
__check3NesstlingRoundComplete:     
			lda #$03           																		; $c771: a9 03     
			jmp __checkIsRoundComplete         																		; $c773: 4c 66 c7  

;-------------------------------------------------------------------------------
___initGameActorVariables:     
			lda #$00           																		; $c776: a9 00     
			sta $63            																		; $c778: 85 63     
			sta vBeeIsHit            																		; $c77a: 85 66     
			sta vKiteHit            																		; $c77c: 85 86     
			sta $87            																		; $c77e: 85 87     
			sta vWoodpeckerSquirrelIsHit            																		; $c780: 85 88     
			sta vInvulnCreatureState            																		; $c782: 85 89     
			sta vHawkIsHit            																		; $c784: 85 8a     
			sta vSnailTimer            																		; $c786: 85 a5     
			sta vTimeFreezeTimer            																		; $c788: 85 a6     
			sta vFoxDeadTimer            																		; $c78a: 85 a7     
			sta vFoxIsHit            																		; $c78c: 85 a8     
			jsr __resetEnemyHitFlags         																		; $c78e: 20 f8 ef  
			sta vMoleCollision            																		; $c791: 85 b7     
			sta $bc            																		; $c793: 85 bc     
			sta vInvulnTimer            																		; $c795: 85 bf     
			sta vFlowerHit            																		; $c797: 85 c1     
			sta vHawkHit            																		; $c799: 85 c0     
			sta vHawkDeadCounter            																		; $c79b: 85 c5     
			sta vWoodpeckerSquirrelCollision            																		; $c79d: 85 be     
			sta vBirdFallState            																		; $c79f: 85 d2     
			sta vButterflyIsCaught            																		; $c7a1: 85 ea     
			sta vMoleIsDying            																		; $c7a3: 85 eb     
__resetMushroomScore:     
			tax                																		; $c7a5: aa        
__resetMushroomScoreLoop:     
			sta vCreatureMushroomDead,x        																		; $c7a6: 9d 10 02  
			sta vScoreForDeadWoodpecker,x        																		; $c7a9: 9d 5a 02  
			sta vBigBeeIsDead,x        																		; $c7ac: 9d 94 02  
			sta vStageSelect10s,x        																		; $c7af: 9d e1 02  
			inx                																		; $c7b2: e8        
			cpx #$06           																		; $c7b3: e0 06     
				bne __resetMushroomScoreLoop         																		; $c7b5: d0 ef     
			rts                																		; $c7b7: 60        

;-------------------------------------------------------------------------------
__roundComplete:     
			lda #$00           																		; $c7b8: a9 00     
			sta vNestling1State            																		; $c7ba: 85 8c     
			sta vNestling3State            																		; $c7bc: 85 8e     
			sta vNestling2State            																		; $c7be: 85 8d     
			sta vRisedNestlingCount            																		; $c7c0: 85 5f     
			lda #$fe           																		; $c7c2: a9 fe     
			sta vGameState            																		; $c7c4: 85 50     
			jsr __increaseNestlingCount         																		; $c7c6: 20 09 c2  
			jmp ___continueGameState         																		; $c7c9: 4c d8 c7  

;-------------------------------------------------------------------------------
__continueGameState:     
			jsr __setPPUIncrementBy1         																		; $c7cc: 20 da fe  
			jsr __increaseNestlingCount         																		; $c7cf: 20 09 c2  
			jsr __showNestlingCountLabel         																		; $c7d2: 20 df c1  
			jsr __scrollScreen         																		; $c7d5: 20 b6 fd  
___continueGameState:     
			lda #$00           																		; $c7d8: a9 00     
			sta vGameIsFrozen            																		; $c7da: 85 5e     
			sta $63            																		; $c7dc: 85 63     
			sta vBirdFallState            																		; $c7de: 85 d2     
			lda #$f8           																		; $c7e0: a9 f8     
			sta vRisingNestlingY            																		; $c7e2: 85 9d     
			jmp __pauseSpriteTiming         																		; $c7e4: 4c 9f c2  

;-------------------------------------------------------------------------------
; levels >12 require 3 nestlings to be fed
__check3NestlingsRising:     
			jsr __levelModulo4ToX         																		; $c7e7: 20 5e c3  
			lda vNestling1State            																		; $c7ea: a5 8c     
			cmp vNestlingMaxFeed            																		; $c7ec: c5 64     
				beq __nestling1IsFed         																		; $c7ee: f0 0d     
			lda vNestling2State            																		; $c7f0: a5 8d     
			cmp vNestlingMaxFeed            																		; $c7f2: c5 64     
				beq __nestling2IsFed         																		; $c7f4: f0 0a     
			lda vNestling3State            																		; $c7f6: a5 8e     
			cmp vNestlingMaxFeed            																		; $c7f8: c5 64     
				beq ___nestling3IsFed         																		; $c7fa: f0 07     
			rts                																		; $c7fc: 60        

;-------------------------------------------------------------------------------
__nestling1IsFed:     
			jmp ___nestling1IsFed         																		; $c7fd: 4c c7 c6  

;-------------------------------------------------------------------------------
__nestling2IsFed:     
			jmp ___nestling2IsFed         																		; $c800: 4c d6 c6  

;-------------------------------------------------------------------------------
___nestling3IsFed:     
			lda #$21           																		; $c803: a9 21     
			sta vDataAddress            																		; $c805: 85 53     
			lda ___nestling3Pos,x       																		; $c807: bd 1b c8  
			sta vDataAddressHi            																		; $c80a: 85 54     
			jsr __playNestlingFedAnimation         																		; $c80c: 20 1e c8  
			jmp __updateNestlingFedFrame         																		; $c80f: 4c d1 c3  

;-------------------------------------------------------------------------------
			jmp ___updateRisingNestling         																		; $c812: 4c e5 c6  

;-------------------------------------------------------------------------------
; these repeat every 3 levels
___nestling1Pos:     
			.hex d0 98 88      																		; $c815: d0 98 88      Data
___nestling2Pos:     
			.hex d2 9a 8a      																		; $c818: d2 9a 8a      Data
___nestling3Pos:     
			.hex d4 9c 8c      																		; $c81b: d4 9c 8c      Data

;-------------------------------------------------------------------------------
__playNestlingFedAnimation:     
			lda vMusicPlayerState            																		; $c81e: a5 20     
				bne __nestlingFedTiming         																		; $c820: d0 04     
			; start bird happy music
			lda #$0d           																		; $c822: a9 0d     
			sta vMusicPlayerState            																		; $c824: 85 20     
			
__nestlingFedTiming:     
			inc vNestlingHappyTimer            																		; $c826: e6 e8     
				beq __nestlingStartRise         																		; $c828: f0 1b     
			lda vNestlingHappyTimer            																		; $c82a: a5 e8     
			cmp #$60           																		; $c82c: c9 60     
				bcc __nestlingSlowHappy         																		; $c82e: 90 06     
			cmp #$b0           																		; $c830: c9 b0     
				bcc ___setXEvery4Cycle         																		; $c832: 90 05     
				bcs __nestlingStartFlapping         																		; $c834: b0 06     
__nestlingSlowHappy:     
			jmp __setXEvery8Cycle         																		; $c836: 4c 8b d0  

;-------------------------------------------------------------------------------
___setXEvery4Cycle:     
			jmp __setXEvery4Cycle         																		; $c839: 4c 93 d0  

;-------------------------------------------------------------------------------
__nestlingStartFlapping:     
			jsr __setXEvery4Cycle         																		; $c83c: 20 93 d0  
__mirrorBirdSprite:     txa                																		; $c83f: 8a        
			clc                																		; $c840: 18        
			adc #$04           																		; $c841: 69 04     
			tax                																		; $c843: aa        
			rts                																		; $c844: 60        

;-------------------------------------------------------------------------------
__nestlingStartRise:     
			jsr __levelModulo4ToX         																		; $c845: 20 5e c3  
			lda __nestlingPosY,x       																		; $c848: bd 79 c8  
			sta vRisingNestlingY            																		; $c84b: 85 9d     
			lda vNestling1State            																		; $c84d: a5 8c     
			cmp vNestlingMaxFeed            																		; $c84f: c5 64     
				bne __nestling2StartRise         																		; $c851: d0 08     
			inc vNestling1State            																		; $c853: e6 8c     
			lda __nestling1PosX,x       																		; $c855: bd 7d c8  
			jmp __startNestlingRise         																		; $c858: 4c 6e c8  

;-------------------------------------------------------------------------------
__nestling2StartRise:     
			lda vNestling2State            																		; $c85b: a5 8d     
			cmp vNestlingMaxFeed            																		; $c85d: c5 64     
				bne __nestling3StartRise         																		; $c85f: d0 08     
			inc vNestling2State            																		; $c861: e6 8d     
			lda __nestling2PosX,x       																		; $c863: bd 81 c8  
			jmp __startNestlingRise         																		; $c866: 4c 6e c8  

;-------------------------------------------------------------------------------
__nestling3StartRise:     
			inc vNestling3State            																		; $c869: e6 8e     
			lda __nestling3PosX,x       																		; $c86b: bd 85 c8  
__startNestlingRise:     
			sta vRisingNestlingX            																		; $c86e: 85 7d     

			lda #$0c           																		; $c870: a9 0c     
			; fed nestling rising music
			sta vMusicPlayerState            																		; $c872: 85 20     
			inc vNestlingIsRising            																		; $c874: e6 a4     
			ldx #$08           																		; $c876: a2 08     
			rts                																		; $c878: 60        

;-------------------------------------------------------------------------------
; these repeat every 3 levels (none on bonus level)
__nestlingPosY:     
			.hex 70 60 60 ff   																		; $c879: 70 60 60 ff   Data
__nestling1PosX:     
			.hex 40 60 20 ff   																		; $c87d: 40 60 20 ff   Data
__nestling2PosX:     
			.hex 48 68 28 ff   																		; $c881: 48 68 28 ff   Data
__nestling3PosX:     
			.hex 50 70 30 ff   																		; $c885: 50 70 30 ff   Data

;-------------------------------------------------------------------------------
___scoreScreenLoop:     
			lda vCurrentLevel            																		; $c889: a5 55     
			and #$03           																		; $c88b: 29 03     
			tay                																		; $c88d: a8        
			lda vIsStudyMode          																		; $c88e: ad e0 02  
				; study mode only lasts for one level
				bne __endStudyMode         																		; $c891: d0 0d     
				
			lda vScoreScreenState            																		; $c893: a5 d3     
				beq __playBonusScoreScreenMusic         																		; $c895: f0 14     
			cmp #$01           																		; $c897: c9 01     
				beq __drawScoreScreen         																		; $c899: f0 28     
			cmp #$02           																		; $c89b: c9 02     
				beq __handleScoreScreen         																		; $c89d: f0 33     
			rts                																		; $c89f: 60        

;-------------------------------------------------------------------------------
__endStudyMode:     
			lda #$00           																		; $c8a0: a9 00     
			sta vBirdLives            																		; $c8a2: 85 56     
			lda #$04           																		; $c8a4: a9 04     
			sta vGameState            																		; $c8a6: 85 50     
			jmp __startDemoSequenceEnd         																		; $c8a8: 4c 9c c6  

;-------------------------------------------------------------------------------
; special music for bonus level score screen
__playBonusScoreScreenMusic:     
			jsr __clearBirdNametable         																		; $c8ab: 20 a2 c6  
			cpy #$03           																		; $c8ae: c0 03     
				bne __playNoMusicScoreScreen         																		; $c8b0: d0 0a     
			lda #$08           																		; $c8b2: a9 08     
			sta vMusicPlayerState            																		; $c8b4: 85 20     
			jsr __handleMusicAndSound         																		; $c8b6: 20 dd f6  
			jmp __handleRoundSelectScoreScreen         																		; $c8b9: 4c da e3  

;-------------------------------------------------------------------------------
; ordinary score screens don't have music
__playNoMusicScoreScreen:     
			lda #$00           																		; $c8bc: a9 00     
			sta vMusicPlayerState            																		; $c8be: 85 20     
			jmp __handleRoundSelectScoreScreen         																		; $c8c0: 4c da e3  

;-------------------------------------------------------------------------------
__drawScoreScreen:     
			jsr __drawTotalScoreLabel         																		; $c8c3: 20 4a ca  
			jsr __scrollScreen         																		; $c8c6: 20 b6 fd  
			jsr __hideSprites         																		; $c8c9: 20 d6 fd  
			jsr __handleMusicAndSound         																		; $c8cc: 20 dd f6  
			inc vScoreScreenState            																		; $c8cf: e6 d3     
			rts                																		; $c8d1: 60        

;-------------------------------------------------------------------------------
__handleScoreScreen:     
			lda vCycleCounter            																		; $c8d2: a5 09     
			and #$03           																		; $c8d4: 29 03     
				bne ___scoreScreenLooping         																		; $c8d6: d0 10     
			inc vScoreScreenCounter            																		; $c8d8: e6 d4     
			lda vScoreScreenCounter            																		; $c8da: a5 d4     
			cmp #$20           																		; $c8dc: c9 20     
				beq __giveBonusScore         																		; $c8de: f0 0b     
			cpy #$03           																		; $c8e0: c0 03     
				beq __bonusScoreCounting         																		; $c8e2: f0 0a     
			cmp #$40           																		; $c8e4: c9 40     
				beq ___startNewRound         																		; $c8e6: f0 14     
___scoreScreenLooping:     
			jmp __handleMusicAndSound         																		; $c8e8: 4c dd f6  

;-------------------------------------------------------------------------------
__giveBonusScore:     
			jmp ___giveBonusScore         																		; $c8eb: 4c 50 c9  

;-------------------------------------------------------------------------------
__bonusScoreCounting:     
			lda vMusicPlayerState            																		; $c8ee: a5 20    
				; bonus score screen music still plays over
				bne ___scoreScreenLooping         																		; $c8f0: d0 f6     
			lda vBonusItemsCaught            																		; $c8f2: a5 8b     
				bne __bonusItemsScoreCount         																		; $c8f4: d0 03     
			jmp __bonusScoreCountEnd         																		; $c8f6: 4c 8e c9  

;-------------------------------------------------------------------------------
__bonusItemsScoreCount:     jmp ___bonusItemsScoreCount         																		; $c8f9: 4c 6f c9  

;-------------------------------------------------------------------------------
___startNewRound:     
			lda vCurrentLevel            																		; $c8fc: a5 55     
			cmp #$2f           																		; $c8fe: c9 2f     
				beq __proceedToBestEnding         																		; $c900: f0 43     
			inc vCurrentLevel            																		; $c902: e6 55     
			lda vNestlingMaxFeed            																		; $c904: a5 64     
			cmp #$04           																		; $c906: c9 04     
				beq __setRoundScreen         																		; $c908: f0 04     
			inc vNestlingMaxFeed            																		; $c90a: e6 64     
			inc vNestlingAwayState            																		; $c90c: e6 65     
__setRoundScreen:     
			lda #$02           																		; $c90e: a9 02     
			sta vGameState            																		; $c910: 85 50     
			jsr __increaseRoundNumber         																		; $c912: 20 f5 ca  
__initGameActorVariables:     
			jsr ___initGameActorVariables         																		; $c915: 20 76 c7  
			sta vMushroomCollision            																		; $c918: 85 ba     
			sta vSnailTimer            																		; $c91a: 85 a5     
			sta vTimeFreezeTimer            																		; $c91c: 85 a6     
			sta vScoreScreenState            																		; $c91e: 85 d3     
			sta vScoreScreenCounter            																		; $c920: 85 d4     
			sta vBonusLevelTimer            																		; $c922: 85 ec     
			sta $ed            																		; $c924: 85 ed     
			sta vBonusScoreScreenCounter            																		; $c926: 85 f1     
			sta vIsGameLoading            																		; $c928: 85 f6     
			sta vGameLoadingCounter            																		; $c92a: 85 f7     
			sta vNestling3000Bonus          																		; $c92c: 8d 28 02  
			sta vNestling2000Bonus          																		; $c92f: 8d 29 02  
			sta vNestling1000Bonus          																		; $c932: 8d 2a 02  
			sta vIsNestlingNoBonus          																		; $c935: 8d 2b 02  
			sta vBonusLevelExtraScore          																		; $c938: 8d 50 02  
			sta vWhaleCounter          																		; $c93b: 8d 52 02  
			lda #$f0           																		; $c93e: a9 f0     
			sta vFlowerY            																		; $c940: 85 a1     
			sta vSnailY            																		; $c942: 85 a2     
			rts                																		; $c944: 60        

;-------------------------------------------------------------------------------
__proceedToBestEnding:     
			lda #$fc           																		; $c945: a9 fc     
			sta vGameState            																		; $c947: 85 50     
			lda #$20           																		; $c949: a9 20     
			sta vCurrentLevel            																		; $c94b: 85 55     
			jmp __initGameActorVariables         																		; $c94d: 4c 15 c9  

;-------------------------------------------------------------------------------
___giveBonusScore:     
			cpy #$03           																		; $c950: c0 03     
				beq __scoreScreenLooping         																		; $c952: f0 18     
			lda vIsNestlingNoBonus          																		; $c954: ad 2b 02  
				bne __drawNoBonusLabel         																		; $c957: d0 72     
			lda vNestling1000Bonus          																		; $c959: ad 2a 02  
				bne __giveBonus1000         																		; $c95c: d0 0b     
			lda vNestling2000Bonus          																		; $c95e: ad 29 02  
				bne __giveBonus2000         																		; $c961: d0 03     
			jmp ___giveBonus3000         																		; $c963: 4c e5 c9  

;-------------------------------------------------------------------------------
__giveBonus2000:     
			jmp ___giveBonus2000         																		; $c966: 4c e8 c9  

;-------------------------------------------------------------------------------
__giveBonus1000:     
			jmp ___giveBonus1000         																		; $c969: 4c eb c9  

;-------------------------------------------------------------------------------
__scoreScreenLooping:     
			jmp ___scoreScreenLooping         																		; $c96c: 4c e8 c8  

;-------------------------------------------------------------------------------
___bonusItemsScoreCount:     
			lda vBonusItemsCaught            																		; $c96f: a5 8b     
				beq __bonusScoreCountEnd         																		; $c971: f0 1b     
			lda vCycleCounter            																		; $c973: a5 09     
			and #$0f           																		; $c975: 29 0f  
				; count score every 16 cycles
				bne ___bonusItemsScoreCountLoop         																		; $c977: d0 12     
			jsr __drawBonusGoodLabel         																		; $c979: 20 9c c9  
			jsr __give100Score         																		; $c97c: 20 15 ff  
			jsr __drawTotalScoreLabel         																		; $c97f: 20 4a ca  
			jsr __scrollScreen         																		; $c982: 20 b6 fd  
			dec vBonusItemsCaught            																		; $c985: c6 8b   
			
			; play score count music
			lda #$0f           																		; $c987: a9 0f     
			sta vMusicPlayerState            																		; $c989: 85 20     
___bonusItemsScoreCountLoop:     
			jmp __handleMusicAndSound         																		; $c98b: 4c dd f6  

;-------------------------------------------------------------------------------
__bonusScoreCountEnd:     
			inc vBonusScoreScreenCounter            																		; $c98e: e6 f1     
			lda vBonusScoreScreenCounter            																		; $c990: a5 f1     
			cmp #$20           																		; $c992: c9 20     
				beq __startNewRound         																		; $c994: f0 03     
			jmp __handleMusicAndSound         																		; $c996: 4c dd f6  

;-------------------------------------------------------------------------------
__startNewRound:     jmp ___startNewRound         																		; $c999: 4c fc c8  

;-------------------------------------------------------------------------------
__drawBonusGoodLabel:     
			lda vBonusItemsCaught            																		; $c99c: a5 8b     
			cmp #$0a           																		; $c99e: c9 0a     
				bcc __return50         																		; $c9a0: 90 22     
			lda vBonusLevelExtraScore          																		; $c9a2: ad 50 02  
				bne __drawBonusGoodLabelPos         																		; $c9a5: d0 06     
				
			jsr __give1000Score         																		; $c9a7: 20 1a ff  
			inc vBonusLevelExtraScore          																		; $c9aa: ee 50 02  
			; set position
__drawBonusGoodLabelPos:     
			lda #$21           																		; $c9ad: a9 21     
			sta ppuAddress          																		; $c9af: 8d 06 20  
			lda #$0d           																		; $c9b2: a9 0d     
			sta ppuAddress          																		; $c9b4: 8d 06 20  
			
			ldx #$00           																		; $c9b7: a2 00    			
__drawGoodLabelLoop:     
			lda __goodLabel,x       																		; $c9b9: bd c5 c9  
			sta ppuData          																		; $c9bc: 8d 07 20  
			inx                																		; $c9bf: e8        
			cpx #$06           																		; $c9c0: e0 06     
				bne __drawGoodLabelLoop         																		; $c9c2: d0 f5     
__return50:     
			rts                																		; $c9c4: 60        

;-------------------------------------------------------------------------------
__goodLabel:     
			.hex 10 18 18 0d   																		; $c9c5: 10 18 18 0d   Data
			.hex 24 27         																		; $c9c9: 24 27         Data
			
__drawNoBonusLabel:     
			lda #$21           																		; $c9cb: a9 21     
			sta ppuAddress          																		; $c9cd: 8d 06 20  
			lda #$0c           																		; $c9d0: a9 0c     
			sta ppuAddress          																		; $c9d2: 8d 06 20  
			ldx #$00           																		; $c9d5: a2 00     
__drawNoBonusLabelLoop:     
			lda __noBonusLabel,x       																		; $c9d7: bd 36 ca  
			sta ppuData          																		; $c9da: 8d 07 20  
			inx                																		; $c9dd: e8        
			cpx #$08           																		; $c9de: e0 08     
				bne __drawNoBonusLabelLoop         																		; $c9e0: d0 f5     
			jmp __scrollScreen         																		; $c9e2: 4c b6 fd  

;-------------------------------------------------------------------------------
___giveBonus3000:     
			jsr __give1000Score         																		; $c9e5: 20 1a ff  
___giveBonus2000:     
			jsr __give1000Score         																		; $c9e8: 20 1a ff  
___giveBonus1000:     
			jsr __give1000Score         																		; $c9eb: 20 1a ff  
			; now count this bonus score
			; set position
			lda #$21           																		; $c9ee: a9 21     
			sta ppuAddress          																		; $c9f0: 8d 06 20  
			lda #$08           																		; $c9f3: a9 08     
			sta ppuAddress          																		; $c9f5: 8d 06 20  
			
			ldx #$00           																		; $c9f8: a2 00     
___drawBonusLabelLoop:     
			lda __bonusLabel,x       																		; $c9fa: bd 3e ca  
			sta ppuData          																		; $c9fd: 8d 07 20  
			inx                																		; $ca00: e8        
			cpx #$0c           																		; $ca01: e0 0c     
				bne ___drawBonusLabelLoop         																		; $ca03: d0 f5     
				
			lda vNestling1000Bonus          																		; $ca05: ad 2a 02  
				bne __draw1000Bonus         																		; $ca08: d0 27     
			lda vNestling2000Bonus          																		; $ca0a: ad 29 02  
				bne __draw2000Bonus         																		; $ca0d: d0 1d     
			; draw 3000 bonus
			lda #$03           																		; $ca0f: a9 03     
__drawBonus:     
			sta ppuData          																		; $ca11: 8d 07 20  
			; fill 3 zeroes
			lda #$00           																		; $ca14: a9 00     
			sta ppuData          																		; $ca16: 8d 07 20  
			sta ppuData          																		; $ca19: 8d 07 20  
			sta ppuData          																		; $ca1c: 8d 07 20  
			; "wow score" sound
			lda #$0f           																		; $ca1f: a9 0f     
			sta vMusicPlayerState            																		; $ca21: 85 20     
			
			jsr __drawTotalScoreLabel         																		; $ca23: 20 4a ca  
			jsr __scrollScreen         																		; $ca26: 20 b6 fd  
			jmp __handleMusicAndSound         																		; $ca29: 4c dd f6  

;-------------------------------------------------------------------------------
__draw2000Bonus:     
			lda #$02           																		; $ca2c: a9 02     
			jmp __drawBonus         																		; $ca2e: 4c 11 ca  

;-------------------------------------------------------------------------------
__draw1000Bonus:     
			lda #$01           																		; $ca31: a9 01     
			jmp __drawBonus         																		; $ca33: 4c 11 ca  

;-------------------------------------------------------------------------------
__noBonusLabel:     
			.hex 17 18 24 0b   																		; $ca36: 17 18 24 0b   Data
			.hex 18 17 1e 1c   																		; $ca3a: 18 17 1e 1c   Data
__bonusLabel:     
			.hex 0b 18 17 1e   																		; $ca3e: 0b 18 17 1e   Data
			.hex 1c 24 24 24   																		; $ca42: 1c 24 24 24   Data
			.hex 24 24 24 24   																		; $ca46: 24 24 24 24   Data

;-------------------------------------------------------------------------------
; draws "score" on level finished screen
__drawTotalScoreLabel:     
			; set position
			ldx #$00           																		; $ca4a: a2 00     
			lda #$20           																		; $ca4c: a9 20     
			sta ppuAddress          																		; $ca4e: 8d 06 20  
			lda #$c8           																		; $ca51: a9 c8     
			sta ppuAddress          																		; $ca53: 8d 06 20  
			
__drawTotalScoreLabelLoop:     
			lda __scoreLabel,x       																		; $ca56: bd 8c ca  
			sta ppuData          																		; $ca59: 8d 07 20  
			inx                																		; $ca5c: e8        
			cpx #$05           																		; $ca5d: e0 05     
				bne __drawTotalScoreLabelLoop         																		; $ca5f: d0 f5     
			
			; set position for score
			lda #$20           																		; $ca61: a9 20     
			sta ppuAddress          																		; $ca63: 8d 06 20  
			lda #$d0           																		; $ca66: a9 d0     
			sta ppuAddress          																		; $ca68: 8d 06 20  	
__drawPlayerScore:     
			ldx #$07           																		; $ca6b: a2 07     
__drawScoreEmpty:     
			lda vPlayerScore,x        																		; $ca6d: bd 00 01  
			bne __drawScoreNumber         																		; $ca70: d0 0e     
			lda #$24           																		; $ca72: a9 24     
			sta ppuData          																		; $ca74: 8d 07 20  
			dex                																		; $ca77: ca        
				bne __drawScoreEmpty         																		; $ca78: d0 f3     
__drawExtraZero:     
			lda #$00           																		; $ca7a: a9 00     
			sta ppuData          																		; $ca7c: 8d 07 20  
__return:     
			rts                																		; $ca7f: 60        

;-------------------------------------------------------------------------------
__drawScoreNumber:     
			lda vPlayerScore,x        																		; $ca80: bd 00 01  
			sta ppuData          																		; $ca83: 8d 07 20  
			dex                																		; $ca86: ca        
				bne __drawScoreNumber         																		; $ca87: d0 f7     
			jmp __drawExtraZero         																		; $ca89: 4c 7a ca  

;-------------------------------------------------------------------------------
__scoreLabel:     
			.hex 1c 0c 18 1b   																		; $ca8c: 1c 0c 18 1b   Data
			.hex 0e            																		; $ca90: 0e            Data

;-------------------------------------------------------------------------------
__drawScoreLabel:     
			; don't draw score if in bonus level
			jsr __levelModulo4ToX         																		; $ca91: 20 5e c3  
			cpx #$03           																		; $ca94: e0 03     
				beq __return         																		; $ca96: f0 e7   
			
			ldx #$00           																		; $ca98: a2 00     
			lda #$20           																		; $ca9a: a9 20     
			sta ppuAddress          																		; $ca9c: 8d 06 20  
			lda #$69           																		; $ca9f: a9 69     
			sta ppuAddress          																		; $caa1: 8d 06 20  
__drawScoreLabelLoop:     
			lda __scoreLabel,x       																		; $caa4: bd 8c ca  
			sta ppuData          																		; $caa7: 8d 07 20  
			inx                																		; $caaa: e8        
			cpx #$05           																		; $caab: e0 05  
			bne __drawScoreLabelLoop         																		; $caad: d0 f5     
			
			lda #$20           																		; $caaf: a9 20     
			sta ppuAddress          																		; $cab1: 8d 06 20  
			lda #$6e           																		; $cab4: a9 6e     
			sta ppuAddress          																		; $cab6: 8d 06 20  
			jmp __drawPlayerScore         																		; $cab9: 4c 6b ca  

;-------------------------------------------------------------------------------
__drawLives:     
			lda vDemoSequenceActive          																		; $cabc: ad 73 02  
				bne __return21         																		; $cabf: d0 33     
			lda vGotExtraLife          																		; $cac1: ad 30 02  
				bne __prepareDrawLives         																		; $cac4: d0 10   
			; check if we have 30000 pts
			lda $0104          																		; $cac6: ad 04 01  
			cmp #$03           																		; $cac9: c9 03     
				bcc __prepareDrawLives         																		; $cacb: 90 09     
			; wow, 1 EXTRA LIFE FOR THIS 36 LEVEL HELL
			inc vGotExtraLife          																		; $cacd: ee 30 02  
			inc vBirdLives            																		; $cad0: e6 56     
			; extra life sound
			lda #$04           																		; $cad2: a9 04     
			sta vSoundPlayerState            																		; $cad4: 85 2a 
			
__prepareDrawLives:     
			lda #$f0           																		; $cad6: a9 f0     
			sta $0774          																		; $cad8: 8d 74 07  
			sta $0778          																		; $cadb: 8d 78 07  
			sta $0770          																		; $cade: 8d 70 07  
			ldx #$00           																		; $cae1: a2 00     
			ldy vBirdLives            																		; $cae3: a4 56     
			dey                																		; $cae5: 88        
				beq __return21         																		; $cae6: f0 0c 
				
__drawLivesLoop:     
			lda #$18           																		; $cae8: a9 18     
			sta $0770,x        																		; $caea: 9d 70 07  
			inx                																		; $caed: e8        
			inx                																		; $caee: e8        
			inx                																		; $caef: e8        
			inx                																		; $caf0: e8        
			dey                																		; $caf1: 88        
				bne __drawLivesLoop         																		; $caf2: d0 f4     
__return21:     
			rts                																		; $caf4: 60        

;-------------------------------------------------------------------------------
__increaseRoundNumber:     
			lda vCurrentLevel            																		; $caf5: a5 55     
			and #$03           																		; $caf7: 29 03     
			cmp #$03           																		; $caf9: c9 03   
				; bonus level
				beq __return26         																		; $cafb: f0 14     
				
			ldx #$00           																		; $cafd: a2 00     
__increaseRoundNumberLoop:     
			lda vRoundNumber,x          																		; $caff: b5 f2     
			clc                																		; $cb01: 18        
			adc #$01           																		; $cb02: 69 01     
			cmp #$0a           																		; $cb04: c9 0a     
				bne __storeRoundNumber         																		; $cb06: d0 0a     
			lda #$00           																		; $cb08: a9 00     
			sta vRoundNumber,x          																		; $cb0a: 95 f2     
			inx                																		; $cb0c: e8        
			cpx #$03           																		; $cb0d: e0 03     
				bne __increaseRoundNumberLoop         																		; $cb0f: d0 ee     
__return26:     
			rts                																		; $cb11: 60        

;-------------------------------------------------------------------------------
__storeRoundNumber:     
			sta vRoundNumber,x          																		; $cb12: 95 f2     
			rts                																		; $cb14: 60        

;-------------------------------------------------------------------------------
; toogle game modes in main menu
__mainMenuHandleSelect:     
			lda vPlayerInput            																		; $cb15: a5 0a     
			
			; is Select pressed
			and #$04           																		; $cb17: 29 04     
				bne __mainMenuSelectPressed         																		; $cb19: d0 05     
			
			lda #$00           																		; $cb1b: a9 00     
			sta vCounter            																		; $cb1d: 85 51     
			rts                																		; $cb1f: 60        
			
__mainMenuSelectPressed:     
			; if select is kept pressed, don't change game mode 
			lda vCounter            																		; $cb20: a5 51     
				bne __return45         																		; $cb22: d0 06     
			; otherwise select another game mode
			inc vGameMode            																		; $cb24: e6 52     
			lda #$01           																		; $cb26: a9 01     
			sta vCounter            																		; $cb28: 85 51     
			
__return45:     
			rts                																		; $cb2a: 60        

;-------------------------------------------------------------------------------
__drawMainMenuBird:     
			; is it time to show demo play?
			lda vMainMenuCounter            																		; $cb2b: a5 57     
			cmp #$20           																		; $cb2d: c9 20     
				beq __return45         																		; $cb2f: f0 f9     
				bcs __return45         																		; $cb31: b0 f7     
			
			jsr __setPPUIncrementBy32         																		; $cb33: 20 e4 fe  
			jsr __clearXY         																		; $cb36: 20 16 d7  
			
			; draw bird either on "game start", or "study mode" label
			lda #$22           																		; $cb39: a9 22     
			sta ppuAddress          																		; $cb3b: 8d 06 20  
			lda #$89           																		; $cb3e: a9 89     
			sta ppuAddress          																		; $cb40: 8d 06 20  
			
			lda vGameMode            																		; $cb43: a5 52     
			and #$01           																		; $cb45: 29 01     
			; is study mode
				bne __mainMenuOnStudyGame         																		; $cb47: d0 12 
			
__drawMainMenuBirdLoop:     
			lda __mainMenuBirdImage,x       																		; $cb49: bd 35 cc  
			sta ppuData          																		; $cb4c: 8d 07 20  
			inx                																		; $cb4f: e8        
			iny                																		; $cb50: c8        
			cpy #$03           																		; $cb51: c0 03     
				bne __drawMainMenuBirdLoop         																		; $cb53: d0 f4   
			
			jsr __scrollScreen         																		; $cb55: 20 b6 fd  
			jmp __setPPUIncrementBy1         																		; $cb58: 4c da fe  

;-------------------------------------------------------------------------------
__mainMenuOnStudyGame:     
			ldx #$03           																		; $cb5b: a2 03     
			jmp __drawMainMenuBirdLoop         																		; $cb5d: 4c 49 cb  

;-------------------------------------------------------------------------------
__initGameDemo:     jmp ___initGameDemo         																		; $cb60: 4c cf cb  

;-------------------------------------------------------------------------------
__playGameDemo:     jmp ___playGameDemo         																		; $cb63: 4c ea cb  

;-------------------------------------------------------------------------------
__handleMainMenu:     
			lda vMainMenuCounter            																		; $cb66: a5 57     
			cmp #$20           																		; $cb68: c9 20     
				beq __initGameDemo         																		; $cb6a: f0 f4   	
				bcs __playGameDemo         																		; $cb6c: b0 f5   
				
			jsr __handleStartButton         																		; $cb6e: 20 2c c2  
			lda vStartPressedCount            																		; $cb71: a5 d1     
			and #$01           																		; $cb73: 29 01     
				beq __updateMainMenuCounter         																		; $cb75: f0 33     
			; select game mode
			lda vGameMode            																		; $cb77: a5 52     
			and #$01           																		; $cb79: 29 01     
				bne __setStudyModeState         																		; $cb7b: d0 28     
			lda #$00           																		; $cb7d: a9 00     
			sta vCurrentLevel            																		; $cb7f: 85 55     
			lda #$01           																		; $cb81: a9 01     
			sta vRoundNumber            																		; $cb83: 85 f2  
			
__startGame:     
			lda #$01           																		; $cb85: a9 01     
			sta vStartPressedCount            																		; $cb87: 85 d1     
			lda #$03           																		; $cb89: a9 03     
			sta vBirdLives            																		; $cb8b: 85 56     
			sta vNestlingMaxFeed            																		; $cb8d: 85 64     
			lda #$04           																		; $cb8f: a9 04     
			sta vNestlingAwayState            																		; $cb91: 85 65     
			lda #$00           																		; $cb93: a9 00     
			sta vFoxDeadTimer            																		; $cb95: 85 a7     
			sta vDemoSequenceActive          																		; $cb97: 8d 73 02  
			jsr __scrollScreen         																		; $cb9a: 20 b6 fd  
			jsr __resetPlayerScore         																		; $cb9d: 20 96 f5  
			inc vGameState            																		; $cba0: e6 50     
			jmp __composeOAMTable         																		; $cba2: 4c 3b ff  

;-------------------------------------------------------------------------------
__setStudyModeState:     
			lda #$fb           																		; $cba5: a9 fb     
			sta vGameState            																		; $cba7: 85 50     
			rts                																		; $cba9: 60        

;-------------------------------------------------------------------------------
__updateMainMenuCounter:     
			lda vCycleCounter            																		; $cbaa: a5 09     
			and #$1f           																		; $cbac: 29 1f     
				bne __skipMainMenuCounter         																		; $cbae: d0 08     
			lda vMainMenuCounter            																		; $cbb0: a5 57     
			cmp #$08           																		; $cbb2: c9 08     
				beq __startMainMenuMusic         																		; $cbb4: f0 05     
__increaseMainMenuCounter:     
			inc vMainMenuCounter            																		; $cbb6: e6 57     
__skipMainMenuCounter:     
			jmp __frozenGameLoop         																		; $cbb8: 4c 22 c1  

;-------------------------------------------------------------------------------
__startMainMenuMusic:     
			lda #$09           																		; $cbbb: a9 09     
			sta vMusicPlayerState            																		; $cbbd: 85 20     
			lda #$01           																		; $cbbf: a9 01     
			sta vDemoSequenceActive          																		; $cbc1: 8d 73 02  
			sta vBirdLives            																		; $cbc4: 85 56     
			lda #$ff           																		; $cbc6: a9 ff     
			sta vNestlingMaxFeed            																		; $cbc8: 85 64     
			sta vNestlingAwayState            																		; $cbca: 85 65     
			jmp __increaseMainMenuCounter         																		; $cbcc: 4c b6 cb  

;-------------------------------------------------------------------------------
___initGameDemo:     
			inc vMainMenuCounter            																		; $cbcf: e6 57     
			jsr __clearBirdNametable         																		; $cbd1: 20 a2 c6  
			
			; select random level to start (exclude bonus levels)
			lda vRandomVar            																		; $cbd4: a5 08     
			and #$03           																		; $cbd6: 29 03     
			tax                																		; $cbd8: aa        
__demoLevelSelectLoop:     
			inx                																		; $cbd9: e8        
			cpx #$03           																		; $cbda: e0 03     
			beq __demoLevelSelectLoop         																		; $cbdc: f0 fb     
			
			stx vCurrentLevel            																		; $cbde: 86 55     
			lda #$01           																		; $cbe0: a9 01     
			sta vRoundNumber            																		; $cbe2: 85 f2     
			jsr __hideSpritesInTable         																		; $cbe4: 20 94 fe  
			jmp __initGameLoop         																		; $cbe7: 4c 83 c0  

;-------------------------------------------------------------------------------
___playGameDemo:     
			lda vMainMenuCounter            																		; $cbea: a5 57     
			cmp #$40           																		; $cbec: c9 40     
				beq __forceEndGameDemo         																		; $cbee: f0 3a     
			
			lda vPlayerInput            																		; $cbf0: a5 0a     
			and #$0c           																		; $cbf2: 29 0c     
				bne __forceEndGameDemo         																		; $cbf4: d0 34   
				
			ldx vDemoPlayerInputDelay          																		; $cbf6: ae 71 02  
			lda __demoPlayerInputDelay,x       																		; $cbf9: bd 23 cc  
			cmp vMainMenuCounter            																		; $cbfc: c5 57     
				beq __nextDemoInput         																		; $cbfe: f0 13 
				
__setDemoInput:     
			ldx vDemoPlayerInput          																		; $cc00: ae 72 02  
			lda __demoPlayerInput,x       																		; $cc03: bd 1c cc  
			sta vPlayerInput            																		; $cc06: 85 0a     
			lda vCycleCounter            																		; $cc08: a5 09     
			and #$1f           																		; $cc0a: 29 1f     
				bne __processGameFrame         																		; $cc0c: d0 02     
			inc vMainMenuCounter            																		; $cc0e: e6 57     
__processGameFrame:     
			jmp ___processGameFrame         																		; $cc10: 4c ac c0  

;-------------------------------------------------------------------------------
__nextDemoInput:     
			inc vDemoPlayerInputDelay          																		; $cc13: ee 71 02  
			inc vDemoPlayerInput          																		; $cc16: ee 72 02  
			jmp __setDemoInput         																		; $cc19: 4c 00 cc  

;-------------------------------------------------------------------------------
__demoPlayerInput:     
			.hex 80 00 40 10   																		; $cc1c: 80 00 40 10   Data
			.hex 80 40 10      																		; $cc20: 80 40 10      Data
__demoPlayerInputDelay:     
			.hex 24 28 30 32   																		; $cc23: 24 28 30 32   Data
			.hex 3a 3c 3e      																		; $cc27: 3a 3c 3e      Data

;-------------------------------------------------------------------------------
__forceEndGameDemo:     
			; hide nestling sprite
			lda #$f0           																		; $cc2a: a9 f0     
			sta vNestlingCountSprite          																		; $cc2c: 8d 60 07  
			jsr __clearBirdNametable         																		; $cc2f: 20 a2 c6  
			jmp ___handleGameOver         																		; $cc32: 4c 67 f4  

;-------------------------------------------------------------------------------
__mainMenuBirdImage:     
			.hex 3d 24 24 24   																		; $cc35: 3d 24 24 24   Data
			.hex 24 3f         																		; $cc39: 24 3f         Data

;-------------------------------------------------------------------------------
__setStudyMode:     
			lda #$00           																		; $cc3b: a9 00     
			sta vDemoSequenceActive          																		; $cc3d: 8d 73 02  
			jsr __handleRoundSelectScoreScreen         																		; $cc40: 20 da e3  
			inc vIsStudyMode          																		; $cc43: ee e0 02  
			ldx #$00           																		; $cc46: a2 00     
			stx vScoreScreenState            																		; $cc48: 86 d3     
			jsr __setRoundLabelPosition         																		; $cc4a: 20 d4 c1  
			
__drawStudyRoundLabelLoop:     
			lda __roundXLabel,x       																		; $cc4d: bd 21 c2  
			sta ppuData          																		; $cc50: 8d 07 20  
			inx                																		; $cc53: e8        
			cpx #$08           																		; $cc54: e0 08     
				bne __drawStudyRoundLabelLoop         																		; $cc56: d0 f5 
				
			jsr __scrollScreen         																		; $cc58: 20 b6 fd  
			jmp __enableNMI         																		; $cc5b: 4c c6 fe  

;-------------------------------------------------------------------------------
___studyModeStageSelectLoop:     
			lda vIsStudyMode          																		; $cc5e: ad e0 02  
				beq __setStudyMode         																		; $cc61: f0 d8     
			lda vCycleCounter            																		; $cc63: a5 09     
			and #$0f           																		; $cc65: 29 0f     
				bne __drawRoundNumber         																		; $cc67: d0 2e   

			; read player input
			lda vPlayerInput            																		; $cc69: a5 0a  
			; up button
			and #$10           																		; $cc6b: 29 10     
				beq __studyModeCheckDDown         																		; $cc6d: f0 12     
			; check if we reached level 36
			lda vCurrentLevel            																		; $cc6f: a5 55     
			cmp #$2e           																		; $cc71: c9 2e     
				beq __studyModeCheckDDown         																		; $cc73: f0 0c     
			inc vCurrentLevel            																		; $cc75: e6 55     
			lda vCurrentLevel            																		; $cc77: a5 55     
			and #$03           																		; $cc79: 29 03     
			cmp #$03           																		; $cc7b: c9 03     
				bne __studyModeCheckDDown         																		; $cc7d: d0 02     
			inc vCurrentLevel            																		; $cc7f: e6 55     
__studyModeCheckDDown:     
			lda vPlayerInput            																		; $cc81: a5 0a     
			and #$20           																		; $cc83: 29 20     
				beq __drawRoundNumber         																		; $cc85: f0 10     
			lda vCurrentLevel            																		; $cc87: a5 55     
				beq __drawRoundNumber         																		; $cc89: f0 0c     
			dec vCurrentLevel            																		; $cc8b: c6 55     
			lda vCurrentLevel            																		; $cc8d: a5 55     
			and #$03           																		; $cc8f: 29 03     
			cmp #$03           																		; $cc91: c9 03     
				bne __drawRoundNumber         																		; $cc93: d0 02     
			dec vCurrentLevel            																		; $cc95: c6 55    			
__drawRoundNumber:     
			lda vCurrentLevel            																		; $cc97: a5 55     
			tax                																		; $cc99: aa        
			lda __levelLabel10s,x       																		; $cc9a: bd 05 cd  
			sta vStageSelect10s          																		; $cc9d: 8d e1 02  
			lda __levelLabelOnes,x       																		; $cca0: bd d5 cc  
			sta vStageSelectOnes          																		; $cca3: 8d e2 02  
			
			; set position
			lda #$20           																		; $cca6: a9 20     
			sta ppuAddress          																		; $cca8: 8d 06 20  
			lda #$d2           																		; $ccab: a9 d2     
			sta ppuAddress          																		; $ccad: 8d 06 20  
			
			lda vStageSelect10s          																		; $ccb0: ad e1 02  
			sta ppuData          																		; $ccb3: 8d 07 20  
			lda vStageSelectOnes          																		; $ccb6: ad e2 02  
			sta ppuData          																		; $ccb9: 8d 07 20  
			jsr __scrollScreen         																		; $ccbc: 20 b6 fd  
			
			; b button starts game
			lda vPlayerInput            																		; $ccbf: a5 0a     
			and #$02           																		; $ccc1: 29 02     
				bne __startStudyGame         																		; $ccc3: d0 01     
			rts                																		; $ccc5: 60        

;-------------------------------------------------------------------------------
__startStudyGame:     
			lda #$00           																		; $ccc6: a9 00     
			sta vStageSelect10s          																		; $ccc8: 8d e1 02  
			sta vStageSelectOnes          																		; $cccb: 8d e2 02  
			lda #$01           																		; $ccce: a9 01     
			sta vGameState            																		; $ccd0: 85 50     
			jmp __startGame         																		; $ccd2: 4c 85 cb  

;-------------------------------------------------------------------------------
__levelLabelOnes:     
			.hex 01 02 03 03   																		; $ccd5: 01 02 03 03   Data
			.hex 04 05 06 06   																		; $ccd9: 04 05 06 06   Data
			.hex 07 08 09 09   																		; $ccdd: 07 08 09 09   Data
			.hex 00 01 02 02   																		; $cce1: 00 01 02 02   Data
			.hex 03 04 05 05   																		; $cce5: 03 04 05 05   Data
			.hex 06 07 08 08   																		; $cce9: 06 07 08 08   Data
			.hex 09 00 01 01   																		; $cced: 09 00 01 01   Data
			.hex 02 03 04 04   																		; $ccf1: 02 03 04 04   Data
			.hex 05 06 07 07   																		; $ccf5: 05 06 07 07   Data
			.hex 08 09 00 00   																		; $ccf9: 08 09 00 00   Data
			.hex 01 02 03 03   																		; $ccfd: 01 02 03 03   Data
			.hex 04 05 06 06   																		; $cd01: 04 05 06 06   Data
__levelLabel10s:     
			.hex 24 24 24 24   																		; $cd05: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $cd09: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $cd0d: 24 24 24 24   Data
			.hex 01 01 01 01   																		; $cd11: 01 01 01 01   Data
			.hex 01 01 01 01   																		; $cd15: 01 01 01 01   Data
			.hex 01 01 01 01   																		; $cd19: 01 01 01 01   Data
			.hex 01 02 02 02   																		; $cd1d: 01 02 02 02   Data
			.hex 02 02 02 02   																		; $cd21: 02 02 02 02   Data
			.hex 02 02 02 02   																		; $cd25: 02 02 02 02   Data
			.hex 02 02 03 03   																		; $cd29: 02 02 03 03   Data
			.hex 03 03 03 03   																		; $cd2d: 03 03 03 03   Data
			.hex 03 03 03 03   																		; $cd31: 03 03 03 03   Data

;-------------------------------------------------------------------------------
__initGameActors:  
			; mute music
			lda #$00           																		; $cd35: a9 00     
			sta vMusicPlayerState            																		; $cd37: 85 20     
			
			sta $84            																		; $cd39: 85 84     
			sta $85            																		; $cd3b: 85 85     
			sta vWoodpeckerState            																		; $cd3d: 85 58     
			sta vWoodpeckerDeadTimer            																		; $cd3f: 85 59     
			; set empty sprite
			lda #$02           																		; $cd41: a9 02     
			sta $0775          																		; $cd43: 8d 75 07  
			sta $0779          																		; $cd46: 8d 79 07  
			sta $0771          																		; $cd49: 8d 71 07  
			sta $0701          																		; $cd4c: 8d 01 07  
			
			lda #$15           																		; $cd4f: a9 15     
			sta $072d          																		; $cd51: 8d 2d 07  
			; hide some actors
			lda #$f0           																		; $cd54: a9 f0     
			sta $0770          																		; $cd56: 8d 70 07  
			sta $0774          																		; $cd59: 8d 74 07  
			sta $0778          																		; $cd5c: 8d 78 07  
			sta $0764          																		; $cd5f: 8d 64 07  
			sta $0768          																		; $cd62: 8d 68 07  
			sta $076c          																		; $cd65: 8d 6c 07  
			sta vMoleY            																		; $cd68: 85 97     
			sta $9c            																		; $cd6a: 85 9c     
			sta vBeeX            																		; $cd6c: 85 70     
			sta vBeeY            																		; $cd6e: 85 90     
			sta vRisingNestlingY            																		; $cd70: 85 9d     
			sta vInvulnCreatureY            																		; $cd72: 85 9f     
			sta vFlowerY            																		; $cd74: 85 a1     
			; set X coords
			lda #$68           																		; $cd76: a9 68     
			sta $0767          																		; $cd78: 8d 67 07  
			lda #$71           																		; $cd7b: a9 71     
			sta $0765          																		; $cd7d: 8d 65 07  
			lda #$78           																		; $cd80: a9 78     
			sta $076b          																		; $cd82: 8d 6b 07  
			sta $0703          																		; $cd85: 8d 03 07  
			lda #$72           																		; $cd88: a9 72     
			sta $0769          																		; $cd8a: 8d 69 07  
			lda #$88           																		; $cd8d: a9 88     
			sta $076f          																		; $cd8f: 8d 6f 07  
			lda #$73           																		; $cd92: a9 73     
			sta $076d          																		; $cd94: 8d 6d 07  
			lda #$c8           																		; $cd97: a9 c8     
			sta $0773          																		; $cd99: 8d 73 07  
			lda #$d8           																		; $cd9c: a9 d8     
			sta $0777          																		; $cd9e: 8d 77 07  
			lda #$e8           																		; $cda1: a9 e8     
			sta $077b          																		; $cda3: 8d 7b 07  
			lda #$15           																		; $cda6: a9 15     
			sta $072d          																		; $cda8: 8d 2d 07  
			lda #$30           																		; $cdab: a9 30     
			sta vBirdSpritePosY          																		; $cdad: 8d 00 07  
			
			; bonus levels dont show nestling count 
			jsr __levelModulo4ToX         																		; $cdb0: 20 5e c3  
			cpx #$03           																		; $cdb3: e0 03     
				beq __initGameActors2         																		; $cdb5: f0 03     
			jsr __showNestlingCountSprite         																		; $cdb7: 20 94 ce  
			; continue initialization
__initGameActors2:  
			; now some level-dependent vatiables (loops every 6 levels)
			lda vCurrentLevel            																		; $cdba: a5 55     
			and #$07           																		; $cdbc: 29 07     
			tay                																		; $cdbe: a8        

			lda __kiteInitialSpeed,y       																		; $cdbf: b9 a4 ce  
			sta vKiteSpeed            																		; $cdc2: 85 6c     
			lda __kiteMaxYChange,y       																		; $cdc4: b9 ac ce  
			sta vKiteMaxYChange            																		; $cdc7: 85 69     
			ldx #$00           																		; $cdc9: a2 00     
			stx vButterfly1Timer            																		; $cdcb: 86 d6     
			lda __butterfly2InitialTimer,y       																		; $cdcd: b9 cc ce  
			sta vButterfly2Timer            																		; $cdd0: 85 d7     
			lda __butterfly3InitialTimer,y       																		; $cdd2: b9 d4 ce  
			sta vButterfly3Timer            																		; $cdd5: 85 d8     
			lda __butterfly4InitialTimer,y       																		; $cdd7: b9 dc ce  
			sta vButterfly4Timer            																		; $cdda: 85 d9     
			lda __nestling1StartingTimer,y       																		; $cddc: b9 b4 ce  
			sta vNestling1Timer          																		; $cddf: 8d 05 02  
			lda __nestling2StartingTimer,y       																		; $cde2: b9 bc ce  
			sta vNestling2Timer          																		; $cde5: 8d 06 02  
			lda __nestling3StartingTimer,y       																		; $cde8: b9 c4 ce  
			sta vNestling3Timer          																		; $cdeb: 8d 07 02  
			lda #$b0           																		; $cdee: a9 b0     
			sta vKiteX1            																		; $cdf0: 85 78     
			lda #$b8           																		; $cdf2: a9 b8     
			sta vKiteX2            																		; $cdf4: 85 79     
			lda #$a0           																		; $cdf6: a9 a0     
			sta vButterfly2X            																		; $cdf8: 85 74     
			lda #$b0           																		; $cdfa: a9 b0     
			sta vButterfly3X            																		; $cdfc: 85 75     
			lda #$c0           																		; $cdfe: a9 c0     
			sta vButterfly4X            																		; $ce00: 85 76     
			lda #$d0           																		; $ce02: a9 d0     
			sta vMoleX            																		; $ce04: 85 77     
			sta vHawkX            																		; $ce06: 85 80     
			sta vBeeX            																		; $ce08: 85 70     
			jsr __levelModulo4ToX         																		; $ce0a: 20 5e c3  
			lda __initialWoodpeckerPosX,x       																		; $ce0d: bd 15 ce  
			sta vWoodpeckerSquirrelX            																		; $ce10: 85 7e     
			jmp __initGameActors3         																		; $ce12: 4c 19 ce  

;-------------------------------------------------------------------------------
__initialWoodpeckerPosX:     
			.hex 3d 5d 98 f0   																		; $ce15: 3d 5d 98 f0   Data

;-------------------------------------------------------------------------------
__initGameActors3:     
			lda vCurrentLevel            																		; $ce19: a5 55     
			and #$0f           																		; $ce1b: 29 0f     
			tax                																		; $ce1d: aa        
			lda __initialBeePosY,x       																		; $ce1e: bd f4 ce  
			sta vBeeY            																		; $ce21: 85 90     
			lda __initialWoodpeckerY,x       																		; $ce23: bd e4 ce  
			sta vWoodpeckerSquirrelY            																		; $ce26: 85 9e     
			lda __initialButterflyY,x       																		; $ce28: bd 04 cf  
			sta vButterfly1Y            																		; $ce2b: 85 93     
			sta vButterfly2Y            																		; $ce2d: 85 94     
			sta vButterfly3Y            																		; $ce2f: 85 95     
			sta vButterfly4Y            																		; $ce31: 85 96     
			lda __initialKiteY,x       																		; $ce33: bd 14 cf  
			sta vKiteY1            																		; $ce36: 85 98     
			sta vKiteY2            																		; $ce38: 85 99     
			lda __initialMushroomY,x       																		; $ce3a: bd 24 cf  
			sta vMushroomY            																		; $ce3d: 85 9a     
			lda #$30           																		; $ce3f: a9 30     
			sta vMushroomX            																		; $ce41: 85 7a     
			lda __initialFoxY,x       																		; $ce43: bd 34 cf  
			sta vFoxY            																		; $ce46: 85 9b     
			lda vCurrentLevel            																		; $ce48: a5 55     
			and #$07           																		; $ce4a: 29 07     
			cmp #$07           																		; $ce4c: c9 07     
				bne __skipBonusLevelInit         																		; $ce4e: d0 10     
			lda #$50           																		; $ce50: a9 50     
			sta vButterfly1Y            																		; $ce52: 85 93     
			lda #$58           																		; $ce54: a9 58     
			sta vButterfly2Y            																		; $ce56: 85 94     
			lda #$59           																		; $ce58: a9 59     
			sta vButterfly3Y            																		; $ce5a: 85 95     
			lda #$40           																		; $ce5c: a9 40     
			sta vButterfly4Y            																		; $ce5e: 85 96     
__skipBonusLevelInit:     
			; hide some creatures
			lda #$f0           																		; $ce60: a9 f0     
			sta vBigBeeY            																		; $ce62: 85 91     
			; some strange creature
			sta $92            																		; $ce64: 85 92     
			sta vOAMTable          																		; $ce66: 8d 00 06  
			lda vCurrentLevel            																		; $ce69: a5 55     
			cmp #$10           																		; $ce6b: c9 10     
				bcc __finalInit         																		; $ce6d: 90 12     
			and #$0f           																		; $ce6f: 29 0f     
			cmp #$0c           																		; $ce71: c9 0c     
				bcc __finalInit         																		; $ce73: 90 0c     
			cmp #$0f           																		; $ce75: c9 0f     
				beq __finalInit         																		; $ce77: f0 08     
			lda #$40           																		; $ce79: a9 40     
			sta vBigBeeY            																		; $ce7b: 85 91     
			lda #$b0           																		; $ce7d: a9 b0     
			sta vBigBeeX            																		; $ce7f: 85 71     
__finalInit:     
			lda #$b0           																		; $ce81: a9 b0     
			sta vHawkX            																		; $ce83: 85 80     
			lda __initialHawkY,x       																		; $ce85: bd 44 cf  
			sta vHawkY            																		; $ce88: 85 a0     
			lda #$01           																		; $ce8a: a9 01     
			sta vSquirrelFlags          																		; $ce8c: 8d 61 02  
			lda #$02           																		; $ce8f: a9 02     
			sta vWoodpeckerState            																		; $ce91: 85 58     
			rts                																		; $ce93: 60        

;-------------------------------------------------------------------------------
__showNestlingCountSprite:     
			lda #$7f           																		; $ce94: a9 7f     
			sta $0761          																		; $ce96: 8d 61 07  
			lda #$14           																		; $ce99: a9 14     
			sta vNestlingCountSprite          																		; $ce9b: 8d 60 07  
			lda #$18           																		; $ce9e: a9 18     
			sta $0763          																		; $cea0: 8d 63 07  
			rts                																		; $cea3: 60        

;-------------------------------------------------------------------------------
__kiteInitialSpeed:     
			.hex 20 28 30 00   																		; $cea4: 20 28 30 00   Data
			.hex 30 30 30 00   																		; $cea8: 30 30 30 00   Data
__kiteMaxYChange:     
			.hex 18 20 28 00   																		; $ceac: 18 20 28 00   Data
			.hex 28 28 28 00   																		; $ceb0: 28 28 28 00   Data
__nestling1StartingTimer:     
			.hex 00 08 00 00   																		; $ceb4: 00 08 00 00   Data
			.hex 10 20 18 00   																		; $ceb8: 10 20 18 00   Data
__nestling2StartingTimer:     
			.hex 10 00 08 00   																		; $cebc: 10 00 08 00   Data
			.hex 30 00 10 00   																		; $cec0: 30 00 10 00   Data
__nestling3StartingTimer:     
			.hex 00 20 20 00   																		; $cec4: 00 20 20 00   Data
			.hex 08 10 00 00   																		; $cec8: 08 10 00 00   Data

__butterfly2InitialTimer:     
			.hex 20 30 40 10   																		; $cecc: 20 30 40 10   Data
			.hex 30 40 50 20   																		; $ced0: 30 40 50 20   Data
__butterfly3InitialTimer:     
			.hex 40 60 90 20   																		; $ced4: 40 60 90 20   Data
			.hex 80 70 60 40   																		; $ced8: 80 70 60 40   Data
__butterfly4InitialTimer:     
			.hex 90 80 60 58   																		; $cedc: 90 80 60 58   Data
			.hex 50 90 98 58   																		; $cee0: 50 90 98 58   Data
__initialWoodpeckerY:     
			.hex f0 f0 90 f0   																		; $cee4: f0 f0 90 f0   Data
			.hex 70 80 90 f0   																		; $cee8: 70 80 90 f0   Data
			.hex 80 90 80 f0   																		; $ceec: 80 90 80 f0   Data
			.hex 70 80 90 f0   																		; $cef0: 70 80 90 f0   Data
__initialBeePosY:     
			.hex f0 f0 f0 f0   																		; $cef4: f0 f0 f0 f0   Data
			.hex f0 f0 f0 f0   																		; $cef8: f0 f0 f0 f0   Data
			.hex f0 f0 f0 f0   																		; $cefc: f0 f0 f0 f0   Data
			.hex 40 50 60 f0   																		; $cf00: 40 50 60 f0   Data
__initialButterflyY:     
			.hex 40 50 60 d4   																		; $cf04: 40 50 60 d4   Data
			.hex 70 50 60 50   																		; $cf08: 70 50 60 50   Data
			.hex 50 60 50 d4   																		; $cf0c: 50 60 50 d4   Data
			.hex 50 60 70 60   																		; $cf10: 50 60 70 60   Data
__initialKiteY:     
			.hex 50 60 70 f0   																		; $cf14: 50 60 70 f0   Data
			.hex 60 70 80 f0   																		; $cf18: 60 70 80 f0   Data
			.hex 50 50 60 f0   																		; $cf1c: 50 50 60 f0   Data
			.hex 70 80 50 f0   																		; $cf20: 70 80 50 f0   Data
__initialMushroomY:     
			.hex c8 c8 c8 f0   																		; $cf24: c8 c8 c8 f0   Data
			.hex c8 c8 c8 f0   																		; $cf28: c8 c8 c8 f0   Data
			.hex c8 c8 c8 f0   																		; $cf2c: c8 c8 c8 f0   Data
			.hex c8 c8 c8 f0   																		; $cf30: c8 c8 c8 f0   Data
__initialFoxY:     
			.hex f0 c8 f0 f0   																		; $cf34: f0 c8 f0 f0   Data
			.hex f0 c8 f0 f0   																		; $cf38: f0 c8 f0 f0   Data
			.hex f0 c8 c8 f0   																		; $cf3c: f0 c8 c8 f0   Data
			.hex f0 c8 c8 f0   																		; $cf40: f0 c8 c8 f0   Data
__initialHawkY:     
			.hex f0 f0 f0 f0   																		; $cf44: f0 f0 f0 f0   Data
			.hex f0 f0 c0 f0   																		; $cf48: f0 f0 c0 f0   Data
			.hex c0 c0 c0 f0   																		; $cf4c: c0 c0 c0 f0   Data
			.hex c0 c0 c0 f0   																		; $cf50: c0 c0 c0 f0   Data

;-------------------------------------------------------------------------------
; things like bird landing/landed/on branch are processed here
__handleBirdFlags:     
			ldy #$01           																		; $cf54: a0 01     
			lda #$3c           																		; $cf56: a9 3c     
			sta vBirdOffsetX            																		; $cf58: 85 5c     
			jsr __updateBirdX         																		; $cf5a: 20 86 d1  
			jsr __isSeaBonusLevel         																		; $cf5d: 20 ee cf  
				beq __birdMissBranch         																		; $cf60: f0 40     
			cmp #$07           																		; $cf62: c9 07     
				beq __birdMissBranch         																		; $cf64: f0 3c     
			lda vBirdOffsetX            																		; $cf66: a5 5c     
			and #$01           																		; $cf68: 29 01     
				bne __birdMissBranch         																		; $cf6a: d0 36     
				
			jsr __levelModulo4ToX         																		; $cf6c: 20 5e c3  
			lda vCurrentLevel            																		; $cf6f: a5 55     
			cmp #$10           																		; $cf71: c9 10     
				bcs __set23LoopBranch         																		; $cf73: b0 49     
				
__birdCheckBranchLanding:     
			lda vBirdOffsetX            																		; $cf75: a5 5c     
			cmp __birdBranchLeftX,x       																		; $cf77: dd de d1  
				bcc __birdCheckBranchLanded         																		; $cf7a: 90 12     
			cmp __birdBranchRightX,x       																		; $cf7c: dd e6 d1  
				bcs __birdCheckBranchLanded         																		; $cf7f: b0 0d   
				
			lda vBirdSpritePosY          																		; $cf81: ad 00 07  
			cmp __birdBranchTopY,x       																		; $cf84: dd ee d1  
				bcc __birdCheckBranchLanded         																		; $cf87: 90 05     
			cmp __birdBranchBottomY,x       																		; $cf89: dd f6 d1  
				bcc __setBirdLanding         																		; $cf8c: 90 57     
				
__birdCheckBranchLanded:     
			lda vBirdOffsetX            																		; $cf8e: a5 5c     
			cmp __birdBranchStrictLeftX,x       																		; $cf90: dd fe d1  
				bcc __birdMissBranch         																		; $cf93: 90 0d     
			cmp __birdBranchStrictRightX,x       																		; $cf95: dd 06 d2  
				bcs __birdMissBranch         																		; $cf98: b0 08     
			lda vBirdSpritePosY          																		; $cf9a: ad 00 07  
			cmp __birdBranchBottomY,x       																		; $cf9d: dd f6 d1  
				beq __setBirdOnBranch         																		; $cfa0: f0 29    
				
__birdMissBranch:     
			ldx #$00           																		; $cfa2: a2 00     
			lda vBirdSpritePosY          																		; $cfa4: ad 00 07  
			cmp #$20           																		; $cfa7: c9 20     
				bcc __setBirdHitsTop         																		; $cfa9: 90 1b     
			stx vBirdHitsTop            																		; $cfab: 86 60     
			cmp #$c8           																		; $cfad: c9 c8     
				bcs __setBirdLanded         																		; $cfaf: b0 2b     
			stx vIsBirdLanded            																		; $cfb1: 86 61     
			cmp #$b8           																		; $cfb3: c9 b8     
				bcs __setBirdLanding         																		; $cfb5: b0 2e     
			stx vIsBirdLanding            																		; $cfb7: 86 62     
__removeBirdFromBranch:     
			lda #$00           																		; $cfb9: a9 00     
			sta vBirdOnBranch            																		; $cfbb: 85 ab     
			rts                																		; $cfbd: 60        

;-------------------------------------------------------------------------------
; branch on 2 and 3 loops is longer, so we should get another set of coordinates
__set23LoopBranch:     
			txa                																		; $cfbe: 8a        
			clc                																		; $cfbf: 18        
			adc #$04           																		; $cfc0: 69 04     
			tax                																		; $cfc2: aa        
			jmp __birdCheckBranchLanding         																		; $cfc3: 4c 75 cf  

;-------------------------------------------------------------------------------
__setBirdHitsTop:     
			sty vBirdHitsTop            																		; $cfc6: 84 60     
			jmp __removeBirdFromBranch         																		; $cfc8: 4c b9 cf  

;-------------------------------------------------------------------------------
__setBirdOnBranch:     
			lda vCurrentLevel            																		; $cfcb: a5 55     
			cmp #$20           																		; $cfcd: c9 20  
				; on 3rd loop it's unsafe to sit on branch, so we just consider it landing
				bcs __setBirdLanded         																		; $cfcf: b0 0b     
			lda #$00           																		; $cfd1: a9 00     
			sta vIsBirdLanding            																		; $cfd3: 85 62     
			sty vIsBirdLanded            																		; $cfd5: 84 61     
			lda #$01           																		; $cfd7: a9 01     
			sta vBirdOnBranch            																		; $cfd9: 85 ab     
			rts                																		; $cfdb: 60        

;-------------------------------------------------------------------------------
__setBirdLanded:     
			sty vIsBirdLanded            																		; $cfdc: 84 61     
			lda #$00           																		; $cfde: a9 00     
			sta vIsBirdLanding            																		; $cfe0: 85 62     
			jmp __removeBirdFromBranch         																		; $cfe2: 4c b9 cf  

;-------------------------------------------------------------------------------
__setBirdLanding:     
			sty vIsBirdLanding            																		; $cfe5: 84 62     
			lda #$00           																		; $cfe7: a9 00     
			sta vIsBirdLanded            																		; $cfe9: 85 61     
			jmp __removeBirdFromBranch         																		; $cfeb: 4c b9 cf  

;-------------------------------------------------------------------------------
__isSeaBonusLevel:     
			lda vCurrentLevel            																		; $cfee: a5 55     
			and #$07           																		; $cff0: 29 07     
			cmp #$03           																		; $cff2: c9 03     
			rts                																		; $cff4: 60        

;-------------------------------------------------------------------------------
__handleBirdFlight:     
			lda #$78           																		; $cff5: a9 78     
			sta $0703          																		; $cff7: 8d 03 07  
			lda vBirdSpritePosY          																		; $cffa: ad 00 07  
			cmp #$1e           																		; $cffd: c9 1e     
				bcc __d005         																		; $cfff: 90 04     
			cmp #$ca           																		; $d001: c9 ca     
				bcc __d00d         																		; $d003: 90 08     
__d005:     
			jsr __hideSpritesInTable         																		; $d005: 20 94 fe  
			lda #$30           																		; $d008: a9 30     
			sta vBirdSpritePosY          																		; $d00a: 8d 00 07  
__d00d:     
			jsr __isSeaBonusLevel         																		; $d00d: 20 ee cf  
				bne __handleBirdMovement         																		; $d010: d0 07     
			lda vIsBirdLanded            																		; $d012: a5 61     
				beq __handleBirdMovement         																		; $d014: f0 03  
			; we are not amphibious
			jmp __handleBirdDrowning         																		; $d016: 4c 9d d1  

;-------------------------------------------------------------------------------
__handleBirdMovement:     	
			lda vCycleCounter            																		; $d019: a5 09     
			and #$07           																		; $d01b: 29 07     
				beq __birdChangeDirection         																		; $d01d: f0 14     
			lda vBirdDirection            																		; $d01f: a5 5d     
				beq __birdMoveRight         																		; $d021: f0 37     
			cmp #$01           																		; $d023: c9 01     
				beq __birdMoveLeft         																		; $d025: f0 2c     
			cmp #$02           																		; $d027: c9 02     
				beq __birdMoveDown         																		; $d029: f0 25     
			cmp #$03           																		; $d02b: c9 03     
				beq ___birdMoveUp         																		; $d02d: f0 32     
			cmp #$04           																		; $d02f: c9 04     
				beq ___birdFreeFall         																		; $d031: f0 1a     
			
__birdChangeDirection:     
			lda #$00           																		; $d033: a9 00     
			sta vBirdDirection            																		; $d035: 85 5d     
			lda vPlayerInput            																		; $d037: a5 0a     
			asl                																		; $d039: 0a        
				bcs __birdMoveRight         																		; $d03a: b0 1e     
			inc vBirdDirection            																		; $d03c: e6 5d     
			asl                																		; $d03e: 0a        
				bcs __birdMoveLeft         																		; $d03f: b0 12     
			inc vBirdDirection            																		; $d041: e6 5d     
			asl                																		; $d043: 0a        
				bcs __birdMoveDown         																		; $d044: b0 0a     
			inc vBirdDirection            																		; $d046: e6 5d     
			asl                																		; $d048: 0a        
				bcs ___birdMoveUp         																		; $d049: b0 16     
			inc vBirdDirection            																		; $d04b: e6 5d     
___birdFreeFall:     
			jmp ____birdFreeFall         																		; $d04d: 4c 36 d1  

;-------------------------------------------------------------------------------
__birdMoveDown:     
			jmp ___birdMoveDown         																		; $d050: 4c 9b d0  

;-------------------------------------------------------------------------------
__birdMoveLeft:     
			lda #$00           																		; $d053: a9 00     
			sta vBirdIsRight            																		; $d055: 85 5a     
			jmp ___birdMoveLeft         																		; $d057: 4c f4 d0  

;-------------------------------------------------------------------------------
__birdMoveRight:     
			lda #$01           																		; $d05a: a9 01     
			sta vBirdIsRight            																		; $d05c: 85 5a     
			jmp ___birdMoveRight         																		; $d05e: 4c 18 d1  

;-------------------------------------------------------------------------------
___birdMoveUp:     
			lda vBirdHitsTop            																		; $d061: a5 60     
				bne __birdDontMoveUp         																		; $d063: d0 03     
			dec vBirdSpritePosY          																		; $d065: ce 00 07  
__birdDontMoveUp:     
			jsr __setXEvery8Cycle         																		; $d068: 20 8b d0  
			lda vBirdIsRight            																		; $d06b: a5 5a     
				bne ____birdMoveUp         																		; $d06d: d0 03     
			jsr __mirrorBirdSprite         																		; $d06f: 20 3f c8  
____birdMoveUp:     
			jsr __setBirdSprite         																		; $d072: 20 84 d0  
			jsr __isOddCycle         																		; $d075: 20 58 d6  
				bne __return41         																		; $d078: d0 10     
			lda vBirdIsRight            																		; $d07a: a5 5a     
				bne __birdMoveNametableRight         																		; $d07c: d0 03     
			jmp ___birdMoveNametableLeft         																		; $d07e: 4c 7b d1  

;-------------------------------------------------------------------------------
__birdMoveNametableRight:     
			jmp ___birdMoveNametableRight         																		; $d081: 4c 6e d1  

;-------------------------------------------------------------------------------
__setBirdSprite:     
			lda __birdSprites,x       																		; $d084: bd be d1  
			sta $0701          																		; $d087: 8d 01 07  
__return41:     
			rts                																		; $d08a: 60        

;-------------------------------------------------------------------------------
__setXEvery8Cycle:     
			lda vCycleCounter            																		; $d08b: a5 09     
			and #$18           																		; $d08d: 29 18     
			lsr                																		; $d08f: 4a        
			jmp ___setXEveryCycleNext         																		; $d090: 4c 97 d0  

;-------------------------------------------------------------------------------
__setXEvery4Cycle:     
			lda vCycleCounter            																		; $d093: a5 09     
			and #$0c           																		; $d095: 29 0c     
___setXEveryCycleNext:     
			lsr                																		; $d097: 4a        
			lsr                																		; $d098: 4a        
			tax                																		; $d099: aa        
			rts                																		; $d09a: 60        

;-------------------------------------------------------------------------------
___birdMoveDown:     
			lda vIsBirdLanded            																		; $d09b: a5 61     
				bne __setBirdLandedSprite         																		; $d09d: d0 26     
			lda vIsBirdLanding            																		; $d09f: a5 62     
				bne ___setBirdLandingSprite         																		; $d0a1: d0 30   
			
			inc vBirdSpritePosY          																		; $d0a3: ee 00 07  
			inc vBirdSpritePosY          																		; $d0a6: ee 00 07  
			jsr __setXEvery8Cycle         																		; $d0a9: 20 8b d0  
			txa                																		; $d0ac: 8a        
			clc                																		; $d0ad: 18        
			adc #$08           																		; $d0ae: 69 08     
			tax                																		; $d0b0: aa        
			lda vBirdIsRight            																		; $d0b1: a5 5a     
				bne ____setBirdSprite         																		; $d0b3: d0 03     
			jsr __mirrorBirdSprite         																		; $d0b5: 20 3f c8  
____setBirdSprite:     
			jsr __setBirdSprite         																		; $d0b8: 20 84 d0  
__birdMoveLeftOrRight:     
			lda vBirdIsRight            																		; $d0bb: a5 5a     
				bne ____birdMoveNametableRight         																		; $d0bd: d0 03     
			jmp ___birdMoveNametableLeft         																		; $d0bf: 4c 7b d1  

;-------------------------------------------------------------------------------
____birdMoveNametableRight:     jmp ___birdMoveNametableRight         																		; $d0c2: 4c 6e d1  

;-------------------------------------------------------------------------------
__setBirdLandedSprite:     
			lda vBirdIsRight            																		; $d0c5: a5 5a     
				bne __setBirdLandedLeftSprite         																		; $d0c7: d0 05     
			ldx #$11           																		; $d0c9: a2 11     
			jmp __setBirdSprite         																		; $d0cb: 4c 84 d0  

;-------------------------------------------------------------------------------
__setBirdLandedLeftSprite:     
			ldx #$15           																		; $d0ce: a2 15     
			jmp __setBirdSprite         																		; $d0d0: 4c 84 d0  

;-------------------------------------------------------------------------------
___setBirdLandingSprite:     
			jsr __getCycleModulo4         																		; $d0d3: 20 5d d6  
				bne __birdLandingKeepY         																		; $d0d6: d0 03     
			inc vBirdSpritePosY          																		; $d0d8: ee 00 07  
			
__birdLandingKeepY:     
			jsr __setXEvery4Cycle         																		; $d0db: 20 93 d0  
			txa                																		; $d0de: 8a        
			clc                																		; $d0df: 18        
			adc #$08           																		; $d0e0: 69 08     
			tax                																		; $d0e2: aa        
			lda vBirdIsRight            																		; $d0e3: a5 5a     
				bne ____setBirdLandingSprite         																		; $d0e5: d0 03     
			jsr __mirrorBirdSprite         																		; $d0e7: 20 3f c8  
____setBirdLandingSprite:     
			jsr __setBirdSprite         																		; $d0ea: 20 84 d0  
			lda vCycleCounter            																		; $d0ed: a5 09     
			and #$07           																		; $d0ef: 29 07     
				beq __birdMoveLeftOrRight         																		; $d0f1: f0 c8     
			rts                																		; $d0f3: 60        

;-------------------------------------------------------------------------------
___birdMoveLeft:     
			lda vIsBirdLanded            																		; $d0f4: a5 61     
				bne __birdMoveLandedLeft         																		; $d0f6: d0 0f     
			jsr __setXEvery8Cycle         																		; $d0f8: 20 8b d0  
			jsr __mirrorBirdSprite         																		; $d0fb: 20 3f c8  
			lda __birdSprites,x       																		; $d0fe: bd be d1  
			sta $0701          																		; $d101: 8d 01 07  
____birdMoveNametableLeft:     
			jmp ___birdMoveNametableLeft         																		; $d104: 4c 7b d1  

;-------------------------------------------------------------------------------
__birdMoveLandedLeft:     
			jsr __setXEvery8Cycle         																		; $d107: 20 8b d0  
			txa                																		; $d10a: 8a        
			clc                																		; $d10b: 18        
			adc #$10           																		; $d10c: 69 10     
			tax                																		; $d10e: aa        
			jsr __setBirdSprite         																		; $d10f: 20 84 d0  
			jsr __getCycleModulo4         																		; $d112: 20 5d d6  
				beq ____birdMoveNametableLeft         																		; $d115: f0 ed     
			rts                																		; $d117: 60        

;-------------------------------------------------------------------------------
___birdMoveRight:     
			lda vIsBirdLanded            																		; $d118: a5 61     
				bne __birdMoveLandedRight         																		; $d11a: d0 09     
			jsr __setXEvery8Cycle         																		; $d11c: 20 8b d0  
			jsr __setBirdSprite         																		; $d11f: 20 84 d0  
______birdMoveNametableRight:     
			jmp ___birdMoveNametableRight         																		; $d122: 4c 6e d1  

;-------------------------------------------------------------------------------
__birdMoveLandedRight:     
			jsr __setXEvery8Cycle         																		; $d125: 20 8b d0  
			txa                																		; $d128: 8a        
			clc                																		; $d129: 18        
			adc #$14           																		; $d12a: 69 14     
			tax                																		; $d12c: aa        
			jsr __setBirdSprite         																		; $d12d: 20 84 d0  
			jsr __getCycleModulo4         																		; $d130: 20 5d d6  
				beq ______birdMoveNametableRight         																		; $d133: f0 ed     
			rts                																		; $d135: 60        

;-------------------------------------------------------------------------------
____birdFreeFall:     
			lda vIsBirdLanded            																		; $d136: a5 61     
				bne ___setBirdLandedSprite         																		; $d138: d0 23     
			lda vIsBirdLanding            																		; $d13a: a5 62     
				bne __setBirdLandingSprite         																		; $d13c: d0 2d     
			jsr __setXEvery8Cycle         																		; $d13e: 20 8b d0  
			lda vBirdIsRight            																		; $d141: a5 5a     
				bne __birdFreeFallRight         																		; $d143: d0 03     
			jsr __mirrorBirdSprite         																		; $d145: 20 3f c8  
__birdFreeFallRight:     
			jsr __setBirdSprite         																		; $d148: 20 84 d0  
			jsr __isOddCycle         																		; $d14b: 20 58 d6  
				bne __birdFreeFallDontChangeY         																		; $d14e: d0 03     
			inc vBirdSpritePosY          																		; $d150: ee 00 07  
__birdFreeFallDontChangeY:     
			lda vBirdIsRight            																		; $d153: a5 5a     
				bne _____birdMoveNametableRight         																		; $d155: d0 03     
			jmp ___birdMoveNametableLeft         																		; $d157: 4c 7b d1  

;-------------------------------------------------------------------------------
_____birdMoveNametableRight:     
			jmp ___birdMoveNametableRight         																		; $d15a: 4c 6e d1  

;-------------------------------------------------------------------------------
___setBirdLandedSprite:     
			lda vBirdIsRight            																		; $d15d: a5 5a     
				bne __setBirdLandedRightSprite         																		; $d15f: d0 05     
			ldx #$11           																		; $d161: a2 11     
___setBirdSprite:     
			jmp __setBirdSprite         																		; $d163: 4c 84 d0  

;-------------------------------------------------------------------------------
__setBirdLandedRightSprite:     
			ldx #$15           																		; $d166: a2 15     
			jmp ___setBirdSprite         																		; $d168: 4c 63 d1  

;-------------------------------------------------------------------------------
__setBirdLandingSprite:     jmp ___setBirdLandingSprite         																		; $d16b: 4c d3 d0  

;-------------------------------------------------------------------------------
___birdMoveNametableRight:     
			inc vBirdPPUX            																		; $d16e: e6 03     
				bne __birdClampNametable         																		; $d170: d0 02     
			inc vBirdPPUNametable            																		; $d172: e6 02     
__birdClampNametable:     
			lda vBirdPPUNametable            																		; $d174: a5 02     
			and #$01           																		; $d176: 29 01     
			sta vBirdPPUNametable            																		; $d178: 85 02     
			rts                																		; $d17a: 60        

;-------------------------------------------------------------------------------
___birdMoveNametableLeft:     
			lda vBirdPPUX            																		; $d17b: a5 03     
				bne ___birdMoveNametableLeftX         																		; $d17d: d0 02     
			dec vBirdPPUNametable            																		; $d17f: c6 02     
___birdMoveNametableLeftX:     
			dec vBirdPPUX            																		; $d181: c6 03     
			jmp __birdClampNametable         																		; $d183: 4c 74 d1  

;-------------------------------------------------------------------------------
__updateBirdX:     
			jsr __convertNametableCoordToReal         																		; $d186: 20 fc d4  
			sta vBirdX            																		; $d189: 85 5b     
			lda vBirdOffsetX            																		; $d18b: a5 5c     
			clc                																		; $d18d: 18        
			adc vBirdX            																		; $d18e: 65 5b     
			cmp #$7c           																		; $d190: c9 7c     
				bcs __birdOutsideNametable0         																		; $d192: b0 04     
			asl                																		; $d194: 0a        
__updateBirdOffsetX:     
			sta vBirdOffsetX            																		; $d195: 85 5c     
			rts                																		; $d197: 60        

;-------------------------------------------------------------------------------
__birdOutsideNametable0:     
			lda #$01           																		; $d198: a9 01     
			jmp __updateBirdOffsetX         																		; $d19a: 4c 95 d1  

;-------------------------------------------------------------------------------
__handleBirdDrowning:     
			inc vBirdDrownTimer          																		; $d19d: ee 27 02  
			lda vBirdDrownTimer          																		; $d1a0: ad 27 02  
			and #$7f           																		; $d1a3: 29 7f     
				beq __endBonusLevel         																		; $d1a5: f0 14     
			jsr __setXEvery4Cycle         																		; $d1a7: 20 93 d0  
			lda vBirdIsRight            																		; $d1aa: a5 5a     
				beq __mirrorBirdDrownSprite         																		; $d1ac: f0 07     
__setBirdDrownSprite:     
			lda __birdDrownSprites,x       																		; $d1ae: bd d6 d1  
			sta $0701          																		; $d1b1: 8d 01 07  
			rts                																		; $d1b4: 60        

;-------------------------------------------------------------------------------
__mirrorBirdDrownSprite:     
			jsr __mirrorBirdSprite         																		; $d1b5: 20 3f c8  
			jmp __setBirdDrownSprite         																		; $d1b8: 4c ae d1  

;-------------------------------------------------------------------------------
__endBonusLevel:     jmp ___endBonusLevel         																		; $d1bb: 4c 23 e0  

;-------------------------------------------------------------------------------
__birdSprites:     
			.hex 00 01 02 01   																		; $d1be: 00 01 02 01   Data
__birdMirrorSprites:     
			.hex 03 04 05 04   																		; $d1c2: 03 04 05 04   Data
			.hex 06 07 08 07   																		; $d1c6: 06 07 08 07   Data
			.hex 09 0a 0b 0a   																		; $d1ca: 09 0a 0b 0a   Data
			.hex 0f 10 11 10   																		; $d1ce: 0f 10 11 10   Data
			.hex 0c 0d 0e 0d   																		; $d1d2: 0c 0d 0e 0d   Data
__birdDrownSprites:     
			.hex 81 83 81 83   																		; $d1d6: 81 83 81 83   Data
			.hex 82 84 82 84   																		; $d1da: 82 84 82 84   Data
__birdBranchLeftX:     
			.hex 74 b4 34 00   																		; $d1de: 74 b4 34 00   Data
			.hex 74 b4 34 00   																		; $d1e2: 74 b4 34 00   Data
__birdBranchRightX:     
			.hex 9c dc 5c 00   																		; $d1e6: 9c dc 5c 00   Data
			.hex ac ec 6c 00   																		; $d1ea: ac ec 6c 00   Data
__birdBranchTopY:     
			.hex 68 58 58 00   																		; $d1ee: 68 58 58 00   Data
			.hex 68 58 58 00   																		; $d1f2: 68 58 58 00   Data
__birdBranchBottomY:     
			.hex 70 60 60 00   																		; $d1f6: 70 60 60 00   Data
			.hex 70 60 60 00   																		; $d1fa: 70 60 60 00   Data
__birdBranchStrictLeftX:     
			.hex 78 b8 38 00   																		; $d1fe: 78 b8 38 00   Data
			.hex 78 b8 38 00   																		; $d202: 78 b8 38 00   Data
__birdBranchStrictRightX:     
			.hex 98 d8 58 00   																		; $d206: 98 d8 58 00   Data
			.hex a8 e8 68 00   																		; $d20a: a8 e8 68 00   Data
__spriteData1:     
			.hex 08 0c 10 0a   																		; $d20e: 08 0c 10 0a   Data
			.hex 0e 12 14 18   																		; $d212: 0e 12 14 18   Data
			.hex 1c 16 1a 1e   																		; $d216: 1c 16 1a 1e   Data
			.hex 28 2c 30 2a   																		; $d21a: 28 2c 30 2a   Data
			.hex 2e 32 34 36   																		; $d21e: 2e 32 34 36   Data
			.hex 38 3c 40 44   																		; $d222: 38 3c 40 44   Data
			.hex 46 44 46 46   																		; $d226: 46 44 46 46   Data
			.hex 48 4a 4c 4e   																		; $d22a: 48 4a 4c 4e   Data
			.hex 50 52 54 56   																		; $d22e: 50 52 54 56   Data
			.hex 58 5a 5c 5e   																		; $d232: 58 5a 5c 5e   Data
			.hex 60 62 64 66   																		; $d236: 60 62 64 66   Data
			.hex 68 6a 6c 6e   																		; $d23a: 68 6a 6c 6e   Data
			.hex 70 74 78 7c   																		; $d23e: 70 74 78 7c   Data
			.hex 24 00 04 06   																		; $d242: 24 00 04 06   Data
			.hex 24 48 26 4a   																		; $d246: 24 48 26 4a   Data
			.hex 88 8a 8c 8e   																		; $d24a: 88 8a 8c 8e   Data
			.hex 90 92 94 96   																		; $d24e: 90 92 94 96   Data
			.hex 98 9a 9c 9e   																		; $d252: 98 9a 9c 9e   Data
			.hex a0 a2 a4 a6   																		; $d256: a0 a2 a4 a6   Data
			.hex a8 aa ac ae   																		; $d25a: a8 aa ac ae   Data
			.hex b0 b4 b8 bc   																		; $d25e: b0 b4 b8 bc   Data
			.hex be bc be c0   																		; $d262: be bc be c0   Data
			.hex c2 c4 c6 c8   																		; $d266: c2 c4 c6 c8   Data
			.hex 08 0c 10 0a   																		; $d26a: 08 0c 10 0a   Data
			.hex 0e 12 14 18   																		; $d26e: 0e 12 14 18   Data
			.hex 1c 16 1a 1e   																		; $d272: 1c 16 1a 1e   Data
			.hex 28 2c 30 2a   																		; $d276: 28 2c 30 2a   Data
			.hex 2e 32 34 36   																		; $d27a: 2e 32 34 36   Data
			.hex 38 f4 f8 fc   																		; $d27e: 38 f4 f8 fc   Data
			.hex 20 22 c1 c3   																		; $d282: 20 22 c1 c3   Data
			.hex c5 c7 c9 cd   																		; $d286: c5 c7 c9 cd   Data
			.hex cf d1 d3 d4   																		; $d28a: cf d1 d3 d4   Data
			.hex d8 d9 db dd   																		; $d28e: d8 d9 db dd   Data
			.hex df e0 e2 e4   																		; $d292: df e0 e2 e4   Data
			.hex e6 dc de d0   																		; $d296: e6 dc de d0   Data
			.hex d2 cc ce d0   																		; $d29a: d2 cc ce d0   Data
			.hex d2 c8 e8 ea   																		; $d29e: d2 c8 e8 ea   Data
			.hex ec ee f0 bd   																		; $d2a2: ec ee f0 bd   Data
			.hex 80 84 88 d5   																		; $d2a6: 80 84 88 d5   Data
			.hex 79 7b 7e      																		; $d2aa: 79 7b 7e      Data
__spriteAtrrib1:     
			.hex 00 00 00 40   																		; $d2ad: 00 00 00 40   Data
			.hex 40 40 00 00   																		; $d2b1: 40 40 00 00   Data
			.hex 00 40 40 40   																		; $d2b5: 00 40 40 40   Data
			.hex 00 00 00 40   																		; $d2b9: 00 00 00 40   Data
			.hex 40 40 00 40   																		; $d2bd: 40 40 00 40   Data
			.hex 00 03 03 03   																		; $d2c1: 00 03 03 03   Data
			.hex 43 83 43 c3   																		; $d2c5: 43 83 43 c3   Data
			.hex 03 43 03 43   																		; $d2c9: 03 43 03 43   Data
			.hex 03 43 03 43   																		; $d2cd: 03 43 03 43   Data
			.hex 03 43 02 42   																		; $d2d1: 03 43 02 42   Data
			.hex 02 42 02 42   																		; $d2d5: 02 42 02 42   Data
			.hex 02 42 02 42   																		; $d2d9: 02 42 02 42   Data
			.hex 03 03 03 03   																		; $d2dd: 03 03 03 03   Data
			.hex 00 02 01 41   																		; $d2e1: 00 02 01 41   Data
			.hex 00 00 40 40   																		; $d2e5: 00 00 40 40   Data
			.hex 02 42 01 41   																		; $d2e9: 02 42 01 41   Data
			.hex 01 41 01 41   																		; $d2ed: 01 41 01 41   Data
			.hex 01 41 01 41   																		; $d2f1: 01 41 01 41   Data
			.hex 01 41 01 41   																		; $d2f5: 01 41 01 41   Data
			.hex 01 41 01 41   																		; $d2f9: 01 41 01 41   Data
			.hex 01 01 01 01   																		; $d2fd: 01 01 01 01   Data
			.hex 41 01 41 03   																		; $d301: 41 01 41 03   Data
			.hex 43 03 43 03   																		; $d305: 43 03 43 03   Data
			.hex 03 03 03 43   																		; $d309: 03 03 03 43   Data
			.hex 43 43 03 03   																		; $d30d: 43 43 03 03   Data
			.hex 03 43 43 43   																		; $d311: 03 43 43 43   Data
			.hex 03 03 03 43   																		; $d315: 03 03 03 43   Data
			.hex 43 43 03 43   																		; $d319: 43 43 03 43   Data
			.hex 03 00 00 00   																		; $d31d: 03 00 00 00   Data
			.hex 00 40 02 42   																		; $d321: 00 40 02 42   Data
			.hex 02 42 02 02   																		; $d325: 02 42 02 02   Data
			.hex 42 02 42 00   																		; $d329: 42 02 42 00   Data
			.hex 00 00 40 00   																		; $d32d: 00 00 40 00   Data
			.hex 40 03 43 03   																		; $d331: 40 03 43 03   Data
			.hex 43 03 43 82   																		; $d335: 43 03 43 82   Data
			.hex c2 02 42 02   																		; $d339: c2 02 42 02   Data
			.hex 42 02 01 41   																		; $d33d: 42 02 01 41   Data
			.hex 01 41 01 00   																		; $d341: 01 41 01 00   Data
			.hex 00 00 00 01   																		; $d345: 00 00 00 01   Data
			.hex 03 43 43      																		; $d349: 03 43 43      Data
__spriteData2:     
			.hex 0a 0e 12 08   																		; $d34c: 0a 0e 12 08   Data
			.hex 0c 10 16 1a   																		; $d350: 0c 10 16 1a   Data
			.hex 1e 14 18 1c   																		; $d354: 1e 14 18 1c   Data
			.hex 2a 2e 32 28   																		; $d358: 2a 2e 32 28   Data
			.hex 2c 30 36 34   																		; $d35c: 2c 30 36 34   Data
			.hex 3a 3e 42 46   																		; $d360: 3a 3e 42 46   Data
			.hex 44 46 44 44   																		; $d364: 44 46 44 44   Data
			.hex 4a 48 4e 4c   																		; $d368: 4a 48 4e 4c   Data
			.hex 52 50 56 54   																		; $d36c: 52 50 56 54   Data
			.hex 5a 58 5e 5c   																		; $d370: 5a 58 5e 5c   Data
			.hex 62 60 66 64   																		; $d374: 62 60 66 64   Data
			.hex 6a 68 6e 6c   																		; $d378: 6a 68 6e 6c   Data
			.hex 72 76 7a 7e   																		; $d37c: 72 76 7a 7e   Data
			.hex 26 02 06 04   																		; $d380: 26 02 06 04   Data
			.hex 26 4a 24 48   																		; $d384: 26 4a 24 48   Data
			.hex 8a 88 8e 8c   																		; $d388: 8a 88 8e 8c   Data
			.hex 92 90 96 94   																		; $d38c: 92 90 96 94   Data
			.hex 9a 98 9e 9c   																		; $d390: 9a 98 9e 9c   Data
			.hex a2 a0 a6 a4   																		; $d394: a2 a0 a6 a4   Data
			.hex aa a8 ae ac   																		; $d398: aa a8 ae ac   Data
			.hex b2 b6 ba be   																		; $d39c: b2 b6 ba be   Data
			.hex bc be bc c2   																		; $d3a0: bc be bc c2   Data
			.hex c0 c6 c4 ca   																		; $d3a4: c0 c6 c4 ca   Data
			.hex 0a 0e 12 08   																		; $d3a8: 0a 0e 12 08   Data
			.hex 0c 10 16 1a   																		; $d3ac: 0c 10 16 1a   Data
			.hex 1e 14 18 1c   																		; $d3b0: 1e 14 18 1c   Data
			.hex 2a 2e 32 28   																		; $d3b4: 2a 2e 32 28   Data
			.hex 2c 30 36 34   																		; $d3b8: 2c 30 36 34   Data
			.hex 3a f6 fa fe   																		; $d3bc: 3a f6 fa fe   Data
			.hex 22 20 c3 c1   																		; $d3c0: 22 20 c3 c1   Data
			.hex c7 c5 c9 cf   																		; $d3c4: c7 c5 c9 cf   Data
			.hex cd d3 d1 d6   																		; $d3c8: cd d3 d1 d6   Data
			.hex da db d9 df   																		; $d3cc: da db d9 df   Data
			.hex dd e2 e0 e6   																		; $d3d0: dd e2 e0 e6   Data
			.hex e4 de dc d2   																		; $d3d4: e4 de dc d2   Data
			.hex d0 ce cc d2   																		; $d3d8: d0 ce cc d2   Data
			.hex d0 ca ea e8   																		; $d3dc: d0 ca ea e8   Data
			.hex ee ec f2 bf   																		; $d3e0: ee ec f2 bf   Data
			.hex 82 86 8a d7   																		; $d3e4: 82 86 8a d7   Data
			.hex 7b 79 7c      																		; $d3e8: 7b 79 7c      Data
__spriteAtrrib2:     
			.hex 00 00 00 40   																		; $d3eb: 00 00 00 40   Data
			.hex 40 40 00 00   																		; $d3ef: 40 40 00 00   Data
			.hex 00 40 40 40   																		; $d3f3: 00 40 40 40   Data
			.hex 00 00 00 40   																		; $d3f7: 00 00 00 40   Data
			.hex 40 40 00 40   																		; $d3fb: 40 40 00 40   Data
			.hex 00 03 03 03   																		; $d3ff: 00 03 03 03   Data
			.hex 43 83 43 c3   																		; $d403: 43 83 43 c3   Data
			.hex 03 43 03 43   																		; $d407: 03 43 03 43   Data
			.hex 03 43 03 43   																		; $d40b: 03 43 03 43   Data
			.hex 03 43 02 42   																		; $d40f: 03 43 02 42   Data
			.hex 02 42 02 42   																		; $d413: 02 42 02 42   Data
			.hex 02 42 02 42   																		; $d417: 02 42 02 42   Data
			.hex 03 03 03 03   																		; $d41b: 03 03 03 03   Data
			.hex 00 02 01 41   																		; $d41f: 00 02 01 41   Data
			.hex 00 00 40 40   																		; $d423: 00 00 40 40   Data
			.hex 02 42 01 41   																		; $d427: 02 42 01 41   Data
			.hex 01 41 01 41   																		; $d42b: 01 41 01 41   Data
			.hex 01 41 01 41   																		; $d42f: 01 41 01 41   Data
			.hex 01 41 01 41   																		; $d433: 01 41 01 41   Data
			.hex 01 41 01 41   																		; $d437: 01 41 01 41   Data
			.hex 01 01 01 01   																		; $d43b: 01 01 01 01   Data
			.hex 41 01 41 03   																		; $d43f: 41 01 41 03   Data
			.hex 43 03 43 03   																		; $d443: 43 03 43 03   Data
			.hex 03 03 03 43   																		; $d447: 03 03 03 43   Data
			.hex 43 43 03 03   																		; $d44b: 43 43 03 03   Data
			.hex 03 43 43 43   																		; $d44f: 03 43 43 43   Data
			.hex 03 03 03 43   																		; $d453: 03 03 03 43   Data
			.hex 43 43 03 43   																		; $d457: 43 43 03 43   Data
			.hex 03 00 00 00   																		; $d45b: 03 00 00 00   Data
			.hex 00 40 02 42   																		; $d45f: 00 40 02 42   Data
			.hex 02 42 42 02   																		; $d463: 02 42 42 02   Data
			.hex 42 02 42 00   																		; $d467: 42 02 42 00   Data
			.hex 00 00 40 00   																		; $d46b: 00 00 40 00   Data
			.hex 40 03 43 03   																		; $d46f: 40 03 43 03   Data
			.hex 43 03 43 82   																		; $d473: 43 03 43 82   Data
			.hex c2 02 42 02   																		; $d477: c2 02 42 02   Data
			.hex 42 02 01 41   																		; $d47b: 42 02 01 41   Data
			.hex 01 41 01 00   																		; $d47f: 01 41 01 00   Data
			.hex 00 00 00 01   																		; $d483: 00 00 00 01   Data
			.hex 03 43 43      																		; $d487: 03 43 43      Data

;-------------------------------------------------------------------------------
__drawGameActors:     
			jsr __clearXY         																		; $d48a: 20 16 d7  
__drawGameActorsLoop:     
			lda vActorX,x          																		; $d48d: b5 70     
			sta vBirdOffsetX            																		; $d48f: 85 5c     
			jsr __setBirdOffsetX         																		; $d491: 20 e5 d4  
			lda vBirdOffsetX            																		; $d494: a5 5c     
			and #$01           																		; $d496: 29 01     
				bne __gameActorOffScreen         																		; $d498: d0 32     
			lda vBirdPPUX            																		; $d49a: a5 03     
			and #$01           																		; $d49c: 29 01     
				bne ___drawGameActor         																		; $d49e: d0 08     
			lda vBirdOffsetX            																		; $d4a0: a5 5c     
			clc                																		; $d4a2: 18        
			adc #$01           																		; $d4a3: 69 01     
			jmp __drawGameActor         																		; $d4a5: 4c aa d4  

;-------------------------------------------------------------------------------
___drawGameActor:     
			lda vBirdOffsetX            																		; $d4a8: a5 5c     
__drawGameActor:     
			sta $0707,y        																		; $d4aa: 99 07 07  
			lda vActorY,x          																		; $d4ad: b5 90     
			cmp #$18           																		; $d4af: c9 18     
				beq __resetOffscreenActor         																		; $d4b1: f0 1e     
			cmp #$d8           																		; $d4b3: c9 d8     
				beq __resetOffscreenActor         																		; $d4b5: f0 1a     
			lda vBirdOffsetX            																		; $d4b7: a5 5c     
			and #$01           																		; $d4b9: 29 01     
				bne __drawOffScreenGameActorSprite         																		; $d4bb: d0 23     
			lda vActorY,x          																		; $d4bd: b5 90     
__drawGameActorSprite:     
			sta $0704,y        																		; $d4bf: 99 04 07  
			iny                																		; $d4c2: c8        
			iny                																		; $d4c3: c8        
			iny                																		; $d4c4: c8        
			iny                																		; $d4c5: c8        
			inx                																		; $d4c6: e8        
			cpx #$13           																		; $d4c7: e0 13     
				bne __drawGameActorsLoop         																		; $d4c9: d0 c2     
			rts                																		; $d4cb: 60        

;-------------------------------------------------------------------------------
__gameActorOffScreen:     
			lda #$f0           																		; $d4cc: a9 f0     
			jmp __drawGameActor         																		; $d4ce: 4c aa d4  

;-------------------------------------------------------------------------------
__resetOffscreenActor:     
			jsr __convertNametableCoordToReal         																		; $d4d1: 20 fc d4  
			clc                																		; $d4d4: 18        
			adc #$c0           																		; $d4d5: 69 c0     
			sta vActorX,x          																		; $d4d7: 95 70     
			lda #$90           																		; $d4d9: a9 90     
			sta vActorY,x          																		; $d4db: 95 90     
			jmp __drawGameActorsLoop         																		; $d4dd: 4c 8d d4  

;-------------------------------------------------------------------------------
__drawOffScreenGameActorSprite:     
			lda #$f0           																		; $d4e0: a9 f0     
			jmp __drawGameActorSprite         																		; $d4e2: 4c bf d4  

;-------------------------------------------------------------------------------
__setBirdOffsetX:     
			jsr __convertNametableCoordToReal         																		; $d4e5: 20 fc d4  
			sta vBirdX            																		; $d4e8: 85 5b     
			lda vBirdOffsetX            																		; $d4ea: a5 5c     
			sec                																		; $d4ec: 38        
			sbc vBirdX            																		; $d4ed: e5 5b     
			cmp #$7c           																		; $d4ef: c9 7c     
				bcs __setBirdOutsideNametable0         																		; $d4f1: b0 04     
			asl                																		; $d4f3: 0a        
___setBirdOffsetX:     
			sta vBirdOffsetX            																		; $d4f4: 85 5c     
			rts                																		; $d4f6: 60        

;-------------------------------------------------------------------------------
__setBirdOutsideNametable0:     
			lda #$01           																		; $d4f7: a9 01     
			jmp ___setBirdOffsetX         																		; $d4f9: 4c f4 d4  

;-------------------------------------------------------------------------------
__convertNametableCoordToReal:     
			lda vBirdPPUNametable            																		; $d4fc: a5 02     
			ror                																		; $d4fe: 6a        
			lda vBirdPPUX            																		; $d4ff: a5 03     
			ror                																		; $d501: 6a        
			rts                																		; $d502: 60        

;-------------------------------------------------------------------------------
__handleKite:     
			lda vCycleCounter            																		; $d503: a5 09     
			and #$3f           																		; $d505: 29 3f     
				bne __handleKiteTimer         																		; $d507: d0 08     
			lda vKiteSpeed            																		; $d509: a5 6c     
			cmp #$b8           																		; $d50b: c9 b8     
				beq __handleKiteTimer         																		; $d50d: f0 02     
			inc vKiteSpeed            																		; $d50f: e6 6c     
__handleKiteTimer:     
			lda vKiteSpeedTimer            																		; $d511: a5 6b     
			clc                																		; $d513: 18        
			adc vKiteSpeed            																		; $d514: 65 6c     
				bcs __handleKiteMovement         																		; $d516: b0 03     
			sta vKiteSpeedTimer            																		; $d518: 85 6b     
			rts                																		; $d51a: 60        

;-------------------------------------------------------------------------------
__handleKiteMovement:     
			sta vKiteSpeedTimer            																		; $d51b: 85 6b     
			lda vKiteMushroomDead          																		; $d51d: ad 11 02  
				bne __handleDeadKite         																		; $d520: d0 18     
			lda vKiteHit            																		; $d522: a5 86     
				bne __handleDeadKite         																		; $d524: d0 14     
			lda vKiteRiseAfterDeath            																		; $d526: a5 67     
				bne __kiteRiseAfterDeath         																		; $d528: d0 13     
			lda vKiteYChange            																		; $d52a: a5 68     
				bne __kiteChangeAltitude         																		; $d52c: d0 12     
			lda vRandomVar            																		; $d52e: a5 08     
				bne __kiteDontChangeAlt         																		; $d530: d0 02     
			inc vKiteYChange            																		; $d532: e6 68     
__kiteDontChangeAlt:     
			lda vKiteDirection            																		; $d534: a5 6a     
				beq ___kiteFlyRight         																		; $d536: f0 36     
				bne __kiteFlyLeft         																		; $d538: d0 54     
				
__handleDeadKite:     
			jmp ___handleDeadKite         																		; $d53a: 4c af d5  

;-------------------------------------------------------------------------------
__kiteRiseAfterDeath:     
			jmp ___kiteRiseAfterDeath         																		; $d53d: 4c 18 d6  

;-------------------------------------------------------------------------------
; this controls kite altitude change when chasing
__kiteChangeAltitude:     
			lda vKiteYChange            																		; $d540: a5 68     
			cmp vKiteMaxYChange            																		; $d542: c5 69     
				beq __stopKiteYChange         																		; $d544: f0 62   
				
			inc vKiteYChange            																		; $d546: e6 68     
			lda vKiteY1            																		; $d548: a5 98     
			cmp #$1a           																		; $d54a: c9 1a     
				bcc __kiteKeepChasing         																		; $d54c: 90 3a     
			cmp #$c0           																		; $d54e: c9 c0     
				bcs __kiteLowerstAlt         																		; $d550: b0 09     

			lda vBirdSpritePosY          																		; $d552: ad 00 07  
			cmp vKiteY1            																		; $d555: c5 98     
				beq __stopKiteYChange         																		; $d557: f0 4f     
				bcs __kiteKeepChasing         																		; $d559: b0 2d     
__kiteLowerstAlt:     
			dec vKiteY1            																		; $d55b: c6 98     
			dec vKiteY2            																		; $d55d: c6 99    
			
__kiteSetDirection:     
			lda vKiteX1            																		; $d55f: a5 78     
			sta vBirdX            																		; $d561: 85 5b     
			jsr __getBirdRelativeDir         																		; $d563: 20 fc d5  
			lda vBirdX            																		; $d566: a5 5b     
				beq __stopKiteYChange         																		; $d568: f0 3e     
			cmp #$01           																		; $d56a: c9 01     
				beq __kiteFlyLeft         																		; $d56c: f0 20     
___kiteFlyRight:     
			inc vKiteX1            																		; $d56e: e6 78     
			inc vKiteX2            																		; $d570: e6 79     
			lda #$00           																		; $d572: a9 00     
			sta vKiteDirection            																		; $d574: 85 6a     
			jsr __setXEvery8Cycle         																		; $d576: 20 8b d0  
			lda __kiteRightAnim1,x       																		; $d579: bd 67 d6  
			sta $0725          																		; $d57c: 8d 25 07  
			lda __kiteRightAnim2,x       																		; $d57f: bd 6b d6  
			sta $0729          																		; $d582: 8d 29 07  
			jmp __kiteHoverUpDown         																		; $d585: 4c 30 d6  

;-------------------------------------------------------------------------------
__kiteKeepChasing:     
			jsr __kiteHoverDown         																		; $d588: 20 4a d6  
			jmp __kiteSetDirection         																		; $d58b: 4c 5f d5  

;-------------------------------------------------------------------------------
__kiteFlyLeft:     
			dec vKiteX1            																		; $d58e: c6 78     
			dec vKiteX2            																		; $d590: c6 79     
			lda #$01           																		; $d592: a9 01     
			sta vKiteDirection            																		; $d594: 85 6a     
			jsr __setXEvery8Cycle         																		; $d596: 20 8b d0  
			lda __kiteLeftAnim1,x       																		; $d599: bd 6f d6  
			sta $0725          																		; $d59c: 8d 25 07  
			lda __kiteLeftAnim2,x       																		; $d59f: bd 73 d6  
			sta $0729          																		; $d5a2: 8d 29 07  
			jmp __kiteHoverUpDown         																		; $d5a5: 4c 30 d6  

;-------------------------------------------------------------------------------
__stopKiteYChange:     
			lda #$00           																		; $d5a8: a9 00     
			sta vKiteYChange            																		; $d5aa: 85 68     
			jmp __kiteDontChangeAlt         																		; $d5ac: 4c 34 d5  

;-------------------------------------------------------------------------------
___handleDeadKite:     
			lda vScoreForDeadKite          																		; $d5af: ad 5b 02  
				beq __giveScoreForDeadKite         																		; $d5b2: f0 3c     
____handleDeadKite:     
			lda vKiteY1            																		; $d5b4: a5 98     
			cmp #$c8           																		; $d5b6: c9 c8     
				bcs __deadKiteLying         																		; $d5b8: b0 16     
			jsr __kiteHoverDown         																		; $d5ba: 20 4a d6  
			jsr __kiteHoverDown         																		; $d5bd: 20 4a d6  
			
			jsr __setXEvery4Cycle         																		; $d5c0: 20 93 d0  
__animateFallingKite:     
			lda __kiteFallAnim1,x       																		; $d5c3: bd 77 d6  
			sta $0725          																		; $d5c6: 8d 25 07  
			lda __kiteFallAnim2,x       																		; $d5c9: bd 7c d6  
			sta $0729          																		; $d5cc: 8d 29 07  
			rts                																		; $d5cf: 60        

;-------------------------------------------------------------------------------
__deadKiteLying:     
			lda vKiteDeadTimer            																		; $d5d0: a5 6e     
			cmp #$a0           																		; $d5d2: c9 a0     
				beq __kiteForceRevive         																		; $d5d4: f0 07     
			inc vKiteDeadTimer            																		; $d5d6: e6 6e     
			ldx #$04           																		; $d5d8: a2 04     
			jmp __animateFallingKite         																		; $d5da: 4c c3 d5  

;-------------------------------------------------------------------------------
__kiteForceRevive:     
			lda #$00           																		; $d5dd: a9 00     
			sta vKiteDeadTimer            																		; $d5df: 85 6e     
			sta vKiteFrontCollision            																		; $d5e1: 85 b8     
			sta vKiteBackCollision            																		; $d5e3: 85 b9     
			sta vKiteMushroomDead          																		; $d5e5: 8d 11 02  
			sta vScoreForDeadKite          																		; $d5e8: 8d 5b 02  
			sta vKiteHit            																		; $d5eb: 85 86     
			inc vKiteRiseAfterDeath            																		; $d5ed: e6 67     
			rts                																		; $d5ef: 60        

;-------------------------------------------------------------------------------
__giveScoreForDeadKite:     
			jsr __give200Score         																		; $d5f0: 20 52 d6  
			inc vScoreForDeadKite          																		; $d5f3: ee 5b 02  
			jsr __killedCreatureSound         																		; $d5f6: 20 45 c5  
			jmp ____handleDeadKite         																		; $d5f9: 4c b4 d5  

;-------------------------------------------------------------------------------
__getBirdRelativeDir:     
			jsr __convertNametableCoordToReal         																		; $d5fc: 20 fc d4  
			clc                																		; $d5ff: 18        
			adc #$3c           																		; $d600: 69 3c     
			sec                																		; $d602: 38        
			sbc vBirdX            																		; $d603: e5 5b     
				beq __relativeSame         																		; $d605: f0 07     
				bpl __relativeRight         																		; $d607: 10 0a     
			lda #$01           																		; $d609: a9 01     
__setBirdRelativeDir:     
			sta vBirdX            																		; $d60b: 85 5b     
			rts                																		; $d60d: 60        

;-------------------------------------------------------------------------------
__relativeSame:     
			lda #$00           																		; $d60e: a9 00     
			jmp __setBirdRelativeDir         																		; $d610: 4c 0b d6  

;-------------------------------------------------------------------------------
__relativeRight:     
			lda #$02           																		; $d613: a9 02     
			jmp __setBirdRelativeDir         																		; $d615: 4c 0b d6  

;-------------------------------------------------------------------------------
___kiteRiseAfterDeath:     
			lda vKiteY1            																		; $d618: a5 98     
			cmp #$80           																		; $d61a: c9 80     
				bcc __kiteStopRising         																		; $d61c: 90 0e     
			dec vKiteY1            																		; $d61e: c6 98     
			dec vKiteY2            																		; $d620: c6 99     
			lda vKiteDirection            																		; $d622: a5 6a     
				beq __kiteFlyRight         																		; $d624: f0 03     
			jmp __kiteFlyLeft         																		; $d626: 4c 8e d5  

;-------------------------------------------------------------------------------
__kiteFlyRight:     jmp ___kiteFlyRight         																		; $d629: 4c 6e d5  

;-------------------------------------------------------------------------------
__kiteStopRising:     
			lda #$00           																		; $d62c: a9 00     
			sta vKiteRiseAfterDeath            																		; $d62e: 85 67     
__kiteHoverUpDown:     
			jsr __getCycleModulo8         																		; $d630: 20 62 d6  
				bne __return8         																		; $d633: d0 14     
			lda vKiteY1            																		; $d635: a5 98     
			cmp #$20           																		; $d637: c9 20     
				bcc __return8         																		; $d639: 90 0e     
			cmp #$c8           																		; $d63b: c9 c8     
				bcs __return8         																		; $d63d: b0 0a     
			lda vRandomVar            																		; $d63f: a5 08     
			and #$01           																		; $d641: 29 01     
				bne __kiteHoverDown         																		; $d643: d0 05     
			dec vKiteY1            																		; $d645: c6 98     
			dec vKiteY2            																		; $d647: c6 99     
__return8:     
			rts                																		; $d649: 60        

;-------------------------------------------------------------------------------
__kiteHoverDown:     
			inc vKiteY1            																		; $d64a: e6 98     
			inc vKiteY2            																		; $d64c: e6 99     
			rts                																		; $d64e: 60        

;-------------------------------------------------------------------------------
__give300Score:     
			jsr __give100Score         																		; $d64f: 20 15 ff  
__give200Score:     
			jsr __give100Score         																		; $d652: 20 15 ff  
			jmp __give100Score         																		; $d655: 4c 15 ff  

;-------------------------------------------------------------------------------
__isOddCycle:     
			lda vCycleCounter            																		; $d658: a5 09     
			and #$01           																		; $d65a: 29 01     
			rts                																		; $d65c: 60        

;-------------------------------------------------------------------------------
__getCycleModulo4:     
			lda vCycleCounter            																		; $d65d: a5 09     
			and #$03           																		; $d65f: 29 03     
			rts                																		; $d661: 60        

;-------------------------------------------------------------------------------
__getCycleModulo8:     
			lda vCycleCounter            																		; $d662: a5 09     
			and #$07           																		; $d664: 29 07     
			rts                																		; $d666: 60        

;-------------------------------------------------------------------------------
__kiteRightAnim1:     
			.hex 45 47 49 47   																		; $d667: 45 47 49 47   Data
__kiteRightAnim2:     
			.hex 3f 41 43 41   																		; $d66b: 3f 41 43 41   Data
__kiteLeftAnim1:     
			.hex 3e 40 42 40   																		; $d66f: 3e 40 42 40   Data
__kiteLeftAnim2:     
			.hex 44 46 48 46   																		; $d673: 44 46 48 46   Data
__kiteFallAnim1:     
			.hex 4a 4c 4a 4c   																		; $d677: 4a 4c 4a 4c   Data
			.hex 4c            																		; $d67b: 4c            Data
__kiteFallAnim2:     
			.hex 4b 4d 4b 4d   																		; $d67c: 4b 4d 4b 4d   Data
			.hex 4d            																		; $d680: 4d            Data

;-------------------------------------------------------------------------------
__handleMole:     
			lda vMoleCollision            																		; $d681: a5 b7     
				bne __handleDeadMole         																		; $d683: d0 07     
			lda vIsMoleOnSurface            																		; $d685: a5 de     
				bne ___handleMoleOnSurface         																		; $d687: d0 42     
			jmp ___handleMoleUnderground         																		; $d689: 4c ab d6  

;-------------------------------------------------------------------------------
__handleDeadMole:     
			lda vMoleIsDying            																		; $d68c: a5 eb     
				bne ___handleDeadMole         																		; $d68e: d0 06 
				
			; play mole dying sound
			lda #$07           																		; $d690: a9 07     
			sta vSoundPlayerState            																		; $d692: 85 2a     
			inc vMoleIsDying            																		; $d694: e6 eb     
___handleDeadMole:     
			lda vCycleCounter            																		; $d696: a5 09     
			and #$0f           																		; $d698: 29 0f     
				bne __return32         																		; $d69a: d0 0e     
			ldx vMoleDeadCounter            																		; $d69c: a6 df     
			cpx #$08           																		; $d69e: e0 08     
				beq __hideDeadMole         																		; $d6a0: f0 3e     
			lda __moleDeadAnimFrames,x       																		; $d6a2: bd 06 d7  
			sta $0721          																		; $d6a5: 8d 21 07  
			inc vMoleDeadCounter            																		; $d6a8: e6 df     
__return32:     
			rts                																		; $d6aa: 60        

;-------------------------------------------------------------------------------
___handleMoleUnderground:   
			; some random of course
			lda vRandomVar2            																		; $d6ab: a5 17     
				bne __return30         																		; $d6ad: d0 1b     
			lda vCycleCounter            																		; $d6af: a5 09     
			cmp #$40           																		; $d6b1: c9 40     
				bcs __return30         																		; $d6b3: b0 15     
			
			; show mole
			inc vIsMoleOnSurface            																		; $d6b5: e6 de     
			lda vRandomVar            																		; $d6b7: a5 08     
			and #$07           																		; $d6b9: 29 07     
			tay                																		; $d6bb: a8        
			lda __moleFlowerPosX,y       																		; $d6bc: b9 0e d7  
			sta vMoleX            																		; $d6bf: 85 77     
			lda #$c8           																		; $d6c1: a9 c8     
			sta vMoleY            																		; $d6c3: 85 97     
			lda #$4e           																		; $d6c5: a9 4e     
			sta $0721          																		; $d6c7: 8d 21 07  
__return30:     
			rts                																		; $d6ca: 60        

;-------------------------------------------------------------------------------
___handleMoleOnSurface:     
			lda vCycleCounter            																		; $d6cb: a5 09     
			and #$0f           																		; $d6cd: 29 0f     
				bne __return31         																		; $d6cf: d0 0e     
			ldx vMoleOnSurfaceTimer            																		; $d6d1: a6 e0     
			cpx #$10           																		; $d6d3: e0 10     
				beq __hideMole         																		; $d6d5: f0 12     
			lda __moleAnimFrames,x       																		; $d6d7: bd f6 d6  
			inc vMoleOnSurfaceTimer            																		; $d6da: e6 e0     
			sta $0721          																		; $d6dc: 8d 21 07  
__return31:     
			rts                																		; $d6df: 60        

;-------------------------------------------------------------------------------
__hideDeadMole:     
			lda #$00           																		; $d6e0: a9 00     
			sta vMoleCollision            																		; $d6e2: 85 b7     
			sta vMoleIsDying            																		; $d6e4: 85 eb     
			jsr __give300Score         																		; $d6e6: 20 4f d6  
__hideMole:     
			lda #$f8           																		; $d6e9: a9 f8     
			sta vMoleY            																		; $d6eb: 85 97     
			lda #$00           																		; $d6ed: a9 00     
			sta vIsMoleOnSurface            																		; $d6ef: 85 de     
			sta vMoleDeadCounter            																		; $d6f1: 85 df     
			sta vMoleOnSurfaceTimer            																		; $d6f3: 85 e0     
			rts                																		; $d6f5: 60        

;-------------------------------------------------------------------------------
__moleAnimFrames:     
			.hex 4e 4f 4e 4f   																		; $d6f6: 4e 4f 4e 4f   Data
			.hex 50 51 52 51   																		; $d6fa: 50 51 52 51   Data
			.hex 52 51 50 51   																		; $d6fe: 52 51 50 51   Data
			.hex 4e 4f 4e 4f   																		; $d702: 4e 4f 4e 4f   Data
__moleDeadAnimFrames:     
			.hex 53 54 53 54   																		; $d706: 53 54 53 54   Data
			.hex 53 54 53 54   																		; $d70a: 53 54 53 54   Data
__moleFlowerPosX:     
			.hex 00 20 40 60   																		; $d70e: 00 20 40 60   Data
			.hex 80 a0 c0 e0   																		; $d712: 80 a0 c0 e0   Data

;-------------------------------------------------------------------------------
__clearXY:     
			ldx #$00           																		; $d716: a2 00     
			ldy #$00           																		; $d718: a0 00     
			rts                																		; $d71a: 60        

;-------------------------------------------------------------------------------
___bestEndingLoop:     
			jsr __handleStartButton         																		; $d71b: 20 2c c2  
			jmp __handleGameLoop         																		; $d71e: 4c 48 c2  

;-------------------------------------------------------------------------------
___processBestEnding:     
			lda vStartBestEnding          																		; $d721: ad 95 02  
				beq __startBestEnding         																		; $d724: f0 1c     
			lda vMusicPlayerState            																		; $d726: a5 20     
				beq __endBestEnding         																		; $d728: f0 15     
			jsr __handleBestEndingSky         																		; $d72a: 20 9d d7  
			jsr __handleBestEndingFlowers         																		; $d72d: 20 cc d7  
			jsr __endingCheckRightToLeft         																		; $d730: 20 46 d8  
			jsr __handleBestEndingBird         																		; $d733: 20 52 d8  
			jsr __handleBestEndingNestlings         																		; $d736: 20 75 d8  
			jsr __drawGameActors         																		; $d739: 20 8a d4  
			jmp __frozenGameLoop         																		; $d73c: 4c 22 c1  

;-------------------------------------------------------------------------------
__endBestEnding:     jmp ___endBestEnding         																		; $d73f: 4c 35 d8  

;-------------------------------------------------------------------------------
__startBestEnding:     
			jsr __showSprites         																		; $d742: 20 e0 fd  
			lda #$13           																		; $d745: a9 13     
			sta vMusicPlayerState            																		; $d747: 85 20     
			inc vStartBestEnding          																		; $d749: ee 95 02  
			jsr __resetObjectHitFlags         																		; $d74c: 20 52 d7  
			jmp __setBestEndingActorsPos         																		; $d74f: 4c 62 d7  

;-------------------------------------------------------------------------------
__resetObjectHitFlags:     
			ldx #$00           																		; $d752: a2 00     
__resetObjectHitFlagsLoop:     
			lda #$00           																		; $d754: a9 00     
			sta vObjectHitFlags,x          																		; $d756: 95 b0     
			lda #$f0           																		; $d758: a9 f0     
			sta vActorY,x          																		; $d75a: 95 90     
			inx                																		; $d75c: e8        
			cpx #$13           																		; $d75d: e0 13     
				bne __resetObjectHitFlagsLoop         																		; $d75f: d0 f3     
			rts                																		; $d761: 60        

;-------------------------------------------------------------------------------
__setBestEndingActorsPos:     
			jsr __clearXY         																		; $d762: 20 16 d7  
__setBestEndingActorsPosLoop:     
			lda __endingActorsPosY,x       																		; $d765: bd 89 d7  
			sta vActorY,x          																		; $d768: 95 90     
			lda __endingActorsPosX,x       																		; $d76a: bd 93 d7  
			sta vActorX,x          																		; $d76d: 95 70     
			lda __endingActorsPosSprite,x       																		; $d76f: bd 7f d7  
			sta $0705,y        																		; $d772: 99 05 07  
			inx                																		; $d775: e8        
			iny                																		; $d776: c8        
			iny                																		; $d777: c8        
			iny                																		; $d778: c8        
			iny                																		; $d779: c8        
			cpx #$0a           																		; $d77a: e0 0a     
				bne __setBestEndingActorsPosLoop         																		; $d77c: d0 e7     
			rts                																		; $d77e: 60        

;-------------------------------------------------------------------------------
__endingActorsPosSprite:     
			.hex 0f 38 38 38   																		; $d77f: 0f 38 38 38   Data
			.hex 38 38 38 38   																		; $d783: 38 38 38 38   Data
			.hex 38 38         																		; $d787: 38 38         Data
__endingActorsPosY:     
			.hex 50 40 60 30   																		; $d789: 50 40 60 30   Data
			.hex 50 70 20 40   																		; $d78d: 50 70 20 40   Data
			.hex 60 80         																		; $d791: 60 80         Data
__endingActorsPosX:     
			.hex f0 a0 a0 b0   																		; $d793: f0 a0 a0 b0   Data
			.hex b0 b0 c0 c0   																		; $d797: b0 b0 c0 c0   Data
			.hex c0 c0         																		; $d79b: c0 c0         Data

__handleBestEndingSky:     
			lda vBestEndingSkyCounter          																		; $d79d: ad c1 02  
			cmp #$09           																		; $d7a0: c9 09     
				beq __return42         																		; $d7a2: f0 1e   
			; every 0x80 cycles
			lda vCycleCounter            																		; $d7a4: a5 09     
			and #$7f           																		; $d7a6: 29 7f     
				bne __return42         																		; $d7a8: d0 18   
				
			ldx #$00           																		; $d7aa: a2 00     
			ldy vBestEndingSkyCounter          																		; $d7ac: ac c1 02  
			lda __endingSkyColor,y       																		; $d7af: b9 c3 d7  
__endingSkyColorChange:     
			sta vPaletteData,x          																		; $d7b2: 95 30     
			inx                																		; $d7b4: e8        
			inx                																		; $d7b5: e8        
			inx                																		; $d7b6: e8        
			inx                																		; $d7b7: e8        
			cpx #$20           																		; $d7b8: e0 20     
				bne __endingSkyColorChange         																		; $d7ba: d0 f6     
			jsr __uploadPalettesToPPU         																		; $d7bc: 20 64 fe  
			inc vBestEndingSkyCounter          																		; $d7bf: ee c1 02  
__return42:    
			rts                																		; $d7c2: 60        

;-------------------------------------------------------------------------------
__endingSkyColor:     
			.hex 32 33 34 35   																		; $d7c3: 32 33 34 35   Data
			.hex 36 37 38 39   																		; $d7c7: 36 37 38 39   Data
			.hex 3a            																		; $d7cb: 3a            Data
__handleBestEndingFlowers:     
			jsr __setPPUIncrementBy32         																		; $d7cc: 20 e4 fe  
			lda vBestEndingFlowerCounter          																		; $d7cf: ad c2 02  
			cmp #$20           																		; $d7d2: c9 20     
				beq __endingDontSpawnFlower         																		; $d7d4: f0 3c     
			; every 0x20 cycles
			lda vCycleCounter            																		; $d7d6: a5 09     
			and #$1f           																		; $d7d8: 29 1f     
				bne __endingDontSpawnFlower         																		; $d7da: d0 36   
				
			lda vBestEndingFlowerCounter          																		; $d7dc: ad c2 02  
			tax                																		; $d7df: aa     
			
			; wow, I thought that game spawns flowers randomly, inctead, they are spawned
			; in a fixed pattern, how lame
			lda #$23           																		; $d7e0: a9 23     
			sta ppuAddress          																		; $d7e2: 8d 06 20  
			lda __endingFlowerPos,x       																		; $d7e5: bd 15 d8  
			sta ppuAddress          																		; $d7e8: 8d 06 20  
			
			lda #$b0           																		; $d7eb: a9 b0     
			sta ppuData          																		; $d7ed: 8d 07 20  
			lda #$b1           																		; $d7f0: a9 b1     
			sta ppuData          																		; $d7f2: 8d 07 20  
			
			lda #$23           																		; $d7f5: a9 23     
			sta ppuAddress          																		; $d7f7: 8d 06 20  
			lda __endingFlowerPos,x       																		; $d7fa: bd 15 d8  
			tay                																		; $d7fd: a8        
			iny                																		; $d7fe: c8        
			sty ppuAddress          																		; $d7ff: 8c 06 20  
			
			lda #$b2           																		; $d802: a9 b2     
			sta ppuData          																		; $d804: 8d 07 20  
			lda #$b3           																		; $d807: a9 b3     
			sta ppuData          																		; $d809: 8d 07 20  
			
			inc vBestEndingFlowerCounter          																		; $d80c: ee c2 02  
			jsr __scrollScreen         																		; $d80f: 20 b6 fd  
__endingDontSpawnFlower:     
			jmp __setPPUIncrementBy1         																		; $d812: 4c da fe  

;-------------------------------------------------------------------------------
__endingFlowerPos:     
			.hex 04 50 18 5c   																		; $d815: 04 50 18 5c   Data
			.hex 14 4a 46 00   																		; $d819: 14 4a 46 00   Data
			.hex 56 0c 1e 5a   																		; $d81d: 56 0c 1e 5a   Data
			.hex 42 4e 12 54   																		; $d821: 42 4e 12 54   Data
			.hex 08 40 44 10   																		; $d825: 08 40 44 10   Data
			.hex 1c 5e 06 0e   																		; $d829: 1c 5e 06 0e   Data
			.hex 58 4c 16 1a   																		; $d82d: 58 4c 16 1a   Data
			.hex 48 0a 02 52   																		; $d831: 48 0a 02 52   Data
			
___endBestEnding:     
			jsr __resetObjectHitFlags         																		; $d835: 20 52 d7  
			lda #$00           																		; $d838: a9 00     
			sta vStartBestEnding          																		; $d83a: 8d 95 02  
			sta vBestEndingSkyCounter          																		; $d83d: 8d c1 02  
			sta vBestEndingFlowerCounter          																		; $d840: 8d c2 02  
			jmp __setRoundScreen         																		; $d843: 4c 0e c9  

;-------------------------------------------------------------------------------
__endingCheckRightToLeft:     
			lda vBestEndingBirdX            																		; $d846: a5 70     
			cmp #$90           																		; $d848: c9 90     
				beq __endingSetRightToLeft         																		; $d84a: f0 01     
			rts                																		; $d84c: 60        

;-------------------------------------------------------------------------------
__endingSetRightToLeft:     
			lda #$01           																		; $d84d: a9 01     
			sta vBestEnding2Loop            																		; $d84f: 85 b0     
			rts                																		; $d851: 60        

;-------------------------------------------------------------------------------
__handleBestEndingBird:     
			jsr __setXEvery8Cycle         																		; $d852: 20 8b d0  
			lda vBestEnding2Loop            																		; $d855: a5 b0     
				bne __bestEndingBirdLeft         																		; $d857: d0 0e     
				
			lda __birdSprites,x       																		; $d859: bd be d1  
			sta $0705          																		; $d85c: 8d 05 07  
			jsr __getCycleModulo4         																		; $d85f: 20 5d d6  
				bne __return43         																		; $d862: d0 02     
			inc vBestEndingBirdX            																		; $d864: e6 70     
__return43:     
			rts                																		; $d866: 60        

;-------------------------------------------------------------------------------
__bestEndingBirdLeft:     
			lda __birdMirrorSprites,x       																		; $d867: bd c2 d1  
			sta $0705          																		; $d86a: 8d 05 07  
			jsr __getCycleModulo4         																		; $d86d: 20 5d d6  
				bne __return43         																		; $d870: d0 f4     
			dec vBestEndingBirdX            																		; $d872: c6 70     
			rts                																		; $d874: 60        

;-------------------------------------------------------------------------------
__handleBestEndingNestlings:     
			jsr __clearXY         																		; $d875: 20 16 d7  
__handleBestEndingNestlingsLoop:     
			lda vBestEnding2Loop            																		; $d878: a5 b0     
				beq __return44         																		; $d87a: f0 1d   				
			stx vTileAddress            																		; $d87c: 86 1e     
			jsr __setXEvery4Cycle         																		; $d87e: 20 93 d0  
			lda __bestEndingNestlingAnim,x       																		; $d881: bd 9a d8  
			; set nestling sprite
			sta $0709,y        																		; $d884: 99 09 07  
			ldx vTileAddress            																		; $d887: a6 1e     
			jsr __getCycleModulo4         																		; $d889: 20 5d d6  
				bne __bestEndingNextNestling         																		; $d88c: d0 02     
			dec vBestEndingNestlingX,x          																		; $d88e: d6 71     
__bestEndingNextNestling:     
			inx                																		; $d890: e8        
			iny                																		; $d891: c8        
			iny                																		; $d892: c8        
			iny                																		; $d893: c8        
			iny                																		; $d894: c8        
			cpx #$09           																		; $d895: e0 09     
				bne __handleBestEndingNestlingsLoop         																		; $d897: d0 df     
__return44:     
			rts                																		; $d899: 60        

;-------------------------------------------------------------------------------
__bestEndingNestlingAnim:     
			.hex 3a 3b 3a 3b   																		; $d89a: 3a 3b 3a 3b   Data

;-------------------------------------------------------------------------------
; one of the most hated creatures in this game, why to program such an awkward flight?
__handleButterflies:     
			jsr __levelModulo4ToX         																		; $d89e: 20 5e c3  
			cpx #$03           																		; $d8a1: e0 03     
				beq __return2         																		; $d8a3: f0 5c   
			
			ldx #$00           																		; $d8a5: a2 00     
__handleButterflyLoop:     
			lda vButterflyXCaught,x          																		; $d8a7: b5 b3     
				bne __handleCaughtButterfly         																		; $d8a9: d0 57    
				
			.hex ad a6 00      																		; $d8ab: ad a6 00  Bad Addr Mode - LDA vTimeFreezeTimerAbs
			; lda vTimeFreezeTimerAbs
				bne __handleButterflyNext         																		; $d8ae: d0 18  
				
			lda vButterfly1Timer,x          																		; $d8b0: b5 d6     
			tay                																		; $d8b2: a8        
			lda __beeButterflyFrameCounter,y       																		; $d8b3: b9 a7 e0  
			clc                																		; $d8b6: 18        
			adc vButterflyFrameTimer,x          																		; $d8b7: 75 da     
			tay                																		; $d8b9: a8        
			lda __beeButterflyFrameTimer,y       																		; $d8ba: b9 2f e0  
			jsr __actorMove         																		; $d8bd: 20 15 d9  
			tay                																		; $d8c0: a8        
			dey                																		; $d8c1: 88        
			lda __butterflyFrames,y       																		; $d8c2: b9 3b da  
__setButterflyFrame:     
			sta vButterflyFrames,x        																		; $d8c5: 9d 00 02 
 
__handleButterflyNext:     
			inx                																		; $d8c8: e8        
			cpx #$04           																		; $d8c9: e0 04     
				bne __handleButterflyLoop         																		; $d8cb: d0 da  
				
__updateFishTimers:        
			lda vCurrentLevel            																		; $d8cd: a5 55     
			and #$03           																		; $d8cf: 29 03     
				beq __updateButterflyTimers         																		; $d8d1: f0 06     
			lda vCycleCounter            																		; $d8d3: a5 09     
			and #$01           																		; $d8d5: 29 01     
				bne __updateButterflyFrame         																		; $d8d7: d0 15     
__updateButterflyTimers:     
			ldx #$00           																		; $d8d9: a2 00     
__updateButterflyTimersLoop:     
			inc vButterflyFrameTimer,x          																		; $d8db: f6 da     
			lda vButterflyFrameTimer,x          																		; $d8dd: b5 da     
			cmp #$08           																		; $d8df: c9 08     
				beq __updateButterflyTimer         																		; $d8e1: f0 29     
__checkResetButterflyTimer:     
			lda vButterfly1Timer,x          																		; $d8e3: b5 d6     
			cmp #$a8           																		; $d8e5: c9 a8     
				beq __resetButterflyTimer         																		; $d8e7: f0 1c     
__updateNextButterflyTimer:     
			inx                																		; $d8e9: e8        
			cpx #$04           																		; $d8ea: e0 04     
				bne __updateButterflyTimersLoop         																		; $d8ec: d0 ed     
				
__updateButterflyFrame:     
			ldx #$00           																		; $d8ee: a2 00     
			ldy #$00           																		; $d8f0: a0 00     
__updateButterflyFrameLoop:     
			lda vButterflyFrames,x        																		; $d8f2: bd 00 02  
			sta $0711,y        																		; $d8f5: 99 11 07  
			inx                																		; $d8f8: e8        
			iny                																		; $d8f9: c8        
			iny                																		; $d8fa: c8        
			iny                																		; $d8fb: c8        
			iny                																		; $d8fc: c8        
			cpx #$04           																		; $d8fd: e0 04     
				bne __updateButterflyFrameLoop         																		; $d8ff: d0 f1     
__return2:     
			rts                																		; $d901: 60        

;-------------------------------------------------------------------------------
__handleCaughtButterfly:     jmp ___handleCaughtButterfly         																		; $d902: 4c 34 d9  

;-------------------------------------------------------------------------------
__resetButterflyTimer:     
			lda #$00           																		; $d905: a9 00     
			sta vButterfly1Timer,x          																		; $d907: 95 d6     
			jmp __updateNextButterflyTimer         																		; $d909: 4c e9 d8  

;-------------------------------------------------------------------------------
__updateButterflyTimer:     
			lda #$00           																		; $d90c: a9 00     
			sta vButterflyFrameTimer,x          																		; $d90e: 95 da     
			inc vButterfly1Timer,x          																		; $d910: f6 d6     
			jmp __checkResetButterflyTimer         																		; $d912: 4c e3 d8  

;-------------------------------------------------------------------------------
; controls actor movement. x register - actor number, a register - direction
__actorMove:    
			lsr                																		; $d915: 4a        
				bcs __moveActorRight         																		; $d916: b0 0a     
__actorMoveLeft:     
			lsr                																		; $d918: 4a        
				bcs __moveActorLeft         																		; $d919: b0 0c     
__actorMoveDown:     
			lsr                																		; $d91b: 4a        
				bcs __moveActorDown         																		; $d91c: b0 0e     
__actorMoveUp:     
			lsr                																		; $d91e: 4a        
				bcs __moveActorUp         																		; $d91f: b0 10     
			rts                																		; $d921: 60        

;-------------------------------------------------------------------------------
__moveActorRight:     
			inc vButterfly1X,x          																		; $d922: f6 73     
			jmp __actorMoveLeft         																		; $d924: 4c 18 d9  

;-------------------------------------------------------------------------------
__moveActorLeft:     
			dec vButterfly1X,x          																		; $d927: d6 73     
			jmp __actorMoveDown         																		; $d929: 4c 1b d9  

;-------------------------------------------------------------------------------
__moveActorDown:     
			dec vButterfly1Y,x          																		; $d92c: d6 93     
			jmp __actorMoveUp         																		; $d92e: 4c 1e d9  

;-------------------------------------------------------------------------------
__moveActorUp:     
			inc vButterfly1Y,x          																		; $d931: f6 93     
			rts                																		; $d933: 60        

;-------------------------------------------------------------------------------
___handleCaughtButterfly:     
			lda vButterflyIsCaught            																		; $d934: a5 ea     
				bne __setCaughtButterflyPos         																		; $d936: d0 0d  
				
			; play butterfly caught sound
			lda #$01           																		; $d938: a9 01     
			sta vSoundPlayerState            																		; $d93a: 85 2a     
			sta vButterflyIsCaught            																		; $d93c: 85 ea     
			stx vBirdOffsetX            																		; $d93e: 86 5c     
			jsr __give10Score         																		; $d940: 20 fa fe  
			
			ldx vBirdOffsetX            																		; $d943: a6 5c     
			
__setCaughtButterflyPos:     
			jsr __convertNametableCoordToReal         																		; $d945: 20 fc d4  
			clc                																		; $d948: 18        
			adc #$3c           																		; $d949: 69 3c     
			sta vBirdOffsetX            																		; $d94b: 85 5c     
			lda vBirdIsRight            																		; $d94d: a5 5a     
				bne __setCaughtButterflyMirror         																		; $d94f: d0 0f     
			lda vBirdOffsetX            																		; $d951: a5 5c     
			sec                																		; $d953: 38        
			sbc #$04           																		; $d954: e9 04 
			
__setCaughtButterflyX:     
			sta vButterfly1X,x          																		; $d956: 95 73     
			lda vCurrentLevel            																		; $d958: a5 55     
			and #$03           																		; $d95a: 29 03     
			tay                																		; $d95c: a8        
			jmp __handleNestlingButterfly         																		; $d95d: 4c a4 d9  

;-------------------------------------------------------------------------------
__setCaughtButterflyMirror:     
			lda vBirdOffsetX            																		; $d960: a5 5c     
			clc                																		; $d962: 18        
			adc #$04           																		; $d963: 69 04     
			jmp __setCaughtButterflyX         																		; $d965: 4c 56 d9  

;-------------------------------------------------------------------------------
__nestling1Feeding:     
			lda vNestling1Timer          																		; $d968: ad 05 02  
			cmp #$40           																		; $d96b: c9 40     
				bcc __nestlingIgnoreButterfly         																		; $d96d: 90 65     
			cmp vNestlingAwayState            																		; $d96f: c5 65     
				beq __nestlingIgnoreButterfly         																		; $d971: f0 61     
			inc vNestling1State            																		; $d973: e6 8c     
			jsr __nestling1Scoring         																		; $d975: 20 f6 d9  
			lda #$00           																		; $d978: a9 00     
			sta vNestling1Timer          																		; $d97a: 8d 05 02  
; spawn a new butterfly in the world			
__releaseButterfly:     
			sta vButterflyXCaught,x          																		; $d97d: 95 b3     
			sta vButterfly1Y,x          																		; $d97f: 95 93     
			lda #$05           																		; $d981: a9 05     
			sta vSoundPlayerState            																		; $d983: 85 2a     
			lda #$00           																		; $d985: a9 00     
			sta vButterflyIsCaught            																		; $d987: 85 ea     
			jmp __setButterflyFrame         																		; $d989: 4c c5 d8  

;-------------------------------------------------------------------------------
__nestling2Feeding:     
			lda vNestling2Timer          																		; $d98c: ad 06 02  
			cmp #$40           																		; $d98f: c9 40     
				bcc __nestlingIgnoreButterfly         																		; $d991: 90 41     
			cmp vNestlingAwayState            																		; $d993: c5 65     
				beq __nestlingIgnoreButterfly         																		; $d995: f0 3d     
			inc vNestling2State            																		; $d997: e6 8d     
			jsr __nestling2Scoring         																		; $d999: 20 fd d9  
			lda #$00           																		; $d99c: a9 00     
			sta vNestling2Timer          																		; $d99e: 8d 06 02  
			jmp __releaseButterfly         																		; $d9a1: 4c 7d d9  

;-------------------------------------------------------------------------------
__handleNestlingButterfly:     
			lda vBirdSpritePosY          																		; $d9a4: ad 00 07  
			; muthaf**king nestling hitbox checking
			cmp __nestlingBranchPosY,y       																		; $d9a7: d9 43 da  
				bne ___nestlingIgnoreButterfly         																		; $d9aa: d0 2b     
			lda vButterfly1X,x          																		; $d9ac: b5 73     
			cmp __nestling1BranchPosX1,y       																		; $d9ae: d9 46 da  
				bcc __nestlingIgnoreButterfly         																		; $d9b1: 90 21     
			cmp __nestling1BranchPosX2,y       																		; $d9b3: d9 49 da  
				bcc __nestling1Feeding         																		; $d9b6: 90 b0     
			cmp __nestling2BranchPosX1,y       																		; $d9b8: d9 4c da  
				bcc __nestlingIgnoreButterfly         																		; $d9bb: 90 17     
			cmp __nestling2BranchPosX2,y       																		; $d9bd: d9 4f da  
				bcc __nestling2Feeding         																		; $d9c0: 90 ca     

			lda vCurrentLevel            																		; $d9c2: a5 55     
			cmp #$10           																		; $d9c4: c9 10     
				bcc __nestlingIgnoreButterfly         																		; $d9c6: 90 0c     
			lda vButterfly1X,x          																		; $d9c8: b5 73     
			cmp __nestling3BranchPosX1,y       																		; $d9ca: d9 52 da  
				bcc __nestlingIgnoreButterfly         																		; $d9cd: 90 05     
			cmp __nestling3BranchPosX2,y       																		; $d9cf: d9 55 da  
				bcc __nestling3Feeding         																		; $d9d2: 90 0a     
__nestlingIgnoreButterfly:     
			lda vBirdSpritePosY          																		; $d9d4: ad 00 07  
___nestlingIgnoreButterfly:     
			sta vButterfly1Y,x          																		; $d9d7: 95 93     
			lda #$1e           																		; $d9d9: a9 1e     
			jmp __setButterflyFrame         																		; $d9db: 4c c5 d8  

;-------------------------------------------------------------------------------
__nestling3Feeding:     
			lda vNestling3Timer          																		; $d9de: ad 07 02  
			cmp #$40           																		; $d9e1: c9 40     
				bcc __nestlingIgnoreButterfly         																		; $d9e3: 90 ef     
			cmp vNestlingAwayState            																		; $d9e5: c5 65     
				beq __nestlingIgnoreButterfly         																		; $d9e7: f0 eb     
			inc vNestling3State            																		; $d9e9: e6 8e     
			jsr __nestling3Scoring         																		; $d9eb: 20 04 da  
			lda #$00           																		; $d9ee: a9 00     
			sta vNestling3Timer          																		; $d9f0: 8d 07 02  
			jmp __releaseButterfly         																		; $d9f3: 4c 7d d9  

;-------------------------------------------------------------------------------
__nestling1Scoring:     
			stx vBirdOffsetX            																		; $d9f6: 86 5c     
			ldx #$00           																		; $d9f8: a2 00     
			jmp __nestlingScoring         																		; $d9fa: 4c 08 da  

;-------------------------------------------------------------------------------
__nestling2Scoring:     
			stx vBirdOffsetX            																		; $d9fd: 86 5c     
			ldx #$01           																		; $d9ff: a2 01     
			jmp __nestlingScoring         																		; $da01: 4c 08 da  

;-------------------------------------------------------------------------------
__nestling3Scoring:     
			stx vBirdOffsetX            																		; $da04: 86 5c     
			ldx #$02           																		; $da06: a2 02     
__nestlingScoring:     
			lda vNestling1Timer,x        																		; $da08: bd 05 02  
			cmp #$a0           																		; $da0b: c9 a0     
				bcc __giveNestling3000Bonus         																		; $da0d: 90 17     
			cmp #$e0           																		; $da0f: c9 e0     
				bcc __giveNestling2000Bonus         																		; $da11: 90 1f     
			cmp #$f0           																		; $da13: c9 f0     
				bcc __giveNestling1000Bonus         																		; $da15: 90 06 
				
			inc vIsNestlingNoBonus          																		; $da17: ee 2b 02  
			ldx vBirdOffsetX            																		; $da1a: a6 5c     
			rts                																		; $da1c: 60        

;-------------------------------------------------------------------------------
__giveNestling1000Bonus:     
			inc vNestling1000Bonus          																		; $da1d: ee 2a 02  
__giveNestlingScore:     
			jsr __give10Score         																		; $da20: 20 fa fe  
			ldx vBirdOffsetX            																		; $da23: a6 5c     
__return19:     
			rts                																		; $da25: 60        

;-------------------------------------------------------------------------------
__giveNestling3000Bonus:     
			jsr __give10Score         																		; $da26: 20 fa fe  
			jsr __give10Score         																		; $da29: 20 fa fe  
			inc vNestling3000Bonus          																		; $da2c: ee 28 02  
			jmp __giveNestlingScore         																		; $da2f: 4c 20 da  

;-------------------------------------------------------------------------------
__giveNestling2000Bonus:     
			jsr __give10Score         																		; $da32: 20 fa fe  
			inc vNestling2000Bonus          																		; $da35: ee 29 02  
			jmp __giveNestlingScore         																		; $da38: 4c 20 da  

;-------------------------------------------------------------------------------
__butterflyFrames:     
			.hex 20 1e 1e 20   																		; $da3b: 20 1e 1e 20   Data
			.hex 21 1f 1f 21   																		; $da3f: 21 1f 1f 21   Data
__nestlingBranchPosY:     
			.hex 70 60 60      																		; $da43: 70 60 60      Data
__nestling1BranchPosX1:     
			.hex 3e 5e 1e      																		; $da46: 3e 5e 1e      Data
__nestling1BranchPosX2:     
			.hex 42 62 22      																		; $da49: 42 62 22      Data
__nestling2BranchPosX1:     
			.hex 46 66 26      																		; $da4c: 46 66 26      Data
__nestling2BranchPosX2:     
			.hex 4a 6a 2a      																		; $da4f: 4a 6a 2a      Data
__nestling3BranchPosX1:     
			.hex 4e 6e 2e      																		; $da52: 4e 6e 2e      Data
__nestling3BranchPosX2:     
			.hex 52 72 32      																		; $da55: 52 72 32      Data

;-------------------------------------------------------------------------------
__handleSeaBonusLevel:     
			lda vCurrentLevel            																		; $da58: a5 55     
			and #$07           																		; $da5a: 29 07     
			cmp #$03           																		; $da5c: c9 03     
				; not sea bonus level
				bne __return19         																		; $da5e: d0 c5     
				
			ldx #$00           																		; $da60: a2 00     
__handleFishLoop:     
			lda vButterflyXCaught,x          																		; $da62: b5 b3     
				bne __handleFishCatch         																		; $da64: d0 32     
			lda vButterfly1Y,x          																		; $da66: b5 93     
			cmp #$d4           																		; $da68: c9 d4     
				bcs __respawnBonusItem         																		; $da6a: b0 57     
				
__updateFish:     
			lda vButterfly1Timer,x          																		; $da6c: b5 d6     
			tay                																		; $da6e: a8        
			lda __fishTimers,y       																		; $da6f: b9 14 dc  
			sta vCounter            																		; $da72: 85 51     
			lda vButterflyFrameTimer,x          																		; $da74: b5 da     
			clc                																		; $da76: 18        
			adc vCounter            																		; $da77: 65 51     
			tay                																		; $da79: a8        
			lda __fishFrameTimers,y       																		; $da7a: b9 a4 db  
			lsr                																		; $da7d: 4a        
				bcs __moveFishRight         																		; $da7e: b0 21     
___moveFishLeft:     
			lsr                																		; $da80: 4a        
				bcs __moveFishLeft         																		; $da81: b0 23     
___moveFishUp:     
			lsr                																		; $da83: 4a        
				bcs __moveFishUp         																		; $da84: b0 25     
___moveFishDown:     
			lsr                																		; $da86: 4a        
				bcs __moveFishDown         																		; $da87: b0 27    
				
__setFishFrame:     
			tay                																		; $da89: a8        
			lda __fishFrames,y       																		; $da8a: b9 a0 db  
			sta vButterflyFrames,x        																		; $da8d: 9d 00 02  
			inx                																		; $da90: e8        
			cpx #$04           																		; $da91: e0 04     
				bne __handleFishLoop         																		; $da93: d0 cd     
				
			jmp __updateFishTimers         																		; $da95: 4c cd d8  

;-------------------------------------------------------------------------------
__handleFishCatch:     
			jsr __bonusItemCaught         																		; $da98: 20 b5 da  
			jsr __respawnBonusItem         																		; $da9b: 20 c3 da  
			jmp __updateFish         																		; $da9e: 4c 6c da  

;-------------------------------------------------------------------------------
__moveFishRight:     
			inc vButterfly1X,x          																		; $daa1: f6 73     
			jmp ___moveFishLeft         																		; $daa3: 4c 80 da  

;-------------------------------------------------------------------------------
__moveFishLeft:     
			dec vButterfly1X,x          																		; $daa6: d6 73     
			jmp ___moveFishUp         																		; $daa8: 4c 83 da  

;-------------------------------------------------------------------------------
__moveFishUp:     
			dec vButterfly1Y,x          																		; $daab: d6 93     
			jmp ___moveFishDown         																		; $daad: 4c 86 da  

;-------------------------------------------------------------------------------
__moveFishDown:     
			inc vButterfly1Y,x          																		; $dab0: f6 93     
			jmp __setFishFrame         																		; $dab2: 4c 89 da  

;-------------------------------------------------------------------------------
__bonusItemCaught:     
			lda #$00           																		; $dab5: a9 00     
			sta vButterflyXCaught,x          																		; $dab7: 95 b3     
			sta vBonusItemCounter,x        																		; $dab9: 9d 10 03  
			; bonus item sound
			lda #$06           																		; $dabc: a9 06     
			sta vSoundPlayerState            																		; $dabe: 85 2a     
			inc vBonusItemsCaught            																		; $dac0: e6 8b     
			rts                																		; $dac2: 60        

;-------------------------------------------------------------------------------
__respawnBonusItem:     
			lda #$00           																		; $dac3: a9 00     
			sta vButterflyFrameTimer,x          																		; $dac5: 95 da     
			lda #$d3           																		; $dac7: a9 d3     
			sta vButterfly1Y,x          																		; $dac9: 95 93     
			
			lda vRandomVar2            																		; $dacb: a5 17     
			and #$01           																		; $dacd: 29 01     
				bne __setBonusPosXOver80         																		; $dacf: d0 12     
			lda vRandomVar            																		; $dad1: a5 08     
			and #$03           																		; $dad3: 29 03     
				beq __setBonusPosX0         																		; $dad5: f0 1c     
			cmp #$01           																		; $dad7: c9 01     
				beq __setBonusPosX20         																		; $dad9: f0 1f     
			cmp #$02           																		; $dadb: c9 02     
				beq __setBonusPosX40         																		; $dadd: f0 24     
			cmp #$03           																		; $dadf: c9 03     
				beq __setBonusPosX60         																		; $dae1: f0 29     
				
__setBonusPosXOver80:     
			lda vCycleCounter            																		; $dae3: a5 09     
			and #$03           																		; $dae5: 29 03     
				beq __setBonusPosX80         																		; $dae7: f0 2c     
			cmp #$01           																		; $dae9: c9 01     
				beq __setBonusPosXA0         																		; $daeb: f0 31     
			cmp #$02           																		; $daed: c9 02     
				beq __setBonusPosXC0         																		; $daef: f0 36     
				bne __setBonusPosXE0         																		; $daf1: d0 3d     
__setBonusPosX0:     
			lda #$00           																		; $daf3: a9 00     
			sta vButterfly1X,x          																		; $daf5: 95 73     
__setBonusTimer:     
			sta vButterfly1Timer,x          																		; $daf7: 95 d6     
__return37:     
			rts                																		; $daf9: 60        

;-------------------------------------------------------------------------------
__setBonusPosX20:     
			lda #$20           																		; $dafa: a9 20     
			sta vButterfly1X,x          																		; $dafc: 95 73     
			lda #$10           																		; $dafe: a9 10     
			jmp __setBonusTimer         																		; $db00: 4c f7 da  

;-------------------------------------------------------------------------------
__setBonusPosX40:     
			lda #$40           																		; $db03: a9 40     
			sta vButterfly1X,x          																		; $db05: 95 73     
			lda #$20           																		; $db07: a9 20     
			jmp __setBonusTimer         																		; $db09: 4c f7 da  

;-------------------------------------------------------------------------------
__setBonusPosX60:     
			lda #$60           																		; $db0c: a9 60     
			sta vButterfly1X,x          																		; $db0e: 95 73     
			lda #$30           																		; $db10: a9 30     
			jmp __setBonusTimer         																		; $db12: 4c f7 da  

;-------------------------------------------------------------------------------
__setBonusPosX80:     
			lda #$80           																		; $db15: a9 80     
			sta vButterfly1X,x          																		; $db17: 95 73     
			lda #$38           																		; $db19: a9 38     
			jmp __setBonusTimer         																		; $db1b: 4c f7 da  

;-------------------------------------------------------------------------------
__setBonusPosXA0:     
			lda #$a0           																		; $db1e: a9 a0     
			sta vButterfly1X,x          																		; $db20: 95 73     
			lda #$48           																		; $db22: a9 48     
			jmp __setBonusTimer         																		; $db24: 4c f7 da  

;-------------------------------------------------------------------------------
__setBonusPosXC0:     
			lda #$c0           																		; $db27: a9 c0     
			sta vButterfly1X,x          																		; $db29: 95 73     
			lda #$58           																		; $db2b: a9 58     
			jmp __setBonusTimer         																		; $db2d: 4c f7 da  

;-------------------------------------------------------------------------------
__setBonusPosXE0:     
			lda #$e0           																		; $db30: a9 e0     
			sta vButterfly1X,x          																		; $db32: 95 73     
			lda #$68           																		; $db34: a9 68     
			jmp __setBonusTimer         																		; $db36: 4c f7 da  

;-------------------------------------------------------------------------------
; Newton's favorite level
__handleTreeBonusLevel:     
			lda vCurrentLevel            																		; $db39: a5 55     
			and #$07           																		; $db3b: 29 07     
			cmp #$07           																		; $db3d: c9 07     
				; not tree bonus level
				bne __return37         																		; $db3f: d0 b8     
				
			ldx #$00           																		; $db41: a2 00     
__handleAppleLoop:     
			lda vButterflyXCaught,x          																		; $db43: b5 b3     
				bne __bonusAppleCaught         																		; $db45: d0 27     

			lda vButterfly1Y,x          																		; $db47: b5 93     
			cmp #$d0           																		; $db49: c9 d0     
				bcs __bonusAppleRespawn         																		; $db4b: b0 24     
			lda vBonusItemCounter,x        																		; $db4d: bd 10 03  
				beq __bonusAppleRespawn         																		; $db50: f0 1f     
			cmp #$20           																		; $db52: c9 20     
				bcc __appleHangsOnTree         																		; $db54: 90 02     
			; apple stays on tree for some time, then falls down
			inc vButterfly1Y,x          																		; $db56: f6 93     
			
__appleHangsOnTree:     
			lda vCycleCounter            																		; $db58: a5 09     
			and #$01           																		; $db5a: 29 01     
				bne __setAppleFrame         																		; $db5c: d0 03     
			inc vBonusItemCounter,x        																		; $db5e: fe 10 03  
__setAppleFrame:     
			lda #$89           																		; $db61: a9 89     
			sta vButterflyFrames,x        																		; $db63: 9d 00 02  
			inx                																		; $db66: e8        
			cpx #$04           																		; $db67: e0 04     
				bne __handleAppleLoop         																		; $db69: d0 d8     
				
			jmp __updateButterflyFrame         																		; $db6b: 4c ee d8  

;-------------------------------------------------------------------------------
__bonusAppleCaught:     
			jsr __bonusItemCaught         																		; $db6e: 20 b5 da  
__bonusAppleRespawn:     
			lda #$01           																		; $db71: a9 01     
			sta vBonusItemCounter,x        																		; $db73: 9d 10 03  
			jsr __respawnBonusItem         																		; $db76: 20 c3 da  
			jmp __setBonusApplePos         																		; $db79: 4c 7c db  

;-------------------------------------------------------------------------------
__setBonusApplePos:     
			lda vRandomVar            																		; $db7c: a5 08     
			and #$03           																		; $db7e: 29 03     
				beq __setBonusApplePosX40         																		; $db80: f0 0f     
			cmp #$01           																		; $db82: c9 01     
				beq __setBonusApplePosX50         																		; $db84: f0 10     
			cmp #$02           																		; $db86: c9 02     
				beq __setBonusApplePosX60         																		; $db88: f0 11     
			lda #$30           																		; $db8a: a9 30     
__setBonusApplePosY:     
			sta vButterfly1Y,x          																		; $db8c: 95 93     
			jmp __setAppleFrame         																		; $db8e: 4c 61 db  

;-------------------------------------------------------------------------------
__setBonusApplePosX40:     
			lda #$40           																		; $db91: a9 40     
			jmp __setBonusApplePosY         																		; $db93: 4c 8c db  

;-------------------------------------------------------------------------------
__setBonusApplePosX50:     
			lda #$50           																		; $db96: a9 50     
			jmp __setBonusApplePosY         																		; $db98: 4c 8c db  

;-------------------------------------------------------------------------------
__setBonusApplePosX60:     
			lda #$60           																		; $db9b: a9 60     
			jmp __setBonusApplePosY         																		; $db9d: 4c 8c db  

;-------------------------------------------------------------------------------
__fishFrames:     
			.hex 22 23 25 24   																		; $dba0: 22 23 25 24   Data
__fishFrameTimers:     
			.hex 01 01 01 05   																		; $dba4: 01 01 01 05   Data
			.hex 01 01 01 05   																		; $dba8: 01 01 01 05   Data
			.hex 12 12 12 16   																		; $dbac: 12 12 12 16   Data
			.hex 12 12 12 16   																		; $dbb0: 12 12 12 16   Data
			.hex 05 05 05 04   																		; $dbb4: 05 05 05 04   Data
			.hex 05 05 05 04   																		; $dbb8: 05 05 05 04   Data
			.hex 16 16 16 14   																		; $dbbc: 16 16 16 14   Data
			.hex 16 16 16 14   																		; $dbc0: 16 16 16 14   Data
			.hex 04 05 04 05   																		; $dbc4: 04 05 04 05   Data
			.hex 04 05 04 05   																		; $dbc8: 04 05 04 05   Data
			.hex 14 16 14 16   																		; $dbcc: 14 16 14 16   Data
			.hex 14 16 14 16   																		; $dbd0: 14 16 14 16   Data
			.hex 01 05 01 05   																		; $dbd4: 01 05 01 05   Data
			.hex 01 05 01 05   																		; $dbd8: 01 05 01 05   Data
			.hex 12 16 12 16   																		; $dbdc: 12 16 12 16   Data
			.hex 12 16 12 16   																		; $dbe0: 12 16 12 16   Data
			.hex 2a 2a 2a 28   																		; $dbe4: 2a 2a 2a 28   Data
			.hex 2a 2a 2a 28   																		; $dbe8: 2a 2a 2a 28   Data
			.hex 39 39 39 38   																		; $dbec: 39 39 39 38   Data
			.hex 39 39 39 38   																		; $dbf0: 39 39 39 38   Data
			.hex 28 2a 28 2a   																		; $dbf4: 28 2a 28 2a   Data
			.hex 28 2a 28 2a   																		; $dbf8: 28 2a 28 2a   Data
			.hex 38 39 38 39   																		; $dbfc: 38 39 38 39   Data
			.hex 38 39 38 39   																		; $dc00: 38 39 38 39   Data
			.hex 22 2a 22 2a   																		; $dc04: 22 2a 22 2a   Data
			.hex 22 2a 22 2a   																		; $dc08: 22 2a 22 2a   Data
			.hex 31 39 31 39   																		; $dc0c: 31 39 31 39   Data
			.hex 31 39 31 39   																		; $dc10: 31 39 31 39   Data
__fishTimers:     
			.hex 20 20 20 20   																		; $dc14: 20 20 20 20   Data
			.hex 10 10 00 00   																		; $dc18: 10 10 00 00   Data
			.hex 00 48 48 58   																		; $dc1c: 00 48 48 58   Data
			.hex 58 58 58 58   																		; $dc20: 58 58 58 58   Data
			.hex 10 10 10 30   																		; $dc24: 10 10 10 30   Data
			.hex 30 30 00 00   																		; $dc28: 30 30 00 00   Data
			.hex 00 00 68 68   																		; $dc2c: 00 00 68 68   Data
			.hex 48 58 58 58   																		; $dc30: 48 58 58 58   Data
			.hex 20 20 20 20   																		; $dc34: 20 20 20 20   Data
			.hex 20 20 10 30   																		; $dc38: 20 20 10 30   Data
			.hex 48 58 58 58   																		; $dc3c: 48 58 58 58   Data
			.hex 58 58 58 58   																		; $dc40: 58 58 58 58   Data
			.hex 20 20 10 30   																		; $dc44: 20 20 10 30   Data
			.hex 48 58 58 58   																		; $dc48: 48 58 58 58   Data
			.hex 28 28 28 28   																		; $dc4c: 28 28 28 28   Data
			.hex 18 18 08 08   																		; $dc50: 18 18 08 08   Data
			.hex 08 40 40 50   																		; $dc54: 08 40 40 50   Data
			.hex 50 50 50 50   																		; $dc58: 50 50 50 50   Data
			.hex 18 18 18 38   																		; $dc5c: 18 18 18 38   Data
			.hex 38 38 08 08   																		; $dc60: 38 38 08 08   Data
			.hex 08 08 60 60   																		; $dc64: 08 08 60 60   Data
			.hex 40 50 50 50   																		; $dc68: 40 50 50 50   Data
			.hex 28 28 28 28   																		; $dc6c: 28 28 28 28   Data
			.hex 28 28 18 38   																		; $dc70: 28 28 18 38   Data
			.hex 40 50 50 50   																		; $dc74: 40 50 50 50   Data
			.hex 50 50 50 50   																		; $dc78: 50 50 50 50   Data
			.hex 28 28 18 38   																		; $dc7c: 28 28 18 38   Data
			.hex 40 50 50 50   																		; $dc80: 40 50 50 50   Data

;-------------------------------------------------------------------------------
__handleMushroom:     
			lda vPlayerInput            																		; $dc84: a5 0a     
			and #$01           																		; $dc86: 29 01     
				bne __dropMushroom         																		; $dc88: d0 28     
			ldx #$00           																		; $dc8a: a2 00     
__mushroomCheckNext:     
			lda vCreatureMushroomDead,x        																		; $dc8c: bd 10 02  
				bne __hideMushroom         																		; $dc8f: d0 27     
			inx                																		; $dc91: e8        
			cpx #$06           																		; $dc92: e0 06     
				bne __mushroomCheckNext         																		; $dc94: d0 f6     
			lda vIsBirdLanded            																		; $dc96: a5 61     
				bne __birdLandedDropMushroom         																		; $dc98: d0 2f     
			lda vMushroomCollision            																		; $dc9a: a5 ba     
				bne __updateCaughtMushroomPos         																		; $dc9c: d0 32  
				
__mushroomCheckReachedLand:     
			lda vMushroomY            																		; $dc9e: a5 9a     
			cmp #$cc           																		; $dca0: c9 cc     
				bcs __mushroomReachedLand         																		; $dca2: b0 05     
				
__mushroomFalling:		
			inc vMushroomY    																		; $dca4: e6 9a
			inc vMushroomY            																		; $dca6: e6 9a     
			rts                																		; $dca8: 60        

;-------------------------------------------------------------------------------
__mushroomReachedLand:     
			lda #$00            																		; $dca9: a9        Suspected data
			sta vMushroomEngaged                																		; $dcaa: 00       
			lda #$cc
			sta vMushroomY
			rts                																		; $dcb1: 60        

;-------------------------------------------------------------------------------
__dropMushroom:     
			jsr __loseMushroom         																		; $dcb2: 20 c2 dc  
			jmp __mushroomCheckReachedLand         																		; $dcb5: 4c 9e dc  

;-------------------------------------------------------------------------------
; if mushroom damages somebody, it is lost when reaches land
__hideMushroom:     
			lda vMushroomY            																		; $dcb8: a5 9a     
			cmp #$cc            																		; $dcba: c9        Suspected data
				bcc __mushroomFalling         																		; $dcbb: cc 90 e6  
			lda #$f0           																		; $dcbe: a9 f0     
			sta vMushroomY            																		; $dcc0: 85 9a     
__loseMushroom:     
			lda #$00           																		; $dcc2: a9 00     
			sta vMushroomCollision            																		; $dcc4: 85 ba     
			sta vMushroomEngaged           																		; $dcc6: 85        Suspected data
			rts
;-------------------------------------------------------------------------------
__birdLandedDropMushroom:     
			lda #$00           																		; $dcc9: a9 00     
			sta vMushroomCollision            																		; $dccb: 85 ba     
			jmp __mushroomCheckReachedLand         																		; $dccd: 4c 9e dc  

;-------------------------------------------------------------------------------
__updateCaughtMushroomPos:     
			lda vBirdSpritePosY          																		; $dcd0: ad 00 07  
			cmp #$c8           																		; $dcd3: c9 c8     
				bcs __updateCaughtMushroomPosX         																		; $dcd5: b0 05     
			clc                																		; $dcd7: 18        
			adc #$0c           																		; $dcd8: 69 0c     
			sta vMushroomY            																		; $dcda: 85 9a     
__updateCaughtMushroomPosX:     
			jsr __convertNametableCoordToReal         																		; $dcdc: 20 fc d4  
			clc                																		; $dcdf: 18        
			adc #$3c           																		; $dce0: 69 3c     
			sta vMushroomX            																		; $dce2: 85 7a     
			rts                																		; $dce4: 60        

;-------------------------------------------------------------------------------
__handleSquirrel:     
			jsr __levelModulo4ToX         																		; $dce5: 20 5e c3  
			cpx #$02           																		; $dce8: e0 02     
				bne __return28         																		; $dcea: d0 2f     
			ldy vSquirrelFlags          																		; $dcec: ac 61 02  
			lda vWoodpeckerMushroomDead          																		; $dcef: ad 14 02  
				bne __handleDeadSquirrel         																		; $dcf2: d0 0b     
			lda vWoodpeckerSquirrelIsHit            																		; $dcf4: a5 88     
				bne __handleDeadSquirrel         																		; $dcf6: d0 07     
			tya                																		; $dcf8: 98        
			lsr                																		; $dcf9: 4a        
				bne __handleSquirrelFlight         																		; $dcfa: d0 4f     
			jmp ___handleSquirrel         																		; $dcfc: 4c 6f dd  

;-------------------------------------------------------------------------------
__handleDeadSquirrel:     
			lda vScoreForDeadWoodpecker          																		; $dcff: ad 5a 02  
				beq __scoreDeadSquirrel        																		; $dd02: f0 18     
___handleDeadWoodpeckerSquirrel:     
			tya                																		; $dd04: 98        
			and #$01           																		; $dd05: 29 01     
				bne __handleDeadSquirrelInFlight         																		; $dd07: d0 1f     
			; dead squirrel	
			lda #$7b           																		; $dd09: a9 7b     
			sta vWoodPeckerSprite          																		; $dd0b: 8d 3d 07  
			lda vWoodpeckerSquirrelY            																		; $dd0e: a5 9e     
			cmp #$b0           																		; $dd10: c9 b0     
				bcs __reviveSquirrel         																		; $dd12: b0 26     
			jsr __isOddCycle         																		; $dd14: 20 58 d6  
				bne __return28         																		; $dd17: d0 02     
			inc vWoodpeckerSquirrelY            																		; $dd19: e6 9e     
__return28:     
			rts                																		; $dd1b: 60        

;-------------------------------------------------------------------------------
__scoreDeadSquirrel:     
			inc vScoreForDeadWoodpecker          																		; $dd1c: ee 5a 02  
			jsr __give300Score         																		; $dd1f: 20 4f d6  
			jsr __killedCreatureSound         																		; $dd22: 20 45 c5  
			jmp ___handleDeadWoodpeckerSquirrel         																		; $dd25: 4c 04 dd  

;-------------------------------------------------------------------------------
__handleDeadSquirrelInFlight:     
			tya                																		; $dd28: 98        
			and #$08           																		; $dd29: 29 08     
				bne __setDeadSquirrelInFlightSpriteRight         																		; $dd2b: d0 08     
			lda #$79           																		; $dd2d: a9 79     
__setDeadSquirrelSprite:     
			sta vWoodPeckerSprite          																		; $dd2f: 8d 3d 07  
			jmp __handleSquirrelFlight         																		; $dd32: 4c 4b dd  

;-------------------------------------------------------------------------------
__setDeadSquirrelInFlightSpriteRight:     
			lda #$78           																		; $dd35: a9 78     
			jmp __setDeadSquirrelSprite         																		; $dd37: 4c 2f dd  

;-------------------------------------------------------------------------------
__reviveSquirrel:     
			lda vInvulnTimer            																		; $dd3a: a5 bf     
				bne __return28         																		; $dd3c: d0 dd     
			lda #$00           																		; $dd3e: a9 00     
			sta vWoodpeckerSquirrelIsHit            																		; $dd40: 85 88     
			sta vWoodpeckerSquirrelCollision            																		; $dd42: 85 be     
			sta vWoodpeckerMushroomDead          																		; $dd44: 8d 14 02  
			sta vScoreForDeadWoodpecker          																		; $dd47: 8d 5a 02  
			rts                																		; $dd4a: 60        

;-------------------------------------------------------------------------------
__handleSquirrelFlight:     
			lda vWoodpeckerSquirrelX            																		; $dd4b: a5 7e     
			and #$1f           																		; $dd4d: 29 1f     
			cmp #$18           																		; $dd4f: c9 18     
				beq __squirrelStopFlight         																		; $dd51: f0 12     
			jsr __getCycleModulo4         																		; $dd53: 20 5d d6  
				bne __squirrelDontChangeY         																		; $dd56: d0 02     
			inc vWoodpeckerSquirrelY            																		; $dd58: e6 9e     
__squirrelDontChangeY:     
			tya                																		; $dd5a: 98        
			and #$08           																		; $dd5b: 29 08     
				bne __squirrelFlyLeft         																		; $dd5d: d0 03     
			; fly right
			dec vWoodpeckerSquirrelX            																		; $dd5f: c6 7e     
			rts                																		; $dd61: 60        

;-------------------------------------------------------------------------------
__squirrelFlyLeft:     
			inc vWoodpeckerSquirrelX            																		; $dd62: e6 7e     
			rts                																		; $dd64: 60        

;-------------------------------------------------------------------------------
__squirrelStopFlight:     
			lda #$00           																		; $dd65: a9 00     
			sta vSquirrelFlags          																		; $dd67: 8d 61 02  
			rts                																		; $dd6a: 60        

;-------------------------------------------------------------------------------
			ror $7f7a,x        																		; $dd6b: 7e 7a 7f  
			.hex 7a            																		; $dd6e: 7a        Invalid Opcode - NOP 
___handleSquirrel:     
			lda vWoodpeckerSquirrelY            																		; $dd6f: a5 9e     
			cmp #$a0           																		; $dd71: c9 a0     
				bcs __squirrelOnBottom         																		; $dd73: b0 04     
			lda vRandomVar            																		; $dd75: a5 08     
				beq __squirrelFlight         																		; $dd77: f0 18     
__squirrelOnBottom:     
			jsr __getCycleModulo4         																		; $dd79: 20 5d d6  
				bne __return51         																		; $dd7c: d0 35     
			lda vWoodpeckerSquirrelY            																		; $dd7e: a5 9e     
			cmp #$30           																		; $dd80: c9 30     
				bcc __descendSquirrel         																		; $dd82: 90 40     
			cmp #$90           																		; $dd84: c9 90     
				bcs __ascendSquirrel         																		; $dd86: b0 48     
			lda vWoodpeckerSquirrelY            																		; $dd88: a5 9e     
			cmp vBirdSpritePosY          																		; $dd8a: cd 00 07  
				bcc __descendSquirrel         																		; $dd8d: 90 35     
				bcs __ascendSquirrel         																		; $dd8f: b0 3f     
				
__squirrelFlight:     
			tya                																		; $dd91: 98        
			ora #$01           																		; $dd92: 09 01     
			sta vSquirrelFlags          																		; $dd94: 8d 61 02  
			lda vWoodpeckerSquirrelX            																		; $dd97: a5 7e     
			sta vBirdX            																		; $dd99: 85 5b     
			jsr __getBirdRelativeDir         																		; $dd9b: 20 fc d5  
			lda vBirdX            																		; $dd9e: a5 5b     
			cmp #$01           																		; $dda0: c9 01     
				bne __squirrelFlightRight         																		; $dda2: d0 10     
			; flight left
			lda vSquirrelFlags          																		; $dda4: ad 61 02  
			ora #$f7           																		; $dda7: 09 f7     
			sta vSquirrelFlags          																		; $dda9: 8d 61 02  
			lda #$77           																		; $ddac: a9 77     
			sta vWoodPeckerSprite          																		; $ddae: 8d 3d 07  
			dec vWoodpeckerSquirrelX            																		; $ddb1: c6 7e     
__return51:     
			rts                																		; $ddb3: 60        

;-------------------------------------------------------------------------------
__squirrelFlightRight:     
			lda vSquirrelFlags          																		; $ddb4: ad 61 02  
			ora #$08           																		; $ddb7: 09 08     
			sta vSquirrelFlags          																		; $ddb9: 8d 61 02  
			lda #$76           																		; $ddbc: a9 76     
			sta vWoodPeckerSprite          																		; $ddbe: 8d 3d 07  
			inc vWoodpeckerSquirrelX            																		; $ddc1: e6 7e     
			rts                																		; $ddc3: 60        

;-------------------------------------------------------------------------------
__descendSquirrel:     
			jsr __setXEvery8Cycle         																		; $ddc4: 20 8b d0  
			lda __squirrelTreeAnim,x       																		; $ddc7: bd dc dd  
			sta vWoodPeckerSprite          																		; $ddca: 8d 3d 07  
			inc vWoodpeckerSquirrelY            																		; $ddcd: e6 9e     
			rts                																		; $ddcf: 60        

;-------------------------------------------------------------------------------
__ascendSquirrel:     
			jsr __setXEvery8Cycle         																		; $ddd0: 20 8b d0  
			lda __squirrelTreeAnim,x       																		; $ddd3: bd dc dd  
			sta vWoodPeckerSprite          																		; $ddd6: 8d 3d 07  
			dec vWoodpeckerSquirrelY            																		; $ddd9: c6 9e     
			rts                																		; $dddb: 60        

;-------------------------------------------------------------------------------
__squirrelTreeAnim:     
			.hex 7c 7a 7d 7a   																		; $dddc: 7c 7a 7d 7a   Data

;-------------------------------------------------------------------------------
; this first checks if fox is allowed in this level
__handleFox:     
			jsr __levelModulo4ToX         																		; $dde0: 20 5e c3  
			cpx #$01           																		; $dde3: e0 01     
				beq __handleSpawnedFox         																		; $dde5: f0 0d     
			lda vCurrentLevel            																		; $dde7: a5 55     
			and #$0f           																		; $dde9: 29 0f     
			cmp #$0c           																		; $ddeb: c9 0c     
				beq __return46         																		; $dded: f0 04     
			cmp #$09           																		; $ddef: c9 09     
				bcs __handleSpawnedFox         																		; $ddf1: b0 01     
__return46:     
			rts                																		; $ddf3: 60        

;-------------------------------------------------------------------------------
__handleSpawnedFox:     
			lda vFoxMushroomDead          																		; $ddf4: ad 12 02  
				bne __handleDeadFox         																		; $ddf7: d0 0e     
			lda vFoxIsHit            																		; $ddf9: a5 a8     
				bne __handleDeadFox         																		; $ddfb: d0 0a     
			lda vFoxDeadTimer            																		; $ddfd: a5 a7     
				bne __handleDeadFox         																		; $ddff: d0 06     
			jsr __handleAliveFox         																		; $de01: 20 78 de  
			jmp __handleAliveFox         																		; $de04: 4c 78 de  

;-------------------------------------------------------------------------------
__handleDeadFox:     
			lda vFoxDeadTimer            																		; $de07: a5 a7     
				beq __killFox         																		; $de09: f0 12     
			lda vFoxY            																		; $de0b: a5 9b     
			cmp #$c8           																		; $de0d: c9 c8     
				bcs __handleDeadLyingFox         																		; $de0f: b0 14     
			; dead fox falls
			inc vFoxY            																		; $de11: e6 9b     
			jsr __setXEvery4Cycle         																		; $de13: 20 93 d0  
			lda __foxDeadFrame,x       																		; $de16: bd 13 df  
			sta $0731          																		; $de19: 8d 31 07  
			rts                																		; $de1c: 60        

;-------------------------------------------------------------------------------
__killFox:     
			jsr __give300Score         																		; $de1d: 20 4f d6  
			inc vFoxDeadTimer            																		; $de20: e6 a7     
			jmp __killedCreatureSound         																		; $de22: 4c 45 c5  

;-------------------------------------------------------------------------------
__handleDeadLyingFox:    
			; dead sprite
			lda #$91           																		; $de25: a9 91     
			sta $0731          																		; $de27: 8d 31 07  
			inc vFoxDeadTimer            																		; $de2a: e6 a7     
			lda vFoxDeadTimer            																		; $de2c: a5 a7     
			; check if it's time to revive fox
			cmp #$f0           																		; $de2e: c9 f0     
				bne __return47         																		; $de30: d0 0b     
			; revive it
			lda #$00           																		; $de32: a9 00     
			sta vFoxDeadTimer            																		; $de34: 85 a7     
			sta vFoxIsHit            																		; $de36: 85 a8     
			sta vFoxMushroomDead          																		; $de38: 8d 12 02  
			sta vFoxCollision            																		; $de3b: 85 bb     
__return47:     
			rts                																		; $de3d: 60        

;-------------------------------------------------------------------------------
__foxJump:     
			lda vRandomVar            																		; $de3e: a5 08     
			and #$03           																		; $de40: 29 03     
				beq __foxLongJump         																		; $de42: f0 15     
				
			lda vFoxX            																		; $de44: a5 7b     
			sta vBirdX            																		; $de46: 85 5b     
			jsr __getBirdRelativeDir         																		; $de48: 20 fc d5  
			cmp #$01           																		; $de4b: c9 01     
				beq __foxShortJumpLeft         																		; $de4d: f0 05     
			lda #$00           																		; $de4f: a9 00     
			jmp __foxMakeJump         																		; $de51: 4c 66 de  

;-------------------------------------------------------------------------------
__foxShortJumpLeft:     
			lda #$10           																		; $de54: a9 10     
			jmp __foxMakeJump         																		; $de56: 4c 66 de  

;-------------------------------------------------------------------------------
__foxLongJump:     
			lda vFoxX            																		; $de59: a5 7b     
			sta vBirdX            																		; $de5b: 85 5b     
			jsr __getBirdRelativeDir         																		; $de5d: 20 fc d5  
			cmp #$01           																		; $de60: c9 01     
				beq __foxLongJumpLeft         																		; $de62: f0 0f     
			lda #$05           																		; $de64: a9 05     
			
__foxMakeJump:     
			sta vFoxJumpFrame          																		; $de66: 8d 90 02  
			lda #$00           																		; $de69: a9 00     
			sta vFoxFrameTimer          																		; $de6b: 8d 91 02  
			lda #$c4           																		; $de6e: a9 c4     
			sta vFoxY            																		; $de70: 85 9b     
			rts                																		; $de72: 60        

;-------------------------------------------------------------------------------
__foxLongJumpLeft:     
			lda #$15           																		; $de73: a9 15     
			jmp __foxMakeJump         																		; $de75: 4c 66 de  

;-------------------------------------------------------------------------------
; fox jumping and sprite updating 
__handleAliveFox:     
			lda vFoxY            																		; $de78: a5 9b     
			cmp #$c8           																		; $de7a: c9 c8     
				bcs __foxJump         																		; $de7c: b0 c0     
			lda vFoxJumpFrame          																		; $de7e: ad 90 02  
			tay                																		; $de81: a8        
			lda __foxFrameCodes,y       																		; $de82: b9 b3 de  
			clc                																		; $de85: 18        
			adc vFoxFrameTimer          																		; $de86: 6d 91 02  
			tay                																		; $de89: a8        
			
			lda __foxMovementCodes,y       																		; $de8a: b9 d3 de  
			ldx #$08           																		; $de8d: a2 08     
			jsr __actorMove         																		; $de8f: 20 15 d9  
			tay                																		; $de92: a8        
			lda __foxJumpFrame,y       																		; $de93: b9 17 df  
			sta $0731          																		; $de96: 8d 31 07  
			jsr __isOddCycle         																		; $de99: 20 58 d6  
				bne __return38         																		; $de9c: d0 14     
			; fox frame control
			inc vFoxFrameTimer          																		; $de9e: ee 91 02  
			lda vFoxFrameTimer          																		; $dea1: ad 91 02  
			cmp #$08           																		; $dea4: c9 08     
				beq __increaseFoxFrame         																		; $dea6: f0 02     
				bne __return38         																		; $dea8: d0 08     
				
__increaseFoxFrame:     
			lda #$00           																		; $deaa: a9 00     
			sta vFoxFrameTimer          																		; $deac: 8d 91 02  
			inc vFoxJumpFrame          																		; $deaf: ee 90 02  
__return38:     
			rts                																		; $deb2: 60        

;-------------------------------------------------------------------------------
__foxFrameCodes:     
			.hex 00 08 10 18   																		; $deb3: 00 08 10 18   Data
			.hex 18 00 00 00   																		; $deb7: 18 00 00 00   Data
			.hex 00 08 10 18   																		; $debb: 00 08 10 18   Data
			.hex 18 18 18 18   																		; $debf: 18 18 18 18   Data
			.hex 20 28 30 38   																		; $dec3: 20 28 30 38   Data
			.hex 38 20 20 20   																		; $dec7: 38 20 20 20   Data
			.hex 20 28 30 38   																		; $decb: 20 28 30 38   Data
			.hex 38 38 38 38   																		; $decf: 38 38 38 38   Data
__foxMovementCodes:     
			.hex 04 04 04 04   																		; $ded3: 04 04 04 04   Data
			.hex 04 04 04 04   																		; $ded7: 04 04 04 04   Data
			.hex 05 00 05 00   																		; $dedb: 05 00 05 00   Data
			.hex 05 00 05 00   																		; $dedf: 05 00 05 00   Data
			.hex 10 19 10 19   																		; $dee3: 10 19 10 19   Data
			.hex 10 19 10 19   																		; $dee7: 10 19 10 19   Data
			.hex 18 18 18 18   																		; $deeb: 18 18 18 18   Data
			.hex 18 18 18 18   																		; $deef: 18 18 18 18   Data
			.hex 24 24 24 24   																		; $def3: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $def7: 24 24 24 24   Data
			.hex 26 20 26 20   																		; $defb: 26 20 26 20   Data
			.hex 26 20 26 20   																		; $deff: 26 20 26 20   Data
			.hex 30 3a 30 3a   																		; $df03: 30 3a 30 3a   Data
			.hex 30 3a 30 3a   																		; $df07: 30 3a 30 3a   Data
			.hex 38 38 38 38   																		; $df0b: 38 38 38 38   Data
			.hex 38 38 38 38   																		; $df0f: 38 38 38 38   Data
__foxDeadFrame:     
			.hex 8b 8c 8b 8c   																		; $df13: 8b 8c 8b 8c   Data
__foxJumpFrame:     
			.hex 90 8e 8f 8d   																		; $df17: 90 8e 8f 8d   Data

;-------------------------------------------------------------------------------
__handleBee:     
			lda vCurrentLevel            																		; $df1b: a5 55     
			and #$0f           																		; $df1d: 29 0f     
			cmp #$0c           																		; $df1f: c9 0c     
				; dont spawn on lower levels
				bcc __return33         																		; $df21: 90 2b     
			lda vDeadBeeTimer          																		; $df23: ad 5d 02  
				bne __handleDeadBee         																		; $df26: d0 18     
			lda vBeeIsHit            																		; $df28: a5 66     
				bne __handleDeadBee         																		; $df2a: d0 14     
			lda vBeeMushroomDead          																		; $df2c: ad 10 02  
				bne __handleDeadBee         																		; $df2f: d0 0f     
				
			lda vCycleCounter            																		; $df31: a5 09     
			and #$0f           																		; $df33: 29 0f     
				bne __handleBeeFrame         																		; $df35: d0 3a     
			jsr __beeLevelWithBird         																		; $df37: 20 43 df  
			jsr __beeHorizontalMovement         																		; $df3a: 20 52 df  
			jmp __handleBeeFrame         																		; $df3d: 4c 71 df  

;-------------------------------------------------------------------------------
__handleDeadBee:     jmp ___handleDeadBee         																		; $df40: 4c cd df  

;-------------------------------------------------------------------------------
; controls bee vertical leveling with bird
__beeLevelWithBird:     
			lda vBeeY            																		; $df43: a5 90     
			cmp vBirdSpritePosY          																		; $df45: cd 00 07  
				beq __return33         																		; $df48: f0 04     
				bcs __beeMoveUp         																		; $df4a: b0 03     
			inc vBeeY            																		; $df4c: e6 90     
__return33:     
			rts                																		; $df4e: 60        

;-------------------------------------------------------------------------------
__beeMoveUp:     
			dec vBeeY            																		; $df4f: c6 90     
			rts                																		; $df51: 60        

;-------------------------------------------------------------------------------
__beeHorizontalMovement:     
			lda vBeeX            																		; $df52: a5 70     
			sta vBirdX            																		; $df54: 85 5b     
			jsr __getBirdRelativeDir         																		; $df56: 20 fc d5  
			lda vBirdX            																		; $df59: a5 5b     
				beq __return48         																		; $df5b: f0 0b     
			cmp #$01           																		; $df5d: c9 01     
				beq __beeMoveLeft         																		; $df5f: f0 08     
			; move bee right
			inc vBeeX            																		; $df61: e6 70     
			lda #$00           																		; $df63: a9 00     
			sta vBeeRotateLeft          																		; $df65: 8d 55 02  
__return48:     
			rts                																		; $df68: 60        

;-------------------------------------------------------------------------------
__beeMoveLeft:     
			dec vBeeX            																		; $df69: c6 70     
			lda #$01           																		; $df6b: a9 01     
			sta vBeeRotateLeft          																		; $df6d: 8d 55 02  
			rts                																		; $df70: 60        

;-------------------------------------------------------------------------------
; updates bee frame and moves it
__handleBeeFrame:     
			jsr __getCycleModulo4         																		; $df71: 20 5d d6  
				beq __chooseBeeFrame         																		; $df74: f0 14     
			lda vBeeFrameCounter          																		; $df76: ad 56 02  
			tay                																		; $df79: a8        
			lda __beeButterflyFrameCounter,y       																		; $df7a: b9 a7 e0  
			clc                																		; $df7d: 18        
			adc vBeeFrameTimer          																		; $df7e: 6d 57 02  
			tay                																		; $df81: a8        
			lda __beeButterflyFrameTimer,y       																		; $df82: b9 2f e0  
			ldx #$fd           																		; $df85: a2 fd     
			jsr __actorMove         																		; $df87: 20 15 d9  
__chooseBeeFrame:     
			jsr ___setBeeFrame         																		; $df8a: 20 c4 df  
			lda vBeeRotateLeft          																		; $df8d: ad 55 02  
				bne __beeSetMirrorFrame         																		; $df90: d0 16     
			lda __beeFrames,x       																		; $df92: bd f6 df  
__updateBeeFrame:     
			sta $0705          																		; $df95: 8d 05 07  
			jsr __getCycleModulo4         																		; $df98: 20 5d d6  
				bne __return49         																		; $df9b: d0 0a     
			inc vBeeFrameTimer          																		; $df9d: ee 57 02  
			lda vBeeFrameTimer          																		; $dfa0: ad 57 02  
			cmp #$08           																		; $dfa3: c9 08     
				beq __beeNextFrame         																		; $dfa5: f0 07     
__return49:     
			rts                																		; $dfa7: 60        

;-------------------------------------------------------------------------------
__beeSetMirrorFrame:     
			lda __beeMirrorFrames,x       																		; $dfa8: bd fa df  
			jmp __updateBeeFrame         																		; $dfab: 4c 95 df  

;-------------------------------------------------------------------------------
__beeNextFrame:     
			lda #$00           																		; $dfae: a9 00     
			sta vBeeFrameTimer          																		; $dfb0: 8d 57 02  
			inc vBeeFrameCounter          																		; $dfb3: ee 56 02  
			lda vBeeFrameCounter          																		; $dfb6: ad 56 02  
			cmp #$a8           																		; $dfb9: c9 a8     
				beq __beeResetFrame         																		; $dfbb: f0 01     
			rts                																		; $dfbd: 60        

;-------------------------------------------------------------------------------
__beeResetFrame:     
			lda #$00           																		; $dfbe: a9 00     
			sta vBeeFrameCounter          																		; $dfc0: 8d 56 02  
			rts                																		; $dfc3: 60        

;-------------------------------------------------------------------------------
___setBeeFrame:     
			lda vCycleCounter            																		; $dfc4: a5 09     
			and #$06           																		; $dfc6: 29 06     
			lsr                																		; $dfc8: 4a        
			and #$01           																		; $dfc9: 29 01     
			tax                																		; $dfcb: aa        
			rts                																		; $dfcc: 60        

;-------------------------------------------------------------------------------
___handleDeadBee:     
			inc vDeadBeeTimer          																		; $dfcd: ee 5d 02  
			lda vDeadBeeTimer          																		; $dfd0: ad 5d 02  
			cmp #$01           																		; $dfd3: c9 01     
				beq __killBee         																		; $dfd5: f0 16     
			inc vBeeY            																		; $dfd7: e6 90     
			lda vBeeY            																		; $dfd9: a5 90     
			cmp #$d8           																		; $dfdb: c9 d8     
				bcs __respawnBee         																		; $dfdd: b0 01     
			rts                																		; $dfdf: 60        

;-------------------------------------------------------------------------------
__respawnBee:     
			lda #$00           																		; $dfe0: a9 00     
			sta vDeadBeeTimer          																		; $dfe2: 8d 5d 02  
			sta vBeeHit            																		; $dfe5: 85 b0     
			sta vBeeIsHit            																		; $dfe7: 85 66     
			sta vBeeMushroomDead          																		; $dfe9: 8d 10 02  
			rts                																		; $dfec: 60        

;-------------------------------------------------------------------------------
__killBee:     
			jsr __give300Score         																		; $dfed: 20 4f d6  
			inc vDeadBeeTimer          																		; $dff0: ee 5d 02  
			jmp __killedCreatureSound         																		; $dff3: 4c 45 c5  

;-------------------------------------------------------------------------------
__beeFrames:     
			.hex 85 87 85 87   																		; $dff6: 85 87 85 87   Data
__beeMirrorFrames:     
			.hex 86 88 86 88   																		; $dffa: 86 88 86 88   Data

___checkBonusLevelTime:     
			jsr __getCycleModulo4         																		; $dffe: 20 5d d6  
				bne __return18         																		; $e001: d0 0e     
				
			inc vBonusLevelTimer            																		; $e003: e6 ec     
			lda vCurrentLevel            																		; $e005: a5 55     
			cmp #$07           																		; $e007: c9 07     
				beq __shorterTimeFor2BonusLevel         																		; $e009: f0 07     
			lda vBonusLevelTimer            																		; $e00b: a5 ec     
			cmp #$8d           																		; $e00d: c9 8d     
				beq __checkBonusLevel2Loop         																		; $e00f: f0 08     
__return18:     
			rts                																		; $e011: 60        

;-------------------------------------------------------------------------------
; another strange moments of this game
__shorterTimeFor2BonusLevel:     
			lda vBonusLevelTimer            																		; $e012: a5 ec     
			cmp #$81           																		; $e014: c9 81     
				beq __checkBonusLevel2Loop         																		; $e016: f0 01     
			rts                																		; $e018: 60        

;-------------------------------------------------------------------------------
__checkBonusLevel2Loop:     
			inc vBonusLevel2Loop          																		; $e019: ee 74 02  
			lda vBonusLevel2Loop          																		; $e01c: ad 74 02  
			cmp #$02           																		; $e01f: c9 02     
				bne __return18         																		; $e021: d0 ee     
				
___endBonusLevel:     
			lda #$00           																		; $e023: a9 00     
			sta vBonusLevel2Loop          																		; $e025: 8d 74 02  
			sta vScoreScreenState            																		; $e028: 85 d3     
			lda #$fe           																		; $e02a: a9 fe     
			sta vGameState            																		; $e02c: 85 50     
			rts                																		; $e02e: 60        

;-------------------------------------------------------------------------------
__beeButterflyFrameTimer:     
			.hex 25 11 11 11   																		; $e02f: 25 11 11 11   Data
			.hex 39 11 11 11   																		; $e033: 39 11 11 11   Data
			.hex 39 11 11 11   																		; $e037: 39 11 11 11   Data
			.hex 25 11 11 11   																		; $e03b: 25 11 11 11   Data
			.hex 66 52 52 52   																		; $e03f: 66 52 52 52   Data
			.hex 7a 52 52 52   																		; $e043: 7a 52 52 52   Data
			.hex 7a 52 52 52   																		; $e047: 7a 52 52 52   Data
			.hex 66 52 52 52   																		; $e04b: 66 52 52 52   Data
			.hex 44 25 44 44   																		; $e04f: 44 25 44 44   Data
			.hex 66 66 44 25   																		; $e053: 66 66 44 25   Data
			.hex 88 7a 88 88   																		; $e057: 88 7a 88 88   Data
			.hex 39 39 88 7a   																		; $e05b: 39 39 88 7a   Data
			.hex 44 66 52 66   																		; $e05f: 44 66 52 66   Data
			.hex 52 52 7a 52   																		; $e063: 52 52 7a 52   Data
			.hex 52 7a 52 7a   																		; $e067: 52 7a 52 7a   Data
			.hex 88 7a 88 88   																		; $e06b: 88 7a 88 88   Data
			.hex 88 7a 11 39   																		; $e06f: 88 7a 11 39   Data
			.hex 11 11 39 11   																		; $e073: 11 11 39 11   Data
			.hex 52 7a 52 52   																		; $e077: 52 7a 52 52   Data
			.hex 66 52 66 44   																		; $e07b: 66 52 66 44   Data
			.hex 44 25 44 25   																		; $e07f: 44 25 44 25   Data
			.hex 25 11 25 11   																		; $e083: 25 11 25 11   Data
			.hex 11 11 39 11   																		; $e087: 11 11 39 11   Data
			.hex 39 88 39 88   																		; $e08b: 39 88 39 88   Data
			.hex 88 7a 88 7a   																		; $e08f: 88 7a 88 7a   Data
			.hex 88 7a 52 52   																		; $e093: 88 7a 52 52   Data
			.hex 11 25 39 7a   																		; $e097: 11 25 39 7a   Data
			.hex 7a 66 25 11   																		; $e09b: 7a 66 25 11   Data
			.hex 52 7a 66 25   																		; $e09f: 52 7a 66 25   Data
			.hex 11 7a 52 52   																		; $e0a3: 11 7a 52 52   Data
__beeButterflyFrameCounter:     
			.hex 00 38 08 50   																		; $e0a7: 00 38 08 50   Data
			.hex 00 38 08 38   																		; $e0ab: 00 38 08 38   Data
			.hex 20 20 30 10   																		; $e0af: 20 20 30 10   Data
			.hex 18 48 18 10   																		; $e0b3: 18 48 18 10   Data
			.hex 48 48 10 48   																		; $e0b7: 48 48 10 48   Data
			.hex 18 18 48 20   																		; $e0bb: 18 18 48 20   Data
			.hex 38 10 50 00   																		; $e0bf: 38 10 50 00   Data
			.hex 10 10 10 28   																		; $e0c3: 10 10 10 28   Data
			.hex 00 00 28 28   																		; $e0c7: 00 00 28 28   Data
			.hex 50 50 20 20   																		; $e0cb: 50 50 20 20   Data
			.hex 10 18 18 10   																		; $e0cf: 10 18 18 10   Data
			.hex 30 38 20 48   																		; $e0d3: 30 38 20 48   Data
			.hex 10 18 38 48   																		; $e0d7: 10 18 38 48   Data
			.hex 30 48 60 60   																		; $e0db: 30 48 60 60   Data
			.hex 38 10 18 28   																		; $e0df: 38 10 18 28   Data
			.hex 38 18 28 60   																		; $e0e3: 38 18 28 60   Data
			.hex 10 18 10 18   																		; $e0e7: 10 18 10 18   Data
			.hex 30 38 18 10   																		; $e0eb: 30 38 18 10   Data
			.hex 48 50 58 00   																		; $e0ef: 48 50 58 00   Data
			.hex 08 00 08 58   																		; $e0f3: 08 00 08 58   Data
			.hex 28 30 40 00   																		; $e0f7: 28 30 40 00   Data
			.hex 08 00 08 20   																		; $e0fb: 08 00 08 20   Data
			.hex 68 00 08 20   																		; $e0ff: 68 00 08 20   Data
			.hex 40 50 58 28   																		; $e103: 40 50 58 28   Data
			.hex 28 00 08 40   																		; $e107: 28 00 08 40   Data
			.hex 40 50 50 20   																		; $e10b: 40 50 50 20   Data
			.hex 20 10 18 10   																		; $e10f: 20 10 18 10   Data
			.hex 18 10 18 30   																		; $e113: 18 10 18 30   Data
			.hex 30 10 18 38   																		; $e117: 30 10 18 38   Data
			.hex 10 18 10 30   																		; $e11b: 10 18 10 30   Data
			.hex 70 10 18 28   																		; $e11f: 70 10 18 28   Data
			.hex 38 10 38 38   																		; $e123: 38 10 38 38   Data
			.hex 10 30 38 70   																		; $e127: 10 30 38 70   Data
			.hex 10 18 10 18   																		; $e12b: 10 18 10 18   Data
			.hex 38 20 40 20   																		; $e12f: 38 20 40 20   Data
			.hex 40 50 50 50   																		; $e133: 40 50 50 50   Data
			.hex 00 08 00 08   																		; $e137: 00 08 00 08   Data
			.hex 40 00 08 58   																		; $e13b: 40 00 08 58   Data
			.hex 58 00 58 40   																		; $e13f: 58 00 58 40   Data
			.hex 00 08 58 00   																		; $e143: 00 08 58 00   Data
			.hex 08 48 58 00   																		; $e147: 08 48 58 00   Data
			.hex 40 48 20 40   																		; $e14b: 40 48 20 40   Data
			.hex 00 08 40 00   																		; $e14f: 00 08 40 00   Data
			.hex 58 08 00 68   																		; $e153: 58 08 00 68   Data
__tileXOffset:     
			.hex f3            																		; $e157: f3            Data
__tileYOffset:     
			.hex e5            																		; $e158: e5            Data
__tileXOffset2:     
			.hex eb            																		; $e159: eb            Data
__tileYOffset2:     
			.hex e8            																		; $e15a: e8            Data

;-------------------------------------------------------------------------------
___initGame:     
			jsr __disableNMI         																		; $e15b: 20 d0 fe  
			jsr __disableDrawing         																		; $e15e: 20 ee fe  
			lda #$24           																		; $e161: a9 24     
			jsr __clearNametable         																		; $e163: 20 f5 fd  
			lda #$09           																		; $e166: a9 09     
			ldx #$20           																		; $e168: a2 20     
			jsr __drawBackground         																		; $e16a: 20 b6 e2  
			jsr __drawMainMenuLabels         																		; $e16d: 20 8a e1  
			jsr __setNametableColor         																		; $e170: 20 31 e2  
			jsr __drawHiScoreLabel         																		; $e173: 20 fc e1  
			jsr __hideSpritesInTable         																		; $e176: 20 94 fe  
			jsr __hideSpritesInOAM         																		; $e179: 20 5a e2  
			jsr __drawBirdInMainMenu         																		; $e17c: 20 65 e2  
			jsr __composeOAMTable         																		; $e17f: 20 3b ff  
			inc vGameState            																		; $e182: e6 50     
			jsr __scrollScreen         																		; $e184: 20 b6 fd  
			jmp __enableNMI         																		; $e187: 4c c6 fe  

;-------------------------------------------------------------------------------
__drawMainMenuLabels:    
			; draw "study mode"
			ldx #$00           																		; $e18a: a2 00     
			lda #$22           																		; $e18c: a9 22     
			sta ppuAddress          																		; $e18e: 8d 06 20  
			lda #$cd           																		; $e191: a9 cd    
			
			sta ppuAddress     			; $e193: 8d 06 20  
__drawStudyModeLoop:     
			lda __studyModeLabel,x       																		; $e196: bd d0 e1  
			sta ppuData          																		; $e199: 8d 07 20  
			inx                																		; $e19c: e8        
			cpx #$0a           																		; $e19d: e0 0a     
			bne __drawStudyModeLoop         																		; $e19f: d0 f5     
			
			; draw "game start"
			ldx #$00           																		; $e1a1: a2 00     
			lda #$22           																		; $e1a3: a9 22     
			sta ppuAddress          																		; $e1a5: 8d 06 20  
			lda #$8d           																		; $e1a8: a9 8d     
			sta ppuAddress          																		; $e1aa: 8d 06 20  
__drawStartGameLoop:     
			lda __gameStartLabel,x       																		; $e1ad: bd da e1  
			sta ppuData          																		; $e1b0: 8d 07 20  
			inx                																		; $e1b3: e8        
			cpx #$0a           																		; $e1b4: e0 0a     
			bne __drawStartGameLoop         																		; $e1b6: d0 f5     
			; draw copyright
			ldx #$00           																		; $e1b8: a2 00     
			lda #$23           																		; $e1ba: a9 23     
			sta ppuAddress          																		; $e1bc: 8d 06 20  
			lda #$24           																		; $e1bf: a9 24     
			sta ppuAddress          																		; $e1c1: 8d 06 20  
__drawCopyrightLoop:     
			lda __copyrightLabel,x       																		; $e1c4: bd e4 e1  
			sta ppuData          																		; $e1c7: 8d 07 20  
			inx                																		; $e1ca: e8        
			cpx #$18           																		; $e1cb: e0 18     
			bne __drawCopyrightLoop         																		; $e1cd: d0 f5     
			
			rts                																		; $e1cf: 60        

;-------------------------------------------------------------------------------
__studyModeLabel:     
			.hex 1c 1d 1e 0d   																		; $e1d0: 1c 1d 1e 0d   Data
			.hex 22 24 10 0a   																		; $e1d4: 22 24 10 0a   Data
			.hex 16 0e         																		; $e1d8: 16 0e         Data
__gameStartLabel:     
			.hex 10 0a 16 0e   																		; $e1da: 10 0a 16 0e   Data
			.hex 24 1c 1d 0a   																		; $e1de: 24 1c 1d 0a   Data
			.hex 1b 1d         																		; $e1e2: 1b 1d         Data
__copyrightLabel:     
			.hex 25 24 01 09   																		; $e1e4: 25 24 01 09   Data
			.hex 08 06 24 1d   																		; $e1e8: 08 06 24 1d   Data
			.hex 18 1c 11 12   																		; $e1ec: 18 1c 11 12   Data
			.hex 0b 0a 24 0e   																		; $e1f0: 0b 0a 24 0e   Data
			.hex 16 12 4f 15   																		; $e1f4: 16 12 4f 15   Data
			.hex 0e 17 0a 1b   																		; $e1f8: 0e 17 0a 1b   Data

;-------------------------------------------------------------------------------
__drawHiScoreLabel:
			; set position
			lda #$20           																		; $e1fc: a9 20     
			sta ppuAddress          																		; $e1fe: 8d 06 20  
			lda #$68           																		; $e201: a9 68     
			sta ppuAddress          																		; $e203: 8d 06 20  
			
			ldy #$00           																		; $e206: a0 00     
__drawHiScoreLabelLoop:     
			lda __hiScoreLabel,y       																		; $e208: b9 75 e2  
			sta ppuData          																		; $e20b: 8d 07 20  
			iny                																		; $e20e: c8        
			cpy #$07           																		; $e20f: c0 07     
			bne __drawHiScoreLabelLoop         																		; $e211: d0 f5     
			
__drawHiScoreLoop:     
			lda vHiPlayerScore,y        																		; $e213: b9 10 01  
			bne __drawHiScoreNumber         																		; $e216: d0 0e     
			lda #$24           																		; $e218: a9 24     
			sta ppuData          																		; $e21a: 8d 07 20  
			dey                																		; $e21d: 88        
			bne __drawHiScoreLoop         																		; $e21e: d0 f3  
			
__drawHiScoreEnd:     
			lda #$00           																		; $e220: a9 00     
			sta ppuData          																		; $e222: 8d 07 20  
			rts                																		; $e225: 60        

;-------------------------------------------------------------------------------
__drawHiScoreNumber:     
			lda vHiPlayerScore,y        																		; $e226: b9 10 01  
			sta ppuData          																		; $e229: 8d 07 20  
			dey                																		; $e22c: 88        
			bne __drawHiScoreNumber         																		; $e22d: d0 f7     
			beq __drawHiScoreEnd         																		; $e22f: f0 ef     
			
__setNametableColor:  
			; set address
			lda #$23           																		; $e231: a9 23     
			sta ppuAddress          																		; $e233: 8d 06 20  
			ldy #$f8           																		; $e236: a0 f8     
			sty ppuAddress          																		; $e238: 8c 06 20  
			
			lda #$55           																		; $e23b: a9 55     
			ldx #$00           																		; $e23d: a2 00     
__setNametable1ColorLoop:     
			sta ppuData          																		; $e23f: 8d 07 20  
			inx                																		; $e242: e8        
			cpx #$08           																		; $e243: e0 08     
			bne __setNametable1ColorLoop         																		; $e245: d0 f8  
			
			; set address
			lda #$27           																		; $e247: a9 27     
			sta ppuAddress          																		; $e249: 8d 06 20  
			sty ppuAddress          																		; $e24c: 8c 06 20  
			
			lda #$55           																		; $e24f: a9 55     
__setNametable2ColorLoop:     
			sta ppuData          																		; $e251: 8d 07 20  
			inx                																		; $e254: e8        
			cpx #$10           																		; $e255: e0 10     
			bne __setNametable2ColorLoop         																		; $e257: d0 f8     
			rts                																		; $e259: 60        

;-------------------------------------------------------------------------------
__hideSpritesInOAM:     
			ldx #$00           																		; $e25a: a2 00     
			lda #$f0           																		; $e25c: a9 f0     
__hideSpritesInOAMLoop:     
			sta vOAMTable,x        																		; $e25e: 9d 00 06  
			inx                																		; $e261: e8        
			bne __hideSpritesInOAMLoop         																		; $e262: d0 fa     
			rts                																		; $e264: 60        

;-------------------------------------------------------------------------------
__drawBirdInMainMenu:     
			lda #$34           																		; $e265: a9 34     
			sta vBirdSpritePosY          																		; $e267: 8d 00 07  
			lda #$05           																		; $e26a: a9 05     
			sta $0701          																		; $e26c: 8d 01 07  
			lda #$b0           																		; $e26f: a9 b0     
			sta $0703          																		; $e271: 8d 03 07  
			rts                																		; $e274: 60        

;-------------------------------------------------------------------------------
__hiScoreLabel:     
			.hex 11 12 1c 0c   																		; $e275: 11 12 1c 0c   Data
			.hex 18 1b 0e      																		; $e279: 18 1b 0e      Data

;-------------------------------------------------------------------------------
___initGameLoop:     
			; some initialization
			jsr __disableNMI         																		; $e27c: 20 d0 fe  
			jsr __disableDrawing         																		; $e27f: 20 ee fe  
			jsr __setPPUIncrementBy1         																		; $e282: 20 da fe  
			jsr __loadPaletteFromLevel         																		; $e285: 20 aa e3  
			jsr __uploadPalettesToPPU         																		; $e288: 20 64 fe  
			jsr __clearStatusBar         																		; $e28b: 20 ca e4  
			
			lda vCurrentLevel            																		; $e28e: a5 55     
			and #$07           																		; $e290: 29 07     
			asl                																		; $e292: 0a        
			tax                																		; $e293: aa        
			
			; now we load level background
			; first nametable 0
			lda __backgroundNametable0,x       																		; $e294: bd e1 e4  
			ldx #$20           																		; $e297: a2 20     
			jsr __drawBackground         																		; $e299: 20 b6 e2  
			
			; then nametable 1
			lda vCurrentLevel            																		; $e29c: a5 55     
			and #$07           																		; $e29e: 29 07     
			asl                																		; $e2a0: 0a        
			tax                																		; $e2a1: aa      
			lda __backgroundNametable1,x       																		; $e2a2: bd e2 e4  
			ldx #$24           																		; $e2a5: a2 24     
			jsr __drawBackground         																		; $e2a7: 20 b6 e2  
			
			jsr __drawNestlingBranch         																		; $e2aa: 20 7e e4  
			jsr __drawBottom         																		; $e2ad: 20 4a e4  
			jsr __scrollScreen         																		; $e2b0: 20 b6 fd  
			jmp ___initGameLoop2         																		; $e2b3: 4c 86 c0  

;-------------------------------------------------------------------------------
__drawBackground:     
			jsr __buildTileBlocks         																		; $e2b6: 20 d4 e2  
			ldx #$00           																		; $e2b9: a2 00     
			stx vDataAddress            																		; $e2bb: 86 53     
			stx vCounter            																		; $e2bd: 86 51     
			
			jsr __uploadTileMacroblockToPPU         																		; $e2bf: 20 01 e3  
			jsr __uploadTileMacroblockToPPU         																		; $e2c2: 20 01 e3  
			jsr __uploadTileMacroblockToPPU         																		; $e2c5: 20 01 e3  
			jsr __uploadTileMacroblockToPPU         																		; $e2c8: 20 01 e3  
			jsr __uploadTileMacroblockToPPU         																		; $e2cb: 20 01 e3  
			jsr __uploadTileMacroblockToPPU         																		; $e2ce: 20 01 e3  
			jmp __setBackgroundPalette         																		; $e2d1: 4c 67 e3  

;-------------------------------------------------------------------------------
__buildTileBlocks:     
			; select nametable to fill
			stx vDataAddressHi            																		; $e2d4: 86 54     
			stx ppuAddress          																		; $e2d6: 8e 06 20  
			ldx #$80           																		; $e2d9: a2 80     
			stx ppuAddress          																		; $e2db: 8e 06 20
			
			sta vTileXOffset            																		; $e2de: 85 1c     
			lda #$30           																		; $e2e0: a9 30     
			sta vTileYOffset            																		; $e2e2: 85 1d     
			jsr __setTileAddressHi         																		; $e2e4: 20 94 e3  
			
			lda __tileXOffset         																		; $e2e7: ad 57 e1  
			sta vTileXOffset            																		; $e2ea: 85 1c     
			lda __tileYOffset         																		; $e2ec: ad 58 e1  
			sta vTileYOffset            																		; $e2ef: 85 1d     
			
			jsr __addTileOffset         																		; $e2f1: 20 86 e3  
			ldy #$00           																		; $e2f4: a0 00     
__buildTileBlocksLoop:     
			lda (vTileAddress),y        																		; $e2f6: b1 1e     
			sta $0300,y        																		; $e2f8: 99 00 03  
			iny                																		; $e2fb: c8        
			cpy #$30           																		; $e2fc: c0 30     
				bne __buildTileBlocksLoop         																		; $e2fe: d0 f6     
			rts                																		; $e300: 60        

;-------------------------------------------------------------------------------
__uploadTileMacroblockToPPU:     
			jsr __composeTileMacroblock         																		; $e301: 20 21 e3  
			cpx #$80           																		; $e304: e0 80     
				bne __uploadTileMacroblockToPPU         																		; $e306: d0 f9     
				
			ldx #$00           																		; $e308: a2 00     
			jsr __uploadTileBlockLineToPPU         																		; $e30a: 20 51 e3  
			
			ldx #$04           																		; $e30d: a2 04     
			jsr __uploadTileBlockLineToPPU         																		; $e30f: 20 51 e3  
			
			ldx #$08           																		; $e312: a2 08     
			jsr __uploadTileBlockLineToPPU         																		; $e314: 20 51 e3  
			
			ldx #$0c           																		; $e317: a2 0c     
			jsr __uploadTileBlockLineToPPU         																		; $e319: 20 51 e3  
			
			ldx #$00           																		; $e31c: a2 00     
			stx vDataAddress            																		; $e31e: 86 53     
			rts                																		; $e320: 60        

;-------------------------------------------------------------------------------
__composeTileMacroblock:     
			ldy vCounter            																		; $e321: a4 51     
			
			lda $0300,y        																		; $e323: b9 00 03  
			sta vTileXOffset            																		; $e326: 85 1c     
			lda #$10           																		; $e328: a9 10     
			sta vTileYOffset            																		; $e32a: 85 1d     
			jsr __setTileAddressHi         																		; $e32c: 20 94 e3  
			
			lda __tileXOffset2         																		; $e32f: ad 59 e1  
			sta vTileXOffset            																		; $e332: 85 1c     
			lda __tileYOffset2         																		; $e334: ad 5a e1  
			sta vTileYOffset            																		; $e337: 85 1d     
			jsr __addTileOffset         																		; $e339: 20 86 e3  
			
			iny                																		; $e33c: c8        
			sty vCounter            																		; $e33d: 84 51     
			ldx vDataAddress            																		; $e33f: a6 53     
			ldy #$00           																		; $e341: a0 00     
__composeTileMacroblockLoop:     
			lda (vTileAddress),y        																		; $e343: b1 1e     
			sta $0400,x        																		; $e345: 9d 00 04  
			inx                																		; $e348: e8        
			iny                																		; $e349: c8        
			cpy #$10           																		; $e34a: c0 10     
				bne __composeTileMacroblockLoop         																		; $e34c: d0 f5     
			stx vDataAddress            																		; $e34e: 86 53     
			rts                																		; $e350: 60        

;-------------------------------------------------------------------------------
__uploadTileBlockLineToPPU:     
			lda $0400,x        																		; $e351: bd 00 04  
			sta ppuData          																		; $e354: 8d 07 20  
			inx                																		; $e357: e8        
			txa                																		; $e358: 8a        
			and #$03           																		; $e359: 29 03     
				bne __uploadTileBlockLineToPPU         																		; $e35b: d0 f4     
			txa                																		; $e35d: 8a        
			clc                																		; $e35e: 18        
			adc #$0c           																		; $e35f: 69 0c     
			tax                																		; $e361: aa        
			cpx #$80           																		; $e362: e0 80     
				bcc __uploadTileBlockLineToPPU         																		; $e364: 90 eb     
			rts                																		; $e366: 60        

;-------------------------------------------------------------------------------
__setBackgroundPalette:     
			lda vDataAddressHi            																		; $e367: a5 54     
			clc                																		; $e369: 18        
			adc #$03           																		; $e36a: 69 03     
			sta ppuAddress          																		; $e36c: 8d 06 20  
			lda #$c8           																		; $e36f: a9 c8     
			sta ppuAddress          																		; $e371: 8d 06 20  
			ldy #$00           																		; $e374: a0 00     
__setBackgroundPaletteLoop:     
			lda $0300,y        																		; $e376: b9 00 03  
			tax                																		; $e379: aa        
			lda __backgroundPaletteData,x       																		; $e37a: bd 93 e8  
			sta ppuData          																		; $e37d: 8d 07 20  
			iny                																		; $e380: c8        
			cpy #$30           																		; $e381: c0 30     
				bne __setBackgroundPaletteLoop         																		; $e383: d0 f1     
			rts                																		; $e385: 60        

;-------------------------------------------------------------------------------
__addTileOffset:     
			lda vTileAddress            																		; $e386: a5 1e     
			clc                																		; $e388: 18        
			adc vTileXOffset            																		; $e389: 65 1c     
			sta vTileAddress            																		; $e38b: 85 1e     
			
			lda vTileAddressHi            																		; $e38d: a5 1f     
			adc vTileYOffset            																		; $e38f: 65 1d     
			sta vTileAddressHi            																		; $e391: 85 1f     
			rts                																		; $e393: 60        

;-------------------------------------------------------------------------------
__setTileAddressHi:     
			lda #$00           																		; $e394: a9 00     
			sta vTileAddress            																		; $e396: 85 1e     
			
			ldx #$08           																		; $e398: a2 08     
__setTileAddressHiLoop:     
			lsr vTileXOffset            																		; $e39a: 46 1c     
				bcc __skipYOffset         																		; $e39c: 90 03     
			clc                																		; $e39e: 18        
			adc vTileYOffset            																		; $e39f: 65 1d     
__skipYOffset:     
			ror                																		; $e3a1: 6a        
			ror vTileAddress            																		; $e3a2: 66 1e     
			dex                																		; $e3a4: ca        
				bne __setTileAddressHiLoop         																		; $e3a5: d0 f3     
			sta vTileAddressHi            																		; $e3a7: 85 1f     
			rts                																		; $e3a9: 60        

;-------------------------------------------------------------------------------
__loadPaletteFromLevel:     
			lda vCurrentLevel            																		; $e3aa: a5 55     
			and #$07           																		; $e3ac: 29 07     
			asl                																		; $e3ae: 0a        
			tax                																		; $e3af: aa      
			
__loadPaletteFromX:     
			lda __paletteAddr,x       																		; $e3b0: bd c7 e3  
			sta vDataAddress            																		; $e3b3: 85 53     
			lda __paletteAddrHi,x       																		; $e3b5: bd c8 e3  
			sta vDataAddressHi            																		; $e3b8: 85 54     
			ldy #$00           																		; $e3ba: a0 00     

__loadPaletteLoop:     
			lda (vDataAddress),y        																		; $e3bc: b1 53     
			sta vPaletteDataAbs,y        																		; $e3be: 99 30 00  
			iny                																		; $e3c1: c8        
			cpy #$20           																		; $e3c2: c0 20     
			bne __loadPaletteLoop         																		; $e3c4: d0 f6     
			rts                																		; $e3c6: 60        

;-------------------------------------------------------------------------------
__paletteAddr:     
			.hex f3            																		; $e3c7: f3            Data
__paletteAddrHi:     
			.hex e4 33 e5 53   																		; $e3c8: e4 33 e5 53   Data
			.hex e5 73 e5 93   																		; $e3cc: e5 73 e5 93   Data
			.hex e5 b3 e5 d3   																		; $e3d0: e5 b3 e5 d3   Data
			.hex e5 13 e5      																		; $e3d4: e5 13 e5      Data
__endDemoSequence:     
			jmp ___endDemoSequence         																		; $e3d7: 4c 9e f4  

;-------------------------------------------------------------------------------
__handleRoundSelectScoreScreen:     
			lda vDemoSequenceActive          																		; $e3da: ad 73 02  
				bne __endDemoSequence         																		; $e3dd: d0 f8     
			lda vGameState            																		; $e3df: a5 50     
			cmp #$02           																		; $e3e1: c9 02     
				beq __clearRoundScreenLabels         																		; $e3e3: f0 33     
				
___handleRoundSelectScoreScreen:     
			jsr __disableNMI         																		; $e3e5: 20 d0 fe  
			jsr __disableDrawing         																		; $e3e8: 20 ee fe  
			jsr __hideSpritesInTable         																		; $e3eb: 20 94 fe  
			jsr __setPPUIncrementBy1         																		; $e3ee: 20 da fe  
			ldx #$0a           																		; $e3f1: a2 0a     
			jsr __loadPaletteFromX         																		; $e3f3: 20 b0 e3  
			jsr __uploadPalettesToPPU         																		; $e3f6: 20 64 fe  
			jsr __clearStatusBar         																		; $e3f9: 20 ca e4  
			
			lda #$0a           																		; $e3fc: a9 0a     
			ldx #$20           																		; $e3fe: a2 20     
			jsr __drawBackground         																		; $e400: 20 b6 e2  
			ldy #$af           																		; $e403: a0 af     
			jsr __drawBottomNext         																		; $e405: 20 54 e4  
			lda #$f0           																		; $e408: a9 f0     
			sta vOAMTable          																		; $e40a: 8d 00 06  
			inc vScoreScreenState            																		; $e40d: e6 d3     
			jsr __scrollScreen         																		; $e40f: 20 b6 fd  
			jsr __composeOAMTable         																		; $e412: 20 3b ff  
			jmp __enableNMI         																		; $e415: 4c c6 fe  

;-------------------------------------------------------------------------------
__clearRoundScreenLabels:     
			lda vRoundNumber            																		; $e418: a5 f2     
			cmp #$01           																		; $e41a: c9 01     
				beq ___handleRoundSelectScoreScreen         																		; $e41c: f0 c7    
				
			lda #$20           																		; $e41e: a9 20     
			sta ppuAddress          																		; $e420: 8d 06 20  
			lda #$c8           																		; $e423: a9 c8     
			sta ppuAddress          																		; $e425: 8d 06 20  
			
			ldx #$00           																		; $e428: a2 00     
			ldy #$24           																		; $e42a: a0 24     
__clearLabelsLine1:     
			sty ppuData          																		; $e42c: 8c 07 20  
			inx                																		; $e42f: e8        
			cpx #$10           																		; $e430: e0 10     
			bne __clearLabelsLine1         																		; $e432: d0 f8    
			
			lda #$21           																		; $e434: a9 21     
			sta ppuAddress          																		; $e436: 8d 06 20  
			lda #$08           																		; $e439: a9 08     
			sta ppuAddress          																		; $e43b: 8d 06 20  
			
__clearLabelsLine2:     
			sty ppuData          																		; $e43e: 8c 07 20  
			inx                																		; $e441: e8        
			cpx #$20           																		; $e442: e0 20     
			bne __clearLabelsLine2         																		; $e444: d0 f8   
			
			jsr __scrollScreen         																		; $e446: 20 b6 fd  
			rts                																		; $e449: 60        

;-------------------------------------------------------------------------------
__drawBottom:     
			lda vCurrentLevel            																		; $e44a: a5 55     
			and #$07           																		; $e44c: 29 07     
			cmp #$03           																		; $e44e: c9 03  
				; bonus level
				beq __drawBottomBonus         																		; $e450: f0 1c    
				
			ldy #$af           																		; $e452: a0 af     
__drawBottomNext:     
			lda #$23           																		; $e454: a9 23     
			sta ppuAddress          																		; $e456: 8d 06 20  
			lda #$80           																		; $e459: a9 80     
			sta ppuAddress          																		; $e45b: 8d 06 20  
			
			jsr __drawBottomTiles         																		; $e45e: 20 73 e4  
			lda #$27           																		; $e461: a9 27     
			sta ppuAddress          																		; $e463: 8d 06 20  
			lda #$80           																		; $e466: a9 80     
			sta ppuAddress          																		; $e468: 8d 06 20  
			jmp __drawBottomTiles         																		; $e46b: 4c 73 e4  

;-------------------------------------------------------------------------------
__drawBottomBonus:     
			ldy #$7d           																		; $e46e: a0 7d     
			jmp __drawBottomNext         																		; $e470: 4c 54 e4  

;-------------------------------------------------------------------------------
__drawBottomTiles:     
			ldx #$00           																		; $e473: a2 00     
__drawBottomTilesLoop:     
			sty ppuData          																		; $e475: 8c 07 20  
			inx                																		; $e478: e8        
			cpx #$40           																		; $e479: e0 40     
			bne __drawBottomTilesLoop         																		; $e47b: d0 f8     
			rts                																		; $e47d: 60        

;-------------------------------------------------------------------------------
__drawNestlingBranch:     
			lda vCurrentLevel            																		; $e47e: a5 55     
			and #$03           																		; $e480: 29 03     
			cmp #$03           																		; $e482: c9 03     
				; is bonus level
				beq __return6         																		; $e484: f0 27   
			
			; 3 level repeating pattern
			lda vCurrentLevel            																		; $e486: a5 55     
			tay                																		; $e488: a8        
			and #$03           																		; $e489: 29 03     
			asl                																		; $e48b: 0a        
			tax                																		; $e48c: aa   
			
			; set position
			lda __nestlingBranchPos,x       																		; $e48d: bd ba e4  
			sta ppuAddress          																		; $e490: 8d 06 20  
			inx                																		; $e493: e8        
			lda __nestlingBranchPos,x       																		; $e494: bd ba e4  
			sta ppuAddress          																		; $e497: 8d 06 20  
			
			ldx #$00           																		; $e49a: a2 00     
			lda vCurrentLevel            																		; $e49c: a5 55     
			cmp #$10           																		; $e49e: c9 10 
				; 3 nestlings
				bcs __draw3NestlingBranch         																		; $e4a0: b0 0c 
				
			; 2 nestlings
__draw2NestlingBranch:     
			lda __branchFor2Nestlings,x       																		; $e4a2: bd c0 e4  
			sta ppuData          																		; $e4a5: 8d 07 20  
			inx                																		; $e4a8: e8        
			cpx #$04           																		; $e4a9: e0 04     
			bne __draw2NestlingBranch         																		; $e4ab: d0 f5     
__return6:     
			rts                																		; $e4ad: 60        

;-------------------------------------------------------------------------------
__draw3NestlingBranch:     
			lda __branchFor3Nestlings,x       																		; $e4ae: bd c4 e4  
			sta ppuData          																		; $e4b1: 8d 07 20  
			inx                																		; $e4b4: e8        
			cpx #$06           																		; $e4b5: e0 06     
			bne __draw3NestlingBranch         																		; $e4b7: d0 f5     
			rts                																		; $e4b9: 60        

;-------------------------------------------------------------------------------
__nestlingBranchPos:     
			.hex 22 10 21 d8   																		; $e4ba: 22 10 21 d8   Data
			.hex 21 c8         																		; $e4be: 21 c8         Data
__branchFor2Nestlings:     
			.hex 75 7c 7c 77   																		; $e4c0: 75 7c 7c 77   Data
__branchFor3Nestlings:     
			.hex 75 7c 7c 7c   																		; $e4c4: 75 7c 7c 7c   Data
			.hex 7c 77         																		; $e4c8: 7c 77         Data

;-------------------------------------------------------------------------------
__clearStatusBar:     
			lda #$20           																		; $e4ca: a9 20     
			sta ppuAddress          																		; $e4cc: 8d 06 20  
			lda #$64           																		; $e4cf: a9 64     
			sta ppuAddress          																		; $e4d1: 8d 06 20  
			ldx #$00           																		; $e4d4: a2 00     
			lda #$24           																		; $e4d6: a9 24     
	__clearStatusBarLoop:     
				sta ppuData          																		; $e4d8: 8d 07 20  
				inx                																		; $e4db: e8        
				cpx #$14           																		; $e4dc: e0 14     
				bne __clearStatusBarLoop         																		; $e4de: d0 f8     
			rts                																		; $e4e0: 60        

;-------------------------------------------------------------------------------
__backgroundNametable0:     
			.hex 02            																		; $e4e1: 02            Data
__backgroundNametable1:     
			.hex 03 0b 05 01   																		; $e4e2: 03 0b 05 01   Data
			.hex 0c 07 08 02   																		; $e4e6: 0c 07 08 02   Data
			.hex 06 0d 04 01   																		; $e4ea: 06 0d 04 01   Data
			.hex 0c 00 00 09   																		; $e4ee: 0c 00 00 09   Data
			.hex 0a 31 17 29   																		; $e4f2: 0a 31 17 29   Data
			.hex 12 31 18 29   																		; $e4f6: 12 31 18 29   Data
			.hex 1a 31 1a 29   																		; $e4fa: 1a 31 1a 29   Data
			.hex 18 31 01 30   																		; $e4fe: 18 31 01 30   Data
			.hex 21 31 12 30   																		; $e502: 21 31 12 30   Data
			.hex 17 31 0f 30   																		; $e506: 17 31 0f 30   Data
			.hex 16 31 13 30   																		; $e50a: 16 31 13 30   Data
			.hex 16 31 0f 38   																		; $e50e: 16 31 0f 38   Data
			.hex 26 31 17 27   																		; $e512: 26 31 17 27   Data
			.hex 12 31 18 39   																		; $e516: 12 31 18 39   Data
			.hex 1a 31 29 26   																		; $e51a: 1a 31 29 26   Data
			.hex 17 31 01 30   																		; $e51e: 17 31 01 30   Data
			.hex 21 31 12 30   																		; $e522: 21 31 12 30   Data
			.hex 17 31 0f 30   																		; $e526: 17 31 0f 30   Data
			.hex 16 31 0f 30   																		; $e52a: 16 31 0f 30   Data
			.hex 12 31 0f 38   																		; $e52e: 12 31 0f 38   Data
			.hex 16 31 17 34   																		; $e532: 16 31 17 34   Data
			.hex 12 31 18 1b   																		; $e536: 12 31 18 1b   Data
			.hex 29 31 15 34   																		; $e53a: 29 31 15 34   Data
			.hex 18 31 10 30   																		; $e53e: 18 31 10 30   Data
			.hex 21 31 12 30   																		; $e542: 21 31 12 30   Data
			.hex 17 31 0f 30   																		; $e546: 17 31 0f 30   Data
			.hex 16 31 18 30   																		; $e54a: 16 31 18 30   Data
			.hex 0f 31 0f 38   																		; $e54e: 0f 31 0f 38   Data
			.hex 26 31 17 27   																		; $e552: 26 31 17 27   Data
			.hex 12 31 18 28   																		; $e556: 12 31 18 28   Data
			.hex 29 31 16 27   																		; $e55a: 29 31 16 27   Data
			.hex 18 31 01 30   																		; $e55e: 18 31 01 30   Data
			.hex 21 31 12 30   																		; $e562: 21 31 12 30   Data
			.hex 17 31 0f 30   																		; $e566: 17 31 0f 30   Data
			.hex 16 31 10 30   																		; $e56a: 16 31 10 30   Data
			.hex 0f 31 0f 38   																		; $e56e: 0f 31 0f 38   Data
			.hex 26 31 17 2a   																		; $e572: 26 31 17 2a   Data
			.hex 12 31 30 11   																		; $e576: 12 31 30 11   Data
			.hex 24 31 30 11   																		; $e57a: 24 31 30 11   Data
			.hex 10 31 2a 30   																		; $e57e: 10 31 2a 30   Data
			.hex 10 31 12 30   																		; $e582: 10 31 12 30   Data
			.hex 17 31 21 31   																		; $e586: 17 31 21 31   Data
			.hex 15 31 0f 30   																		; $e58a: 15 31 0f 30   Data
			.hex 12 31 21 03   																		; $e58e: 12 31 21 03   Data
			.hex 2c 31 17 28   																		; $e592: 2c 31 17 28   Data
			.hex 12 31 18 28   																		; $e596: 12 31 18 28   Data
			.hex 36 31 17 28   																		; $e59a: 36 31 17 28   Data
			.hex 18 31 07 30   																		; $e59e: 18 31 07 30   Data
			.hex 21 31 12 30   																		; $e5a2: 21 31 12 30   Data
			.hex 17 31 0f 30   																		; $e5a6: 17 31 0f 30   Data
			.hex 16 31 13 30   																		; $e5aa: 16 31 13 30   Data
			.hex 16 31 0f 38   																		; $e5ae: 16 31 0f 38   Data
			.hex 26 31 17 29   																		; $e5b2: 26 31 17 29   Data
			.hex 12 31 16 29   																		; $e5b6: 12 31 16 29   Data
			.hex 1b 31 1a 29   																		; $e5ba: 1b 31 1a 29   Data
			.hex 18 31 01 30   																		; $e5be: 18 31 01 30   Data
			.hex 21 31 12 30   																		; $e5c2: 21 31 12 30   Data
			.hex 17 31 0f 30   																		; $e5c6: 17 31 0f 30   Data
			.hex 16 31 17 30   																		; $e5ca: 16 31 17 30   Data
			.hex 0f 31 0f 38   																		; $e5ce: 0f 31 0f 38   Data
			.hex 26 31 17 29   																		; $e5d2: 26 31 17 29   Data
			.hex 12 31 18 28   																		; $e5d6: 12 31 18 28   Data
			.hex 36 31 1b 29   																		; $e5da: 36 31 1b 29   Data
			.hex 18 31 01 30   																		; $e5de: 18 31 01 30   Data
			.hex 28 31 12 30   																		; $e5e2: 28 31 12 30   Data
			.hex 17 31 0f 30   																		; $e5e6: 17 31 0f 30   Data
			.hex 16 31 10 30   																		; $e5ea: 16 31 10 30   Data
			.hex 0f 31 0f 38   																		; $e5ee: 0f 31 0f 38   Data
			.hex 26 10 0f 10   																		; $e5f2: 26 10 0f 10   Data
			.hex 0f 10 0f 10   																		; $e5f6: 0f 10 0f 10   Data
			.hex 0f 0c 0e 0b   																		; $e5fa: 0f 0c 0e 0b   Data
			.hex 0d 0d 0e 0c   																		; $e5fe: 0d 0d 0e 0c   Data
			.hex 0d 0e 0b 0c   																		; $e602: 0d 0e 0b 0c   Data
			.hex 0b 0b 0d 0d   																		; $e606: 0b 0b 0d 0d   Data
			.hex 0d 0c 12 0d   																		; $e60a: 0d 0c 12 0d   Data
			.hex 12 0d 12 0c   																		; $e60e: 12 0d 12 0c   Data
			.hex 12 31 13 31   																		; $e612: 12 31 13 31   Data
			.hex 13 31 13 31   																		; $e616: 13 31 13 31   Data
			.hex 13 07 07 08   																		; $e61a: 13 07 07 08   Data
			.hex 07 0a 07 07   																		; $e61e: 07 0a 07 07   Data
			.hex 08 10 0f 10   																		; $e622: 08 10 0f 10   Data
			.hex 0f 10 0f 10   																		; $e626: 0f 10 0f 10   Data
			.hex 0f 0c 21 0c   																		; $e62a: 0f 0c 21 0c   Data
			.hex 21 0b 21 0d   																		; $e62e: 21 0b 21 0d   Data
			.hex 21 0d 20 4f   																		; $e632: 21 0d 20 4f   Data
			.hex 20 0e 20 0b   																		; $e636: 20 0e 20 0b   Data
			.hex 20 11 1f 11   																		; $e63a: 20 11 1f 11   Data
			.hex 1f 11 1f 11   																		; $e63e: 1f 11 1f 11   Data
			.hex 1f 00 1e 51   																		; $e642: 1f 00 1e 51   Data
			.hex 1e 50 1e 50   																		; $e646: 1e 50 1e 50   Data
			.hex 1e 07 08 0a   																		; $e64a: 1e 07 08 0a   Data
			.hex 07 08 09 07   																		; $e64e: 07 08 09 07   Data
			.hex 08 02 00 22   																		; $e652: 08 02 00 22   Data
			.hex 0f 26 00 00   																		; $e656: 0f 26 00 00   Data
			.hex 00 00 23 0c   																		; $e65a: 00 00 23 0c   Data
			.hex 21 0b 27 00   																		; $e65e: 21 0b 27 00   Data
			.hex 01 00 24 0d   																		; $e662: 01 00 24 0d   Data
			.hex 20 4e 28 00   																		; $e666: 20 4e 28 00   Data
			.hex 00 00 00 25   																		; $e66a: 00 00 00 25   Data
			.hex 1f 29 4d 00   																		; $e66e: 1f 29 4d 00   Data
			.hex 00 05 05 50   																		; $e672: 00 05 05 50   Data
			.hex 1e 00 14 15   																		; $e676: 1e 00 14 15   Data
			.hex 1d 08 0a 08   																		; $e67a: 1d 08 0a 08   Data
			.hex 07 09 07 0a   																		; $e67e: 07 09 07 0a   Data
			.hex 08 00 03 04   																		; $e682: 08 00 03 04   Data
			.hex 00 00 00 00   																		; $e686: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e68a: 00 00 00 00   Data
			.hex 00 00         																		; $e68e: 00 00         Data
			.hex 01 00 00 00   																		; $e690: 01 00 00 00   Data
			.hex 00 00 00 00   																		; $e694: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e698: 00 00 00 00   Data
			.hex 00 17 18 15   																		; $e69c: 00 17 18 15   Data
			.hex 1c 1b 00 14   																		; $e6a0: 1c 1b 00 14   Data
			.hex 15 16 19 30   																		; $e6a4: 15 16 19 30   Data
			.hex 30 30 1d 08   																		; $e6a8: 30 30 1d 08   Data
			.hex 0a 07 09 07   																		; $e6ac: 0a 07 09 07   Data
			.hex 07 0a 07 02   																		; $e6b0: 07 0a 07 02   Data
			.hex 00 00 00 03   																		; $e6b4: 00 00 00 03   Data
			.hex 04 00 00 00   																		; $e6b8: 04 00 00 00   Data
			.hex 00 00 01 00   																		; $e6bc: 00 00 01 00   Data
			.hex 00 00 01 00   																		; $e6c0: 00 00 01 00   Data
			.hex 00 00 00 00   																		; $e6c4: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e6c8: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e6cc: 00 00 00 00   Data
			.hex 00 00 00 52   																		; $e6d0: 00 00 00 52   Data
			.hex 50 53 52 53   																		; $e6d4: 50 53 52 53   Data
			.hex 51 52 52 0a   																		; $e6d8: 51 52 52 0a   Data
			.hex 54 54 55 0a   																		; $e6dc: 54 54 55 0a   Data
			.hex 55 0a 0a 03   																		; $e6e0: 55 0a 0a 03   Data
			.hex 04 00 00 00   																		; $e6e4: 04 00 00 00   Data
			.hex 00 00 00 00   																		; $e6e8: 00 00 00 00   Data
			.hex 00 00 00 02   																		; $e6ec: 00 00 00 02   Data
			.hex 01 00 00 00   																		; $e6f0: 01 00 00 00   Data
			.hex 00 00 00 00   																		; $e6f4: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e6f8: 00 00 00 00   Data
			.hex 00 2b 2f 00   																		; $e6fc: 00 2b 2f 00   Data
			.hex 00 00 00 2a   																		; $e700: 00 00 00 2a   Data
			.hex 2c 2d 2e 2a   																		; $e704: 2c 2d 2e 2a   Data
			.hex 2a 2f 00 08   																		; $e708: 2a 2f 00 08   Data
			.hex 07 07 08 08   																		; $e70c: 07 07 08 08   Data
			.hex 07 07 07 00   																		; $e710: 07 07 07 00   Data
			.hex 03 04 00 00   																		; $e714: 03 04 00 00   Data
			.hex 00 00 00 00   																		; $e718: 00 00 00 00   Data
			.hex 00 00 00 02   																		; $e71c: 00 00 00 02   Data
			.hex 00 02 00 00   																		; $e720: 00 02 00 00   Data
			.hex 01 00 00 00   																		; $e724: 01 00 00 00   Data
			.hex 00 00 00 00   																		; $e728: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e72c: 00 00 00 00   Data
			.hex 00 00 00 17   																		; $e730: 00 00 00 17   Data
			.hex 18 15 1c 1b   																		; $e734: 18 15 1c 1b   Data
			.hex 00 00 00 07   																		; $e738: 00 00 00 07   Data
			.hex 0a 09 0a 0a   																		; $e73c: 0a 09 0a 0a   Data
			.hex 0a 0a 08 00   																		; $e740: 0a 0a 08 00   Data
			.hex 00 00 03 04   																		; $e744: 00 00 03 04   Data
			.hex 00 00 00 00   																		; $e748: 00 00 00 00   Data
			.hex 02 00 00 00   																		; $e74c: 02 00 00 00   Data
			.hex 00 01 00 00   																		; $e750: 00 01 00 00   Data
			.hex 00 00 00 00   																		; $e754: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e758: 00 00 00 00   Data
			.hex 00 00 36 00   																		; $e75c: 00 00 36 00   Data
			.hex 00 00 00 00   																		; $e760: 00 00 00 00   Data
			.hex 00 2c 30 2e   																		; $e764: 00 2c 30 2e   Data
			.hex 00 00 00 32   																		; $e768: 00 00 00 32   Data
			.hex 32 33 34 34   																		; $e76c: 32 33 34 34   Data
			.hex 35 32 32 00   																		; $e770: 35 32 32 00   Data
			.hex 03 04 00 00   																		; $e774: 03 04 00 00   Data
			.hex 03 04 00 00   																		; $e778: 03 04 00 00   Data
			.hex 00 00 00 00   																		; $e77c: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e780: 00 00 00 00   Data
			.hex 00 00 00 01   																		; $e784: 00 00 00 01   Data
			.hex 00 00 00 00   																		; $e788: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e78c: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e790: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e794: 00 00 00 00   Data
			.hex 00 00 00 32   																		; $e798: 00 00 00 32   Data
			.hex 32 32 32 32   																		; $e79c: 32 32 32 32   Data
			.hex 32 32 32 00   																		; $e7a0: 32 32 32 00   Data
			.hex 3f 40 41 42   																		; $e7a4: 3f 40 41 42   Data
			.hex 3c 39 00 00   																		; $e7a8: 3c 39 00 00   Data
			.hex 43 44 45 46   																		; $e7ac: 43 44 45 46   Data
			.hex 47 48 00 00   																		; $e7b0: 47 48 00 00   Data
			.hex 3e 49 4a 4b   																		; $e7b4: 3e 49 4a 4b   Data
			.hex 4c 56 00 00   																		; $e7b8: 4c 56 00 00   Data
			.hex 3a 38 38 38   																		; $e7bc: 3a 38 38 38   Data
			.hex 38 3b 00 00   																		; $e7c0: 38 3b 00 00   Data
			.hex 00 00 00 00   																		; $e7c4: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e7c8: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e7cc: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e7d0: 00 00 00 00   Data
			.hex 37 3c 3c 3c   																		; $e7d4: 37 3c 3c 3c   Data
			.hex 3c 39 00 00   																		; $e7d8: 3c 39 00 00   Data
			.hex 3e 57 57 57   																		; $e7dc: 3e 57 57 57   Data
			.hex 57 3d 00 00   																		; $e7e0: 57 3d 00 00   Data
			.hex 3a 38 38 38   																		; $e7e4: 3a 38 38 38   Data
			.hex 38 3b 00 00   																		; $e7e8: 38 3b 00 00   Data
			.hex 00 00 17 18   																		; $e7ec: 00 00 17 18   Data
			.hex 1b 00 00 17   																		; $e7f0: 1b 00 00 17   Data
			.hex 18 15 16 19   																		; $e7f4: 18 15 16 19   Data
			.hex 30 1d 06 07   																		; $e7f8: 30 1d 06 07   Data
			.hex 08 07 0a 08   																		; $e7fc: 08 07 0a 08   Data
			.hex 09 07 08 00   																		; $e800: 09 07 08 00   Data
			.hex 03 04 00 22   																		; $e804: 03 04 00 22   Data
			.hex 0f 26 00 01   																		; $e808: 0f 26 00 01   Data
			.hex 00 00 23 0d   																		; $e80c: 00 00 23 0d   Data
			.hex 21 0e 27 00   																		; $e810: 21 0e 27 00   Data
			.hex 00 00 24 0c   																		; $e814: 00 00 24 0c   Data
			.hex 20 4f 28 00   																		; $e818: 20 4f 28 00   Data
			.hex 2b 2f 00 25   																		; $e81c: 2b 2f 00 25   Data
			.hex 1f 29 4d 2c   																		; $e820: 1f 29 4d 2c   Data
			.hex 2d 2e 05 00   																		; $e824: 2d 2e 05 00   Data
			.hex 1e 00 00 07   																		; $e828: 1e 00 00 07   Data
			.hex 0a 08 0a 09   																		; $e82c: 0a 08 0a 09   Data
			.hex 07 08 07 10   																		; $e830: 07 08 07 10   Data
			.hex 0f 10 0f 10   																		; $e834: 0f 10 0f 10   Data
			.hex 0f 10 0f 0c   																		; $e838: 0f 10 0f 0c   Data
			.hex 21 0c 21 0b   																		; $e83c: 21 0c 21 0b   Data
			.hex 21 0d 21 0d   																		; $e840: 21 0d 21 0d   Data
			.hex 20 0b 20 0e   																		; $e844: 20 0b 20 0e   Data
			.hex 20 0b 20 11   																		; $e848: 20 0b 20 11   Data
			.hex 1f 11 1f 11   																		; $e84c: 1f 11 1f 11   Data
			.hex 1f 11 1f 00   																		; $e850: 1f 11 1f 00   Data
			.hex 1e 50 1e 00   																		; $e854: 1e 50 1e 00   Data
			.hex 1e 51 1e 0a   																		; $e858: 1e 51 1e 0a   Data
			.hex 08 07 09 08   																		; $e85c: 08 07 09 08   Data
			.hex 0a 07 08 00   																		; $e860: 0a 07 08 00   Data
			.hex 03 04 00 22   																		; $e864: 03 04 00 22   Data
			.hex 0f 26 00 01   																		; $e868: 0f 26 00 01   Data
			.hex 00 00 23 0d   																		; $e86c: 00 00 23 0d   Data
			.hex 21 0e 27 00   																		; $e870: 21 0e 27 00   Data
			.hex 00 00 24 0c   																		; $e874: 00 00 24 0c   Data
			.hex 20 4f 28 00   																		; $e878: 20 4f 28 00   Data
			.hex 00 00 00 25   																		; $e87c: 00 00 00 25   Data
			.hex 1f 29 4d 52   																		; $e880: 1f 29 4d 52   Data
			.hex 50 53 53 52   																		; $e884: 50 53 53 52   Data
			.hex 1e 50 52 0a   																		; $e888: 1e 50 52 0a   Data
			.hex 54 55 0a 55   																		; $e88c: 54 55 0a 55   Data
			.hex 54 54 55      																		; $e890: 54 54 55      Data
__backgroundPaletteData:     
			.hex ff ff ff ff   																		; $e893: ff ff ff ff   Data
			.hex ff 55 55 55   																		; $e897: ff 55 55 55   Data
			.hex 55 55 55 aa   																		; $e89b: 55 55 55 aa   Data
			.hex aa aa aa aa   																		; $e89f: aa aa aa aa   Data
			.hex aa aa aa aa   																		; $e8a3: aa aa aa aa   Data
			.hex ff ff ff ff   																		; $e8a7: ff ff ff ff   Data
			.hex ff ff ff ff   																		; $e8ab: ff ff ff ff   Data
			.hex ff ff aa aa   																		; $e8af: ff ff aa aa   Data
			.hex aa aa aa aa   																		; $e8b3: aa aa aa aa   Data
			.hex aa aa aa aa   																		; $e8b7: aa aa aa aa   Data
			.hex aa aa ff ff   																		; $e8bb: aa aa ff ff   Data
			.hex ff ff ff ff   																		; $e8bf: ff ff ff ff   Data
			.hex ff aa aa aa   																		; $e8c3: ff aa aa aa   Data
			.hex aa aa 55 00   																		; $e8c7: aa aa 55 00   Data
			.hex 00 00 00 00   																		; $e8cb: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e8cf: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e8d3: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e8d7: 00 00 00 00   Data
			.hex 00 00 00 00   																		; $e8db: 00 00 00 00   Data
			.hex 00 aa 0a a0   																		; $e8df: 00 aa 0a a0   Data
			.hex 55 55 55 55   																		; $e8e3: 55 55 55 55   Data
			.hex 55 55 00 00   																		; $e8e7: 55 55 00 00   Data
			.hex 24 24 24 24   																		; $e8eb: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $e8ef: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $e8f3: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $e8f7: 24 24 24 24   Data
			.hex a0 a2 24 24   																		; $e8fb: a0 a2 24 24   Data
			.hex a1 a3 24 24   																		; $e8ff: a1 a3 24 24   Data
			.hex 24 24 24 24   																		; $e903: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $e907: 24 24 24 24   Data
			.hex 24 85 85 24   																		; $e90b: 24 85 85 24   Data
			.hex a0 3e 3e a6   																		; $e90f: a0 3e 3e a6   Data
			.hex a1 3e 3e a3   																		; $e913: a1 3e 3e a3   Data
			.hex 24 a8 a8 24   																		; $e917: 24 a8 a8 24   Data
			.hex 24 a4 a6 a4   																		; $e91b: 24 a4 a6 a4   Data
			.hex 87 7f 4e 3e   																		; $e91f: 87 7f 4e 3e   Data
			.hex 24 a1 a7 a1   																		; $e923: 24 a1 a7 a1   Data
			.hex 24 24 24 24   																		; $e927: 24 24 24 24   Data
			.hex a6 a4 a6 24   																		; $e92b: a6 a4 a6 24   Data
			.hex 3e 3e 3e ab   																		; $e92f: 3e 3e 3e ab   Data
			.hex a3 a5 a7 24   																		; $e933: a3 a5 a7 24   Data
			.hex 24 24 24 24   																		; $e937: 24 24 24 24   Data
			.hex 6c 6e 24 24   																		; $e93b: 6c 6e 24 24   Data
			.hex 61 61 24 24   																		; $e93f: 61 61 24 24   Data
			.hex 70 72 24 24   																		; $e943: 70 72 24 24   Data
			.hex 71 73 24 24   																		; $e947: 71 73 24 24   Data
			.hex 6c 6e 6c 6e   																		; $e94b: 6c 6e 6c 6e   Data
			.hex 61 61 61 61   																		; $e94f: 61 61 61 61   Data
			.hex 70 72 70 72   																		; $e953: 70 72 70 72   Data
			.hex 71 73 71 73   																		; $e957: 71 73 71 73   Data
			.hex 74 af 74 af   																		; $e95b: 74 af 74 af   Data
			.hex af 76 74 af   																		; $e95f: af 76 74 af   Data
			.hex af af af 76   																		; $e963: af af af 76   Data
			.hex 76 af af af   																		; $e967: 76 af af af   Data
			.hex af 76 74 af   																		; $e96b: af 76 74 af   Data
			.hex 74 af af af   																		; $e96f: 74 af af af   Data
			.hex 74 af af af   																		; $e973: 74 af af af   Data
			.hex af af 76 af   																		; $e977: af af 76 af   Data
			.hex af 74 af af   																		; $e97b: af 74 af af   Data
			.hex af af af af   																		; $e97f: af af af af   Data
			.hex 74 af 74 af   																		; $e983: 74 af 74 af   Data
			.hex af af b8 ba   																		; $e987: af af b8 ba   Data
			.hex b8 af 74 af   																		; $e98b: b8 af 74 af   Data
			.hex 76 74 af af   																		; $e98f: 76 74 af af   Data
			.hex 74 af af af   																		; $e993: 74 af af af   Data
			.hex af af 76 af   																		; $e997: af af 76 af   Data
			.hex 62 62 63 60   																		; $e99b: 62 62 63 60   Data
			.hex 62 62 60 60   																		; $e99f: 62 62 60 60   Data
			.hex 62 60 63 61   																		; $e9a3: 62 60 63 61   Data
			.hex 63 63 62 61   																		; $e9a7: 63 63 62 61   Data
			.hex 62 62 63 62   																		; $e9ab: 62 62 63 62   Data
			.hex 60 62 63 61   																		; $e9af: 60 62 63 61   Data
			.hex 62 63 63 63   																		; $e9b3: 62 63 63 63   Data
			.hex 61 63 62 61   																		; $e9b7: 61 63 62 61   Data
			.hex 62 63 63 61   																		; $e9bb: 62 63 63 61   Data
			.hex 60 62 61 61   																		; $e9bf: 60 62 61 61   Data
			.hex 61 62 60 62   																		; $e9c3: 61 62 60 62   Data
			.hex 61 62 61 62   																		; $e9c7: 61 62 61 62   Data
			.hex 63 62 63 63   																		; $e9cb: 63 62 63 63   Data
			.hex 62 63 63 63   																		; $e9cf: 62 63 63 63   Data
			.hex 62 60 63 62   																		; $e9d3: 62 60 63 62   Data
			.hex 63 63 62 62   																		; $e9d7: 63 63 62 62   Data
			.hex 24 24 68 6a   																		; $e9db: 24 24 68 6a   Data
			.hex 68 64 63 63   																		; $e9df: 68 64 63 63   Data
			.hex 60 60 63 62   																		; $e9e3: 60 60 63 62   Data
			.hex 63 63 62 62   																		; $e9e7: 63 63 62 62   Data
			.hex 24 24 24 24   																		; $e9eb: 24 24 24 24   Data
			.hex 6e aa 24 24   																		; $e9ef: 6e aa 24 24   Data
			.hex 63 62 6a 68   																		; $e9f3: 63 62 6a 68   Data
			.hex 63 63 62 62   																		; $e9f7: 63 63 62 62   Data
			.hex 62 63 63 61   																		; $e9fb: 62 63 63 61   Data
			.hex 60 62 60 61   																		; $e9ff: 60 62 60 61   Data
			.hex 61 62 6b 69   																		; $ea03: 61 62 6b 69   Data
			.hex 69 6b 24 24   																		; $ea07: 69 6b 24 24   Data
			.hex 63 63 63 61   																		; $ea0b: 63 63 63 61   Data
			.hex 60 63 60 60   																		; $ea0f: 60 63 60 60   Data
			.hex 62 63 5c 5e   																		; $ea13: 62 63 5c 5e   Data
			.hex 63 63 59 5b   																		; $ea17: 63 63 59 5b   Data
			.hex a8 69 49 4a   																		; $ea1b: a8 69 49 4a   Data
			.hex 24 24 45 47   																		; $ea1f: 24 24 45 47   Data
			.hex 24 24 40 42   																		; $ea23: 24 24 40 42   Data
			.hex 24 24 41 43   																		; $ea27: 24 24 41 43   Data
			.hex 24 24 24 24   																		; $ea2b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ea2f: 24 24 24 24   Data
			.hex 24 24 88 8a   																		; $ea33: 24 24 88 8a   Data
			.hex 88 8a af af   																		; $ea37: 88 8a af af   Data
			.hex 24 24 88 8a   																		; $ea3b: 24 24 88 8a   Data
			.hex 88 8a af af   																		; $ea3f: 88 8a af af   Data
			.hex af af af af   																		; $ea43: af af af af   Data
			.hex af af af af   																		; $ea47: af af af af   Data
			.hex af af 8d 3c   																		; $ea4b: af af 8d 3c   Data
			.hex af 8d 91 93   																		; $ea4f: af 8d 91 93   Data
			.hex af af af af   																		; $ea53: af af af af   Data
			.hex af af af af   																		; $ea57: af af af af   Data
			.hex 24 24 24 24   																		; $ea5b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ea5f: 24 24 24 24   Data
			.hex 24 24 88 8e   																		; $ea63: 24 24 88 8e   Data
			.hex 88 8a af 8f   																		; $ea67: 88 8a af 8f   Data
			.hex 24 24 24 24   																		; $ea6b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ea6f: 24 24 24 24   Data
			.hex 92 24 24 90   																		; $ea73: 92 24 24 90   Data
			.hex 3c 92 90 af   																		; $ea77: 3c 92 90 af   Data
			.hex 91 93 af af   																		; $ea7b: 91 93 af af   Data
			.hex af af af af   																		; $ea7f: af af af af   Data
			.hex af af af af   																		; $ea83: af af af af   Data
			.hex af af af af   																		; $ea87: af af af af   Data
			.hex 24 24 88 8a   																		; $ea8b: 24 24 88 8a   Data
			.hex 24 90 af af   																		; $ea8f: 24 90 af af   Data
			.hex 90 af af af   																		; $ea93: 90 af af af   Data
			.hex af af af af   																		; $ea97: af af af af   Data
			.hex 24 24 24 24   																		; $ea9b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ea9f: 24 24 24 24   Data
			.hex 89 8b 24 24   																		; $eaa3: 89 8b 24 24   Data
			.hex af af 89 8b   																		; $eaa7: af af 89 8b   Data
			.hex 89 8b 24 24   																		; $eaab: 89 8b 24 24   Data
			.hex af af 89 8b   																		; $eaaf: af af 89 8b   Data
			.hex af af af af   																		; $eab3: af af af af   Data
			.hex af af af af   																		; $eab7: af af af af   Data
			.hex 97 24 24 24   																		; $eabb: 97 24 24 24   Data
			.hex af 97 24 24   																		; $eabf: af 97 24 24   Data
			.hex af af 97 24   																		; $eac3: af af 97 24   Data
			.hex af af af 97   																		; $eac7: af af af 97   Data
			.hex 24 24 44 46   																		; $eacb: 24 24 44 46   Data
			.hex 24 24 45 47   																		; $eacf: 24 24 45 47   Data
			.hex 24 24 40 42   																		; $ead3: 24 24 40 42   Data
			.hex 24 24 41 43   																		; $ead7: 24 24 41 43   Data
			.hex 62 62 48 4b   																		; $eadb: 62 62 48 4b   Data
			.hex 63 63 48 4b   																		; $eadf: 63 63 48 4b   Data
			.hex 69 63 48 4b   																		; $eae3: 69 63 48 4b   Data
			.hex 24 a8 44 46   																		; $eae7: 24 a8 44 46   Data
			.hex 60 62 50 52   																		; $eaeb: 60 62 50 52   Data
			.hex 60 63 51 4a   																		; $eaef: 60 63 51 4a   Data
			.hex 62 4c 48 4b   																		; $eaf3: 62 4c 48 4b   Data
			.hex 61 4d 49 4b   																		; $eaf7: 61 4d 49 4b   Data
			.hex 62 62 63 60   																		; $eafb: 62 62 63 60   Data
			.hex 63 63 5c 5e   																		; $eaff: 63 63 5c 5e   Data
			.hex 63 62 5d 5f   																		; $eb03: 63 62 5d 5f   Data
			.hex 61 63 58 5a   																		; $eb07: 61 63 58 5a   Data
			.hex 24 24 24 24   																		; $eb0b: 24 24 24 24   Data
			.hex 24 24 24 68   																		; $eb0f: 24 24 24 68   Data
			.hex 24 24 64 60   																		; $eb13: 24 24 64 60   Data
			.hex 64 60 60 62   																		; $eb17: 64 60 60 62   Data
			.hex 24 24 24 64   																		; $eb1b: 24 24 24 64   Data
			.hex 24 24 64 60   																		; $eb1f: 24 24 64 60   Data
			.hex 24 6c 60 61   																		; $eb23: 24 6c 60 61   Data
			.hex 24 6d 60 61   																		; $eb27: 24 6d 60 61   Data
			.hex 24 24 64 62   																		; $eb2b: 24 24 64 62   Data
			.hex 24 24 65 60   																		; $eb2f: 24 24 65 60   Data
			.hex 24 24 a9 61   																		; $eb33: 24 24 a9 61   Data
			.hex 24 24 24 6d   																		; $eb37: 24 24 24 6d   Data
			.hex 65 65 62 62   																		; $eb3b: 65 65 62 62   Data
			.hex 24 69 62 60   																		; $eb3f: 24 69 62 60   Data
			.hex 24 24 a8 69   																		; $eb43: 24 24 a8 69   Data
			.hex 24 24 24 24   																		; $eb47: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $eb4b: 24 24 24 24   Data
			.hex 66 24 24 24   																		; $eb4f: 66 24 24 24   Data
			.hex 62 66 6a 24   																		; $eb53: 62 66 6a 24   Data
			.hex 63 62 63 6e   																		; $eb57: 63 62 63 6e   Data
			.hex 6e 24 24 24   																		; $eb5b: 6e 24 24 24   Data
			.hex 61 66 24 24   																		; $eb5f: 61 66 24 24   Data
			.hex 62 61 6e 24   																		; $eb63: 62 61 6e 24   Data
			.hex 63 62 6f 24   																		; $eb67: 63 62 6f 24   Data
			.hex 60 62 66 24   																		; $eb6b: 60 62 66 24   Data
			.hex 61 63 62 ab   																		; $eb6f: 61 63 62 ab   Data
			.hex 61 62 67 24   																		; $eb73: 61 62 67 24   Data
			.hex 61 61 ab 24   																		; $eb77: 61 61 ab 24   Data
			.hex 61 62 61 67   																		; $eb7b: 61 62 61 67   Data
			.hex 62 61 63 61   																		; $eb7f: 62 61 63 61   Data
			.hex 62 63 67 a8   																		; $eb83: 62 63 67 a8   Data
			.hex 6b a8 24 24   																		; $eb87: 6b a8 24 24   Data
			.hex 24 98 9c 9a   																		; $eb8b: 24 98 9c 9a   Data
			.hex 24 99 af 9b   																		; $eb8f: 24 99 af 9b   Data
			.hex 98 9f af 9b   																		; $eb93: 98 9f af 9b   Data
			.hex 99 9b af 9b   																		; $eb97: 99 9b af 9b   Data
			.hex 24 24 24 24   																		; $eb9b: 24 24 24 24   Data
			.hex 24 98 9c 9a   																		; $eb9f: 24 98 9c 9a   Data
			.hex 98 af 9d 9f   																		; $eba3: 98 af 9d 9f   Data
			.hex 99 9d 9f 9b   																		; $eba7: 99 9d 9f 9b   Data
			.hex 24 24 98 9c   																		; $ebab: 24 24 98 9c   Data
			.hex 24 24 99 af   																		; $ebaf: 24 24 99 af   Data
			.hex 24 98 9f af   																		; $ebb3: 24 98 9f af   Data
			.hex 24 99 9b 99   																		; $ebb7: 24 99 9b 99   Data
			.hex af 99 9b 9b   																		; $ebbb: af 99 9b 9b   Data
			.hex 9d 9f 9b 9b   																		; $ebbf: 9d 9f 9b 9b   Data
			.hex 99 9d 9f 9b   																		; $ebc3: 99 9d 9f 9b   Data
			.hex 99 99 9b 9b   																		; $ebc7: 99 99 9b 9b   Data
			.hex af 9b 24 24   																		; $ebcb: af 9b 24 24   Data
			.hex af 9b 9c 9a   																		; $ebcf: af 9b 9c 9a   Data
			.hex af 9b af 9b   																		; $ebd3: af 9b af 9b   Data
			.hex af 9b af 9b   																		; $ebd7: af 9b af 9b   Data
			.hex 24 24 24 24   																		; $ebdb: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ebdf: 24 24 24 24   Data
			.hex 9c 9a 24 24   																		; $ebe3: 9c 9a 24 24   Data
			.hex af 9b 24 24   																		; $ebe7: af 9b 24 24   Data
			.hex af af af af   																		; $ebeb: af af af af   Data
			.hex af af af af   																		; $ebef: af af af af   Data
			.hex af af af af   																		; $ebf3: af af af af   Data
			.hex af af af af   																		; $ebf7: af af af af   Data
			.hex 6b 69 6b a8   																		; $ebfb: 6b 69 6b a8   Data
			.hex 24 24 24 24   																		; $ebff: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ec03: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ec07: 24 24 24 24   Data
			.hex aa aa aa aa   																		; $ec0b: aa aa aa aa   Data
			.hex 7d 7d 7d 7d   																		; $ec0f: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec13: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec17: 7d 7d 7d 7d   Data
			.hex ac ad ad ad   																		; $ec1b: ac ad ad ad   Data
			.hex 7d 7d 7d 7d   																		; $ec1f: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec23: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec27: 7d 7d 7d 7d   Data
			.hex ad ad ad ad   																		; $ec2b: ad ad ad ad   Data
			.hex 7d 7d 7d 7d   																		; $ec2f: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec33: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec37: 7d 7d 7d 7d   Data
			.hex ae aa aa aa   																		; $ec3b: ae aa aa aa   Data
			.hex 7d 7d 7d 7d   																		; $ec3f: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec43: 7d 7d 7d 7d   Data
			.hex 7d 7d 7d 7d   																		; $ec47: 7d 7d 7d 7d   Data
			.hex 24 24 24 24   																		; $ec4b: 24 24 24 24   Data
			.hex 80 82 24 24   																		; $ec4f: 80 82 24 24   Data
			.hex 81 83 24 24   																		; $ec53: 81 83 24 24   Data
			.hex 84 86 24 24   																		; $ec57: 84 86 24 24   Data
			.hex 34 3a 3a 3a   																		; $ec5b: 34 3a 3a 3a   Data
			.hex 38 24 24 24   																		; $ec5f: 38 24 24 24   Data
			.hex 38 24 24 24   																		; $ec63: 38 24 24 24   Data
			.hex 38 24 24 24   																		; $ec67: 38 24 24 24   Data
			.hex 39 39 39 39   																		; $ec6b: 39 39 39 39   Data
			.hex 24 24 24 24   																		; $ec6f: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ec73: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ec77: 24 24 24 24   Data
			.hex 3a 3a 3a 36   																		; $ec7b: 3a 3a 3a 36   Data
			.hex 24 24 24 3b   																		; $ec7f: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ec83: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ec87: 24 24 24 3b   Data
			.hex 35 39 39 39   																		; $ec8b: 35 39 39 39   Data
			.hex 24 24 24 24   																		; $ec8f: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ec93: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ec97: 24 24 24 24   Data
			.hex 39 39 39 37   																		; $ec9b: 39 39 39 37   Data
			.hex 24 24 24 24   																		; $ec9f: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $eca3: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $eca7: 24 24 24 24   Data
			.hex 3a 3a 3a 3a   																		; $ecab: 3a 3a 3a 3a   Data
			.hex 24 24 24 24   																		; $ecaf: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ecb3: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ecb7: 24 24 24 24   Data
			.hex 24 24 24 3b   																		; $ecbb: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ecbf: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ecc3: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ecc7: 24 24 24 3b   Data
			.hex 38 24 24 24   																		; $eccb: 38 24 24 24   Data
			.hex 38 24 24 24   																		; $eccf: 38 24 24 24   Data
			.hex 38 24 24 24   																		; $ecd3: 38 24 24 24   Data
			.hex 38 24 24 24   																		; $ecd7: 38 24 24 24   Data
			.hex 34 3a 3a 3a   																		; $ecdb: 34 3a 3a 3a   Data
			.hex 38 24 2c 31   																		; $ecdf: 38 24 2c 31   Data
			.hex 38 24 2e 24   																		; $ece3: 38 24 2e 24   Data
			.hex 38 24 2d 31   																		; $ece7: 38 24 2d 31   Data
			.hex 3a 3a 3a 3a   																		; $eceb: 3a 3a 3a 3a   Data
			.hex 2a 24 30 24   																		; $ecef: 2a 24 30 24   Data
			.hex 2e 24 2e 24   																		; $ecf3: 2e 24 2e 24   Data
			.hex 1f 24 2e 24   																		; $ecf7: 1f 24 2e 24   Data
			.hex 3a 3a 3a 3a   																		; $ecfb: 3a 3a 3a 3a   Data
			.hex 2c 31 2a 24   																		; $ecff: 2c 31 2a 24   Data
			.hex 2e 24 2e 24   																		; $ed03: 2e 24 2e 24   Data
			.hex 2d 31 2b 24   																		; $ed07: 2d 31 2b 24   Data
			.hex 3a 3a 3a 3a   																		; $ed0b: 3a 3a 3a 3a   Data
			.hex 2c 31 2a 24   																		; $ed0f: 2c 31 2a 24   Data
			.hex 2e 24 2e 24   																		; $ed13: 2e 24 2e 24   Data
			.hex 2e 24 2e 24   																		; $ed17: 2e 24 2e 24   Data
			.hex 38 24 2e 24   																		; $ed1b: 38 24 2e 24   Data
			.hex 38 24 23 31   																		; $ed1f: 38 24 23 31   Data
			.hex 38 24 24 24   																		; $ed23: 38 24 24 24   Data
			.hex 38 24 24 24   																		; $ed27: 38 24 24 24   Data
			.hex 2e 24 2e 24   																		; $ed2b: 2e 24 2e 24   Data
			.hex 2b 24 2f 24   																		; $ed2f: 2b 24 2f 24   Data
			.hex 24 24 24 24   																		; $ed33: 24 24 24 24   Data
			.hex 24 30 24 30   																		; $ed37: 24 30 24 30   Data
			.hex 2e 24 20 24   																		; $ed3b: 2e 24 20 24   Data
			.hex 2f 24 2f 24   																		; $ed3f: 2f 24 2f 24   Data
			.hex 24 24 24 24   																		; $ed43: 24 24 24 24   Data
			.hex 24 30 24 2c   																		; $ed47: 24 30 24 2c   Data
			.hex 2e 24 2e 24   																		; $ed4b: 2e 24 2e 24   Data
			.hex 23 31 2b 24   																		; $ed4f: 23 31 2b 24   Data
			.hex 24 24 24 24   																		; $ed53: 24 24 24 24   Data
			.hex 31 33 24 2c   																		; $ed57: 31 33 24 2c   Data
			.hex 24 24 24 24   																		; $ed5b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ed5f: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ed63: 24 24 24 24   Data
			.hex 31 33 24 30   																		; $ed67: 31 33 24 30   Data
			.hex 24 24 24 3b   																		; $ed6b: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ed6f: 24 24 24 3b   Data
			.hex 24 24 24 3b   																		; $ed73: 24 24 24 3b   Data
			.hex 24 30 24 3b   																		; $ed77: 24 30 24 3b   Data
			.hex 24 2e 24 2e   																		; $ed7b: 24 2e 24 2e   Data
			.hex 24 2e 24 2e   																		; $ed7f: 24 2e 24 2e   Data
			.hex 24 2e 24 2e   																		; $ed83: 24 2e 24 2e   Data
			.hex 24 29 31 21   																		; $ed87: 24 29 31 21   Data
			.hex 24 2e 24 2e   																		; $ed8b: 24 2e 24 2e   Data
			.hex 24 2e 24 2d   																		; $ed8f: 24 2e 24 2d   Data
			.hex 24 2e 24 2e   																		; $ed93: 24 2e 24 2e   Data
			.hex 31 2b 24 23   																		; $ed97: 31 2b 24 23   Data
			.hex 24 24 24 2e   																		; $ed9b: 24 24 24 2e   Data
			.hex 31 33 24 2d   																		; $ed9f: 31 33 24 2d   Data
			.hex 24 24 24 2e   																		; $eda3: 24 24 24 2e   Data
			.hex 31 33 24 23   																		; $eda7: 31 33 24 23   Data
			.hex 24 24 24 2e   																		; $edab: 24 24 24 2e   Data
			.hex 31 33 24 2d   																		; $edaf: 31 33 24 2d   Data
			.hex 24 24 24 2e   																		; $edb3: 24 24 24 2e   Data
			.hex 31 33 24 2f   																		; $edb7: 31 33 24 2f   Data
			.hex 60 67 24 24   																		; $edbb: 60 67 24 24   Data
			.hex 6b 24 24 24   																		; $edbf: 6b 24 24 24   Data
			.hex 24 24 24 24   																		; $edc3: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $edc7: 24 24 24 24   Data
			.hex 60 62 63 60   																		; $edcb: 60 62 63 60   Data
			.hex 61 63 60 60   																		; $edcf: 61 63 60 60   Data
			.hex 63 61 61 63   																		; $edd3: 63 61 61 63   Data
			.hex 63 63 63 63   																		; $edd7: 63 63 63 63   Data
			.hex 60 62 63 60   																		; $eddb: 60 62 63 60   Data
			.hex 61 63 60 60   																		; $eddf: 61 63 60 60   Data
			.hex 63 61 61 63   																		; $ede3: 63 61 61 63   Data
			.hex 63 63 63 63   																		; $ede7: 63 63 63 63   Data
			.hex 24 24 24 24   																		; $edeb: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $edef: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $edf3: 24 24 24 24   Data
			.hex b9 bb b9 bb   																		; $edf7: b9 bb b9 bb   Data
			.hex 24 24 24 24   																		; $edfb: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $edff: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ee03: 24 24 24 24   Data
			.hex b9 bb 24 24   																		; $ee07: b9 bb 24 24   Data
			.hex 24 24 24 24   																		; $ee0b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ee0f: 24 24 24 24   Data
			.hex b4 b6 24 24   																		; $ee13: b4 b6 24 24   Data
			.hex b5 b7 24 24   																		; $ee17: b5 b7 24 24   Data
			.hex 24 24 24 24   																		; $ee1b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ee1f: 24 24 24 24   Data
			.hex b4 b6 b4 b6   																		; $ee23: b4 b6 b4 b6   Data
			.hex b5 b7 b5 b7   																		; $ee27: b5 b7 b5 b7   Data
			.hex b0 b2 b0 b2   																		; $ee2b: b0 b2 b0 b2   Data
			.hex b1 b3 b1 b3   																		; $ee2f: b1 b3 b1 b3   Data
			.hex 74 af b0 b2   																		; $ee33: 74 af b0 b2   Data
			.hex b8 b8 b1 b3   																		; $ee37: b8 b8 b1 b3   Data
			.hex b0 b2 af af   																		; $ee3b: b0 b2 af af   Data
			.hex b1 b3 b8 ba   																		; $ee3f: b1 b3 b8 ba   Data
			.hex 74 af b0 b2   																		; $ee43: 74 af b0 b2   Data
			.hex af af b1 b3   																		; $ee47: af af b1 b3   Data
			.hex 24 2e 24 3b   																		; $ee4b: 24 2e 24 3b   Data
			.hex 31 2b 24 3b   																		; $ee4f: 31 2b 24 3b   Data
			.hex 24 20 24 3b   																		; $ee53: 24 20 24 3b   Data
			.hex 24 2f 24 3b   																		; $ee57: 24 2f 24 3b   Data
			.hex 24 24 24 24   																		; $ee5b: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ee5f: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ee63: 24 24 24 24   Data
			.hex 24 24 24 24   																		; $ee67: 24 24 24 24   Data

;-------------------------------------------------------------------------------
__handleInvulnCreatures:     
			lda vInvulnCreatureState            																		; $ee6b: a5 89     
				bne __handleSpawnedInvulnCreature         																		; $ee6d: d0 0d     
			lda vHawkMushroomDead          																		; $ee6f: ad 13 02  
			clc                																		; $ee72: 18        
			adc vBeeMushroomDead          																		; $ee73: 6d 10 02  
			adc vBigBeeDead          																		; $ee76: 6d 15 02  
				bne __selectInvulnCreatureToSpawn         																		; $ee79: d0 04     
			rts                																		; $ee7b: 60        

;-------------------------------------------------------------------------------
__handleSpawnedInvulnCreature:     
			jmp ___handleSpawnedInvulnCreature         																		; $ee7c: 4c e1 ee  

;-------------------------------------------------------------------------------
__selectInvulnCreatureToSpawn:     
			lda vWoodpeckerMushroomDead          																		; $ee7f: ad 14 02  
				bne __giveCoolInvulnCreature         																		; $ee82: d0 38     
			lda vKiteMushroomDead          																		; $ee84: ad 11 02  
				bne __giveSuperInvulnCreature         																		; $ee87: d0 40     
			lda vInvulnTimer            																		; $ee89: a5 bf     
				bne __return59         																		; $ee8b: d0 2e     
__invulnCreatureSpawnTimer:     
			lda vInvulnSpawnTimer          																		; $ee8d: ad e4 02  
			and #$7f           																		; $ee90: 29 7f     
			inc vInvulnSpawnTimer          																		; $ee92: ee e4 02  
				beq __createInvulnCreature         																		; $ee95: f0 01     
			rts                																		; $ee97: 60        

;-------------------------------------------------------------------------------
__createInvulnCreature:     
			lda vCycleCounter            																		; $ee98: a5 09     
			and #$80           																		; $ee9a: 29 80     
			sta vInvulnCreatureState            																		; $ee9c: 85 89     
			inc vInvulnCreatureState            																		; $ee9e: e6 89     
			jsr __levelModulo4ToX         																		; $eea0: 20 5e c3  
			lda __invulnCreatureSpawnX,x       																		; $eea3: bd 5b ef  
			sta vInvulnCreatureX            																		; $eea6: 85 7f     
			lda __invulnCreatureSpawnY,x       																		; $eea8: bd 5e ef  
			sta vInvulnCreatureY            																		; $eeab: 85 9f     
			lda vStageSelect10s          																		; $eead: ad e1 02  
			clc                																		; $eeb0: 18        
			adc vStageSelectOnes          																		; $eeb1: 6d e2 02  
				bne __setNutInvulnCreature         																		; $eeb4: d0 26     
			; set pink birdie invuln creature
			lda #$57           																		; $eeb6: a9 57     
__setInvulnCreatureSprite:     
			sta $0741          																		; $eeb8: 8d 41 07  
__return59:     
			rts                																		; $eebb: 60        

;-------------------------------------------------------------------------------
__giveCoolInvulnCreature:     
			lda vInvulnSpawnTimer          																		; $eebc: ad e4 02  
			and #$7f           																		; $eebf: 29 7f     
				bne __invulnCreatureSpawnTimer         																		; $eec1: d0 ca     
			inc vStageSelect10s          																		; $eec3: ee e1 02  
			jmp __giveInvulnCreature         																		; $eec6: 4c d6 ee  

;-------------------------------------------------------------------------------
__giveSuperInvulnCreature:     
			lda vInvulnSpawnTimer          																		; $eec9: ad e4 02  
			and #$7f           																		; $eecc: 29 7f     
				bne __invulnCreatureSpawnTimer         																		; $eece: d0 bd     
			inc vStageSelectOnes          																		; $eed0: ee e2 02  
			jsr __give1000Score         																		; $eed3: 20 1a ff  
__giveInvulnCreature:     
			jsr __give1000Score         																		; $eed6: 20 1a ff  
			jmp __invulnCreatureSpawnTimer         																		; $eed9: 4c 8d ee  

;-------------------------------------------------------------------------------
__setNutInvulnCreature:     
			lda #$16           																		; $eedc: a9 16     
			jmp __setInvulnCreatureSprite         																		; $eede: 4c b8 ee  

;-------------------------------------------------------------------------------
___handleSpawnedInvulnCreature:     
			lda vInvulnTimer            																		; $eee1: a5 bf     
				bne __removeInvulnCreature         																		; $eee3: d0 24     
			lda vInvulnCreatureState            																		; $eee5: a5 89     
			and #$7f           																		; $eee7: 29 7f     
			cmp #$01           																		; $eee9: c9 01     
				beq __invulnCreatureFalling         																		; $eeeb: f0 05     
			cmp #$02           																		; $eeed: c9 02     
				beq __invulnCreatureRunaway         																		; $eeef: f0 0d     
			rts                																		; $eef1: 60        

;-------------------------------------------------------------------------------
; go catch it!
__invulnCreatureFalling:     
			inc vInvulnCreatureY            																		; $eef2: e6 9f     
			lda vInvulnCreatureY            																		; $eef4: a5 9f     
			cmp #$c8           																		; $eef6: c9 c8     
				bcs __setInvulnCreatureRunaway         																		; $eef8: b0 01     
			rts                																		; $eefa: 60        

;-------------------------------------------------------------------------------
__setInvulnCreatureRunaway:     
			inc vInvulnCreatureState            																		; $eefb: e6 89     
			rts                																		; $eefd: 60        

;-------------------------------------------------------------------------------
__invulnCreatureRunaway:     
			jsr ___invulnCreatureRunaway         																		; $eefe: 20 12 ef  
			lda $0740          																		; $ef01: ad 40 07  
			; too late for you
			cmp #$f0           																		; $ef04: c9 f0     
				beq __removeInvulnCreature         																		; $ef06: f0 01     
			rts                																		; $ef08: 60        

;-------------------------------------------------------------------------------
__removeInvulnCreature:     
			lda #$00           																		; $ef09: a9 00     
			sta vInvulnCreatureState            																		; $ef0b: 85 89     
			lda #$f0           																		; $ef0d: a9 f0     
			sta vInvulnCreatureY            																		; $ef0f: 85 9f     
			rts                																		; $ef11: 60        

;-------------------------------------------------------------------------------
___invulnCreatureRunaway:     
			lda vStageSelect10s          																		; $ef12: ad e1 02  
			clc                																		; $ef15: 18        
			adc vStageSelectOnes          																		; $ef16: 6d e2 02  
				bne __invulnNutRunaway         																		; $ef19: d0 20     
			; invuln birdie runaway
			lda vInvulnCreatureState            																		; $ef1b: a5 89     
			and #$80           																		; $ef1d: 29 80     
				bne __invulnBirdieRunLeft         																		; $ef1f: d0 10     
			jsr __getCycleModulo4         																		; $ef21: 20 5d d6  
				bne __setInvulnBirdieSprite         																		; $ef24: d0 02     
			; run right
			inc vInvulnCreatureX            																		; $ef26: e6 7f     
__setInvulnBirdieSprite:     
			jsr __setXEvery8Cycle         																		; $ef28: 20 8b d0  
			lda __invulnBirdieSprites,x       																		; $ef2b: bd 61 ef  
			jmp __setInvulnCreatureSprite         																		; $ef2e: 4c b8 ee  

;-------------------------------------------------------------------------------
__invulnBirdieRunLeft:     
			jsr __getCycleModulo4         																		; $ef31: 20 5d d6  
				bne __setInvulnBirdieSprite         																		; $ef34: d0 f2     
			dec vInvulnCreatureX            																		; $ef36: c6 7f     
			jmp __setInvulnBirdieSprite         																		; $ef38: 4c 28 ef  

;-------------------------------------------------------------------------------
__invulnNutRunaway:     
			lda vInvulnCreatureState            																		; $ef3b: a5 89     
			and #$80           																		; $ef3d: 29 80     
				bne __invulnNutRunLeft         																		; $ef3f: d0 10     
			jsr __getCycleModulo4         																		; $ef41: 20 5d d6  
				bne __setInvulnNutSprite         																		; $ef44: d0 02     
			inc vInvulnCreatureX            																		; $ef46: e6 7f     
__setInvulnNutSprite:     
			jsr __setXEvery8Cycle         																		; $ef48: 20 8b d0  
			lda __invulnNutSprites,x       																		; $ef4b: bd 65 ef  
			jmp __setInvulnCreatureSprite         																		; $ef4e: 4c b8 ee  

;-------------------------------------------------------------------------------
__invulnNutRunLeft:    
			jsr __getCycleModulo4         																		; $ef51: 20 5d d6  
				bne __setInvulnNutSprite         																		; $ef54: d0 f2     
			dec vInvulnCreatureX            																		; $ef56: c6 7f     
			jmp __setInvulnNutSprite         																		; $ef58: 4c 48 ef  

;-------------------------------------------------------------------------------
__invulnCreatureSpawnX:     
			.hex 30 50 10      																		; $ef5b: 30 50 10      Data
__invulnCreatureSpawnY:     
			.hex 30 30 30      																		; $ef5e: 30 30 30      Data
__invulnBirdieSprites:     
			.hex 59 5a 59 5a   																		; $ef61: 59 5a 59 5a   Data
__invulnNutSprites:     
			.hex 17 18 17 18   																		; $ef65: 17 18 17 18   Data

;-------------------------------------------------------------------------------
__handleInvulerability:     
			lda vInvulnTimer            																		; $ef69: a5 bf     
				beq __return23         																		; $ef6b: f0 40     
			cmp #$01           																		; $ef6d: c9 01     
				bne __chooseInvulnSpeed         																		; $ef6f: d0 0b   
				
			lda vDemoSequenceActive          																		; $ef71: ad 73 02  
				bne __birdInvulnNoMusicInDemo         																		; $ef74: d0 04     
			
			; play invuln music
			lda #$10           																		; $ef76: a9 10     
			sta vMusicPlayerState            																		; $ef78: 85 20     
__birdInvulnNoMusicInDemo:     
			inc vInvulnTimer            																		; $ef7a: e6 bf     
			
__chooseInvulnSpeed: 
			; both flags could be set for even faster speed
			lda vStageSelect10s          																		; $ef7c: ad e1 02  
				bne __invulnSpeedFast         																		; $ef7f: d0 2d     
			lda vStageSelectOnes          																		; $ef81: ad e2 02  
				bne __invulnSpeedSlow         																		; $ef84: d0 31     
				
			; lda vTimeFreezeTimerAbs
__invulnSetColor:     
			.hex ad a6 00      																		; $ef86: ad a6 00  Bad Addr Mode - LDA vTimeFreezeTimerAbs
				bne __changeInvulnBirdColor         																		; $ef89: d0 19     
			lda vCycleCounter            																		; $ef8b: a5 09     
			and #$08           																		; $ef8d: 29 08     
				beq __return23         																		; $ef8f: f0 1c     
				bne __birdInvulnTimer         																		; $ef91: d0 00    
				
__birdInvulnTimer:     
			jsr __changeInvulnBirdColor         																		; $ef93: 20 a4 ef  
			jsr __isOddCycle         																		; $ef96: 20 58 d6  
				bne __return23         																		; $ef99: d0 12     
			inc vInvulnTimer            																		; $ef9b: e6 bf     
			lda vInvulnTimer            																		; $ef9d: a5 bf     
			cmp #$fa           																		; $ef9f: c9 fa     
				beq __endInvelnerability         																		; $efa1: f0 22     
			rts                																		; $efa3: 60        

;-------------------------------------------------------------------------------
__changeInvulnBirdColor:     
			lda $0701          																		; $efa4: ad 01 07  
			clc                																		; $efa7: 18        
			adc #$5c           																		; $efa8: 69 5c     
			sta $0701          																		; $efaa: 8d 01 07  
__return23:     
			rts                																		; $efad: 60        

;-------------------------------------------------------------------------------
__invulnSpeedFast:     
			jsr __handleBirdFlags         																		; $efae: 20 54 cf  
			jsr __handleBirdFlight         																		; $efb1: 20 f5 cf  
			jmp __invulnSetColor         																		; $efb4: 4c 86 ef  

;-------------------------------------------------------------------------------
__invulnSpeedSlow:     
			jsr __isOddCycle         																		; $efb7: 20 58 d6  
				bne __invulnSetColor         																		; $efba: d0 ca     
			jsr __handleBirdFlags         																		; $efbc: 20 54 cf  
			jsr __handleBirdFlight         																		; $efbf: 20 f5 cf  
			jmp __invulnSetColor         																		; $efc2: 4c 86 ef  

;-------------------------------------------------------------------------------
__endInvelnerability:     
			lda #$00           																		; $efc5: a9 00     
			sta vInvulnTimer            																		; $efc7: 85 bf     
			sta vWoodpeckerDeadTimer            																		; $efc9: 85 59     
			sta vBeeIsHit            																		; $efcb: 85 66     
			sta vKiteDeadTimer            																		; $efcd: 85 6e     
			sta vKiteHit            																		; $efcf: 85 86     
			sta $87            																		; $efd1: 85 87     
			sta vWoodpeckerSquirrelIsHit            																		; $efd3: 85 88     
			sta vHawkIsHit            																		; $efd5: 85 8a     
			sta $ae            																		; $efd7: 85 ae     
			sta vFoxIsHit            																		; $efd9: 85 a8     
			sta vFoxDeadTimer            																		; $efdb: 85 a7     
			jsr __resetEnemyHitFlags         																		; $efdd: 20 f8 ef  
			sta $bc            																		; $efe0: 85 bc     
			sta vWoodpeckerSquirrelCollision            																		; $efe2: 85 be     
			sta vHawkHit            																		; $efe4: 85 c0     
			sta vHawkDeadCounter            																		; $efe6: 85 c5     
			sta vWoodpeckerSquirrelCollision            																		; $efe8: 85 be     
			jsr __resetMushroomScore         																		; $efea: 20 a5 c7  
			sta vStageSelect10s          																		; $efed: 8d e1 02  
			sta vStageSelectOnes          																		; $eff0: 8d e2 02  
			sta vMusicPlayerState            																		; $eff3: 85 20     
			inc vKiteRiseAfterDeath            																		; $eff5: e6 67     
			rts                																		; $eff7: 60        

;-------------------------------------------------------------------------------
__resetEnemyHitFlags:     
			sta vBeeHit            																		; $eff8: 85 b0     
			sta vBigBeeCollision            																		; $effa: 85 b1     
			sta $b2            																		; $effc: 85 b2     
			sta vKiteFrontCollision            																		; $effe: 85 b8     
			sta vKiteBackCollision            																		; $f000: 85 b9     
			sta vFoxCollision            																		; $f002: 85 bb     
			rts                																		; $f004: 60        

;-------------------------------------------------------------------------------
__handleHawk:     
			lda vCurrentLevel            																		; $f005: a5 55     
			; check level
			and #$0f           																		; $f007: 29 0f     
			cmp #$06           																		; $f009: c9 06     
				bcc __return3         																		; $f00b: 90 40
				
			lda vHawkDeadCounter            																		; $f00d: a5 c5     
				bne __handleDeadHawk         																		; $f00f: d0 3d     
			lda vHawkIsHit            																		; $f011: a5 8a     
				bne __handleDeadHawk         																		; $f013: d0 39     
			lda vHawkMushroomDead          																		; $f015: ad 13 02  
				bne __handleDeadHawk         																		; $f018: d0 34     
				
			jsr __hawkCheckRiseFall         																		; $f01a: 20 ac f0  
			jsr __hawkRising         																		; $f01d: 20 74 f0  
			jsr __hawkSkyMove         																		; $f020: 20 51 f0  
			
			lda vHawkState            																		; $f023: a5 c6     
			and #$c0           																		; $f025: 29 c0     
				bne __return3         																		; $f027: d0 24     
				
			lda vBirdSpritePosY          																		; $f029: ad 00 07  
			cmp vHawkY            																		; $f02c: c5 a0     
				bcc __return3         																		; $f02e: 90 1d     
				
			lda vRandomVar2            																		; $f030: a5 17     
			cmp #$05           																		; $f032: c9 05     
				bne __return3         																		; $f034: d0 17     
			; move to bird	
			lda #$00           																		; $f036: a9 00     
			sta vHawkState            																		; $f038: 85 c6     
			lda vHawkX            																		; $f03a: a5 80     
			sta vBirdX            																		; $f03c: 85 5b     
			jsr __getBirdRelativeDir         																		; $f03e: 20 fc d5  
			cmp #$01           																		; $f041: c9 01     
				beq __hawkSkyFall         																		; $f043: f0 02     
			
			inc vHawkState            																		; $f045: e6 c6     
			; fall from sky
__hawkSkyFall:     
			lda vHawkState            																		; $f047: a5 c6     
			ora #$04           																		; $f049: 09 04     
			sta vHawkState            																		; $f04b: 85 c6     
__return3:     
			rts                																		; $f04d: 60        

;-------------------------------------------------------------------------------
__handleDeadHawk:     
			jmp ___handleDeadHawk         																		; $f04e: 4c cf f0  

;-------------------------------------------------------------------------------
__hawkSkyMove:     
			lda vHawkState            																		; $f051: a5 c6     
			and #$0c           																		; $f053: 29 0c     
				bne __return57         																		; $f055: d0 11     
			lda vHawkState            																		; $f057: a5 c6     
			and #$01           																		; $f059: 29 01     
				bne __setHawkMoveRight         																		; $f05b: d0 0c     
			dec vHawkX            																		; $f05d: c6 80     
			jsr __setXEvery4Cycle         																		; $f05f: 20 93 d0  
			lda __hawkFlyAnim,x       																		; $f062: bd 05 f1  
__setHawkSprite:     
			sta $0745          																		; $f065: 8d 45 07  
__return57:     
			rts                																		; $f068: 60        

;-------------------------------------------------------------------------------
__setHawkMoveRight:     
			inc vHawkX            																		; $f069: e6 80     
			jsr __setXEvery4Cycle         																		; $f06b: 20 93 d0  
			lda __hawkFlyAnimRight,x       																		; $f06e: bd 09 f1  
			jmp __setHawkSprite         																		; $f071: 4c 65 f0  

;-------------------------------------------------------------------------------
__hawkRising:     
			lda vHawkY            																		; $f074: a5 a0     
			cmp #$20           																		; $f076: c9 20     
				beq __hawkStopRising         																		; $f078: f0 2b     
				
			lda vHawkState            																		; $f07a: a5 c6     
			and #$08           																		; $f07c: 29 08     
				bne ___hawkRising         																		; $f07e: d0 02     
				beq __return57         																		; $f080: f0 e6     
				
___hawkRising:     
			jsr __isOddCycle         																		; $f082: 20 58 d6  
				beq ___hawkRisingDontChangeY         																		; $f085: f0 02     
			dec vHawkY            																		; $f087: c6 a0     
___hawkRisingDontChangeY:     
			lda vHawkState            																		; $f089: a5 c6     
			and #$01           																		; $f08b: 29 01     
				bne ___hawkRiseRight         																		; $f08d: d0 0b     
			; rise left	
			dec vHawkX            																		; $f08f: c6 80     
			jsr __setXEvery8Cycle         																		; $f091: 20 8b d0  
			lda __hawkFlyAnim,x       																		; $f094: bd 05 f1  
			jmp __setHawkSprite         																		; $f097: 4c 65 f0  

;-------------------------------------------------------------------------------
___hawkRiseRight:     
			inc vHawkX            																		; $f09a: e6 80     
			jsr __setXEvery8Cycle         																		; $f09c: 20 8b d0  
			lda __hawkFlyAnimRight,x       																		; $f09f: bd 09 f1  
			jmp __setHawkSprite         																		; $f0a2: 4c 65 f0  

;-------------------------------------------------------------------------------
__hawkStopRising:     
			lda vHawkState            																		; $f0a5: a5 c6     
			and #$01           																		; $f0a7: 29 01     
			sta vHawkState            																		; $f0a9: 85 c6     
			rts                																		; $f0ab: 60        

;-------------------------------------------------------------------------------
__hawkCheckRiseFall:     
			lda vHawkIsHit            																		; $f0ac: a5 8a     
				bne __return56         																		; $f0ae: d0 0c     
			lda vHawkY            																		; $f0b0: a5 a0     
			cmp #$b0           																		; $f0b2: c9 b0     
				bcs __hawkStartRising         																		; $f0b4: b0 10     
			lda vHawkState            																		; $f0b6: a5 c6     
			and #$04           																		; $f0b8: 29 04     
				bne __hawkFalling         																		; $f0ba: d0 01     
__return56:     
			rts                																		; $f0bc: 60        

;-------------------------------------------------------------------------------
__hawkFalling:     
			inc vHawkY            																		; $f0bd: e6 a0     
			inc vHawkY            																		; $f0bf: e6 a0     
			lda #$96           																		; $f0c1: a9 96     
			jmp __setHawkSprite         																		; $f0c3: 4c 65 f0  

;-------------------------------------------------------------------------------
__hawkStartRising:     
			lda vHawkState            																		; $f0c6: a5 c6     
			ora #$08           																		; $f0c8: 09 08     
			and #$09           																		; $f0ca: 29 09     
			sta vHawkState            																		; $f0cc: 85 c6     
			rts                																		; $f0ce: 60        

;-------------------------------------------------------------------------------
___handleDeadHawk:     
			jsr __scoreDeadHawk         																		; $f0cf: 20 f9 f0  
			lda vHawkY            																		; $f0d2: a5 a0     
			cmp #$c8           																		; $f0d4: c9 c8     
				bcc __hawkFalling         																		; $f0d6: 90 e5     
			; set sprite
			lda #$9b           																		; $f0d8: a9 9b     
			sta $0745          																		; $f0da: 8d 45 07  
			inc vHawkDeadCounter            																		; $f0dd: e6 c5     
			lda vHawkDeadCounter            																		; $f0df: a5 c5     
			cmp #$ff           																		; $f0e1: c9 ff     
				bne __return56         																		; $f0e3: d0 d7     
			; revive hawk
			lda #$00           																		; $f0e5: a9 00     
			sta vHawkHit            																		; $f0e7: 85 c0     
			sta vHawkIsHit            																		; $f0e9: 85 8a     
			sta vHawkDeadCounter            																		; $f0eb: 85 c5     
			sta vHawkMushroomDead          																		; $f0ed: 8d 13 02  
			lda vHawkState            																		; $f0f0: a5 c6     
			ora #$08           																		; $f0f2: 09 08     
			and #$09           																		; $f0f4: 29 09     
			sta vHawkState            																		; $f0f6: 85 c6     
__return55:     
			rts                																		; $f0f8: 60        

;-------------------------------------------------------------------------------
__scoreDeadHawk:     
			lda vHawkDeadCounter            																		; $f0f9: a5 c5     
				bne __return55         																		; $f0fb: d0 fb     
			inc vHawkDeadCounter            																		; $f0fd: e6 c5     
			jsr __killedCreatureSound         																		; $f0ff: 20 45 c5  
			jmp __give300Score         																		; $f102: 4c 4f d6  

;-------------------------------------------------------------------------------
__hawkFlyAnim:     
			.hex 92 94 92 94   																		; $f105: 92 94 92 94   Data
__hawkFlyAnimRight:     
			.hex 93 95 93 95   																		; $f109: 93 95 93 95   Data

;-------------------------------------------------------------------------------
__handleFlowers:     
			jsr __levelModulo4ToX         																		; $f10d: 20 5e c3  
			cpx #$03           																		; $f110: e0 03     
				; bonus level
				beq __return39         																		; $f112: f0 32     
			jsr __spawnFlower         																		; $f114: 20 1a f1  
			jmp __handleFlowerScore         																		; $f117: 4c 5a f1  

;-------------------------------------------------------------------------------
__spawnFlower:     
			.hex ad a6 00      																		; $f11a: ad a6 00  Bad Addr Mode - LDA vTimeFreezeTimerAbs
			; lda vTimeFreezeTimerAbs
				bne __return39         																		; $f11d: d0 27     
				
			lda vMushroomRecoverTimer          																		; $f11f: ad 96 02  
				bne __increaseMushroomRecoverTimer         																		; $f122: d0 23     
			lda vBeeMushroomDead          																		; $f124: ad 10 02  
			clc                																		; $f127: 18        
			adc vKiteMushroomDead          																		; $f128: 6d 11 02  
			adc vFoxMushroomDead          																		; $f12b: 6d 12 02  
				beq __return39         																		; $f12e: f0 16     
			
			; spawn a flower
			jsr __getCycleModulo4         																		; $f130: 20 5d d6  
			tax                																		; $f133: aa        
			lda #$c8           																		; $f134: a9 c8     
			sta vFlowerY            																		; $f136: 85 a1     
			lda __moleFlowerPosX,x       																		; $f138: bd 0e d7  
			sta vFlowerX            																		; $f13b: 85 81     
			lda __flowerSprite,x       																		; $f13d: bd 56 f1  
			sta $0749          																		; $f140: 8d 49 07  
			inc vMushroomRecoverTimer          																		; $f143: ee 96 02  
__return39:     rts                																		; $f146: 60        

;-------------------------------------------------------------------------------
__increaseMushroomRecoverTimer:     
			jsr __isOddCycle         																		; $f147: 20 58 d6  
				bne __return39         																		; $f14a: d0 fa     
			inc vMushroomRecoverTimer          																		; $f14c: ee 96 02  
			lda vMushroomRecoverTimer          																		; $f14f: ad 96 02  
				beq __hideFlowerRestoreCreatures         																		; $f152: f0 20     
				bne __return39         																		; $f154: d0 f0     
__flowerSprite:     
			.hex 97 98 99 9a   																		; $f156: 97 98 99 9a   Data

;-------------------------------------------------------------------------------
__handleFlowerScore:     
			lda vFlowerHit            																		; $f15a: a5 c1     
				beq __return40         																		; $f15c: f0 32     
			lda $0749          																		; $f15e: ad 49 07  
			cmp #$98           																		; $f161: c9 98     
				beq __flowerGive200Score         																		; $f163: f0 32     
			cmp #$99           																		; $f165: c9 99     
				beq __flowerGive300Score         																		; $f167: f0 2b     
			cmp #$9a           																		; $f169: c9 9a     
				beq __flowerGive400Score         																		; $f16b: f0 24     
				
__flowerGive100Score:     
			jsr __give100Score         																		; $f16d: 20 15 ff  
			lda #$06           																		; $f170: a9 06     
			sta vSoundPlayerState            																		; $f172: 85 2a  
			
__hideFlowerRestoreCreatures:     
			lda #$f0           																		; $f174: a9 f0     
			sta vFlowerY            																		; $f176: 85 a1     
			lda #$00           																		; $f178: a9 00     
			sta vFlowerHit            																		; $f17a: 85 c1     
			sta vMushroomRecoverTimer          																		; $f17c: 8d 96 02  
			sta vBeeMushroomDead          																		; $f17f: 8d 10 02  
			sta vKiteMushroomDead          																		; $f182: 8d 11 02  
			sta vFoxMushroomDead          																		; $f185: 8d 12 02  
			sta vScoreForDeadKite          																		; $f188: 8d 5b 02  
			sta $025c          																		; $f18b: 8d 5c 02  
			inc vKiteRiseAfterDeath            																		; $f18e: e6 67     
__return40:     
			rts                																		; $f190: 60        

;-------------------------------------------------------------------------------
__flowerGive400Score:     
			jsr __give100Score         																		; $f191: 20 15 ff  
__flowerGive300Score:     
			jsr __give100Score         																		; $f194: 20 15 ff  
__flowerGive200Score:     
			jsr __give100Score         																		; $f197: 20 15 ff  
			jmp __flowerGive100Score         																		; $f19a: 4c 6d f1  

;-------------------------------------------------------------------------------
__handleSnail:     
			jsr __levelModulo4ToX         																		; $f19d: 20 5e c3  
			cpx #$03           																		; $f1a0: e0 03     
				; not bonus level
				bne ___handleSnail         																		; $f1a2: d0 01     
			rts                																		; $f1a4: 60        

;-------------------------------------------------------------------------------
___handleSnail:     
			jsr __showSnail         																		; $f1a5: 20 b1 f1  
			jsr __handleSnailMovement         																		; $f1a8: 20 db f1  
			jsr __snailCheckHit         																		; $f1ab: 20 1e f2  
			jmp __handleTimeFreeze         																		; $f1ae: 4c 2f f2  

;-------------------------------------------------------------------------------
__showSnail:     
			lda vTimeFreezeTimer            																		; $f1b1: a5 a6     
				bne __return35         																		; $f1b3: d0 1d     
			lda vMoleCollision            																		; $f1b5: a5 b7     
				beq __return35         																		; $f1b7: f0 19     
			lda vSnailTimer            																		; $f1b9: a5 a5     
				bne __return35         																		; $f1bb: d0 15     
				
			lda vRandomVar            																		; $f1bd: a5 08     
			and #$07           																		; $f1bf: 29 07     
			tax                																		; $f1c1: aa        
			lda __snailPosX,x       																		; $f1c2: bd d3 f1  
			sta vSnailX            																		; $f1c5: 85 82     
			lda #$c8           																		; $f1c7: a9 c8     
			sta vSnailY            																		; $f1c9: 85 a2     
			lda #$33           																		; $f1cb: a9 33     
			sta $074d          																		; $f1cd: 8d 4d 07  
			inc vSnailTimer            																		; $f1d0: e6 a5     
__return35:     
			rts                																		; $f1d2: 60        

;-------------------------------------------------------------------------------
__snailPosX:     
			.hex 00 30 80 a0   																		; $f1d3: 00 30 80 a0   Data
			.hex c0 d0 f0 60   																		; $f1d7: c0 d0 f0 60   Data

;-------------------------------------------------------------------------------
__handleSnailMovement:     
			lda vSnailTimer            																		; $f1db: a5 a5     
				beq __return35         																		; $f1dd: f0 f3     
			jsr __getCycleModulo4         																		; $f1df: 20 5d d6  
				bne __return35         																		; $f1e2: d0 ee     
			inc vSnailTimer            																		; $f1e4: e6 a5     
			lda vSnailTimer            																		; $f1e6: a5 a5     
			cmp #$f0           																		; $f1e8: c9 f0     
				beq __hideSnail         																		; $f1ea: f0 27     
			lda vSnailIsLeft          																		; $f1ec: ad 95 02  
			and #$01           																		; $f1ef: 29 01     
				bne __snailMoveLeft         																		; $f1f1: d0 0c 
				
			inc vSnailX            																		; $f1f3: e6 82     
			jsr __setXEvery8Cycle         																		; $f1f5: 20 8b d0  
			lda __snailLeft,x       																		; $f1f8: bd 0b f2  
			sta $074d          																		; $f1fb: 8d 4d 07  
			rts                																		; $f1fe: 60        

;-------------------------------------------------------------------------------
__snailMoveLeft:     
			dec vSnailX            																		; $f1ff: c6 82     
			jsr __setXEvery8Cycle         																		; $f201: 20 8b d0  
			lda __snailRight,x       																		; $f204: bd 0f f2  
			sta $074d          																		; $f207: 8d 4d 07  
			rts                																		; $f20a: 60        

;-------------------------------------------------------------------------------
__snailLeft:     
			.hex 9d 9e 9d 9e   																		; $f20b: 9d 9e 9d 9e   Data
__snailRight:     
			.hex 33 9c 33 9c   																		; $f20f: 33 9c 33 9c   Data

;-------------------------------------------------------------------------------
__hideSnail:     
			lda #$f0           																		; $f213: a9 f0     
			sta vSnailY            																		; $f215: 85 a2     
			lda #$00           																		; $f217: a9 00     
			sta vSnailTimer            																		; $f219: 85 a5     
			sta vSnailHit            																		; $f21b: 85 c2     
			rts                																		; $f21d: 60        

;-------------------------------------------------------------------------------
__snailCheckHit:     
			lda vSnailTimer            																		; $f21e: a5 a5     
				beq __return35         																		; $f220: f0 b0     
			lda vSnailHit            																		; $f222: a5 c2     
				beq __return35         																		; $f224: f0 ac     
			inc vTimeFreezeTimer            																		; $f226: e6 a6   
			; play time freeze music
			lda #$12           																		; $f228: a9 12     
			sta vMusicPlayerState            																		; $f22a: 85 20     
			jmp __hideSnail         																		; $f22c: 4c 13 f2  

;-------------------------------------------------------------------------------
__handleTimeFreeze:     
			lda vTimeFreezeTimer            																		; $f22f: a5 a6     
				beq __return36         																		; $f231: f0 38     
			lda vMusicPlayerState            																		; $f233: a5 20     
				bne __timeFreezeMusicIsPlaying         																		; $f235: d0 04     
				
			; play time freeze music
			lda #$12           																		; $f237: a9 12     
			sta vMusicPlayerState            																		; $f239: 85 20    
			
__timeFreezeMusicIsPlaying:     
			jsr __getCycleModulo4         																		; $f23b: 20 5d d6  
				bne __return36         																		; $f23e: d0 2b     
			inc vTimeFreezeTimer            																		; $f240: e6 a6     
			lda vTimeFreezeTimer            																		; $f242: a5 a6     
			cmp #$b0           																		; $f244: c9 b0     
				beq __timeFreezeTimeUp         																		; $f246: f0 02     
				bne __timeFreezeReset         																		; $f248: d0 10     

__timeFreezeTimeUp:     
			lda #$00           																		; $f24a: a9 00     
			sta vTimeFreezeTimer            																		; $f24c: 85 a6     
			sta vMoleCollision            																		; $f24e: 85 b7     
			sta vMoleIsDying            																		; $f250: 85 eb     
			jsr __hideMole         																		; $f252: 20 e9 d6  
			sta vMusicPlayerState            																		; $f255: 85 20     
			jsr __hideSnail         																		; $f257: 20 13 f2  
__timeFreezeReset:     
			lda #$00           																		; $f25a: a9 00     
			jsr __resetEnemyHitFlags         																		; $f25c: 20 f8 ef  
			sta vFoxDeadTimer            																		; $f25f: 85 a7     
			sta vFoxIsHit            																		; $f261: 85 a8     
			sta vSnailTimer            																		; $f263: 85 a5     
			sta vMushroomCollision            																		; $f265: 85 ba     
			sta $bd            																		; $f267: 85 bd     
			sta vHawkHit            																		; $f269: 85 c0     
__return36:     
			rts                																		; $f26b: 60        

;-------------------------------------------------------------------------------
__handleWoodpecker:     
			lda vCurrentLevel            																		; $f26c: a5 55     
			and #$03           																		; $f26e: 29 03     
			cmp #$02           																		; $f270: c9 02     
				beq __return29         																		; $f272: f0 37     
				
			lda vCurrentLevel            																		; $f274: a5 55     
			and #$0f           																		; $f276: 29 0f     
			cmp #$03           																		; $f278: c9 03     
				; bonus level
				bcc __return29         																		; $f27a: 90 2f     
				
			lda vWoodpeckerMushroomDead          																		; $f27c: ad 14 02  
				bne __handleDeadWoodpecker         																		; $f27f: d0 11     
			lda vWoodpeckerSquirrelIsHit            																		; $f281: a5 88     
				bne __handleDeadWoodpecker         																		; $f283: d0 0d     
			lda vWoodpeckerDeadTimer            																		; $f285: a5 59     
				bne __handleDeadWoodpecker         																		; $f287: d0 09     
				
			jsr __woodpeckerControlAltitude         																		; $f289: 20 ef f2  
			jsr __handleWoodpeckerOnTree         																		; $f28c: 20 c1 f2  
			jmp __woodpeckerCheckFlyAway         																		; $f28f: 4c 5c f3  

;-------------------------------------------------------------------------------
__handleDeadWoodpecker:     
			lda vWoodpeckerSquirrelY            																		; $f292: a5 9e     
			cmp #$c8           																		; $f294: c9 c8     
				beq __deadWoodpeckerLying         																		; $f296: f0 06     
			inc vWoodpeckerSquirrelY            																		; $f298: e6 9e     
			lda vWoodpeckerDeadTimer            																		; $f29a: a5 59     
				beq __scoreDeadWoodpecker         																		; $f29c: f0 0e     
				
__deadWoodpeckerLying:     
			inc vWoodpeckerDeadTimer            																		; $f29e: e6 59     
			lda vWoodpeckerDeadTimer            																		; $f2a0: a5 59     
			cmp #$ff           																		; $f2a2: c9 ff     
				beq __reviveWoodpecker         																		; $f2a4: f0 0f     
			lda #$2e           																		; $f2a6: a9 2e     
__setWoodpeckerSprite:     
			sta vWoodPeckerSprite          																		; $f2a8: 8d 3d 07  
__return29:     
			rts                																		; $f2ab: 60        

;-------------------------------------------------------------------------------
__scoreDeadWoodpecker:     
			jsr __give200Score         																		; $f2ac: 20 52 d6  
			jsr __killedCreatureSound         																		; $f2af: 20 45 c5  
			jmp __deadWoodpeckerLying         																		; $f2b2: 4c 9e f2  

;-------------------------------------------------------------------------------
__reviveWoodpecker:     
			lda #$00           																		; $f2b5: a9 00     
			sta vWoodpeckerSquirrelCollision            																		; $f2b7: 85 be     
			sta vWoodpeckerSquirrelIsHit            																		; $f2b9: 85 88     
			sta vWoodpeckerMushroomDead          																		; $f2bb: 8d 14 02  
			sta vWoodpeckerDeadTimer            																		; $f2be: 85 59     
			rts                																		; $f2c0: 60        

;-------------------------------------------------------------------------------
__handleWoodpeckerOnTree:     
			lda vWoodpeckerState            																		; $f2c1: a5 58     
			and #$02           																		; $f2c3: 29 02     
				bne __handleWoodpeckerFlight         																		; $f2c5: d0 40     
				
			lda vCycleCounter            																		; $f2c7: a5 09     
			and #$40           																		; $f2c9: 29 40     
				bne __woodpeckerChangeTreeSprite         																		; $f2cb: d0 18     
			lda vWoodpeckerState            																		; $f2cd: a5 58     
			and #$01           																		; $f2cf: 29 01     
				bne ___setWoodpeckerTreeMirrorSprite         																		; $f2d1: d0 09     
__setWoodpeckerTreeAnim:     
			jsr __setXEvery4Cycle         																		; $f2d3: 20 93 d0  
__setWoodpeckerTreeSprite:     
			lda __woodpeckerTreeSprite,x       																		; $f2d6: bd 8b f3  
			jmp __setWoodpeckerSprite         																		; $f2d9: 4c a8 f2  

;-------------------------------------------------------------------------------
___setWoodpeckerTreeMirrorSprite:     
			jsr __setXEvery4Cycle         																		; $f2dc: 20 93 d0  
__setWoodpeckerTreeMirrorSprite:     
			lda __woodpeckerTreeMirrorSprite,x       																		; $f2df: bd 8f f3  
			jmp __setWoodpeckerSprite         																		; $f2e2: 4c a8 f2  

;-------------------------------------------------------------------------------
__woodpeckerChangeTreeSprite:     
			ldx #$00           																		; $f2e5: a2 00     
			lda vWoodpeckerState            																		; $f2e7: a5 58     
			and #$01           																		; $f2e9: 29 01     
				beq __setWoodpeckerTreeSprite         																		; $f2eb: f0 e9     
				bne __setWoodpeckerTreeMirrorSprite         																		; $f2ed: d0 f0     
				
__woodpeckerControlAltitude:     
			lda vWoodpeckerSquirrelY            																		; $f2ef: a5 9e     
			cmp #$a0           																		; $f2f1: c9 a0     
				bcc __woodpeckerSetFlags         																		; $f2f3: 90 0b     
				beq __woodpeckerSetFlags         																		; $f2f5: f0 09     
			; rise from dead
			lda vCycleCounter            																		; $f2f7: a5 09     
			and #$01           																		; $f2f9: 29 01     
				bne __return60         																		; $f2fb: d0 02     
			dec vWoodpeckerSquirrelY            																		; $f2fd: c6 9e     
__return60:     
			rts                																		; $f2ff: 60        

;-------------------------------------------------------------------------------
__woodpeckerSetFlags:     
			lda vWoodpeckerState            																		; $f300: a5 58     
			and #$03           																		; $f302: 29 03     
			sta vWoodpeckerState            																		; $f304: 85 58     
			rts                																		; $f306: 60        

;-------------------------------------------------------------------------------
__handleWoodpeckerFlight:     
			jsr __woodpeckerChaseBird         																		; $f307: 20 68 f3  
			lda vWoodpeckerState            																		; $f30a: a5 58     
			and #$01           																		; $f30c: 29 01     
				bne __woodpeckerFlyLeft         																		; $f30e: d0 26     
			inc vWoodpeckerSquirrelX            																		; $f310: e6 7e     
			
			lda vCurrentLevel            																		; $f312: a5 55     
			and #$03           																		; $f314: 29 03     
			cmp #$01           																		; $f316: c9 01     
				beq __woodpeckerCheckRightFlight         																		; $f318: f0 0d     
			lda vWoodpeckerSquirrelX            																		; $f31a: a5 7e     
			cmp #$31           																		; $f31c: c9 31     
				bne __setWoodpeckerFlyRightSprite         																		; $f31e: d0 0d     
__setWoodpeckerLeftTreeMode:     
			lda #$01           																		; $f320: a9 01     
			sta vWoodpeckerState            																		; $f322: 85 58     
			jmp ___setWoodpeckerTreeMirrorSprite         																		; $f324: 4c dc f2  

;-------------------------------------------------------------------------------
__woodpeckerCheckRightFlight:     
			lda vWoodpeckerSquirrelX            																		; $f327: a5 7e     
			cmp #$51           																		; $f329: c9 51     
				beq __setWoodpeckerLeftTreeMode         																		; $f32b: f0 f3     
__setWoodpeckerFlyRightSprite:     
			jsr __setXEvery8Cycle         																		; $f32d: 20 8b d0  
			lda __woodpeckerFlyRightSprite,x       																		; $f330: bd 97 f3  
			jmp __setWoodpeckerSprite         																		; $f333: 4c a8 f2  

;-------------------------------------------------------------------------------
__woodpeckerFlyLeft:     
			dec vWoodpeckerSquirrelX            																		; $f336: c6 7e     
			lda vCurrentLevel            																		; $f338: a5 55     
			and #$03           																		; $f33a: 29 03     
			cmp #$01           																		; $f33c: c9 01     
				beq __woodpeckerCheckLeftFlight         																		; $f33e: f0 0d     
			lda vWoodpeckerSquirrelX            																		; $f340: a5 7e     
			cmp #$3d           																		; $f342: c9 3d     
				bne __setWoodpeckerFlyLeftSprite         																		; $f344: d0 0d     
__setWoodpeckerTreeOnLeft:    
			lda #$00           																		; $f346: a9 00     
			sta vWoodpeckerState            																		; $f348: 85 58     
			jmp __setWoodpeckerTreeAnim         																		; $f34a: 4c d3 f2  

;-------------------------------------------------------------------------------
__woodpeckerCheckLeftFlight:     
			lda vWoodpeckerSquirrelX            																		; $f34d: a5 7e     
			cmp #$5d           																		; $f34f: c9 5d     
				beq __setWoodpeckerTreeOnLeft         																		; $f351: f0 f3     
__setWoodpeckerFlyLeftSprite:     
			jsr __setXEvery8Cycle         																		; $f353: 20 8b d0  
			lda __woodpeckerFlyLeftSprite,x       																		; $f356: bd 93 f3  
			jmp __setWoodpeckerSprite         																		; $f359: 4c a8 f2  

;-------------------------------------------------------------------------------
__woodpeckerCheckFlyAway:     
			lda vRandomVar2            																		; $f35c: a5 17     
				bne __return58         																		; $f35e: d0 23     
			lda vCycleCounter            																		; $f360: a5 09     
			cmp #$80           																		; $f362: c9 80     
				bcc __setWoodpeckerFlyAway         																		; $f364: 90 1e     
				bcs __return58         																		; $f366: b0 1b     
__woodpeckerChaseBird:     
			jsr __getCycleModulo4         																		; $f368: 20 5d d6  
				bne __return58         																		; $f36b: d0 16     
			lda vWoodpeckerSquirrelY            																		; $f36d: a5 9e     
			cmp vBirdSpritePosY          																		; $f36f: cd 00 07  
				bcc __woodpeckerMoveDown         																		; $f372: 90 07     
			cmp #$48           																		; $f374: c9 48     
				beq __return58         																		; $f376: f0 0b     
			; move up
			dec vWoodpeckerSquirrelY            																		; $f378: c6 9e     
			rts                																		; $f37a: 60        

;-------------------------------------------------------------------------------
__woodpeckerMoveDown:     
			lda vWoodpeckerSquirrelY            																		; $f37b: a5 9e     
			cmp #$a0           																		; $f37d: c9 a0     
				beq __return58         																		; $f37f: f0 02     
			inc vWoodpeckerSquirrelY            																		; $f381: e6 9e     
__return58:     
			rts                																		; $f383: 60        

;-------------------------------------------------------------------------------
__setWoodpeckerFlyAway:     
			lda vWoodpeckerState            																		; $f384: a5 58     
			ora #$02           																		; $f386: 09 02     
			sta vWoodpeckerState            																		; $f388: 85 58     
			rts                																		; $f38a: 60        

;-------------------------------------------------------------------------------
__woodpeckerTreeSprite:     
			.hex 26 28 26 28   																		; $f38b: 26 28 26 28   Data
__woodpeckerTreeMirrorSprite:     
			.hex 27 29 27 29   																		; $f38f: 27 29 27 29   Data
__woodpeckerFlyLeftSprite:     
			.hex 2a 2c 2a 2c   																		; $f393: 2a 2c 2a 2c   Data
__woodpeckerFlyRightSprite:     
			.hex 2b 2d 2b 2d   																		; $f397: 2b 2d 2b 2d   Data

;-------------------------------------------------------------------------------
__handleBigBee:     
			; big bee only on 22-24 and 24-36 levels
			lda vCurrentLevel            																		; $f39b: a5 55     
			cmp #$10           																		; $f39d: c9 10     
				bcc __return34         																		; $f39f: 90 3b     
			lda vCurrentLevel            																		; $f3a1: a5 55     
			and #$0f           																		; $f3a3: 29 0f     
			cmp #$0b           																		; $f3a5: c9 0b     
				bcc __return34         																		; $f3a7: 90 33     
				
			lda vBigBeeIsDead          																		; $f3a9: ad 94 02  
			clc                																		; $f3ac: 18        
			adc vBigBeeDead          																		; $f3ad: 6d 15 02  
				beq __handleAliveBigBee         																		; $f3b0: f0 03     
			jmp __handleDeadBigBee         																		; $f3b2: 4c 1d f4  

;-------------------------------------------------------------------------------
__handleAliveBigBee:     
			jsr __handleBigBeeFlight         																		; $f3b5: 20 be f3  
			jsr __bigBeeBirdRelativeMovement         																		; $f3b8: 20 dd f3  
			jmp __handleBigBeeFrameCounter         																		; $f3bb: 4c 11 f4  

;-------------------------------------------------------------------------------
__handleBigBeeFlight:     
			lda vBigBeeFrameCounter          																		; $f3be: ad 92 02  
			and #$01           																		; $f3c1: 29 01     
				bne __return34         																		; $f3c3: d0 17     
			lda vCycleCounter            																		; $f3c5: a5 09     
			lsr                																		; $f3c7: 4a        
			and #$0f           																		; $f3c8: 29 0f     
			tax                																		; $f3ca: aa        
			lda __bigBeeMovementPattern,x       																		; $f3cb: bd 57 f4  
			ldx #$fe           																		; $f3ce: a2 fe     
			jsr __actorMove         																		; $f3d0: 20 15 d9  
__setBigBeeFrame:     
			jsr __setXEvery4Cycle         																		; $f3d3: 20 93 d0  
			lda __bigBeeSprite,x       																		; $f3d6: bd 53 f4  
__setBigBeeSprite:     
			sta $0709          																		; $f3d9: 8d 09 07  
__return34:     
			rts                																		; $f3dc: 60        

;-------------------------------------------------------------------------------
__bigBeeBirdRelativeMovement:     
			lda vBigBeeFrameCounter          																		; $f3dd: ad 92 02  
			and #$01           																		; $f3e0: 29 01     
				beq __return34         																		; $f3e2: f0 f8     
			inc vBigBeeTimer          																		; $f3e4: ee 93 02  
			lda vBigBeeTimer          																		; $f3e7: ad 93 02  
			and #$07           																		; $f3ea: 29 07     
				beq __increaseBigBeeCounter         																		; $f3ec: f0 2b     
			lda vBirdSpritePosY          																		; $f3ee: ad 00 07  
			cmp vBigBeeY            																		; $f3f1: c5 91     
				bcc __bigBeeFlyDown         																		; $f3f3: 90 12     
			inc vBigBeeY            																		; $f3f5: e6 91     
__bigBeeHorizontalMovement:     
			lda vBigBeeX            																		; $f3f7: a5 71     
			sta vBirdX            																		; $f3f9: 85 5b     
			jsr __getBirdRelativeDir         																		; $f3fb: 20 fc d5  
			cmp #$01           																		; $f3fe: c9 01     
				beq __bigBeeFlyLeft         																		; $f400: f0 0a     
			; fly right
			inc vBigBeeX            																		; $f402: e6 71     
			jmp __setBigBeeFrame         																		; $f404: 4c d3 f3  

;-------------------------------------------------------------------------------
__bigBeeFlyDown:     
			dec vBigBeeY            																		; $f407: c6 91     
			jmp __bigBeeHorizontalMovement         																		; $f409: 4c f7 f3  

;-------------------------------------------------------------------------------
__bigBeeFlyLeft:     
			dec vBigBeeX            																		; $f40c: c6 71     
			jmp __setBigBeeFrame         																		; $f40e: 4c d3 f3  

;-------------------------------------------------------------------------------
__handleBigBeeFrameCounter:     
			lda vCycleCounter            																		; $f411: a5 09     
			and #$3f           																		; $f413: 29 3f     
				beq __increaseBigBeeCounter         																		; $f415: f0 02     
				bne __return52         																		; $f417: d0 03     
__increaseBigBeeCounter:     
			inc vBigBeeFrameCounter          																		; $f419: ee 92 02  
__return52:     
			rts                																		; $f41c: 60        

;-------------------------------------------------------------------------------
__handleDeadBigBee:     
			lda vDeadBigBeeCounter          																		; $f41d: ad 95 02  
				beq __scoreForBigBee         																		; $f420: f0 0d     
			lda vBigBeeY            																		; $f422: a5 91     
			cmp #$c8           																		; $f424: c9 c8     
				beq __deadBigBeeCounter         																		; $f426: f0 11     
			; dead big bee falling
			inc vBigBeeY            																		; $f428: e6 91     
			lda #$32           																		; $f42a: a9 32     
			jmp __setBigBeeSprite         																		; $f42c: 4c d9 f3  

;-------------------------------------------------------------------------------
__scoreForBigBee:     
			jsr __give200Score         																		; $f42f: 20 52 d6  
			jsr __killedCreatureSound         																		; $f432: 20 45 c5  
			inc vDeadBigBeeCounter          																		; $f435: ee 95 02  
__return53:     
			rts                																		; $f438: 60        

;-------------------------------------------------------------------------------
__deadBigBeeCounter:     
			inc vDeadBigBeeCounter          																		; $f439: ee 95 02  
			lda vDeadBigBeeCounter          																		; $f43c: ad 95 02  
			cmp #$ff           																		; $f43f: c9 ff     
				beq __reviveBigBee         																		; $f441: f0 02     
				bne __return53         																		; $f443: d0 f3     
__reviveBigBee:     
			lda #$00           																		; $f445: a9 00     
			sta vBigBeeIsDead          																		; $f447: 8d 94 02  
			sta vDeadBigBeeCounter          																		; $f44a: 8d 95 02  
			sta vBigBeeDead          																		; $f44d: 8d 15 02  
			sta vBigBeeCollision            																		; $f450: 85 b1     
			rts                																		; $f452: 60        

;-------------------------------------------------------------------------------
__bigBeeSprite:     
			.hex 30 31 30 31   																		; $f453: 30 31 30 31   Data
__bigBeeMovementPattern:     
			.hex 02 02 0a 0a   																		; $f457: 02 02 0a 0a   Data
			.hex 02 02 06 05   																		; $f45b: 02 02 06 05   Data
			.hex 01 01 09 09   																		; $f45f: 01 01 09 09   Data
			.hex 01 01 05 06   																		; $f463: 01 01 05 06   Data

;-------------------------------------------------------------------------------
___handleGameOver:    	
			lda vDemoSequenceActive          																		; $f467: ad 73 02  
				bne ___endDemoSequence         																		; $f46a: d0 32     
			
			lda vNestlingIsDead            																		; $f46c: a5 e9     
				bne __handleDeadNestling         																		; $f46e: d0 42     
			lda vBirdLives            																		; $f470: a5 56     
				bne __checkDeadNestling         																		; $f472: d0 27     
				
__drawGameOverLabel:     
			jsr __clearBirdNametable         																		; $f474: 20 a2 c6  
			sta vNestlingIsDead            																		; $f477: 85 e9     
			tax                																		; $f479: aa        
			lda #$21           																		; $f47a: a9 21     
			sta ppuAddress          																		; $f47c: 8d 06 20  
			lda #$2c           																		; $f47f: a9 2c     
			sta ppuAddress          																		; $f481: 8d 06 20  
__drawGameOverLabelLoop:     
			lda __gameOverLabel,x       																		; $f484: bd a9 f4  
			sta ppuData          																		; $f487: 8d 07 20  
			inx                																		; $f48a: e8        
			cpx #$09           																		; $f48b: e0 09     
				bne __drawGameOverLabelLoop         																		; $f48d: d0 f5     
			
			jsr __showNestlingCountLabel         																		; $f48f: 20 df c1  
			jsr __setSprite0         																		; $f492: 20 18 f6  
			jsr __statusBarSprite0Timing         																		; $f495: 20 e8 f5  
			jmp __resetGameVars         																		; $f498: 4c 46 f5  

;-------------------------------------------------------------------------------
__checkDeadNestling:     
			jmp ___checkDeadNestling         																		; $f49b: 4c f9 f4  

;-------------------------------------------------------------------------------
___endDemoSequence:     
			jsr __restartGame         																		; $f49e: 20 bb f5  
			jsr __resetNestlingCount         																		; $f4a1: 20 49 f5  
			lda #$00           																		; $f4a4: a9 00     
			sta vGameState            																		; $f4a6: 85 50     
			rts                																		; $f4a8: 60        

;-------------------------------------------------------------------------------
__gameOverLabel:     
			.hex 10 0a 16 0e   																		; $f4a9: 10 0a 16 0e   Data
			.hex 24 18 1a 0e   																		; $f4ad: 24 18 1a 0e   Data
			.hex 1b            																		; $f4b1: 1b            Data

;-------------------------------------------------------------------------------
; when those nasty chicks die
__handleDeadNestling:     
			jsr __setXEvery8Cycle         																		; $f4b2: 20 8b d0  
			lda __deadNestlingAnimFrames,x       																		; $f4b5: bd 42 f5  
			sta $0739          																		; $f4b8: 8d 39 07  
			jsr __isOddCycle         																		; $f4bb: 20 58 d6  
				; rise every 2 frames
				bne __deadNestlingDontChangeY         																		; $f4be: d0 02     
			dec vRisingNestlingY            																		; $f4c0: c6 9d     
__deadNestlingDontChangeY:     
			lda vRisingNestlingY            																		; $f4c2: a5 9d     
			cmp #$1a           																		; $f4c4: c9 1a     
				; nestling in heaven 
				beq __hideDeadNestling         																		; $f4c6: f0 11     
			jsr __pauseSpriteTiming         																		; $f4c8: 20 9f c2  
			jsr __drawGameActors         																		; $f4cb: 20 8a d4  
			lda vMusicPlayerState            																		; $f4ce: a5 20     
				bne __deadNestlingFrozenLoop         																		; $f4d0: d0 04     
			
			; dead nestling music
			lda #$0a           																		; $f4d2: a9 0a     
			sta vMusicPlayerState            																		; $f4d4: 85 20     
__deadNestlingFrozenLoop:     
			jmp __frozenGameLoop         																		; $f4d6: 4c 22 c1  

;-------------------------------------------------------------------------------
__hideDeadNestling:     
			lda #$f0           																		; $f4d9: a9 f0     
			sta vRisingNestlingY            																		; $f4db: 85 9d     
			lda vBirdLives            																		; $f4dd: a5 56     
			cmp #$01           																		; $f4df: c9 01     
				bne __decreaseLivesDeadNestling         																		; $f4e1: d0 03     
			jmp __drawGameOverLabel         																		; $f4e3: 4c 74 f4  

;-------------------------------------------------------------------------------
__decreaseLivesDeadNestling:     
			jsr __pauseSpriteTiming         																		; $f4e6: 20 9f c2  
			jsr __drawGameActors         																		; $f4e9: 20 8a d4  
			dec vBirdLives            																		; $f4ec: c6 56     
			; continue game
			lda #$03           																		; $f4ee: a9 03     
			sta vGameState            																		; $f4f0: 85 50     
			lda #$00           																		; $f4f2: a9 00     
			sta vNestlingIsDead            																		; $f4f4: 85 e9     
			sta vMusicPlayerState            																		; $f4f6: 85 20     
			rts                																		; $f4f8: 60        

;-------------------------------------------------------------------------------
___checkDeadNestling:     
			jsr __setSprite0         																		; $f4f9: 20 18 f6  
			jsr __statusBarSprite0Timing         																		; $f4fc: 20 e8 f5  
			lda vCurrentLevel            																		; $f4ff: a5 55     
			and #$03           																		; $f501: 29 03     
			tay                																		; $f503: a8        
			lda __nestlingPosY,y       																		; $f504: b9 79 c8  
			sta vRisingNestlingY            																		; $f507: 85 9d     
			lda vNestling1Timer          																		; $f509: ad 05 02  
			cmp #$ff           																		; $f50c: c9 ff     
				bne ___checkDeadNestling2         																		; $f50e: d0 06     
			lda __nestling1PosX,y       																		; $f510: b9 7d c8  
			jmp __nestlingDies         																		; $f513: 4c 26 f5  

;-------------------------------------------------------------------------------
___checkDeadNestling2:     
			lda vNestling2Timer          																		; $f516: ad 06 02  
			cmp #$ff           																		; $f519: c9 ff     
				bne __nestling3Dies         																		; $f51b: d0 06     
			lda __nestling2PosX,y       																		; $f51d: b9 81 c8  
			jmp __nestlingDies         																		; $f520: 4c 26 f5  

;-------------------------------------------------------------------------------
__nestling3Dies:     
			lda __nestling3PosX,y       																		; $f523: b9 85 c8  
__nestlingDies:     
			sta vRisingNestlingX            																		; $f526: 85 7d     
			jsr __drawGameActors         																		; $f528: 20 8a d4  
			lda vBirdLives            																		; $f52b: a5 56     
			cmp #$01           																		; $f52d: c9 01     
				beq __killNestling         																		; $f52f: f0 08     
			lda #$00           																		; $f531: a9 00     
			sta vNestlingStates,y        																		; $f533: 99 8c 00  
			sta vNestling1Timer,y        																		; $f536: 99 05 02  
__killNestling:     
			inc vNestlingIsDead            																		; $f539: e6 e9     
			; dead nestling music
			lda #$0a           																		; $f53b: a9 0a     
			sta vMusicPlayerState            																		; $f53d: 85 20     
			jmp __handleMusicAndSound         																		; $f53f: 4c dd f6  

;-------------------------------------------------------------------------------
__deadNestlingAnimFrames:     
			.hex 74 75 74 75   																		; $f542: 74 75 74 75   Data

;-------------------------------------------------------------------------------
__resetGameVars:     
			jsr __updateHiScore         																		; $f546: 20 70 f5  
__resetNestlingCount:     
			lda #$00           																		; $f549: a9 00     
			sta vNestlingOnes            																		; $f54b: 85 10     
			sta vNestling10s            																		; $f54d: 85 11     
			sta vNestling100s            																		; $f54f: 85 12     
			sta vIsStudyMode          																		; $f551: 8d e0 02  
			sta vStageSelect10s          																		; $f554: 8d e1 02  
			sta vStageSelectOnes          																		; $f557: 8d e2 02  
			tax                																		; $f55a: aa        
__resetGameVariables:     
			sta vDataAddress,x          																		; $f55b: 95 53     
			sta vButterflyFrames,x        																		; $f55d: 9d 00 02  
			inx                																		; $f560: e8        
			cpx #$ad           																		; $f561: e0 ad     
				bne __resetGameVariables         																		; $f563: d0 f6     
			
			inc vGameState            																		; $f565: e6 50     
			jsr __hideSpritesInTable         																		; $f567: 20 94 fe  
			jsr __showNestlingCountSprite         																		; $f56a: 20 94 ce  
			jmp __frozenGameLoop         																		; $f56d: 4c 22 c1  

;-------------------------------------------------------------------------------
__updateHiScore:     
			lda vIsStudyMode          																		; $f570: ad e0 02  
				bne __return25         																		; $f573: d0 20   
				
			ldx #$08           																		; $f575: a2 08     
__updateHiScoreNextNumber:     
			lda vHiPlayerScore,x        																		; $f577: bd 10 01  
			cmp vPlayerScore,x        																		; $f57a: dd 00 01  
				bne __updateHiScoreCompare         																		; $f57d: d0 05     
			dex                																		; $f57f: ca        
				beq __return25         																		; $f580: f0 13     
				bne __updateHiScoreNextNumber         																		; $f582: d0 f3     
__updateHiScoreCompare:     
			lda vHiPlayerScore,x        																		; $f584: bd 10 01  
			cmp vPlayerScore,x        																		; $f587: dd 00 01  
				bcs __return25         																		; $f58a: b0 09     
__updateHiScoreNumberLoop:     
			lda vPlayerScore,x        																		; $f58c: bd 00 01  
			sta vHiPlayerScore,x        																		; $f58f: 9d 10 01  
			dex                																		; $f592: ca        
				bne __updateHiScoreNumberLoop         																		; $f593: d0 f7     
__return25:     
			rts                																		; $f595: 60        

;-------------------------------------------------------------------------------
__resetPlayerScore:     
			ldx #$00           																		; $f596: a2 00     
			txa                																		; $f598: 8a        
__resetPlayerScoreLoop:     
			sta vPlayerScore,x        																		; $f599: 9d 00 01  
			inx                																		; $f59c: e8        
			cpx #$08           																		; $f59d: e0 08     
			bne __resetPlayerScoreLoop         																		; $f59f: d0 f8     
			rts                																		; $f5a1: 60        

;-------------------------------------------------------------------------------
___handleRealGameOver:     
			lda vDataAddress            																		; $f5a2: a5 53     
				beq __playGameOverMusic         																		; $f5a4: f0 0c     
			lda vPlayerInput            																		; $f5a6: a5 0a     
			and #$0c           																		; $f5a8: 29 0c     
				bne __restartGame         																		; $f5aa: d0 0f     
			lda vMusicPlayerState            																		; $f5ac: a5 20     
				bne __postGameOverLoop         																		; $f5ae: d0 08     
				beq __restartGame         																		; $f5b0: f0 09     
__playGameOverMusic:     
			lda #$0b           																		; $f5b2: a9 0b     
			sta vMusicPlayerState            																		; $f5b4: 85 20     
			inc vDataAddress            																		; $f5b6: e6 53     
__postGameOverLoop:     
			jmp __frozenGameLoop         																		; $f5b8: 4c 22 c1  

;-------------------------------------------------------------------------------
__restartGame:     
			jsr __disableDrawing         																		; $f5bb: 20 ee fe  
			lda #$00           																		; $f5be: a9 00     
			sta vGameState            																		; $f5c0: 85 50     
			sta vMusicPlayerState            																		; $f5c2: 85 20     
			tax                																		; $f5c4: aa        
			
___loadMainMenuPaletteLoop:     
			lda __mainMenuPalette,x       																		; $f5c5: bd 00 c0  
			sta vPaletteData,x          																		; $f5c8: 95 30     
			inx                																		; $f5ca: e8        
			cpx #$20           																		; $f5cb: e0 20     
			bne ___loadMainMenuPaletteLoop         																		; $f5cd: d0 f6     
			
			jsr __uploadPalettesToPPU         																		; $f5cf: 20 64 fe  
			lda #$20           																		; $f5d2: a9 20     
			jsr __clearNametable         																		; $f5d4: 20 f5 fd  
			jsr __scrollScreen         																		; $f5d7: 20 b6 fd  
			jsr __hideSpritesInOAM         																		; $f5da: 20 5a e2  
			jsr __showSprites         																		; $f5dd: 20 e0 fd  
			lda #$f0           																		; $f5e0: a9 f0     
			sta vNestlingCountSprite          																		; $f5e2: 8d 60 07  
			jmp __frozenGameLoop         																		; $f5e5: 4c 22 c1  

;-------------------------------------------------------------------------------
__statusBarSprite0Timing:     
			lda vCurrentLevel            																		; $f5e8: a5 55     
			and #$03           																		; $f5ea: 29 03     
			cmp #$03           																		; $f5ec: c9 03    
				; since bonus levels don't have a status bar, no need to time it
				beq __hideSprite0         																		; $f5ee: f0 20     
				
			lda vPPUController            																		; $f5f0: a5 06     
			and #$fc           																		; $f5f2: 29 fc     
			sta ppuControl          																		; $f5f4: 8d 00 20  
			stx ppuScroll          																		; $f5f7: 8e 05 20  
			stx ppuScroll          																		; $f5fa: 8e 05 20  
__slightDelay2:     
			nop                																		; $f5fd: ea        
			dex                																		; $f5fe: ca        
				bne __slightDelay2         																		; $f5ff: d0 fc     
__waitForSprite0Hit:     
			lda ppuStatus          																		; $f601: ad 02 20  
			and #$40           																		; $f604: 29 40     
				beq __waitForSprite0Hit         																		; $f606: f0 f9 
				
__slightDelay3:     
			dex                																		; $f608: ca        
			cpx #$91           																		; $f609: e0 91     
				bne __slightDelay3         																		; $f60b: d0 fb     
			jmp __scrollScreen         																		; $f60d: 4c b6 fd  

;-------------------------------------------------------------------------------
__hideSprite0:     
			lda #$f0           																		; $f610: a9 f0     
			sta vOAMTable          																		; $f612: 8d 00 06  
			jmp __scrollScreen         																		; $f615: 4c b6 fd  

;-------------------------------------------------------------------------------
__setSprite0:     
			lda #$fc           																		; $f618: a9 fc     
			sta $0601          																		; $f61a: 8d 01 06  
			lda #$68           																		; $f61d: a9 68     
			sta $0603          																		; $f61f: 8d 03 06  
			lda #$17           																		; $f622: a9 17     
			sta vOAMTable          																		; $f624: 8d 00 06  
			lda #$20           																		; $f627: a9 20     
			sta $0602          																		; $f629: 8d 02 06  
			rts                																		; $f62c: 60        

;-------------------------------------------------------------------------------
; on levels>12, show nestling place on tree 
__show3rdNestlingPlace:     
			jsr __levelModulo4ToX         																		; $f62d: 20 5e c3  
			cpx #$03           																		; $f630: e0 03     
				; bonus level
				beq __return20         																		; $f632: f0 1a     
			lda vCurrentLevel            																		; $f634: a5 55     
			cmp #$10           																		; $f636: c9 10     
				bcc __return20         																		; $f638: 90 14 
				
			and #$03           																		; $f63a: 29 03     
			tax                																		; $f63c: aa        
			
			lda #$23           																		; $f63d: a9 23     
			sta ppuAddress          																		; $f63f: 8d 06 20  
			lda __3rdNestlingPlaceTilePos,x       																		; $f642: bd 29 c2  
			sta ppuAddress          																		; $f645: 8d 06 20  
			
			lda __3rdNestlingPlaceTile,x       																		; $f648: bd 4f f6  
			sta ppuData          																		; $f64b: 8d 07 20  
__return20:     
			rts                																		; $f64e: 60        

;-------------------------------------------------------------------------------
__3rdNestlingPlaceTile:     
			.hex 8a a8 a8      																		; $f64f: 8a a8 a8      Data
___initAPUshowGraphics:     
			lda #$1e           																		; $f652: a9 1e     
			sta vPPUMask            																		; $f654: 85 07     
			jmp __initSound         																		; $f656: 4c 3a f8  

;-------------------------------------------------------------------------------
__handleSecretCreatures:     
			lda vCurrentLevel            																		; $f659: a5 55     
			cmp #$0e           																		; $f65b: c9 0e     
				beq __handleCaterpillar         																		; $f65d: f0 38     
			cmp #$0b           																		; $f65f: c9 0b     
				bne __return16         																		; $f661: d0 1d     
			lda vBonusItemsCaught            																		; $f663: a5 8b     
			cmp #$01           																		; $f665: c9 01     
				bne __hideSecrenCreature         																		; $f667: d0 29     
			lda vWhaleCounter          																		; $f669: ad 52 02  
			cmp #$03           																		; $f66c: c9 03     
				bcs __showAndMoveWhale         																		; $f66e: b0 11     
				
			; this is what you need to do to show the whale on level 9
			lda #$3c           																		; $f670: a9 3c     
			sta vBirdOffsetX            																		; $f672: 85 5c     
			jsr __updateBirdX         																		; $f674: 20 86 d1  
			lda vBirdOffsetX            																		; $f677: a5 5c     
			cmp #$98           																		; $f679: c9 98     
				bne __return16         																		; $f67b: d0 03     
			inc vWhaleCounter          																		; $f67d: ee 52 02  
__return16:     
			rts                																		; $f680: 60        

;-------------------------------------------------------------------------------
__showAndMoveWhale:     
			lda #$35           																		; $f681: a9 35     
			sta $0741          																		; $f683: 8d 41 07  
			lda #$c0           																		; $f686: a9 c0     
			sta vInvulnCreatureY            																		; $f688: 85 9f     
			jsr __getCycleModulo4         																		; $f68a: 20 5d d6  
				bne __return16         																		; $f68d: d0 f1     
			dec vInvulnCreatureX            																		; $f68f: c6 7f     
			rts                																		; $f691: 60        

;-------------------------------------------------------------------------------
__hideSecrenCreature:     
			lda #$f0           																		; $f692: a9 f0     
			sta vInvulnCreatureY            																		; $f694: 85 9f     
			rts                																		; $f696: 60        

;-------------------------------------------------------------------------------
__handleCaterpillar:     
			lda vCaterpillarTaken          																		; $f697: ad 53 02  
				bne __return12         																		; $f69a: d0 30     
			lda vCaterpillarSpawned          																		; $f69c: ad 54 02  
				bne __spawnCaterpillar         																		; $f69f: d0 0d     
			lda vKiteMushroomDead          																		; $f6a1: ad 11 02  
				beq __return12         																		; $f6a4: f0 26     
			lda vFoxMushroomDead          																		; $f6a6: ad 12 02  
				beq __return12         																		; $f6a9: f0 21     
			inc vCaterpillarSpawned          																		; $f6ab: ee 54 02  
			
__spawnCaterpillar:     
			lda vCaterpillarSpawned          																		; $f6ae: ad 54 02  
				beq __return12         																		; $f6b1: f0 19     
			cmp #$02           																		; $f6b3: c9 02     
				bcs __hideCaterpillar         																		; $f6b5: b0 1c     
			lda vInvulnTimer            																		; $f6b7: a5 bf     
				bne __giveCaterpllareScore         																		; $f6b9: d0 12     
			; set position
			lda #$40           																		; $f6bb: a9 40     
			sta vInvulnCreatureY            																		; $f6bd: 85 9f     
			lda #$8f           																		; $f6bf: a9 8f     
			sta vInvulnCreatureX            																		; $f6c1: 85 7f     
			jsr __setXEvery8Cycle         																		; $f6c3: 20 8b d0  
			lda __caterpillarAnim,x       																		; $f6c6: bd d9 f6  
			sta $0741          																		; $f6c9: 8d 41 07  
__return12:     
			rts                																		; $f6cc: 60        

;-------------------------------------------------------------------------------
__giveCaterpllareScore:     
			jsr __give1000Score         																		; $f6cd: 20 1a ff  
			jsr __killedCreatureSound         																		; $f6d0: 20 45 c5  
__hideCaterpillar:     
			inc vCaterpillarTaken          																		; $f6d3: ee 53 02  
			jmp __hideSecrenCreature         																		; $f6d6: 4c 92 f6  

;-------------------------------------------------------------------------------
__caterpillarAnim:     
			.hex 36 37 36 37   																		; $f6d9: 36 37 36 37   Data

;-------------------------------------------------------------------------------
__handleMusicAndSound:     
			jsr __handleMusicPlayer         																		; $f6dd: 20 e3 f6  
			jmp __handleSoundPlayer         																		; $f6e0: 4c 93 f7  

;-------------------------------------------------------------------------------
__handleMusicPlayer:     
			ldx vMusicPlayerState            																		; $f6e3: a6 20     
				beq __return13         																		; $f6e5: f0 33     
			cpx #$ff           																		; $f6e7: e0 ff     
				beq __increaseMusicCounter         																		; $f6e9: f0 27     
				
			dex                																		; $f6eb: ca        
			lda __musicSpeed,x       																		; $f6ec: bd 58 f8  
			sta vMusicSpeed            																		; $f6ef: 85 23     
			cpx #$0f           																		; $f6f1: e0 0f     
				beq __setPulseLengthCounterLoad         																		; $f6f3: f0 18     
			lda #$08           																		; $f6f5: a9 08     
___handleMusicPlayer:     
			sta vPulseLengthCounterLoad            																		; $f6f7: 85 24     
			txa                																		; $f6f9: 8a        
			asl                																		; $f6fa: 0a        
			tax                																		; $f6fb: aa        
			lda __musicData,x       																		; $f6fc: bd 6c f8  
			sta vMusicAddr            																		; $f6ff: 85 21     
			lda __musicDataHi,x       																		; $f701: bd 6d f8  
			sta vMusicAddrHi            																		; $f704: 85 22     
			; now music is playing
			ldx #$ff           																		; $f706: a2 ff     
			stx vMusicPlayerState            																		; $f708: 86 20     
			jmp __playMusic         																		; $f70a: 4c 1b f7  

;-------------------------------------------------------------------------------
__setPulseLengthCounterLoad:     
			lda #$68           																		; $f70d: a9 68     
			jmp ___handleMusicPlayer         																		; $f70f: 4c f7 f6  

;-------------------------------------------------------------------------------
__increaseMusicCounter:     
			inc vMusicCounter            																		; $f712: e6 25     
			lda vMusicCounter            																		; $f714: a5 25     
			cmp vMusicSpeed            																		; $f716: c5 23     
				beq __playMusic         																		; $f718: f0 01     
__return13:     
			rts                																		; $f71a: 60        

;-------------------------------------------------------------------------------
__playMusic:     
			ldy #$00           																		; $f71b: a0 00     
			sty vMusicCounter            																		; $f71d: 84 25     
			lda (vMusicAddr),y        																		; $f71f: b1 21     
			sta vMusicNote            																		; $f721: 85 26     
			cmp #$ff           																		; $f723: c9 ff     
				beq __setMusicPlayerState         																		; $f725: f0 37     
			cmp #$f0           																		; $f727: c9 f0     
				beq __nextNote         																		; $f729: f0 27     
			cmp #$f1           																		; $f72b: c9 f1     
				beq __repeatMusicPattern         																		; $f72d: f0 32     
			cmp #$f2           																		; $f72f: c9 f2     
				beq __checkNextPattern         																		; $f731: f0 40     
			lsr                																		; $f733: 4a        
			lsr                																		; $f734: 4a        
			lsr                																		; $f735: 4a        
			lsr                																		; $f736: 4a        
			and #$0c           																		; $f737: 29 0c     
			tax                																		; $f739: aa        
			cpx #$04           																		; $f73a: e0 04     
				bne __playPulseNote         																		; $f73c: d0 00     
__playPulseNote:     
			lda vMusicNote            																		; $f73e: a5 26     
			asl                																		; $f740: 0a        
			and #$3e           																		; $f741: 29 3e     
			tay                																		; $f743: a8        
			lda __noteTimerLow,y       																		; $f744: b9 fb f7  
			sta apu1PulseTLow,x        																		; $f747: 9d 02 40  
			lda __noteTimerHigh,y       																		; $f74a: b9 fa f7  
			ora vPulseLengthCounterLoad            																		; $f74d: 05 24     
			sta apu1PulseTHigh,x        																		; $f74f: 9d 03 40  
__nextNote:     
			jsr __advanceMusicPointer         																		; $f752: 20 8c f7  
			lda vMusicNote            																		; $f755: a5 26     
			and #$20           																		; $f757: 29 20     
				bne __return7         																		; $f759: d0 05     
			jmp __playMusic         																		; $f75b: 4c 1b f7  

;-------------------------------------------------------------------------------
__setMusicPlayerState:     
			sty vMusicPlayerState            																		; $f75e: 84 20     
__return7:     
			rts                																		; $f760: 60        

;-------------------------------------------------------------------------------
__repeatMusicPattern:     
			jsr __advanceMusicPointer         																		; $f761: 20 8c f7  
			lda vMusicAddr            																		; $f764: a5 21     
			sta vMusicOldAddr            																		; $f766: 85 27     
			lda vMusicAddrHi            																		; $f768: a5 22     
			sta vMusicOldAddrHi            																		; $f76a: 85 28     
			lda #$01           																		; $f76c: a9 01     
			sta vMusicRepeatPrevPattern            																		; $f76e: 85 29     
			jmp __playMusic         																		; $f770: 4c 1b f7  

;-------------------------------------------------------------------------------
__checkNextPattern:     
			lda vMusicRepeatPrevPattern            																		; $f773: a5 29     
			cmp #$01           																		; $f775: c9 01     
				beq __reloadOldMusicPattern         																		; $f777: f0 06     
			jsr __advanceMusicPointer         																		; $f779: 20 8c f7  
			jmp __playMusic         																		; $f77c: 4c 1b f7  

;-------------------------------------------------------------------------------
__reloadOldMusicPattern:     
			sty vMusicRepeatPrevPattern            																		; $f77f: 84 29     
			lda vMusicOldAddr            																		; $f781: a5 27     
			sta vMusicAddr            																		; $f783: 85 21     
			lda vMusicOldAddrHi            																		; $f785: a5 28     
			sta vMusicAddrHi            																		; $f787: 85 22     
			jmp __playMusic         																		; $f789: 4c 1b f7  

;-------------------------------------------------------------------------------
__advanceMusicPointer:     
			inc vMusicAddr            																		; $f78c: e6 21     
				bne __return54         																		; $f78e: d0 02     
			; increase hi-byte
			inc vMusicAddrHi            																		; $f790: e6 22     
__return54:     
			rts                																		; $f792: 60        

;-------------------------------------------------------------------------------
__handleSoundPlayer:     
			ldx vSoundPlayerState            																		; $f793: a6 2a  
				; no sound playing
				beq __return15         																		; $f795: f0 2a     
			cpx #$ff           																		; $f797: e0 ff     
				; sound playing
				beq __increaseSoundCounter         																		; $f799: f0 1e   
				
			dex                																		; $f79b: ca        
			lda __soundSpeedAndData,x       																		; $f79c: bd 64 fc  
			sta vSoundSpeed            																		; $f79f: 85 2d     
			lda #$08           																		; $f7a1: a9 08     
			sta vTriangleLengthCounterLoad            																		; $f7a3: 85 2e     
			
			txa                																		; $f7a5: 8a        
			asl                																		; $f7a6: 0a        
			tax                																		; $f7a7: aa        
			lda __soundAddr,x       																		; $f7a8: bd 4e fc  
			sta vSoundAddr            																		; $f7ab: 85 2b     
			lda __soundHiAddr,x       																		; $f7ad: bd 4f fc  
			sta vSoundHiAddr            																		; $f7b0: 85 2c     
			
			; now player is active
			ldx #$ff           																		; $f7b2: a2 ff     
			stx vSoundPlayerState            																		; $f7b4: 86 2a     
			jmp __playSound         																		; $f7b6: 4c c2 f7  

;-------------------------------------------------------------------------------
__increaseSoundCounter:     
			inc vSoundCounter            																		; $f7b9: e6 2f     
			lda vSoundCounter            																		; $f7bb: a5 2f     
			cmp vSoundSpeed            																		; $f7bd: c5 2d     
			beq __playSound         																		; $f7bf: f0 01     
__return15:     
			rts                																		; $f7c1: 60        

;-------------------------------------------------------------------------------
; sounds use only triangle channel
__playSound:     
			ldy #$00           																		; $f7c2: a0 00     
			sty vSoundCounter            																		; $f7c4: 84 2f     
			lda (vSoundAddr),y        																		; $f7c6: b1 2b     
			sta vMusicNote            																		; $f7c8: 85 26     
			cmp #$ff           																		; $f7ca: c9 ff     
				beq __saveSoundState         																		; $f7cc: f0 1d     
			cmp #$f0           																		; $f7ce: c9 f0     
				beq __nextSoundNote         																		; $f7d0: f0 13     
				
			asl                																		; $f7d2: 0a        
			and #$3e           																		; $f7d3: 29 3e     
			tay                																		; $f7d5: a8        
			lda __noteTimerLow,y       																		; $f7d6: b9 fb f7  
			lsr                																		; $f7d9: 4a        
			sta apuTriangleTLow          																		; $f7da: 8d 0a 40  
			lda __noteTimerHigh,y       																		; $f7dd: b9 fa f7  
			ora vTriangleLengthCounterLoad            																		; $f7e0: 05 2e     
			sta apuTriangleTHigh          																		; $f7e2: 8d 0b 40  
__nextSoundNote:     
			jsr __iterateSoundAddress         																		; $f7e5: 20 f3 f7  
				jmp __return15         																		; $f7e8: 4c c1 f7  

;-------------------------------------------------------------------------------
__saveSoundState:     
			sty vSoundPlayerState            																		; $f7eb: 84 2a     
			lda #$7f           																		; $f7ed: a9 7f     
			sta $4009          																		; $f7ef: 8d 09 40  
			rts                																		; $f7f2: 60        

;-------------------------------------------------------------------------------
__iterateSoundAddress:     
			inc vSoundAddr            																		; $f7f3: e6 2b     
			bne __return14         																		; $f7f5: d0 02     
			inc vSoundHiAddr            																		; $f7f7: e6 2c     
__return14:     
			rts                																		; $f7f9: 60        

;-------------------------------------------------------------------------------
__noteTimerHigh:     
			.hex 02            																		; $f7fa: 02            Data
__noteTimerLow:     
			.hex 1b 01 fc 01   																		; $f7fb: 1b 01 fc 01   Data
			.hex e0 01 c5 01   																		; $f7ff: e0 01 c5 01   Data
			.hex ac 01 94 01   																		; $f803: ac 01 94 01   Data
			.hex 7d 01 68 01   																		; $f807: 7d 01 68 01   Data
			.hex 53 01 40 01   																		; $f80b: 53 01 40 01   Data
			.hex 2e 01 1d 01   																		; $f80f: 2e 01 1d 01   Data
			.hex 0d 00 fe 00   																		; $f813: 0d 00 fe 00   Data
			.hex f0 00 e2 00   																		; $f817: f0 00 e2 00   Data
			.hex d6 00 ca 00   																		; $f81b: d6 00 ca 00   Data
			.hex be 00 b4 00   																		; $f81f: be 00 b4 00   Data
			.hex aa 00 a0 00   																		; $f823: aa 00 a0 00   Data
			.hex 97 00 8f 00   																		; $f827: 97 00 8f 00   Data
			.hex 87 00 7f 00   																		; $f82b: 87 00 7f 00   Data
			.hex 78 00 71 00   																		; $f82f: 78 00 71 00   Data
			.hex 6b 00 65 00   																		; $f833: 6b 00 65 00   Data
			.hex 5f 00 5a      																		; $f837: 5f 00 5a      Data
			
__initSound:     
			lda #$0f           																		; $f83a: a9 0f     
			sta apuStatus          																		; $f83c: 8d 15 40  
			lda #$c0           																		; $f83f: a9 c0     
			sta joy2port          																		; $f841: 8d 17 40  
			lda #$0f           																		; $f844: a9 0f     
			sta apu1Pulse1          																		; $f846: 8d 00 40  
			sta apu2Pulse1          																		; $f849: 8d 04 40  
			sta apuTriangle          																		; $f84c: 8d 08 40  
			lda #$7f           																		; $f84f: a9 7f     
			sta apu1PulseSweep          																		; $f851: 8d 01 40  
			sta apu2PulseSweep          																		; $f854: 8d 05 40  
			rts                																		; $f857: 60        

;-------------------------------------------------------------------------------
__musicSpeed:     
			.hex 08 08 08 08   																		; $f858: 08 08 08 08   Data
			.hex 05 08 08 08   																		; $f85c: 05 08 08 08   Data
			.hex 0a 08 08 08   																		; $f860: 0a 08 08 08   Data
			.hex 04 02 02 08   																		; $f864: 04 02 02 08   Data
			.hex 08 08 08 08   																		; $f868: 08 08 08 08   Data
__musicData:     
			.hex 92            																		; $f86c: 92            Data
__musicDataHi:     
			.hex f8 92 f8 92   																		; $f86d: f8 92 f8 92   Data
			.hex f8 98 f9 27   																		; $f871: f8 98 f9 27   Data
			.hex fb cb fa ad   																		; $f875: fb cb fa ad   Data
			.hex fa f3 f9 66   																		; $f879: fa f3 f9 66   Data
			.hex fa 0e fb ec   																		; $f87d: fa 0e fb ec   Data
			.hex fa 30 fb 69   																		; $f881: fa 30 fb 69   Data
			.hex fb 69 fb 49   																		; $f885: fb 69 fb 49   Data
			.hex fc 80 fb af   																		; $f889: fc 80 fb af   Data
			.hex fb 0f fc 6b   																		; $f88d: fb 0f fc 6b   Data
			.hex fc f1 10 60   																		; $f891: fc f1 10 60   Data
			.hex f0 64 f0 64   																		; $f895: f0 64 f0 64   Data
			.hex f0 10 60 f0   																		; $f899: f0 10 60 f0   Data
			.hex 64 f0 64 f0   																		; $f89d: 64 f0 64 f0   Data
			.hex 10 60 f0 0f   																		; $f8a1: 10 60 f0 0f   Data
			.hex 64 f0 10 64   																		; $f8a5: 64 f0 10 64   Data
			.hex f0 13 60 f0   																		; $f8a9: f0 13 60 f0   Data
			.hex 64 f0 64 f0   																		; $f8ad: 64 f0 64 f0   Data
			.hex 17 62 35 17   																		; $f8b1: 17 62 35 17   Data
			.hex 65 35 17 65   																		; $f8b5: 65 35 17 65   Data
			.hex f0 62 f0 65   																		; $f8b9: f0 62 f0 65   Data
			.hex f0 65 f0 17   																		; $f8bd: f0 65 f0 17   Data
			.hex 62 36 15 65   																		; $f8c1: 62 36 15 65   Data
			.hex 34 13 65 f0   																		; $f8c5: 34 13 65 f0   Data
			.hex 62 f0 65 f0   																		; $f8c9: 62 f0 65 f0   Data
			.hex 65 f0 f2 f1   																		; $f8cd: 65 f0 f2 f1   Data
			.hex 0c 64 f0 1a   																		; $f8d1: 0c 64 f0 1a   Data
			.hex 67 f0 67 f0   																		; $f8d5: 67 f0 67 f0   Data
			.hex 18 64 f0 67   																		; $f8d9: 18 64 f0 67   Data
			.hex f0 67 f0 13   																		; $f8dd: f0 67 f0 13   Data
			.hex 64 f0 10 67   																		; $f8e1: 64 f0 10 67   Data
			.hex f0 11 67 f0   																		; $f8e5: f0 11 67 f0   Data
			.hex 13 64 f0 67   																		; $f8e9: 13 64 f0 67   Data
			.hex f0 67 f0 17   																		; $f8ed: f0 67 f0 17   Data
			.hex 65 35 17 69   																		; $f8f1: 65 35 17 69   Data
			.hex 35 17 69 35   																		; $f8f5: 35 17 69 35   Data
			.hex 0b 65 29 0b   																		; $f8f9: 0b 65 29 0b   Data
			.hex 69 29 0b 69   																		; $f8fd: 69 29 0b 69   Data
			.hex 29 17 65 35   																		; $f901: 29 17 65 35   Data
			.hex 17 69 35 17   																		; $f905: 17 69 35 17   Data
			.hex 69 35 0b 65   																		; $f909: 69 35 0b 65   Data
			.hex 29 0b 69 29   																		; $f90d: 29 0b 69 29   Data
			.hex 0b 69 29 f2   																		; $f911: 0b 69 29 f2   Data
			.hex f1 1c 60 f0   																		; $f915: f1 1c 60 f0   Data
			.hex 64 f0 64 f0   																		; $f919: 64 f0 64 f0   Data
			.hex 18 60 f0 64   																		; $f91d: 18 60 f0 64   Data
			.hex f0 64 f0 1c   																		; $f921: f0 64 f0 1c   Data
			.hex 60 3b 1c 64   																		; $f925: 60 3b 1c 64   Data
			.hex 3b 1c 64 f0   																		; $f929: 3b 1c 64 f0   Data
			.hex 13 60 f0 64   																		; $f92d: 13 60 f0 64   Data
			.hex f0 64 f0 1a   																		; $f931: f0 64 f0 1a   Data
			.hex 62 3c 1d 65   																		; $f935: 62 3c 1d 65   Data
			.hex 3f 1d 65 3c   																		; $f939: 3f 1d 65 3c   Data
			.hex 1a 62 f0 65   																		; $f93d: 1a 62 f0 65   Data
			.hex f0 65 f0 17   																		; $f941: f0 65 f0 17   Data
			.hex 62 36 17 65   																		; $f945: 62 36 17 65   Data
			.hex 38 1a 65 3a   																		; $f949: 38 1a 65 3a   Data
			.hex 13 62 f0 65   																		; $f94d: 13 62 f0 65   Data
			.hex f0 65 f0 0c   																		; $f951: f0 65 f0 0c   Data
			.hex 64 2b 0c 67   																		; $f955: 64 2b 0c 67   Data
			.hex f0 10 67 2f   																		; $f959: f0 10 67 2f   Data
			.hex 10 64 f0 13   																		; $f95d: 10 64 f0 13   Data
			.hex 67 32 13 67   																		; $f961: 67 32 13 67   Data
			.hex f0 1f 64 f0   																		; $f965: f0 1f 64 f0   Data
			.hex 67 f0 67 f0   																		; $f969: 67 f0 67 f0   Data
			.hex 64 f0 67 f0   																		; $f96d: 64 f0 67 f0   Data
			.hex 67 f0 15 65   																		; $f971: 67 f0 15 65   Data
			.hex 34 15 69 f0   																		; $f975: 34 15 69 f0   Data
			.hex 1a 69 39 1a   																		; $f979: 1a 69 39 1a   Data
			.hex 65 f0 1d 69   																		; $f97d: 65 f0 1d 69   Data
			.hex f0 1d 69 f0   																		; $f981: f0 1d 69 f0   Data
			.hex 1a 65 f0 69   																		; $f985: 1a 65 f0 69   Data
			.hex f0 0e 69 2d   																		; $f989: f0 0e 69 2d   Data
			.hex 0e 65 2d 0e   																		; $f98d: 0e 65 2d 0e   Data
			.hex 69 2d 0e 69   																		; $f991: 69 2d 0e 69   Data
			.hex f0 f2 ff 13   																		; $f995: f0 f2 ff 13   Data
			.hex 67 f0 15 69   																		; $f999: 67 f0 15 69   Data
			.hex f0 17 6b f0   																		; $f99d: f0 17 6b f0   Data
			.hex 18 60 f0 64   																		; $f9a1: 18 60 f0 64   Data
			.hex f0 13 60 f0   																		; $f9a5: f0 13 60 f0   Data
			.hex 64 f0 18 60   																		; $f9a9: 64 f0 18 60   Data
			.hex f0 64 33 18   																		; $f9ad: f0 64 33 18   Data
			.hex 60 38 13 64   																		; $f9b1: 60 38 13 64   Data
			.hex 38 15 60 61   																		; $f9b5: 38 15 60 61   Data
			.hex 62 63 10 64   																		; $f9b9: 62 63 10 64   Data
			.hex f0 69 f0 15   																		; $f9bd: f0 69 f0 15   Data
			.hex 64 f0 69 30   																		; $f9c1: 64 f0 69 30   Data
			.hex 15 64 35 10   																		; $f9c5: 15 64 35 10   Data
			.hex 69 35 11 65   																		; $f9c9: 69 35 11 65   Data
			.hex 66 67 68 09   																		; $f9cd: 66 67 68 09   Data
			.hex 65 f0 69 f0   																		; $f9d1: 65 f0 69 f0   Data
			.hex 11 65 f0 69   																		; $f9d5: 11 65 f0 69   Data
			.hex 29 11 65 31   																		; $f9d9: 29 11 65 31   Data
			.hex 09 69 31 13   																		; $f9dd: 09 69 31 13   Data
			.hex 67 13 66 67   																		; $f9e1: 67 13 66 67   Data
			.hex 13 66 15 67   																		; $f9e5: 13 66 15 67   Data
			.hex 68 16 69 6a   																		; $f9e9: 68 16 69 6a   Data
			.hex 17 6b f0 3f   																		; $f9ed: 17 6b f0 3f   Data
			.hex 33 ff 13 67   																		; $f9f1: 33 ff 13 67   Data
			.hex f0 11 69 f0   																		; $f9f5: f0 11 69 f0   Data
			.hex 10 6b f0 0c   																		; $f9f9: 10 6b f0 0c   Data
			.hex 40 bc f0 44   																		; $f9fd: 40 bc f0 44   Data
			.hex bf be 10 40   																		; $fa01: bf be 10 40   Data
			.hex bf be 44 bf   																		; $fa05: bf be 44 bf   Data
			.hex f0 0c 47 b8   																		; $fa09: f0 0c 47 b8   Data
			.hex 66 67 10 66   																		; $fa0d: 66 67 10 66   Data
			.hex 0c 67 10 66   																		; $fa11: 0c 67 10 66   Data
			.hex 0e 45 bd f0   																		; $fa15: 0e 45 bd f0   Data
			.hex 42 bd bc 11   																		; $fa19: 42 bd bc 11   Data
			.hex 45 bd bc 42   																		; $fa1d: 45 bd bc 42   Data
			.hex bd f0 0e 45   																		; $fa21: bd f0 0e 45   Data
			.hex ba 64 65 11   																		; $fa25: ba 64 65 11   Data
			.hex 64 0e 65 11   																		; $fa29: 64 0e 65 11   Data
			.hex 64 09 42 bd   																		; $fa2d: 64 09 42 bd   Data
			.hex f0 45 bd bc   																		; $fa31: f0 45 bd bc   Data
			.hex 11 49 bd bc   																		; $fa35: 11 49 bd bc   Data
			.hex 45 bd f0 09   																		; $fa39: 45 bd f0 09   Data
			.hex 45 b5 64 65   																		; $fa3d: 45 b5 64 65   Data
			.hex 11 64 09 65   																		; $fa41: 11 64 09 65   Data
			.hex 11 64 0c 44   																		; $fa45: 11 64 0c 44   Data
			.hex bc f0 40 bc   																		; $fa49: bc f0 40 bc   Data
			.hex bb 10 44 bc   																		; $fa4d: bb 10 44 bc   Data
			.hex bb 40 bc f0   																		; $fa51: bb 40 bc f0   Data
			.hex 0c 44 b8 63   																		; $fa55: 0c 44 b8 63   Data
			.hex 64 10 63 0c   																		; $fa59: 64 10 63 0c   Data
			.hex 64 10 63 0c   																		; $fa5d: 64 10 63 0c   Data
			.hex 64 f0 f0 f0   																		; $fa61: 64 f0 f0 f0   Data
			.hex ff 18 60 37   																		; $fa65: ff 18 60 37   Data
			.hex 18 64 30 1a   																		; $fa69: 18 64 30 1a   Data
			.hex 64 38 18 40   																		; $fa6d: 64 38 18 40   Data
			.hex b8 b7 44 b8   																		; $fa71: b8 b7 44 b8   Data
			.hex b0 44 ae ac   																		; $fa75: b0 44 ae ac   Data
			.hex 17 42 ae 35   																		; $fa79: 17 42 ae 35   Data
			.hex 17 65 3a 17   																		; $fa7d: 17 65 3a 17   Data
			.hex 65 35 1d 42   																		; $fa81: 65 35 1d 42   Data
			.hex b7 b5 45 b7   																		; $fa85: b7 b5 45 b7   Data
			.hex ba 45 b7 b5   																		; $fa89: ba 45 b7 b5   Data
			.hex 15 49 bd f0   																		; $fa8d: 15 49 bd f0   Data
			.hex 71 35 71 35   																		; $fa91: 71 35 71 35   Data
			.hex 17 49 b5 13   																		; $fa95: 17 49 b5 13   Data
			.hex b7 51 b5 b3   																		; $fa99: b7 51 b5 b3   Data
			.hex 51 b5 b3 18   																		; $fa9d: 51 b5 b3 18   Data
			.hex 4c ac ab 50   																		; $faa1: 4c ac ab 50   Data
			.hex ac b0 50 b3   																		; $faa5: ac b0 50 b3   Data
			.hex b7 4c b8 ff   																		; $faa9: b7 4c b8 ff   Data
			.hex 13 47 ac 11   																		; $faad: 13 47 ac 11   Data
			.hex 65 10 44 b3   																		; $fab1: 65 10 44 b3   Data
			.hex 0e 62 0c 40   																		; $fab5: 0e 62 0c 40   Data
			.hex ac f0 13 47   																		; $fab9: ac f0 13 47   Data
			.hex b3 b0 0c 40   																		; $fabd: b3 b0 0c 40   Data
			.hex ac f0 f0 f0   																		; $fac1: ac f0 f0 f0   Data
			.hex f0 f0 f0 f0   																		; $fac5: f0 f0 f0 f0   Data
			.hex f0 ff 1f 6c   																		; $fac9: f0 ff 1f 6c   Data
			.hex 3e 3d 1c 6c   																		; $facd: 3e 3d 1c 6c   Data
			.hex 1b 6c 3a 39   																		; $fad1: 1b 6c 3a 39   Data
			.hex 18 6c 17 6c   																		; $fad5: 18 6c 17 6c   Data
			.hex 36 35 14 6c   																		; $fad9: 36 35 14 6c   Data
			.hex 13 6c 32 31   																		; $fadd: 13 6c 32 31   Data
			.hex 10 6c 0f 6c   																		; $fae1: 10 6c 0f 6c   Data
			.hex 2e 2d 0c 6c   																		; $fae5: 2e 2d 0c 6c   Data
			.hex 2b 2a ff 1f   																		; $fae9: 2b 2a ff 1f   Data
			.hex 60 62 64 65   																		; $faed: 60 62 64 65   Data
			.hex 1c 67 1f 69   																		; $faf1: 1c 67 1f 69   Data
			.hex 1d 6b 1c 6c   																		; $faf5: 1d 6b 1c 6c   Data
			.hex 1a 6e 70 71   																		; $faf9: 1a 6e 70 71   Data
			.hex 1c 73 1f 75   																		; $fafd: 1c 73 1f 75   Data
			.hex 77 1c 78 18   																		; $fb01: 77 1c 78 18   Data
			.hex 73 70 6c f0   																		; $fb05: 73 70 6c f0   Data
			.hex f0 f0 f0 f0   																		; $fb09: f0 f0 f0 f0   Data
			.hex ff 00 bf be   																		; $fb0d: ff 00 bf be   Data
			.hex 24 0c bf be   																		; $fb11: 24 0c bf be   Data
			.hex 30 18 bf be   																		; $fb15: 30 18 bf be   Data
			.hex 3c 00 bf be   																		; $fb19: 3c 00 bf be   Data
			.hex 23 0c bf be   																		; $fb1d: 23 0c bf be   Data
			.hex 2f 18 bf be   																		; $fb21: 2f 18 bf be   Data
			.hex 3b ff 1a 60   																		; $fb25: 3b ff 1a 60   Data
			.hex 38 f0 1c 70   																		; $fb29: 38 f0 1c 70   Data
			.hex 1f 67 ff 0c   																		; $fb2d: 1f 67 ff 0c   Data
			.hex 40 bf f0 67   																		; $fb31: 40 bf f0 67   Data
			.hex bc 0c 44 bf   																		; $fb35: bc 0c 44 bf   Data
			.hex f0 67 bc 0c   																		; $fb39: f0 67 bc 0c   Data
			.hex 40 bf 10 62   																		; $fb3d: 40 bf 10 62   Data
			.hex 64 0c 45 bc   																		; $fb41: 64 0c 45 bc   Data
			.hex 13 47 bf f0   																		; $fb45: 13 47 bf f0   Data
			.hex 67 ba 0e 42   																		; $fb49: 67 ba 0e 42   Data
			.hex bd f0 69 ba   																		; $fb4d: bd f0 69 ba   Data
			.hex 0e 45 bd f0   																		; $fb51: 0e 45 bd f0   Data
			.hex 69 ba 0e 42   																		; $fb55: 69 ba 0e 42   Data
			.hex bd 10 64 11   																		; $fb59: bd 10 64 11   Data
			.hex 65 13 47 ba   																		; $fb5d: 65 13 47 ba   Data
			.hex 15 49 bd f0   																		; $fb61: 15 49 bd f0   Data
			.hex 69 f0 f0 ff   																		; $fb65: 69 f0 f0 ff   Data
			.hex 0b 47 ab 2e   																		; $fb69: 0b 47 ab 2e   Data
			.hex 37 33 0b ae   																		; $fb6d: 37 33 0b ae   Data
			.hex 2e 37 33 0b   																		; $fb71: 2e 37 33 0b   Data
			.hex 47 b7 2e 37   																		; $fb75: 47 b7 2e 37   Data
			.hex 33 0b b3 2e   																		; $fb79: 33 0b b3 2e   Data
			.hex 37 33 ff f1   																		; $fb7d: 37 33 ff f1   Data
			.hex 10 60 64 64   																		; $fb81: 10 60 64 64   Data
			.hex 22 65 65 64   																		; $fb85: 22 65 65 64   Data
			.hex 67 13 67 65   																		; $fb89: 67 13 67 65   Data
			.hex 69 15 69 67   																		; $fb8d: 69 15 69 67   Data
			.hex 17 6b 13 6b   																		; $fb91: 17 6b 13 6b   Data
			.hex 4b f2 f1 18   																		; $fb95: 4b f2 f1 18   Data
			.hex 6c 38 38 70   																		; $fb99: 6c 38 38 70   Data
			.hex 37 35 17 6e   																		; $fb9d: 37 35 17 6e   Data
			.hex f0 15 71 35   																		; $fba1: f0 15 71 35   Data
			.hex 15 70 f0 33   																		; $fba5: 15 70 f0 33   Data
			.hex 15 73 37 f0   																		; $fba9: 15 73 37 f0   Data
			.hex f2 ff 60 67   																		; $fbad: f2 ff 60 67   Data
			.hex 60 67 18 60   																		; $fbb1: 60 67 18 60   Data
			.hex 67 60 17 67   																		; $fbb5: 67 60 17 67   Data
			.hex 13 64 67 64   																		; $fbb9: 13 64 67 64   Data
			.hex f0 64 67 6c   																		; $fbbd: f0 64 67 6c   Data
			.hex 67 1a 62 69   																		; $fbc1: 67 1a 62 69   Data
			.hex 62 1d 69 62   																		; $fbc5: 62 1d 69 62   Data
			.hex 69 1c 62 1b   																		; $fbc9: 69 1c 62 1b   Data
			.hex 69 1c 65 69   																		; $fbcd: 69 1c 65 69   Data
			.hex 18 65 f0 65   																		; $fbd1: 18 65 f0 65   Data
			.hex 69 6e 49 04   																		; $fbd5: 69 6e 49 04   Data
			.hex 60 64 13 60   																		; $fbd9: 60 64 13 60   Data
			.hex 64 10 60 0e   																		; $fbdd: 64 10 60 0e   Data
			.hex 64 60 64 04   																		; $fbe1: 64 60 64 04   Data
			.hex 60 05 64 07   																		; $fbe5: 60 05 64 07   Data
			.hex 60 09 64 0b   																		; $fbe9: 60 09 64 0b   Data
			.hex 60 0c 64 60   																		; $fbed: 60 0c 64 60   Data
			.hex 64 05 62 65   																		; $fbf1: 64 05 62 65   Data
			.hex 04 62 65 05   																		; $fbf5: 04 62 65 05   Data
			.hex 62 04 65 62   																		; $fbf9: 62 04 65 62   Data
			.hex 65 05 62 07   																		; $fbfd: 65 05 62 07   Data
			.hex 65 09 62 0b   																		; $fc01: 65 09 62 0b   Data
			.hex 65 0c 62 0e   																		; $fc05: 65 0c 62 0e   Data
			.hex 65 0c 62 0e   																		; $fc09: 65 0c 62 0e   Data
			.hex 65 ff b0 f0   																		; $fc0d: 65 ff b0 f0   Data
			.hex ac f0 ff 3f   																		; $fc11: ac f0 ff 3f   Data
			.hex 3d 38 f0 f0   																		; $fc15: 3d 38 f0 f0   Data
			.hex ff bc bf b0   																		; $fc19: ff bc bf b0   Data
			.hex af a8 ab ff   																		; $fc1d: af a8 ab ff   Data
			.hex 2c 2d 27 20   																		; $fc21: 2c 2d 27 20   Data
			.hex f0 f0 f0 ff   																		; $fc25: f0 f0 f0 ff   Data
			.hex 3f 3e 3f f0   																		; $fc29: 3f 3e 3f f0   Data
			.hex f0 f0 ff 3c   																		; $fc2d: f0 f0 ff 3c   Data
			.hex 3d 3e 3f f0   																		; $fc31: 3d 3e 3f f0   Data
			.hex f0 f0 ff 27   																		; $fc35: f0 f0 ff 27   Data
			.hex 33 38 f0 f0   																		; $fc39: 33 38 f0 f0   Data
			.hex f0 ff 3a 3c   																		; $fc3d: f0 ff 3a 3c   Data
			.hex 2e 30 22 24   																		; $fc41: 2e 30 22 24   Data
			.hex f0 f0 f0 ff   																		; $fc45: f0 f0 f0 ff   Data
			.hex 3f 3e 3f f0   																		; $fc49: 3f 3e 3f f0   Data
			.hex ff            																		; $fc4d: ff            Data
__soundAddr:     
			.hex 30            																		; $fc4e: 30            Data
__soundHiAddr:     
			.hex fc 21 fc 1a   																		; $fc4f: fc 21 fc 1a   Data
			.hex fc 29 fc 14   																		; $fc53: fc 29 fc 14   Data
			.hex fc 38 fc 3f   																		; $fc57: fc 38 fc 3f   Data
			.hex fc 29 fc 30   																		; $fc5b: fc 29 fc 30   Data
			.hex fc 38 fc 3f   																		; $fc5f: fc 38 fc 3f   Data
			.hex fc            																		; $fc63: fc            Data
__soundSpeedAndData:     
			.hex 02 01 02 06   																		; $fc64: 02 01 02 06   Data
			.hex 01 01 01 f1   																		; $fc68: 01 01 01 f1   Data
			.hex f0 40 b8 f0   																		; $fc6c: f0 40 b8 f0   Data
			.hex 44 ba b8 64   																		; $fc70: 44 ba b8 64   Data
			.hex f0 40 bc bb   																		; $fc74: f0 40 bc bb   Data
			.hex 44 bc f0 64   																		; $fc78: 44 bc f0 64   Data
			.hex f0 62 f0 11   																		; $fc7c: f0 62 f0 11   Data
			.hex 65 30 11 65   																		; $fc80: 65 30 11 65   Data
			.hex f0 62 f0 65   																		; $fc84: f0 62 f0 65   Data
			.hex f0 65 f0 44   																		; $fc88: f0 65 f0 44   Data
			.hex bf be 47 bd   																		; $fc8c: bf be 47 bd   Data
			.hex bc 47 bb ba   																		; $fc90: bc 47 bb ba   Data
			.hex 44 bc f0 67   																		; $fc94: 44 bc f0 67   Data
			.hex f0 67 f0 42   																		; $fc98: f0 67 f0 42   Data
			.hex ba f0 11 65   																		; $fc9c: ba f0 11 65   Data
			.hex 30 11 65 f0   																		; $fca0: 30 11 65 f0   Data
			.hex 42 bc f0 65   																		; $fca4: 42 bc f0 65   Data
			.hex f0 65 f2 10   																		; $fca8: f0 65 f2 10   Data
			.hex 60 f0 64 f0   																		; $fcac: 60 f0 64 f0   Data
			.hex 13 64 2c 60   																		; $fcb0: 13 64 2c 60   Data
			.hex f0 13 64 f0   																		; $fcb4: f0 13 64 f0   Data
			.hex 14 64 f0 15   																		; $fcb8: 14 64 f0 15   Data
			.hex 62 f0 65 f0   																		; $fcbc: 62 f0 65 f0   Data
			.hex 11 65 f0 0e   																		; $fcc0: 11 65 f0 0e   Data
			.hex 62 f0 65 f0   																		; $fcc4: 62 f0 65 f0   Data
			.hex 65 f0 10 64   																		; $fcc8: 65 f0 10 64   Data
			.hex f0 67 f0 13   																		; $fccc: f0 67 f0 13   Data
			.hex 67 2c 64 f0   																		; $fcd0: 67 2c 64 f0   Data
			.hex 13 67 f0 14   																		; $fcd4: 13 67 f0 14   Data
			.hex 67 f0 15 62   																		; $fcd8: 67 f0 15 62   Data
			.hex f0 65 f0 65   																		; $fcdc: f0 65 f0 65   Data
			.hex f0 62 f0 65   																		; $fce0: f0 62 f0 65   Data
			.hex f0 65 f0 10   																		; $fce4: f0 65 f0 10   Data
			.hex 67 f0 4c a7   																		; $fce8: 67 f0 4c a7   Data
			.hex a6 4c a5 a4   																		; $fcec: a6 4c a5 a4   Data
			.hex 13 47 a2 32   																		; $fcf0: 13 47 a2 32   Data
			.hex 13 6c f0 6c   																		; $fcf4: 13 6c f0 6c   Data
			.hex f0 11 65 f0   																		; $fcf8: f0 11 65 f0   Data
			.hex 49 a4 a5 49   																		; $fcfc: 49 a4 a5 49   Data
			.hex a6 a7 15 45   																		; $fd00: a6 a7 15 45   Data
			.hex a9 34 15 69   																		; $fd04: a9 34 15 69   Data
			.hex f0 69 f0 13   																		; $fd08: f0 69 f0 13   Data
			.hex 47 a7 f0 15   																		; $fd0c: 47 a7 f0 15   Data
			.hex 6b f0 17 6b   																		; $fd10: 6b f0 17 6b   Data
			.hex f0 17 47 ab   																		; $fd14: f0 17 47 ab   Data
			.hex f0 6b f0 1a   																		; $fd18: f0 6b f0 1a   Data
			.hex 6e f0 18 4c   																		; $fd1c: 6e f0 18 4c   Data
			.hex ac ab ac ae   																		; $fd20: ac ab ac ae   Data
			.hex b0 f0 ff      																		; $fd24: b0 f0 ff      Data

;-------------------------------------------------------------------------------
; reset vector
;-------------------------------------------------------------------------------
reset:      
;-------------------------------------------------------------------------------
; irq/brk vector
;-------------------------------------------------------------------------------
irq:        sei                																		; $fd27: 78        
			cld                																		; $fd28: d8        
			ldx #$30           																		; $fd29: a2 30     
			stx ppuControl          																		; $fd2b: 8e 00 20  
			
			; wait 2 vblanks
__firstVBlank:     
			lda ppuStatus          																		; $fd2e: ad 02 20  
				bpl __firstVBlank         																		; $fd31: 10 fb     
__secondVBlank:     
			lda ppuStatus          																		; $fd33: ad 02 20  
				bpl __secondVBlank         																		; $fd36: 10 fb 
			
			; hide everything
			ldx #$00           																		; $fd38: a2 00     
			stx ppuMask          																		; $fd3a: 8e 01 20  
			; init stack with FF
			dex                																		; $fd3d: ca        
			txs                																		; $fd3e: 9a      
			
			jsr __loadMainMenuPalette         																		; $fd3f: 20 87 fe  
			jsr __uploadPalettesToPPU         																		; $fd42: 20 64 fe  
			jsr __initZero_200_300         																		; $fd45: 20 2a fe  
			lda #$20           																		; $fd48: a9 20     
			jsr __clearNametable         																		; $fd4a: 20 f5 fd  
			lda #$20           																		; $fd4d: a9 20     
			jsr __clearAttributeTable         																		; $fd4f: 20 13 fe  
			jsr __dummy         																		; $fd52: 20 ea ff  
			
			; this mapper implements copy protection check
__copyProtectionCheck:     
			lda __copyProtectionValues         																		; $fd55: ad 20 c0  
			sta __copyProtectionValues         																		; $fd58: 8d 20 c0  
			jsr __copyProtection         																		; $fd5b: 20 a3 fd  
			beq __copyProtectionCheck         																		; $fd5e: f0 f5   
__copyProtectionCheck2:     
			lda __copyProtectionValues2         																		; $fd60: ad 21 c0  
			sta __copyProtectionValues2         																		; $fd63: 8d 21 c0  
			jsr __copyProtection         																		; $fd66: 20 a3 fd  
			bne __copyProtectionCheck2         																		; $fd69: d0 f5     
			
			; init video and sound
			lda #$b0           																		; $fd6b: a9 b0     
			sta vPPUController            																		; $fd6d: 85 06     
			lda #$1e           																		; $fd6f: a9 1e     
			sta vPPUMask            																		; $fd71: 85 07     
			jsr __initAPUshowGraphics         																		; $fd73: 20 30 c0  
			
			; generate NMI on VBlank
			lda vPPUController            																		; $fd76: a5 06     
			ora #$80           																		; $fd78: 09 80     
			sta vPPUController            																		; $fd7a: 85 06     
			sta ppuControl          																		; $fd7c: 8d 00 20 
			
			; this will loop until NMI will be generated
__foreverLoop:     
			inc vRandomVar            																		; $fd7f: e6 08     
			inc vRandomVar            																		; $fd81: e6 08     
			inc vRandomVar2            																		; $fd83: e6 17     
			inc vRandomVar            																		; $fd85: e6 08     
			jmp __foreverLoop         																		; $fd87: 4c 7f fd  

;-------------------------------------------------------------------------------
; nmi vector
;-------------------------------------------------------------------------------
nmi:        
			; DMA offset
			lda #$00           																		; $fd8a: a9 00     
			sta ppuOAMAddr          																		; $fd8c: 8d 03 20  
			
			; upload DMA data
			lda #$06           																		; $fd8f: a9 06     
			sta OAMDMA          																		; $fd91: 8d 14 40  
			; show everything (with sprites or not)
			lda vPPUMask            																		; $fd94: a5 07     
			sta ppuMask          																		; $fd96: 8d 01 20  
			
			lda ppuStatus          																		; $fd99: ad 02 20  
			jsr __processGameState         																		; $fd9c: 20 33 c0  
			jsr __getControllerInput         																		; $fd9f: 20 a2 fe  
			rti                																		; $fda2: 40        

;-------------------------------------------------------------------------------
__copyProtection:     
			lda #$1f           																		; $fda3: a9 1f     
			sta ppuAddress          																		; $fda5: 8d 06 20  
			lda #$f0           																		; $fda8: a9 f0     
			sta ppuAddress          																		; $fdaa: 8d 06 20  
			lda ppuData          																		; $fdad: ad 07 20  
			lda ppuData          																		; $fdb0: ad 07 20  
			cmp #$0c           																		; $fdb3: c9 0c     
			rts                																		; $fdb5: 60        

;-------------------------------------------------------------------------------
__scrollScreen:     
			lda vPPUController            																		; $fdb6: a5 06     
			and #$fc           																		; $fdb8: 29 fc     
			tax                																		; $fdba: aa        
			lda vBirdPPUNametable            																		; $fdbb: a5 02     
				beq __scrollNametable0         																		; $fdbd: f0 01     
			inx                																		; $fdbf: e8        
__scrollNametable0:     
			lda vPPUScrollX            																		; $fdc0: a5 04     
				; always true
				beq __scrollDontUseMirror         																		; $fdc2: f0 02     
			inx                																		; $fdc4: e8        
			inx                																		; $fdc5: e8   
			
__scrollDontUseMirror:     
			stx vPPUController            																		; $fdc6: 86 06     
			stx ppuControl          																		; $fdc8: 8e 00 20  
			; current bird position
			lda vBirdPPUX            																		; $fdcb: a5 03     
			sta ppuScroll          																		; $fdcd: 8d 05 20  
			; y scroll is always zero
			lda vPPUScrollY            																		; $fdd0: a5 05     
			sta ppuScroll          																		; $fdd2: 8d 05 20  
			rts                																		; $fdd5: 60        

;-------------------------------------------------------------------------------
__hideSprites:     
			lda vPPUMask            																		; $fdd6: a5 07     
			and #$ef           																		; $fdd8: 29 ef     
			sta vPPUMask            																		; $fdda: 85 07     
			nop                																		; $fddc: ea        
			nop                																		; $fddd: ea        
			nop                																		; $fdde: ea        
			rts                																		; $fddf: 60        

;-------------------------------------------------------------------------------
__showSprites:     
			lda vPPUMask            																		; $fde0: a5 07     
			ora #$10           																		; $fde2: 09 10     
			sta vPPUMask            																		; $fde4: 85 07     
			nop                																		; $fde6: ea        
			nop                																		; $fde7: ea        
			nop                																		; $fde8: ea        
			rts                																		; $fde9: 60        

;-------------------------------------------------------------------------------
__hideAllSpritesInTable:     
			ldx #$00           																		; $fdea: a2 00     
			lda #$f0           																		; $fdec: a9 f0     
__hideAllSpritesInTableLoop:     
			sta vSpriteTable,x        																		; $fdee: 9d 00 07  
			inx                																		; $fdf1: e8        
			bne __hideAllSpritesInTableLoop         																		; $fdf2: d0 fa     
			rts                																		; $fdf4: 60        

;-------------------------------------------------------------------------------
; register A - nametable to clear (#$20 - $2000-23BF, 3C0 iterations)
__clearNametable:      
			sta ppuAddress          																		; $fdf5: 8d 06 20  
			ldx #$00           																		; $fdf8: a2 00     
			stx ppuAddress          																		; $fdfa: 8e 06 20  
			ldy #$03           																		; $fdfd: a0 03
			; empty tile
			lda #$24           																		; $fdff: a9 24     

__clearNametableLoop:     
			sta ppuData          																		; $fe01: 8d 07 20  
			inx                																		; $fe04: e8        
			bne __clearNametableLoop         																		; $fe05: d0 fa     
			dey                																		; $fe07: 88        
			bne __clearNametableLoop         																		; $fe08: d0 f7    
			
__clearNametableLoopLast:     
			sta ppuData          																		; $fe0a: 8d 07 20  
			inx                																		; $fe0d: e8        
			cpx #$c0           																		; $fe0e: e0 c0     
			bne __clearNametableLoopLast         																		; $fe10: d0 f8     
			rts                																		; $fe12: 60        

;-------------------------------------------------------------------------------
__clearAttributeTable:     
			clc                																		; $fe13: 18        
			adc #$03           																		; $fe14: 69 03     
			sta ppuAddress          																		; $fe16: 8d 06 20  
			lda #$c0           																		; $fe19: a9 c0     
			sta ppuAddress          																		; $fe1b: 8d 06 20  
			lda #$00           																		; $fe1e: a9 00     
			tax                																		; $fe20: aa        
__clearAttributeTableLoop:     
			sta ppuData          																		; $fe21: 8d 07 20  
			inx                																		; $fe24: e8        
			cpx #$40           																		; $fe25: e0 40     
			bne __clearAttributeTableLoop         																		; $fe27: d0 f8     
			rts                																		; $fe29: 60        

;-------------------------------------------------------------------------------
__initZero_200_300:     
			lda #$00           																		; $fe2a: a9 00     
			tax                																		; $fe2c: aa        
__initZero_200_300_Loop:     
			sta $00,x          																		; $fe2d: 95 00     
			sta vPage200,x        																		; $fe2f: 9d 00 02  
			sta $0300,x        																		; $fe32: 9d 00 03  
			nop                																		; $fe35: ea        
			inx                																		; $fe36: e8        
			bne __initZero_200_300_Loop         																		; $fe37: d0 f4    
			
			jsr __hideAllSpritesInTable         																		; $fe39: 20 ea fd  
			; another check
__fe3c:     
			lda $0130,x        																		; $fe3c: bd 30 01  
			cmp __copyProtectionValues,x       																		; $fe3f: dd 20 c0  
				bne __fe4a         																		; $fe42: d0 06     
			inx                																		; $fe44: e8        
			cpx #$10           																		; $fe45: e0 10     
				bne __fe3c         																		; $fe47: d0 f3     
			rts                																		; $fe49: 60        

;-------------------------------------------------------------------------------
__fe4a:     
			ldx #$00           																		; $fe4a: a2 00     
			txa                																		; $fe4c: 8a        
__fe4d:     sta vPlayerScore,x        																		; $fe4d: 9d 00 01  
			inx                																		; $fe50: e8        
				bne __fe4d         																		; $fe51: d0 fa     
__fe53:     
			lda __copyProtectionValues,x       																		; $fe53: bd 20 c0  
			sta $0130,x        																		; $fe56: 9d 30 01  
			inx                																		; $fe59: e8        
			cpx #$10           																		; $fe5a: e0 10     
				bne __fe53         																		; $fe5c: d0 f5     
			; set initial high score
			lda #$03           																		; $fe5e: a9 03     
			sta $0114          																		; $fe60: 8d 14 01  
			rts                																		; $fe63: 60        

;-------------------------------------------------------------------------------
__uploadPalettesToPPU:    
			; set palette address
			ldy #$3f           																		; $fe64: a0 3f     
			sty ppuAddress          																		; $fe66: 8c 06 20  
			ldx #$00           																		; $fe69: a2 00     
			stx ppuAddress          																		; $fe6b: 8e 06 20  
			
__uploadPalettesToPPULoop:     
			lda vPaletteData,x          																		; $fe6e: b5 30     
			sta ppuData          																		; $fe70: 8d 07 20  
			inx                																		; $fe73: e8        
			cpx #$20           																		; $fe74: e0 20     
			bne __uploadPalettesToPPULoop         																		; $fe76: d0 f6     
			
			sty ppuAddress          																		; $fe78: 8c 06 20  
			lda #$00           																		; $fe7b: a9 00     
			sta ppuAddress          																		; $fe7d: 8d 06 20  
			sta ppuAddress          																		; $fe80: 8d 06 20  
			sta ppuAddress          																		; $fe83: 8d 06 20  
			rts                																		; $fe86: 60        

;-------------------------------------------------------------------------------
__loadMainMenuPalette:     
			ldx #$00           																		; $fe87: a2 00     
__loadMainMenuPaletteLoop:     
			lda __mainMenuPalette,x       																		; $fe89: bd 00 c0  
			sta vPaletteData,x          																		; $fe8c: 95 30     
			inx                																		; $fe8e: e8        
			cpx #$20           																		; $fe8f: e0 20     
			bne __loadMainMenuPaletteLoop         																		; $fe91: d0 f6     
			rts                																		; $fe93: 60        

;-------------------------------------------------------------------------------
; writing f0 will hide sprite
__hideSpritesInTable:     
			ldx #$00           																		; $fe94: a2 00     
			lda #$f0           																		; $fe96: a9 f0     
__hideAllSpritesLoop:     
			sta vSpriteTable,x        																		; $fe98: 9d 00 07  
			inx                																		; $fe9b: e8        
			inx                																		; $fe9c: e8        
			inx                																		; $fe9d: e8        
			inx                																		; $fe9e: e8        
			bne __hideAllSpritesLoop         																		; $fe9f: d0 f7     
			rts                																		; $fea1: 60        

;-------------------------------------------------------------------------------
; fills vPlayerInput and vPlayer2Input with input from joysticks
__getControllerInput:    
			; strobe
			ldx #$01           																		; $fea2: a2 01     
			stx joy1port          																		; $fea4: 8e 16 40  
			lda #$00           																		; $fea7: a9 00     
			sta joy1port          																		; $fea9: 8d 16 40  
			
			; now stack all buttons in vPlayerInput and vPlayer2Input by shifting bits
			ldx #$08           																		; $feac: a2 08     
__inputStacking:     
			lda joy1port          																		; $feae: ad 16 40  
			and #$03           																		; $feb1: 29 03     
			cmp #$01           																		; $feb3: c9 01     
			ror vPlayerInput            																		; $feb5: 66 0a     
			lda joy2port          																		; $feb7: ad 17 40  
			and #$03           																		; $feba: 29 03     
			cmp #$01           																		; $febc: c9 01     
			ror vPlayer2Input            																		; $febe: 66 0b     
			dex                																		; $fec0: ca        
			bne __inputStacking         																		; $fec1: d0 eb  
			
			; advance to next game cycle
			inc vCycleCounter            																		; $fec3: e6 09     
			rts                																		; $fec5: 60        

;-------------------------------------------------------------------------------
__enableNMI:     
			lda vPPUController            																		; $fec6: a5 06     
			ora #$80           																		; $fec8: 09 80     
			sta vPPUController            																		; $feca: 85 06     
			sta ppuControl          																		; $fecc: 8d 00 20  
			rts                																		; $fecf: 60        

;-------------------------------------------------------------------------------
__disableNMI:     
			lda vPPUController            																		; $fed0: a5 06     
			and #$7f           																		; $fed2: 29 7f     
			sta vPPUController            																		; $fed4: 85 06     
			sta ppuControl          																		; $fed6: 8d 00 20  
			rts                																		; $fed9: 60        

;-------------------------------------------------------------------------------
__setPPUIncrementBy1:     
			lda vPPUController            																		; $feda: a5 06     
			and #$fb           																		; $fedc: 29 fb     
			sta vPPUController            																		; $fede: 85 06     
			sta ppuControl          																		; $fee0: 8d 00 20  
			rts                																		; $fee3: 60        

;-------------------------------------------------------------------------------
__setPPUIncrementBy32:     
			lda vPPUController            																		; $fee4: a5 06     
			ora #$04           																		; $fee6: 09 04     
			sta vPPUController            																		; $fee8: 85 06     
			sta ppuControl          																		; $feea: 8d 00 20  
			rts                																		; $feed: 60        

;-------------------------------------------------------------------------------
__disableDrawing:     
			lda #$00           																		; $feee: a9 00     
			sta ppuMask          																		; $fef0: 8d 01 20  
			rts                																		; $fef3: 60        

;-------------------------------------------------------------------------------
; wow - another unused function
			lda vPPUMask            																		; $fef4: a5 07     
			sta ppuMask          																		; $fef6: 8d 01 20  
			rts                																		; $fef9: 60        

;-------------------------------------------------------------------------------
__give10Score:     
			ldx #$01           																		; $fefa: a2 01     
			jmp __addPlayerScore         																		; $fefc: 4c 21 ff  

;-------------------------------------------------------------------------------
; wow - an unused function
			clc                																		; $feff: 18        
			adc #$01           																		; $ff00: 69 01     
			cmp #$0a           																		; $ff02: c9 0a     
				bne __storePlayerScore         																		; $ff04: d0 0b     
			lda #$00           																		; $ff06: a9 00     
			sta vPlayerScore,x        																		; $ff08: 9d 00 01  
			inx                																		; $ff0b: e8        
			cpx #$08           																		; $ff0c: e0 08     
				bne __addPlayerScore         																		; $ff0e: d0 11     
			rts                																		; $ff10: 60        

;-------------------------------------------------------------------------------
__storePlayerScore:     
			sta vPlayerScore,x        																		; $ff11: 9d 00 01  
			rts                																		; $ff14: 60        

;-------------------------------------------------------------------------------
__give100Score:     
			ldx #$02           																		; $ff15: a2 02     
			jmp __addPlayerScore         																		; $ff17: 4c 21 ff  

;-------------------------------------------------------------------------------
__give1000Score:     
			ldx #$03           																		; $ff1a: a2 03     
			jmp __addPlayerScore         																		; $ff1c: 4c 21 ff  

;-------------------------------------------------------------------------------
			ldx #$01           																		; $ff1f: a2 01     
__addPlayerScore:     
			lda vDemoSequenceActive          																		; $ff21: ad 73 02  
				bne __return9         																		; $ff24: d0 14     
			lda vPlayerScore,x        																		; $ff26: bd 00 01  
			clc                																		; $ff29: 18        
			adc #$01           																		; $ff2a: 69 01     
			cmp #$0a           																		; $ff2c: c9 0a     
				bne __storePlayerScore         																		; $ff2e: d0 e1     
			lda #$00           																		; $ff30: a9 00     
			sta vPlayerScore,x        																		; $ff32: 9d 00 01  
			inx                																		; $ff35: e8        
			cpx #$08           																		; $ff36: e0 08     
				bne __addPlayerScore         																		; $ff38: d0 e7     
__return9:     
			rts                																		; $ff3a: 60        

;-------------------------------------------------------------------------------
; the last function in game loop that will prepare RAM copy of OAM sprite table for upload to PPU
__composeOAMTable:     
			ldy #$00           																		; $ff3b: a0 00     
			lda vCycleCounter            																		; $ff3d: a5 09     
			and #$01           																		; $ff3f: 29 01     
				bne __composeOAMPart2         																		; $ff41: d0 03     
			jmp __composeOAMPart1         																		; $ff43: 4c 98 ff  

;-------------------------------------------------------------------------------
__composeOAMPart2:     
			lda vSpriteTable,y        																		; $ff46: b9 00 07  
			; sprite data is delayed by one scanline
			clc                																		; $ff49: 18        
			adc #$ff           																		; $ff4a: 69 ff     
			sta vOAMPosY,y        																		; $ff4c: 99 04 06  
			
			ldx $0701,y        																		; $ff4f: be 01 07  
			lda __spriteData2,x       																		; $ff52: bd 4c d3  
			sta vOAMTileIndex,y        																		; $ff55: 99 05 06  
			lda __spriteAtrrib2,x       																		; $ff58: bd eb d3  
			sta vOAMAttributes,y        																		; $ff5b: 99 06 06
			; shift sprites 8 pixels right to simulate partial drawn sprites
			lda $0703,y        																		; $ff5e: b9 03 07  
			clc                																		; $ff61: 18        
			adc #$08           																		; $ff62: 69 08     
			sta vOAMPosX,y        																		; $ff64: 99 07 06  
			iny                																		; $ff67: c8        
			iny                																		; $ff68: c8        
			iny                																		; $ff69: c8        
			iny                																		; $ff6a: c8        
			cpy #$7c           																		; $ff6b: c0 7c     
				bne __composeOAMPart2         																		; $ff6d: d0 d7     
			
			ldy #$80           																		; $ff6f: a0 80     
			
__composeOAMPart2Next:     
			lda $0680,y        																		; $ff71: b9 80 06  
			clc                																		; $ff74: 18        
			adc #$ff           																		; $ff75: 69 ff     
			sta vOAMPosY,y        																		; $ff77: 99 04 06  
			ldx $0681,y        																		; $ff7a: be 81 06  
			lda __spriteData1,x       																		; $ff7d: bd 0e d2  
			sta vOAMTileIndex,y        																		; $ff80: 99 05 06  
			lda __spriteAtrrib1,x       																		; $ff83: bd ad d2  
			sta vOAMAttributes,y        																		; $ff86: 99 06 06  
			lda $0683,y        																		; $ff89: b9 83 06  
			sta vOAMPosX,y        																		; $ff8c: 99 07 06  
			iny                																		; $ff8f: c8        
			iny                																		; $ff90: c8        
			iny                																		; $ff91: c8        
			iny                																		; $ff92: c8        
			cpy #$fc           																		; $ff93: c0 fc     
				bne __composeOAMPart2Next         																		; $ff95: d0 da     
			rts                																		; $ff97: 60        

;-------------------------------------------------------------------------------
__composeOAMPart1:     
			lda vSpriteTable,y        																		; $ff98: b9 00 07  
			; sprite data is delayed by one scanline
			clc                																		; $ff9b: 18        
			adc #$ff           																		; $ff9c: 69 ff     
			sta vOAMPosY,y        																		; $ff9e: 99 04 06  
			
			ldx $0701,y        																		; $ffa1: be 01 07  
			lda __spriteData1,x       																		; $ffa4: bd 0e d2  
			sta vOAMTileIndex,y        																		; $ffa7: 99 05 06  
			lda __spriteAtrrib1,x       																		; $ffaa: bd ad d2  
			sta vOAMAttributes,y        																		; $ffad: 99 06 06  
			lda $0703,y        																		; $ffb0: b9 03 07  
			sta vOAMPosX,y        																		; $ffb3: 99 07 06  
			iny                																		; $ffb6: c8        
			iny                																		; $ffb7: c8        
			iny                																		; $ffb8: c8        
			iny                																		; $ffb9: c8        
			cpy #$7c           																		; $ffba: c0 7c     
				bne __composeOAMPart1         																		; $ffbc: d0 da     
			
			ldy #$80           																		; $ffbe: a0 80     
__composeOAMPart1Next:     
			lda $0680,y        																		; $ffc0: b9 80 06  
			clc                																		; $ffc3: 18        
			adc #$ff           																		; $ffc4: 69 ff     
			sta vOAMPosY,y        																		; $ffc6: 99 04 06  
			ldx $0681,y        																		; $ffc9: be 81 06  
			lda __spriteData2,x       																		; $ffcc: bd 4c d3  
			sta vOAMTileIndex,y        																		; $ffcf: 99 05 06  
			lda __spriteAtrrib2,x       																		; $ffd2: bd eb d3  
			sta vOAMAttributes,y        																		; $ffd5: 99 06 06  
			
			; shift sprites 8 pixels right to simulate partial drawn sprites
			lda $0683,y        																		; $ffd8: b9 83 06  
			clc                																		; $ffdb: 18        
			adc #$08           																		; $ffdc: 69 08     
			sta vOAMPosX,y        																		; $ffde: 99 07 06  
			iny                																		; $ffe1: c8        
			iny                																		; $ffe2: c8        
			iny                																		; $ffe3: c8        
			iny                																		; $ffe4: c8        
			cpy #$fc           																		; $ffe5: c0 fc     
				bne __composeOAMPart1Next         																		; $ffe7: d0 d7     
			rts                																		; $ffe9: 60        

;-------------------------------------------------------------------------------
__dummy:     rts                																		; $ffea: 60        

;-------------------------------------------------------------------------------
			.hex ff ff ff      																		; $ffeb: ff ff ff  Invalid Opcode - ISC $ffff,x
			.hex ff ff ff      																		; $ffee: ff ff ff  Invalid Opcode - ISC $ffff,x
			.hex ff ff ff      																		; $fff1: ff ff ff  Invalid Opcode - ISC $ffff,x
			.hex ff ff ff      																		; $fff4: ff ff ff  Invalid Opcode - ISC $ffff,x
			.hex ff ff ff      																		; $fff7: ff ff ff  Invalid Opcode - ISC $ffff,x

;-------------------------------------------------------------------------------
; Vector Table
;-------------------------------------------------------------------------------
vectors:    .dw nmi                        																		; $fffa: 8a fd     Vector table
			.dw reset                      																		; $fffc: 27 fd     Vector table
			.dw irq                        																		; $fffe: 27 fd     Vector table

;-------------------------------------------------------------------------------
; CHR-ROM
;-------------------------------------------------------------------------------
			.incbin BirdWeek.chr ; Include CHR-ROM
