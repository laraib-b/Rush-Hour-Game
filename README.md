## Rush Hour – Assembly Language Game

This repository contains an x86 assembly implementation of a **Rush Hour–style taxi game** written for the **Irvine32** framework on 32‑bit Windows.  
You control a taxi on a 20×20 grid, navigate traffic and obstacles, pick up passengers, and drop them at their destinations while managing your score.

### Features

- **Main menu**
  - Start a new game
  - Continue a paused game
  - Change difficulty level (not implemented yet)
  - View leader board (not implemented yet)
  - Read game instructions
- **Player customization**
  - Choose your taxi color: **Yellow**, **Red**, or **Random**
  - Enter a player name (shown as the driver)
- **Grid‑based world**
  - 20×20 grid stored in memory
  - Visual labels for tiles such as `Road`, `Building`, `NPC Car (static)`, `NPC Person`, `Tree`, `Obstacle`, `Passengers`, `Drop Position`
- **Passenger system**
  - Multiple potential passenger positions
  - Track whether each passenger is picked up or dropped off
- **Scoring system**
  - Start from a base score (5 points)
  - **Penalties**:
    - Hit a person (NPC or passenger): −5
    - Hit a wall: −1
    - Hit an obstacle (tree/box): −2 (Red taxi) / −4 (Yellow taxi)
    - Hit another car: −3 (Red taxi) / −2 (Yellow taxi)
  - Supports “Game Over” when you lose all score / crash (course‑specific behavior)
- **Pause & resume**
  - Pause and resume mid‑game, with an option to return to the main menu.

### Controls

- **Movement**: `W`, `A`, `S`, `D`
  - `W` – move up
  - `S` – move down
  - `A` – move left
  - `D` – move right
- **Game flow**
  - `P` / `p` – pause / resume the game
  - `B` / `b` – go back to the previous screen or pause menu (depending on context)
  - `R` / `r` – refresh/redraw the board if the display becomes inconsistent

Refer to the in‑game **INSTRUCTIONS** screen for the exact key bindings and penalty rules used in your build.

### Technical Overview

- **Language**: x86 assembly
- **Platform**: 32‑bit Windows console
- **Framework**: `Irvine32.inc` and Irvine32 library (Kip Irvine)
- **Main source file**: `RushHour.asm`
- **Key procedures** (high level)
  - `main` – initializes the program and displays the main menu
  - `displayInstructions` – shows instructions and scoring rules
  - `initializeGrid` – sets up the 20×20 grid
  - `Game` – core game loop (movement, collisions, passenger logic, score updates)
  - Various helper procedures to:
    - Draw the board and labels
    - Read keyboard input
    - Update the player and passenger states
    - Detect collisions and adjust score

### Prerequisites

- **Operating system**: Windows (32‑bit or 64‑bit with 32‑bit support)
- **Assembler & tools**
  - MASM with the **Irvine32** library (as provided in Kip Irvine’s “Assembly Language for x86 Processors” textbook package), or
  - A Visual Studio project preconfigured with `Irvine32.lib`, `kernel32.lib`, etc.
- **Irvine32 setup**
  - `Irvine32.inc` must be in the assembler’s include path.
  - `Irvine32.lib` must be linked at build time.

If you are using a course‑provided Visual Studio / MASM template, simply add the `.asm` file to that project and make sure `Irvine32.inc` is correctly referenced at the top of the file (already done in this project).

### Installing Irvine32 and Running This Game (Step‑by‑Step)

- **Step 1 – Install Irvine32 using the provided ZIP**
  - Download the `Irvine.zip` package from this link:  
    `https://github.com/syedalizain786/AssemblyConsoleApplication1/blob/master/Irvine.zip`
  - Extract the ZIP to a permanent folder, for example: `C:\Irvine`.

- **Step 2 – Watch the Visual Studio + Irvine32 setup video**
  - Follow this YouTube tutorial to set up Visual Studio with MASM and Irvine32:  
    **YouTube setup guide**: `https://www.youtube.com/watch?v=81UUI8kO1LE`
  - After following the video, you should have:
    - A working Visual Studio project configured for MASM,
    - Include and library paths pointing to the Irvine32 files,
    - The project set to the **Win32 (x86)** platform.
  - If the link doesn't work, follow any YouTube video for Irvine setup in your VS with MASM.

- **Step 3 – Copy/paste this game’s code into your project**
  - Open `RushHour.asm` from this GitHub repository.
  - Copy the entire contents of `RushHour.asm`.
  - In your configured Visual Studio project:
    - Either create a new `.asm` file and paste the code, **or**
    - Replace the contents of the existing sample `.asm` file with this code.
  - Save the file.

- **Step 4 – Build and run the game**
  - Build the project (e.g., `Ctrl+Shift+B`).
  - Fix any configuration issues if the linker cannot find `Irvine32.lib` (re‑check the video and your project properties).
  - Run the project (`F5`). A console window should open and display the **RUSH HOUR** main menu.

### Project Structure

- `RushHour.asm` – main game source code
- `RushHour.docx` – project/report document (design, explanation, and reflections)
- `README.md` – this documentation file for GitHub

### How the Game Works (High-Level Design)

- **Initialization**
  - Clear the console and display the **RUSH HOUR** title and main menu.
  - Random seed initialization (`Randomize`) for any randomized elements (e.g., random taxi color).
  - Set up the grid array (`grid`) in memory to represent the map.
- **Player selection**
  - Read the taxi color choice and validate input; fallback to random if out of range.
  - Prompt the user for a player name (`ReadString`) and store up to 20 characters.
- **Game loop**
  - Draw the board and the legend (road, buildings, NPCs, obstacles, passengers, drop positions).
  - Repeatedly:
    - Read keyboard input.
    - Update the taxi’s coordinates (`playerX`, `playerY`) based on WASD.
    - Check for collisions with grid entities and adjust score and flags (e.g., `isObstacle`, `isNPCperson`, `isNPCcar`, `istree`, `isBuilding`).
    - Handle passenger pickup / drop‑off and update related arrays (`passengerX`, `passengerY`, `isPicked`, `isPassenger`, `isPicking`, `dropX`, `dropY`).
    - Display feedback messages (picked, dropped, hit obstacle, game over, etc.).
  - Support pausing, resuming, or returning to the main menu using flags like `isPaused` and `isBack`.

### Academic Integrity

This project was developed as part of the **Coal Project Fall 2025 (BS‑DS)** course.  
If you are a student using this repository as a reference:

- **Do not copy the code verbatim** if your institution prohibits it.
- Use it to understand assembly concepts, game loops, and Irvine32 usage.
- Always follow your university’s academic integrity policy.

### Author

- **Name**: Laraib Butt
- **Program**: BS Data Science  
- **Course/Project**: Coal Project – Rush Hour Game (Fall 2025)

For any clarifications, you can refer to the accompanying PDF assignment specification and the Word report, which explain the game logic and design decisions in more detail.

