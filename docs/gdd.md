# Game Design Document (GDD)
### Team's Project Template

**Team: Computer Business**
**Authors: Calvin Nyeholt, Clara Siefke, Phoebe Tozer, Benjamin Whitsett**

## 1. Game Concept

**Working Title: Torn Asunder**  

**Genre: Sokoban**  

**Platform: Web (Desktop)**  

**Elevator Pitch: In a couch-co-op Sokoban, your character has been TORN ASUNDER. Two players escape through parallel worlds, interacting through "entangled blocks" that, when pushed, move in *both* universes.** 

**Target Audience: People who enjoy collaborative puzzle solving.** 


---

## 2. Core Loop

The two players will respectively move around the maze and push blocks. The effect of these actions will be advancement of players from a designated entrance to a designated exit, or them falling into holes and needing to restart the level or undo their most recent actions. Each time both players reach the exits, they will mutually advance to a new level. Once the characters have passed through all levels in the maze, they will be unified once again.

---

## 3. Game Mechanics

**Player Actions:**

Each player can move their character up, down, left, or right one grid square at a time. In doing so, a player may push a block impeding their path, depending on color-indicated permissions specific to the block, or else be rebuffed from motion. Player can also pass through one-directional portals and change their colors using paint. Blocks can be pushed into other blocks or fill holes in the player map. If either character falls into a hole, that character will be unable to move and the players will need to either undo their most recent actions or restart the level.

**Interactions:**

On desktop, the left character will be controlled with WASD, and the right character will be controlled with arrow keys. Holding a key will enable multiple steps to be attempted in sequence. There will also be keyboard shortcuts to undo a move or restart a level.

A pause menu will also be openable by keypress. Menu navigation will be done with the mouse.

**Rules:**

Neither character can walk through walls in the grid. Basic blocks can be pushed by either player. Some blocks will be movable only by characters of a specific color - player colors must match the color of the block they are pushing. Some blocks will also be "entangled," meaning a version of the block exists in both the left and right worlds. One player pushing one entangled block will also push the corresponding block in the other world, and pushing is not permitted unless both blocks are able to move. If an entangled block falls into a hole in either map, it will turn into a floor tile in the map with the hole and a wall in the other.

Blocks can push other blocks. A colored block can be indirectly pushed by an uncolored block, but only if the player ultimately responsible for the push would be allowed to push that entangled block directly.

Walking through a "paint" square will change a player's color, thereby changing which blocks they are permitted to push. There will be colorless paint which removes color from players, meaning they will be able to push neither of the two color-locked block types. Paint is destroyed if a block slides over it.

Stepping on the input to a portal will immediately transport a player to the output of the portal, unless the output is covered by a block. Blocks cannot pass through portals.

Rolling blocks will, once pushed, continue to move in their original direction until stopped. Rolling blocks can push other blocks as if they were a player of their own color. For example, a red rolling block can push red and colorless blocks, while a colorless rolling block can only push colorless blocks. Player motion inputs will still be processed while rolling blocks are moving.

**Rewards:**

The primary reward system will be intrinsic in nature: the progress from level to level, as indicated by a HUD element indicating how many levels have been completed and how many are yet to be completed. Players will also be rewarded by the uniqueness of successive levels, changing visual styles, and the drive to discover new mechanics.

**Feedback:**

Audio-visual cues during the level will be neutral in nature, as the same player action may be beneficial in one level and harmful in another, and the task of determining the distinction is left to the players. A "progress" noise will be played between levels. HUD indicators of game completion fraction will also provide feedback to players on the scale of the eventual game course.

---

## 4. Story & Narrative

**Premise:**

A freak plane crash has buried the two halves of Leroy's body alive in separate dimensions. Much as the two halves are linked, so too are the twisted mazes they find themselves trapped in. Leroy's halves must use the links between their worlds to help each other escape. Though torn asunder, they may yet reunite as one.

**Main Characters:**

The main characters are the left and right halves of Leroy's body, Leonard and Roy. Leonard exists in the left maze and Roy exists in the right maze. Because they are two halves of the same mind, they can communicate with each other and work together.

**Goal:**

Naturally, Leonard and Roy do not want to be buried alive and in separate dimensions. Escaping these puzzling maze dimensions will bring them together. If they find each other, they can be Leroy again.

---

## 5. Level & World Design

**Setting:** 

This is a cooperative escape game where both halves of our hero have been trapped against their will in a series of elaborate mazes. Teamwork, communication, and collaboration between the two players will be necessary to complete levels and progress towards freedom. Only if they are able to think as one will the two halves of our hero be able to escape the tunnels and re-unite.

The setting is an interdimensional series of tunnels, with certain entangled blocks existing in two dimensions at once. The world is full of interdimensional magic, which causes different objects to behave in strange ways. 

**Level Structure:**

The game will have a linear structure, with an embedded narrative. There will only be one possible ending. Each level will have a short level name which will provide the players with hints in order to solve it. Players will go sequentially through the levels, always working on the same level simultaneously. 

**Tutorial/Onboarding:**

Mechanics will gradually be revealed to players throughout the game, with players learning the nature of the mechanics by trial and error. Levels will be grouped into three *layers*, each of which has a dedicated list of available mechanics for level design. The first layer will introduce players to movement, block pushing, entangled blocks, and holes. The second will include colored blocks and portals. The third will introduce rolling blocks (blocks that keep moving after being pushed) and paint, which changes player colors. Mechanics and the ways they can be made to interact will be revealed gradually throughout each layer.

**Progression:**

We intend to provide a gradual difficulty curve, with an interesting balance of challenging levels and levels where the players are able to get into a flow state and progress quickly. Some levels will be very short and simple, whereas others will be designed to take more experimentation and time. If players ever get totally stuck, a solution manual is included in this repository at `docs/Solutions.md`. The level selector will also be unlocked, so players can skip levels and return to them at a later date if they so desire.

---

## 6. Visual & Audio Style

**Art Style Reference: small size pixel art**

**Color Palette:**

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

**Music/Audio Resources:**

https://www.bfxr.net
https://sfbgames.itch.io/chiptone
https://yurisizov.itch.io/boscaceoil-blue
---

## 7. User Interface

**HUD Elements: progress tracking**

At top of screen:
 - Current Layer
 - Universal controls
 - Current Level/Levels in Layer

At bottom of screen:
 - Left player controls
 - Right player controls

**Menus (main, pause, inventory, etc.):**

- Pause Menu
    - Resume
    - Level Navigator
        - Caves
            - Level n
            - ...
            - Level 2
            - Level 1
        - Ruins
            - Level m
            - ...
            - Level 2
            - Level 1
        - Bog
            - Level p
            - ...
            - Level 2
            - Level 1
        - Back
    - Settings
        - Audio
            - Master Volume
            - Music Volume
            - Sound Effect Volume
        - Back
    - Title Screen

- Title Screen
    - Continue
    - Level Navigator...
    - Settings...
    - Quit

**Accessibility Features:**

- Block are designed to be distinguished by shape, texture, and color (using a color-blind-friendly color palette).
- Players may press shift to undo their most recent actions or press space to restart the level.
- Players may adjust the music volume and sound effect volume separately in the settings.
- A solutions guide is available if players get stuck.

---

## 8. Technical Requirements

**Engine: Godot**

**Programming Language: GDScript**

**Tools for Assets (art, sound, etc.): Google Draw**

**Deployment Platform: Web for Desktop (tested in Chrome and Firefox)**