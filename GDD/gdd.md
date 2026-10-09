# Game Design Document (GDD)
### Team's Project Template

**Team: Computer Business**
**Authors: Calvin Nyeholt, Clara Siefke, Phoebe Tozer, Benjamin Whitsett**

## 1. Game Concept

**Working Title: Torn Asunder**  

**Genre: Sokoban**  

**Platform(s): Windows, Linux, (Web)**  

**Elevator Pitch (1-2 sentences): In a couch-co-op Sokoban, your character has been TORN ASUNDER. Two players escape through parallel worlds, interacting through "entangled blocks" that, when pushed, move in *both* universes.** 

**Target Audience: People who enjoy collaborative puzzle solving.** 


---

## 2. Core Loop

*Describe the main repeating cycle of your game (what the player does over and over)*:

The two players will respectively move around the maze and push blocks. The effect of these actions will be advancement of players from a designated entrance to a designated exit, or them falling into holes and needing to restart the level or undo their most recent actions. Each time both players reach the exits, they will mutually advance to a new level. Once the characters have passed through all levels in the maze, they will be unified once again.

---

## 3. Game Mechanics

**Player Actions (What can the player do?):**

Each player can move their character up, down, left, or right one grid square at a time. In doing so, a player may push a block impeding their path, depending on color-indicated permissions specific to the block, or else be rebuffed from motion. Player can also pass through one-directional portals and change their colors using paint. Blocks can be pushed into other blocks or fill holes in the player map. If either character falls into a hole, the current level will restart for both of them or they will need to undo their most recent actions.

**Interactions (How do players interact with the game or characters? Controls setup?):**

On desktop, the left character will be controlled with WASD, and the right character will be controlled with arrow keys. Holding a key will enable multiple steps to be attempted in sequence. There will also be keyboard shortcuts to undo a move or restart a level. In a later stage of development, these shortcuts could be identified with game controller buttons.

A game menu will also be openable by mouse click from a button in the HUD. Level selection and setting selection will be done by mouse in this phase of development.

**Rules (What constraints or systems define the gameplay?):**

Neither character can walk through walls in the grid. Some blocks are "unentangled" and can be pushed by either player (but not into a wall). "Entangled" blocks occupy the same location in both the left and right worlds, and may only be moveable by one of the characters, as will be visually indicated. Blocks and players can be pushed into each other. If an entangled block falls into a hole in either map, it will turn into a floor tile in the map with the hole and a wall in the other.

An entangled block can be indirectly pushed by an unentangled block, but only if the player ultimately responsible for the push would be allowed to push that entangled block directly.

**Rewards (How does your game reward the players after completing tasks or in the gameplay? What kind of reward system do you envision?):**

The primary reward system will be intrinsic in nature: the progress from level to level, as indicated by a HUD element and/or message between levels indicating how many levels have been completed and how many are yet to be completed. Players will also be rewarded by the uniqueness of successive levels, changing visual styles, and the drive to discover new mechanics.

**Feedback (How does your game notifies the player? Audio-visual cues? Progress tracking via HUD? Positive/negative feedback?):**

Audio-visual cues during the level will be neutral in nature, as the same player action may be beneficial in one level and harmful in another, and the task of determining the distinction is left to the players. A positive "progress" noise may be played between levels. HUD or inter-level indicators of game completion fraction will also provide feedback to players on the scale of the eventual game course.

---

## 4. Story & Narrative

**Premise (What is the story/world about?):**

A freak plane crash has buried the two halves of Leroy's body alive in separate dimensions. Much as the two halves are linked, so too are the twisted mazes they find themselves trapped in. Leroy's halves must use the links between their worlds to help each other escape. Though torn asunder, they may yet reunite as one.

**Main Characters:**

The main characters are the left and right halves of Leroy's body, Leonard and Roy. Leonard exists in the left maze and Roy exists in the right maze. Because they are two halves of the same mind, they can communicate with each other and work together.

**Conflict/Goal:**

Naturally, Leonard and Roy do not want to be buried alive and in separate dimensions. Escaping these puzzling maze dimensions will bring them together. If they find each other, they can be Leroy again.

---

## 5. Level & World Design

**Setting/Theme:** 

