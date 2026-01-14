INCLUDE Irvine32.inc

.data

bufferSize BYTE 20

rows    db 20
cols    db 20

grid    db 20*20 DUP (0)

space db "  ", 0

randomLine db "--------------------------------------", 0

gameTitle db " RUSH HOUR ", 0
menuHeading db "MENU", 0
option1 db "1. Start a New Game", 0
option2 db "2. Continue the Game", 0
option3 db "3. Change Difficulty Level", 0
option4 db "4. View the Leader Board", 0
option5 db "5. Read the Instructions menu", 0

prompt1 db "Enter choice (insert number only): ", 0
choice db ?


taxiColorHeading db "CHOOSE YOUR CAR COLOR", 0
yellowCar db "1. Yellow", 0
redCar db "2. Red", 0
defaultChoice db "3. Random selection", 0
carChoice db ?


prompt2 db "Enter your name (max 20 characters): ", 0
playerName db 20 DUP (0)
nameHeading db "Driver: ", 0

randomStr db "Lets play now!", 0

playerX db 15
playerY db 3
oldX db 15
oldY db 3

instrHeading db "INSTRUCTIONS", 0
instr1 db "1. Use WASD for movement", 0
instr2 db "2. Make sure to read map labels next to game", 0
instr3 db "3. Press R to refresh if the board is not correct :3", 0
instr4 db "4. Hitting objects will deduct score using following criteria", 0
instr4a db "> Hitting a person (NPC or passenger): -5", 0
instr4b db "> Hitting walls: -1", 0
instr4c db "[Red Taxi]: ",0
instr4d db "> Obstacle (tree or box): -2", 0
instr4e db "> Another car: -3", 0
instr4f db "[Yellow Car]: ", 0
instr4g db "> Obstacle (tree or box): -4", 0
instr4h db "> Another car: -2", 0


goBack db "Press 'B' or 'b' to go back to previous screen.", 0
isBack db 0
goBack2 db "Press 'B' or 'b' to pause the game and later press '2' to continue.", 0
pauseL db "Press 'P' or 'p' to pause the game and resume it again", 0

score sbyte 5
scoreHeading db "Score: ", 0

;boolean flags basically
isObstacle db 0
isNPCperson db 0
istree db 0
isNPCcar db 0
isBuilding db 0
wrongMove db 0

i db 0
j db 0


road db "Road", 0
building db "Building", 0
npcPerson db "NPC Preson", 0
npcCar db "NPC Car", 0
tree db "Tree", 0
obs db "Obstacle", 0
you db "You", 0
passenger db "Passengers ", 0
dropLocation db "Drop Position", 0

isPaused db 0
pauseLine db "Your game has been paused!", 0
resumeLine db "your game has resumed", 0

passengerX db 5 DUP(0)
passengerY db 5 DUP(0)
isPassenger db 0
isPicked db 5 DUP(0)
tempX db 0
tempY db 0

isPicking db 0
dropX db 0
dropY db 0


;messages:
msgPicked db "You have picked up passenger.",0
msgDropped db "You have dropped off the passenger", 0
msgisPicking db "You can not pick up another passenger rn!", 0
msgHit db "You have hit an obstacle!! Be careful!", 0

gameOverStr db "GAME OVER! YOU DIED!!", 0

.code
main PROC
;-----------------------------------------------------------Menu display------------------------------------------------
displayMenu:

    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0

    call Randomize

    mov dl, 15
    mov dh, 0
    call Gotoxy

    mov eax, green + (black * 16)
    call SetTextColor

    mov edx, offset randomLine
    call WriteString

    mov dl, 27
    mov dh, 1
    call Gotoxy

    mov edx, offset gameTitle
    call WriteString

    mov dl, 15
    mov dh, 2
    call Gotoxy

    mov edx, offset randomLine
    call WriteString

    mov dl, 29
    mov dh, 5
    call Gotoxy

    mov edx, offset menuHeading
    call WriteString

    mov dl, 17
    mov dh, 7
    call Gotoxy

    mov edx, offset option1
    call WriteString

    mov dl, 17
    mov dh, 8
    call Gotoxy

    mov edx, offset option2
    call WriteString

    mov dl, 17
    mov dh, 9
    call Gotoxy

    mov edx, offset option3
    call WriteString

    mov dl, 17
    mov dh, 10
    call Gotoxy

    mov edx, offset option4
    call WriteString

    mov dl, 17
    mov dh, 11
    call Gotoxy

    mov edx, offset option5
    call WriteString

    mov dl, 17
    mov dh, 13
    call Gotoxy

    mov edx, offset prompt1
    call WriteString

    mov eax, magenta + (black*16)
    call SetTextColor

    mov eax, 0
    call ReadDec
    mov choice, al

    cmp choice, 1
    je SelectGameControls

    cmp choice, 5
    je readIntsr

    cmp choice, 2
    cmp isBack, 1
    jne displayMenu
    jmp continueGame

    ;else
    jmp displayMenu

    readIntsr:
        mov al, 1
        call WriteDec
        call displayInstructions
        jmp displayMenu

    SelectGameControls:
    ;---------------------------------------------------game controls-----------------------------------------------------------
    call Clrscr

    mov eax, green + (black*16)
    call SetTextColor

    mov dl, 15
    mov dh, 0
    call Gotoxy

    mov edx, offset randomLine
    call WriteString

    mov dl, 23
    mov dh, 1
    call Gotoxy

    mov edx, offset taxiColorHeading
    call WriteString

    mov dl, 15
    mov dh, 2
    call Gotoxy

    mov edx, offset randomLine
    call WriteString

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov dl, 15
    mov dh, 4
    call Gotoxy

    mov edx, offset yellowCar
    call WriteString

    mov eax, red + (black * 16)
    call SetTextColor

    mov dl, 27
    mov dh, 4
    call Gotoxy

    mov edx, offset redCar
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor

    mov dl, 36
    mov dh, 4
    call Gotoxy

    mov edx, offset defaultChoice
    call WriteString

    mov eax, green + (black * 16)
    call SetTextColor

    mov dl, 15
    mov dh, 6
    call Gotoxy

    mov edx, offset prompt1
    call WriteString

    mov eax, magenta + (black * 16)
    call SetTextColor

    call ReadDec
    
    cmp al, 3
    je randomcarChoice

    cmp al, 2
    jg randomcarChoice

    cmp al, 0
    jle randomcarChoice

    mov carChoice, al
    jmp nextStep

    randomcarChoice:
        mov eax, 2 ;bound
        call RandomRange ;0 or 1
        inc eax
        mov carChoice, al

    nextStep:

    mov dl, 15
    mov dh, 7
    call Gotoxy

    mov eax, green + (black*16)
    call SetTextColor

    mov edx, offset prompt2
    call WriteString

    mov eax, magenta + (black*16)
    call SetTextColor

    mov edx, offset playerName
    mov cl, bufferSize
    call ReadString

    
    ;----------------------game start------------------------
    call initializeGrid
    call resetFlags
    mov playerX, 15
    mov playerY, 3
    mov isPicking, 0
    mov score, 5
    

    continueGame:
    call Game

    cmp isBack, 1
    je displayMenu



    
main ENDP