This is a cooperative escape game where both halves of our hero have been trapped against their will in a series of elaborate mazes. Teamwork, communication, and collaboration between the two players will be necessary to complete levels and progress towards freedom. Only if they are able to think as one will the two halves of our hero be able to escape the tunnels and re-unite.

The setting is an interdimensional series of tunnels, with certain entangled blocks existing in two dimensions at once. The world is full of interdimensional magic, and quantum weirdness which causes different objects to behave in strange ways. 

**Level Structure (linear, open world, hub-based?):**

The game will have a linear structure, with an embedded narrative. There will only be one possible ending. Each level will have a short level name which will provide the players with hints in order to solve it. Players will go sequentially through the levels, always working on the same level simultaneously. 

**Tutorial/Onboarding (How will players learn mechanics?):**

Mechanics will gradually be revealed to players throughout the game, with players learning the nature of the mechanics by trial and error. Levels will be grouped into three *layers*, each of which has a dedicated list of available mechanics for level design. The first layer will introduce players to movement, block pushing, entangled blocks, and holes. The second will include portals and spheres (rolling blocks that don't stop after being pushed). The third will introduce paint, which changes player colors. Mechanics and the ways they can be made to interact will be revealed gradually throughout each layer.

**Progression (How does your game increase in difficulty or complexity?):**

We are going to shoot for a gradual difficulty curve with an interesting balance of challenging levels, as well as levels where the players are able to get into a flow state and progress quickly. Some levels will be very short and simple, whereas others will be designed to take more experimentation and time. If players ever get totally stuck, a solution manual will be available if the player chooses to use it.

**Exploration/Challenges/Puzzles (if applicable):**

There may be a few hidden "secret" parts of levels which can surprise the player into more aspects of exploration. 

---

## 6. Visual & Audio Style

**Art Style Reference (pixel art, 3D, realistic, low poly, etc.): small size pixel art**

**Color Palette: limited color palette (tbd)**

The color palette for the environment will be a two tone palette, with one main hue with value variations. The second hue will serve as a highlight. The players and level objects will have their own palette (fixed throughout the game) to contrast with their environment and make levels more readable.

Mock-ups are being done with the palette below, called "Darkworld Palette", by Solitaire on lospec.com

https://lospec.com/palette-list/darkworld

```
0	0	0	000000
36	1	66	240142
41	5	115	290573
74	28	184	4a1cb8
115	18	252	7312fc
160	101	227	a065e3
207	132	240	cf84f0
227	178	252	e3b2fc
253	205	134	fdcd86
```

**Music/Audio Resources (to complement the theme of your game): tbd**

https://www.bfxr.net
https://sfbgames.itch.io/chiptone
https://yurisizov.itch.io/boscaceoil-blue
---

## 7. User Interface (UI/UX)

**HUD (Heads-Up Display) Elements (health, score, minimap, progress tracking, etc.): progress tracking**

At top of screen:
 - Current Layer
 - Current Level/Levels in Layer

**Menus (main, pause, inventory, etc.):**

- Pause Menu
    - Resume
    - Hint
    - Level Navigator
        - Layer 3
            - Level n
            - ...
            - Level 2
            - Level 1
        - Layer 2
            - Level m
            - ...
            - Level 2
            - Level 1
        - Layer 1
            - Level p
            - ...
            - Level 2
            - Level 1
    - Settings
        - Audio
            - Music Volume
            - Sound Effect Volume
    - Title Screen

- Title Screen
    - Continue
    - Level Navigator...
    - Settings...
    - Quit

**Accessibility Features:**

- Block colors and shapes will be designed in a color-blind-friendly manner.
- Hints will be available.

---

## 8. Technical Requirements

**Engine: Godot**

**Programming Language(s): GDScript**

**Tools for Assets (art, sound, etc.): (TBD)**

**Deployment Platform (PC build, web, mobile, etc.): Desktop (Windows/Linux/web)**

---

## 9. Development Plan 

*Proposed Work Schedule: Describe here what your team will work on each week for the remainder of the term. This should function as a schedule or work plan to be followed and successfully develop your game prototype*:

- Week 3: (steady 3 added mechanics per week begin here)
- Week 4: focus on presentation for next week (not game related, but true), organize
- Week 5: art/sound, menu design
- Week 6: level loader/exporter, menu implementation
- Week 7: testing and level design
- Week 8: testing and level design
- Week 9: Finishing touches