;---------------------------------------------------------display instructions-----------------------------------------------------------
displayInstructions PROC
    
    call Clrscr

    mov dl, 15
    mov dh, 0
    call Gotoxy

    mov eax, green + (black * 16)
    call SetTextColor

    mov edx, offset randomLine
    call WriteString

    mov dl, 27
    mov dh, 1
    call Gotoxy

    mov edx, offset instrHeading
    call WriteString

    mov dl, 15
    mov dh, 2
    call Gotoxy

    mov edx, offset randomLine
    call WriteString

    mov eax, cyan + (black * 16)
    call SetTextColor

    mov dl, 14
    mov dh, 5
    call Gotoxy

    mov edx, offset instr1
    call WriteString

    mov dl, 14
    mov dh, 6
    call Gotoxy

    mov edx, offset instr2
    call WriteString

    mov dl, 14
    mov dh, 7
    call Gotoxy

    mov edx, offset instr3
    call WriteString

    mov dl, 14
    mov dh, 8
    call Gotoxy

    mov edx, offset instr4
    call WriteString

    mov dl, 14
    mov dh, 10
    call Gotoxy

    mov edx, offset instr4a
    call WriteString

    mov dl, 14
    mov dh, 11
    call Gotoxy

    mov edx, offset instr4b
    call WriteString

    mov dl, 14
    mov dh, 12
    call Gotoxy

    mov eax, red + (black*16)
    call SetTextColor

    mov edx, offset instr4c
    call WriteString

    mov eax, cyan + (black*16)
    call SetTextColor

    mov dl, 14
    mov dh, 13
    call Gotoxy

    mov edx, offset instr4d
    call WriteString

    mov dl, 14
    mov dh, 14
    call Gotoxy

    mov edx, offset instr4e
    call WriteString

    mov dl, 45
    mov dh, 12
    call Gotoxy

    mov eax, yellow + (black*16)
    call SetTextColor

    mov edx, offset instr4f
    call WriteString

    mov eax, cyan + (black*16)
    call SetTextColor

    mov dl, 45
    mov dh, 13
    call Gotoxy

    mov edx, offset instr4g
    call WriteString

    mov dl, 45
    mov dh, 14
    call Gotoxy

    mov edx, offset instr4h
    call WriteString



    mov dl, 14
    mov dh, 19
    call Gotoxy

    mov eax, green + (black * 16)
    call SetTextColor

    mov edx, offset goBack
    call WriteString

    call crlf
    call ReadChar
    cmp al, 'B'
    jmp returnBack

    cmp al, 'b'
    jmp returnBack

    returnBack:
        call Clrscr
        ret

displayInstructions endp

;--------------------------------------------------------------initialize grid------------------------------------------------------------
initializeGrid PROC

    

    mov eax, 0
    mov al, rows
    mul cols
    mov ecx, eax ;total cells
    mov edi, offset grid

    loop1:
        mov eax, 10
        call RandomRange

        cmp al, 3
        jl set1

        ;set 0  
        mov byte ptr [edi], 0
        jmp cont

        set1:
            mov byte ptr [edi], 1
            
        cont:
            inc edi
            loop loop1


    ;Initial player position 
    mov edi, offset grid
    mov bl, 'z'
    mov [edi], bl

    ;Hardcoding trees
    mov ecx, 4 ;4 trees
    loop2:
        add edi, 50
        mov bl, 't'
        add edi, 7
        mov [edi], bl
        loop loop2

    
    ;Hardcoding random obstacles
    mov edi, offset grid
    mov ecx, 3
    loop3:
        add edi, 94
        mov bl, 'o'
        mov [edi], bl
        loop loop3

    ;Hardcoding NPCs
    mov edi, offset grid
    mov ecx, 3
    loop4:
        add edi, 97
        mov bl, 'n'
        
        mov [edi], bl
        loop loop4


    call initializePassengerCoordinates
    call generateDropCoordinates
    call resetFlags
        

    ret
exit
initializeGrid ENDP

;-----------------------------------------------------------passenger pickup and drop off----------------------------------------------------------

initializePassengerCoordinates PROC

    mov ecx, 5
    mov esi, offset isPicked
    mov eax, 0
    initializePick:
        mov byte ptr [esi], 0
        inc esi
    loop initializePick


    mov ecx, 5
    mov esi, offset passengerX
    mov edi, offset passengerY

    generateAgain:
        initializeX:
            mov eax, 39
            call RandomRange
            add eax, 15
            test al, 1 ;checking if random num is odd or even
            jnz initializeY ;if odd then move forward

            ;for even:
            inc eax ;make it odd :)

        initializeY:
            mov tempX, al
            mov eax, 20
            call RandomRange
            add eax, 3
            mov tempY, al

        ;now check tempX = xCord, tempY = yCord and let's check with grid array

        call getIndex2

        mov al, [edx]

        cmp al, 1 ;if building then regenerate
        je generateAgain

        cmp al, 'o'
        je generateAgain

        cmp al, 't'
        je generateAgain

        cmp al, 'n'
        je generateAgain
        
        cmp al, 'z' ;top left corner
        je generateAgain

        mov dl, tempX
        mov [esi], dl
        mov dh, tempY
        mov [edi], dh
        inc esi
        inc edi
        loop generateAgain




    ret

initializePassengerCoordinates endp

getIndex2 PROC

    mov al, tempY
    sub al, 3 ;-3 from yCord
    mov i, al ;row index

    mov al, tempX ;moving xCord to al
    sub al, 15  ;-15 from xCord
    mov bl, 2
    shr al, 1
    mov j, al ;col index

    mov edx, offset grid

    mov eax, 0
    mov al, i
    mov bl, 20
    mul bl
    add edx, eax ;edx moved to desired ith row

    mov ebx, 0
    mov bl, j
    add edx, ebx ;edx moved to desired jth col

    ret

getIndex2 endp

printPassengers PROC

    mov esi, offset passengerX
    mov edi, offset passengerY
    mov ebx, offset isPicked
    mov ecx, 4

    printPass:
        mov dl, byte ptr [esi]
        mov dh, byte ptr [edi]
        call Gotoxy

        mov al, [ebx]
        cmp al, 0
        jne picked

        mov eax, cyan + (cyan * 16)
        call SetTextcolor
        mov edx, offset space
        call WriteString
        jmp done

            picked:
                mov eax, white + (white * 16)
                call SetTextcolor
                mov edx, offset space
                call WriteString
        
        done:
            inc esi
            inc edi
            inc ebx
        loop printPass

    mov eax, 7
    call SetTextColor
    ret

printPassengers endp


pickUpPassenger PROC

    mov dl, playerX
    mov dh, playerY
    
    mov esi, offset passengerX
    mov edi, offset passengerY
    mov ebx, offset isPicked
    mov eax, 0
    mov ecx, 5

    searching:
        mov al, [esi]
        mov ah, [edi]

        cmp al, dl
        jne notThis

        cmp ah, dh
        jne notThis

        mov byte ptr [ebx], 1

        notThis:
            inc esi
            inc edi
            inc ebx
    loop searching

    

    ret
    
pickUpPassenger endp

generateDropCoordinates PROC
    
    mov dl, playerX ;passenger X
    mov dh, playerY ;passenger Y

    generate: 
        generateX:
            mov eax, 39
            call RandomRange
            add eax, 15
            test al, 1 ;checking if random num is odd or even
            jnz issameAsPlayerX

            ;for even:
                inc eax ;make it odd :) 

            issameAsPlayerX:
                cmp al, dl
                je generateX

                mov dropX, al

        generateY:
            mov eax, 20
            call RandomRange
            add eax, 3

            cmp al, dh
            je generateY

            mov dropY, al

        ;convert dropX and dropY to indexes

        mov al, dropY
        sub al, 3
        mov i, al ;row index

        mov al, dropX
        sub al, 15
        mov bl, 2
        shr al, 1
        mov j, al ;col index

        mov esi, offset grid

        mov eax, 0
        mov al, i
        mov bl, 20
        mul bl
        add esi, eax ;esi moved to desired ith row

        mov ebx, 0
        mov bl, j
        add esi, ebx ;esi moved to desired jth col

        mov eax, [esi]

        cmp al, 1
        je generate

        cmp al, 'o'
        je generate

        cmp al, 't'
        je generate

        cmp al, 'n'
        je generate 



    ret

generateDropCoordinates endp


printDropPosition PROC

    cmp isPicking, 0
    je doNothing

        mov dl, dropX
        mov dh, dropY
        call Gotoxy

        mov eax, lightCyan + (lightCyan * 16)
        call SetTextColor

        mov edx, offset space
        call WriteString

        mov eax, 7
        call SetTextColor

    doNothing:

    ret
printDropPosition endp

dropPassenger PROC

    mov dl, dropX
    mov dh, dropY
    call Gotoxy

    mov eax, white + (white*16)
    call SetTextColor


    mov isPicking, 0

    add score, 10
    call printScore

    ret

dropPassenger endp

;----------------------------------------------------------main game loop---------------------------------------------------------------
Game PROC
    
    call Clrscr

    gameLoop:

        cmp score, 0
        jle endGame

        call GameDisplay
        call printPassengers
        call printDropPosition
        mov dl, playerX
        mov dh, playerY
        call printPlayerProc
        
        
        call ReadChar

        cmp isPaused, 1
        jne continueNormalGame

            cmp al, 'p'
            je resume

            cmp al, 'P'
            je resume

        mov dl, 20
        mov dh, 24
        call Gotoxy
        mov eax, cyan + (black * 16)
        call SetTextColor
        mov edx, offset pauseLine
        call WriteString
        jmp gameLoop

        resume:
            mov isPaused, 0
            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, black + (black * 16)
            call SetTextColor
            mov edx, offset pauseLine
            call WriteString
            jmp gameLoop

        continueNormalGame:

        cmp al, 'B'
        je goBackToMenu

        cmp al, 'b'
        je goBackToMenu

        cmp al, 'R'
        je refresh

        cmp al, 'r'
        je refresh

        cmp al, 'W'
        je moveUp

        cmp al, 'w'
        je moveup

        cmp al, 'A'
        je moveLeft

        cmp al, 'a'
        je moveLeft

        cmp al, 'S'
        je moveDown

        cmp al, 's'
        je moveDown

        cmp al, 'D'
        je moveRight

        cmp al, 'd'
        je moveRight

        cmp al, 32
        je isInPickingMode

        cmp al, 'p'
        je pauseGame

        cmp al, 'P'
        je pauseGame

        jmp gameLoop

        moveUp:
            cmp playerY, 3
            je updateScoreW

            ;update player coordinates
            mov bl, playerY
            mov oldY, bl
            dec bl
            mov playerY, bl

            ;check validity of movement
            call isInvalid

            cmp wrongMove, 1
            je resetCoordnates1
            jmp checkIfPassenger

            ;reset coordinates if invalid
            resetCoordnates1:
                inc playerY
                inc oldY
                call updateScore
                call resetFlags
                jmp validMove1

            checkIfPassenger:
                call isPassengerProc
                cmp isPassenger, 1
                je resetCoordnates1
                
            validMove1:
            call printPlayerProc
            jmp gameLoop
            
        moveDown:
            cmp playerY, 22
            je updateScoreW

            ;update player coordinates
            mov bl, playerY
            mov oldY, bl
            inc bl
            mov playerY, bl

            ;check validity of movement
            call isInvalid

            cmp wrongMove, 1
            je resetCoordnates2
            jmp checkIfPassenger2

            ;reset coordinates if invalid
            resetCoordnates2:
                dec playerY
                dec oldY
                call updateScore
                call resetFlags
                jmp validMove2

            checkIfPassenger2:
                call isPassengerProc
                cmp isPassenger, 1
                je resetCoordnates2

            validMove2:
            call printPlayerProc
            jmp gameLoop

        moveLeft:
            cmp playerX, 15
            je updateScoreW

            ;update player coordinates
            mov bl, playerX
            mov oldX, bl
            sub bl, 2
            mov playerX, bl

            ;check validity of movement
            call isInvalid

            cmp wrongMove, 1
            je resetCoordnates3
            jmp checkIfPassenger3

            ;reset coordinates if invalid
            resetCoordnates3:
                add playerX, 2
                add oldX, 2
                call updateScore
                call resetFlags
                jmp validMove3

            checkIfPassenger3:
                call isPassengerProc
                cmp isPassenger, 1
                je resetCoordnates3


            validMove3:
            call printPlayerProc
            jmp gameLoop

        moveRight:
            cmp playerX, 53
            je updateScoreW

            ;update player coordinates
            mov bl, playerX
            mov oldX, bl
            add bl, 2
            mov playerX, bl

            ;check validity of movement
            call isInvalid

            cmp wrongMove, 1
            je resetCoordnates4
            jmp checkIfPassenger4

            ;reset coordinates if invalid
            resetCoordnates4:
                sub playerX, 2
                sub oldY, 2
                call updateScore
                call resetFlags
                jmp validMove4

            checkIfPassenger4:
                call isPassengerProc
                cmp isPassenger, 1
                je resetCoordnates4

            validMove4:
            call printPlayerProc
            jmp gameLoop

        goBackToMenu:
            call Clrscr
            mov isBack, 1
            ret

        refresh:
            mov playerX, 15
            mov playerY, 3
            call initializeGrid
            call printPlayerProc
            mov isPicking, 0

            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, black + (black * 16)
            call SetTextColor
            mov edx, offset msgDropped
            call WriteString
            mov edx, offset msgPicked
            call WriteString
            mov edx, 0

            
            jmp gameLoop

        updateScoreW:
                mov bl, score
                dec bl
                mov score, bl
                call printScore
                jmp gameLoop

        pauseGame:
            mov isPaused, 1
            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, black + (black * 16)
            call SetTextColor
            mov edx, offset msgDropped
            call WriteString
            mov edx, 0
            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, black + (black * 16)
            call SetTextColor
            mov edx, offset msgPicked
            call WriteString
            mov edx, 0
            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, cyan + (black * 16)
            call SetTextColor
            mov edx, offset pauseLine
            call WriteString

            jmp gameLoop


        isInPickingMode:
            cmp isPicking, 0
            je pickUp
            jmp drop
            
            
        pickUp:

            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, black + (black * 16)
            call SetTextColor
            mov edx, offset msgDropped
            call WriteString
            mov edx, 0

            ;if player on right
            add playerX, 2
            call isPassengerProc
            cmp isPassenger, 1
            je a

            sub playerX, 2
            jmp checkNext

            a:
                call pickUpPassenger  ;passenger removed from map and score++
                call generateDropCoordinates
                sub playerX, 2
                mov isPicking, 1
                mov isPassenger, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgPicked
                call WriteString
                mov edx, 0
            
            jmp gameLoop

            checkNext:
            ;if on left
            sub playerX, 2
            call isPassengerProc
            cmp isPassenger, 1
            je b

            add playerX, 2
            jmp checkNext2

            b:
                call pickUpPassenger
                call generateDropCoordinates
                add playerX, 2
                mov isPicking, 1
                mov isPassenger, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgPicked
                call WriteString
                mov edx, 0

            jmp gameLoop

            checkNext2:
            ;if down
            inc playerY
            call isPassengerProc
            cmp isPassenger, 1
            je cc

            dec playerY
            jmp checkNext3

            cc:
                call pickUpPassenger
                call generateDropCoordinates
                dec playerY
                mov isPicking, 1
                mov isPassenger, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgPicked
                call WriteString
                mov edx, 0
            
            jmp gameLoop

            checkNext3:
            ;if up
            dec playerY
            call isPassengerProc
            cmp isPassenger, 1
            je d

            inc playerY
            jmp gameLoop

            d:
                call pickUpPassenger
                call generateDropCoordinates
                inc playerY
                mov isPicking, 1
                mov isPassenger, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgPicked
                call WriteString
                mov edx, 0
            
            jmp gameLoop

        drop:
            
            mov dl, 20
            mov dh, 24
            call Gotoxy
            mov eax, black + (black * 16)
            call SetTextColor
            mov edx, offset msgPicked
            call WriteString
            mov edx, 0

            ;if drop on right
            mov bl, playerX
            add bl, 2
            cmp bl, dropX
            je e

            jmp checkNext4

            e:
                mov bl, playerY
                cmp bl, dropY
                jne checkNext4

                call dropPassenger
                mov isPicking, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgDropped
                call WriteString
                mov edx, 0
            
            jmp gameLoop

            checkNext4:
            ;if on left
            mov bl, playerX
            sub bl, 2
            cmp bl, dropX
            je f

            jmp checkNext5

            f:
                mov bl, playerY
                cmp bl, dropY
                jne checkNext5

                call dropPassenger
                mov isPicking, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgDropped
                call WriteString
                mov edx, 0

            jmp gameLoop

            checkNext5:
            ;if down
            mov bl, playerY
            inc bl
            cmp bl, dropY
            je g

            jmp checkNext6

            g:
                mov bl, playerX
                cmp bl, dropX
                jne checkNext6

                call dropPassenger
                mov isPicking, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgDropped
                call WriteString
                mov edx, 0
            
            jmp gameLoop

            checkNext6:
            ;if up
            mov bl, playerY
            dec bl
            cmp bl, dropY
            je h

            jmp gameLoop

            h:
                mov bl, playerX
                cmp bl, dropX
                jne gameLoop

                call dropPassenger
                mov isPicking, 0

                mov dl, 20
                mov dh, 24
                call Gotoxy
                mov eax, cyan + (black * 16)
                call SetTextColor
                mov edx, offset msgDropped
                call WriteString
                mov edx, 0
            
            jmp gameLoop

            endGame:
                call gameOver
    ret
exit
Game ENDP

;------------------------------------------------------------display player--------------------------------------------------------------------

printPlayerProc PROC

    mov dl, oldX
    mov dh, oldY
    call Gotoxy
    mov eax, white + (yellow * 16)
    call SetTextColor

    mov dl, playerX ;placement
    mov dh, playerY
    call Gotoxy
    

    cmp carChoice, 1
    jne Redlabel
    mov eax, yellow + (yellow * 16)
    jmp nextt

    Redlabel:
        mov eax, red + (red * 16)

    nextt:
    call SetTextColor
    mov edx, offset space
    call WriteString

    mov eax, 7
    call SetTextColor


    ret
exit
printPlayerProc ENDP


;--------------------------------------------------------------movement helper functions----------------------------------------------------

isPassengerProc PROC

    mov isPassenger, 0

    mov dl, playerX
    mov dh, playerY

    mov esi, offset passengerX
    mov edi, offset passengerY
    mov ebx, offset isPicked

    mov ecx, 5

    checkLoop:
        mov al, [esi]
        mov ah, [edi]

        cmp al, dl
        jne notFound

        cmp ah, dh
        jne notFound

        mov al, byte ptr [ebx]
        cmp al, 1      ;picked 
        je notFound

        mov isPassenger, 1
        ret

    notFound:
        inc esi
        inc edi
        inc ebx
        loop checkLoop

    ret
isPassengerProc endp

resetFlags PROC

    mov isObstacle, 0
    mov isBuilding, 0
    mov isTree, 0
    mov isNPCperson, 0
    mov isNPCcar, 0
    mov wrongMove, 0
    mov isPassenger, 0
    ret
resetFlags endp

isInvalid PROC

    ;finding array indexes according to player's positionss
    call getIndex

    mov esi, offset grid
    ;we are at i=0 and j=0 currently

    ;moving i to desired row
    mov eax, 0
    mov al, i
    mov bl, 20
    mul bl
    add esi, eax ;esi moved to desired ith row

    mov ebx, 0
    mov bl, j
    add esi, ebx ;esi moved to desired jth col

    mov eax, 0
    mov al, [esi]

    cmp al, 'o'
    je isO

    cmp al, 't'
    je isT

    cmp al, 'n'
    je isN

    cmp al, 1
    je isB
    
    ret

    isO:
        mov isObstacle, 1
        jmp nexttt
    isT:
        mov isTree, 1
        jmp nexttt
    isN:
        mov isNPCperson, 1
        jmp nexttt
    isB:
        mov isBuilding, 1
        jmp nexttt

    nexttt:
        mov wrongMove, 1
        ret
        
isInvalid endp

getIndex PROC
    ;x = 15 and y = 3 means i = 0 and j = 0
    ;x = 17 and y = 4 means i = 1 and j = 1
    ;x = 19 and y = 5 means i = 2 and j = 2
    ;x = 23 and y = 5 means i = 2 and j = 4
    ;relation: i = (y-3) and j = (x-15)/2

    mov al, playerY
    sub al, 3
    mov i, al

    mov al, playerX
    sub al, 15
    mov bl, 2
    shr al, 1
    mov j, al

    ret
getIndex endp

;----------------------------------------------------updating score mechanism--------------------------------------------------------------

updateScore PROC

    cmp isBuilding, 1
    je bb

    cmp isNPCperson, 1
    je nn

    cmp isPassenger, 1
    je pp

    cmp isObstacle, 1
    je oo

    cmp isTree, 1
    je oo

    jmp done

    bb:
        sub score, 1
        jmp done
    nn:
        sub score, 5
        jmp done
    pp: 
        sub score, 5
        jmp done
    oo:
        cmp carChoice, 1
        je yellowScoring

        sub score, 2
        jmp done
        
        yellowScoring:
            sub score, 4
            jmp done

    done:
        call printScore
        ret


updateScore endp

;------------------------------------------------------------display game--------------------------------------------------------------------
GameDisplay PROC
    

    ;DISPLAY STARTS HERE:

    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0

    call printScore
    call drawMapInstr

    mov esi, OFFSET grid
    mov ebx, 3 ;row index ke hisab se y ki value

    rowLoop:
        mov edi, 15 ; column index at little away from edge according to x values
        mov cl, cols ;loop for columns

        colLoop:

            mov dh, bl ;row index so basically y value
            mov eax, edi  ; edi has col index so basically x value
            mov dl, al   ;moving col index/x value to dl
            call Gotoxy
            
           mov eax, 0
            mov al, [esi] ;array value

            cmp al, 1
            je printBuilding

            cmp al, 't'
            je printTree

            cmp al, 'o'
            je printObstacle

            cmp al, 'n'
            je printNPC

            ;else white road
            mov eax, black + (white * 16)
            call SetTextColor
            mov edx, offset space
            call WriteString
            jmp nextIter


            printBuilding:
                mov eax, 0
                mov eax, gray + (gray * 16)
                call SetTextColor
                mov edx, offset space
                call WriteString
                jmp nextIter

            printObstacle:
                call printObstacleProc
                jmp nextIter

            printTree:
                call printTreeProc
                jmp nextIter

            printNPC:
                call printNPCproc
                jmp nextIter
            nextIter:
                inc esi
                add edi, 2

            loop colLoop

        inc ebx
        mov eax, ebx
        sub eax, 3
        cmp al, rows
        jl rowLoop

    mov dl, 1
    mov dh, 27
    call Gotoxy

    mov eax, lightBlue + (black * 16)
    call SetTextColor
    mov edx, offset goBack2
    call WriteString
    call crlf
    mov dl, 1
    mov dh, 28
    call Gotoxy
    mov eax, lightBlue + (black * 16)
    call SetTextColor
    mov edx, offset pauseL
    call WriteString

    

    mov eax, 7
    call SetTextColor
    call crlf
       
    ret
exit
GameDisplay ENDP

drawMapInstr PROC
    
    mov dl, 60
    mov dh, 1
    call Gotoxy

    mov eax, white + (white * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset road
    call WriteString

    mov dl, 60
    mov dh, 3
    call Gotoxy

    mov eax, gray + (gray * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset building
    call WriteString

    mov dl, 60
    mov dh, 5
    call Gotoxy

    mov eax, magenta + (magenta * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset npcPerson
    call WriteString

    mov dl, 60
    mov dh, 7
    call Gotoxy

    mov eax, brown + (brown * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset obs
    call WriteString

    mov dl, 60
    mov dh, 9
    call Gotoxy

    mov eax, green + (green * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset tree
    call WriteString

    mov dl, 60
    mov dh, 11
    call Gotoxy

    mov eax, cyan + (cyan*16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTexTColor
    mov edx, offset space
    call WriteString 
    mov edx, offset passenger
    call WriteString

    mov dl, 60
    mov dh, 13
    call Gotoxy

    mov eax, lightCyan + (lightCyan*16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTexTColor
    mov edx, offset space
    call WriteString 
    mov edx, offset dropLocation
    call WriteString

    mov dl, 60
    mov dh, 15
    call Gotoxy

    cmp carChoice, 1
    je yellowCh
    mov eax, red + (red * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset you
    call WriteString
    mov eax, 7
    call SetTextColor
    ret

    yellowCh:
    mov eax, yellow + (yellow * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString 
    mov edx, offset you
    call WriteString

    mov eax, 7
    call SetTextColor
    ret
drawMapInstr endp
   
printScore PROC

    mov dl, 1
    mov dh, 2
    call Gotoxy

    mov eax, black + (black * 16)
    call SetTextColor

    mov ecx, 30
    loopppp:
        mov edx, offset space
        call WriteString
        loop loopppp


    mov dl, 1
    mov dh, 2
    call Gotoxy

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, offset scoreHeading
    call WriteString

    mov al, score
    call WriteDec

    mov dl, 1
    mov dh, 1
    call Gotoxy

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, offset nameHeading
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, offset playerName
    call WriteString

    ret
printScore endp

printObstacleProc PROC
    mov eax, brown + (brown * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    ret
exit
printObstacleProc ENDP

printTreeProc PROC
    mov eax, green + (green * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    ret
printTreeProc ENDP

printNPCproc PROC
    mov eax, magenta + (magenta * 16)
    call SetTextColor
    mov edx, offset space
    call WriteString
    ret
printNPCproc endp

;---------------------------------------------------game over-----------------------------------------------------

gameOver PROC

    call Clrscr

    mov dl, 30
    mov dh, 10

    call Gotoxy

    mov edx, offset gameOverStr
    call WriteString 

    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf

gameOver endp


END main
