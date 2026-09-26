# Game Design Document (GDD)
### Team's Project Template

**Team: Computer Business**
**Authors: Calvin Nyeholt, Clara Siefke, Phoebe Tozer, Benjamin Whitsett**

## 1. Game Concept

**Working Title: Asunder**  

**Genre:**  

**Platform(s): PC**  

**Elevator Pitch (1-2 sentences): In a couch-co-op sokoban, your character has been torn asunder. Two players escape through parallel worlds, interacting through "entangled blocks" that, when pushed, move in *both* universes.** 

**Target Audience:** 


---

## 2. Core Loop

*Describe the main repeating cycle of your game (what the player does over and over)*:

The two players will respectively move around the maze and push fragments, filling holes in the floor as needed. The effect of these actions will be advancement of players from the bottom of each level to the top, or them falling into holes and restarting the level. Each time both players reach the top of the level, they will mutually advance to a new level. Once the characters have passed through all levels in the maze, they will be unified once again.

---

## 3. Game Mechanics

**Player Actions (What can the player do?):**

Each player can move their characters up, down, left, or right one grid square at a time. In so doing, a player may "push" a fragment blocking their path, depending on permissions specific to the block, or else be rebuffed from motion. Fragments can be pushed into other fragments or fill holes in the player map. If either character falls into a hole, the current level will restart for both of them.

**Interactions (How do players interact with the game or characters? Controls setup?):**

On PC, the left character will be controlled with WASD, and the right character will be controlled with arrow keys. *(Holding a key to initiate a "run" may or may not be allowed).* There will also be keyboard shortcuts to undo a move or restart a level *(TBD)*. In a later stage of development, these shortcuts could be identified with game controller buttons.

A game menu will also be openable by mouse click from a button in the HUD. Level selection and setting selection will be done by mouse in this phase of development.

**Rules (What constraints or systems define the gameplay?):**

Neither character can walk through walls in the grid. Some fragments are "unentangled" and can be pushed by either player (but not into a wall). "Entangled" fragments occupy the same location in both the left and right worlds, and will each be movable by only one of the characters, as will be visually indicated. While fragments can be pushed into each other, players cannot themselves be pushed. If an entangled fragment falls into a hole in either map, it will turn into a floor tile in the map with the hole and a wall in the other.

An entangled fragment can be indirectly pushed by an unentangled fragment, but only if the player ultimately responsible for the push would be allowed to push that entangled fragment directly.

**Rewards (How does your game reward the players after completing tasks or in the gameplay? What kind of reward system do you envision?):**

The primary reward system will be intrinsic in nature: the progress from level to level, as indicated by a HUD element and/or message between levels indicating how many levels have been completed and how many are yet to be completed. Players will also be rewarded by the uniqueness of successive levels, driving intrigue.

**Feedback (How does your game notifies the player? Audio-visual cues? Progress tracking via HUD? Positive/negative feedback?):**

Audio-visual cues during the level will be neutral in nature, as the same player action may be beneficial in one level and harmful in another, and the task of determining the distinction is left to the players. A positive "progress" noise may be played between levels. HUD or inter-level indicators of game completion fraction will also provide feedback to players on the scale of the eventual game course.

---

## 4. Story & Narrative

**Premise (What is the story/world about?):**

After a plane crash, the two halves of Leroy's body have been buried alive in separate dimensions, still sharing a mind. Much like themselves, linked fragments fill the elaborate mazes which imprison them. Leroy's halves must use these linked fragments to help each other escape. Though torn asunder, they may yet reunite as one.

**Main Characters:**

The main characters are the left and right halves of Leroy's body, Leonard and Roy. Leonard exists in the left maze and Roy exists in the right maze. Because they are two halves of the same mind, they can communicate with each other and work together.

**Conflict/Goal:**

Naturally, Leonard and Roy do not want to be buried alive and in separate dimensions. Escaping these puzzling maze dimensions will bring them together. If they find each other, they can be Leroy again.

---

## 5. Level & World Design

**Setting/Theme:**

**Level Structure (linear, open world, hub-based?):**

**Tutorial/Onboarding (How will players learn mechanics?):**

**Progression (How does your game increase in difficulty or complexity?):**

**Exploration/Challenges/Puzzles (if applicable):**

---

## 6. Visual & Audio Style

**Art Style Reference (pixel art, 3D, realistic, low poly, etc.):**

**Color Palette:**

**Music/Audio Resources (to complement the theme of your game):**

---

## 7. User Interface (UI/UX)

**HUD (Heads-Up Display) Elements (health, score, minimap, progress tracking, etc.):**

**Menus (main, pause, inventory, etc.):**

**Accessibility Features (if any):**

---

## 8. Technical Requirements

**Engine:**

**Programming Language(s):**

**Tools for Assets (art, sound, etc.):**

**Deployment Platform (PC build, web, mobile, etc.):**

---

## 9. Development Plan 

*Proposed Work Schedule: Describe here what your team will work on each week for the remainder of the term. This should function as a schedule or work plan to be followed and successfully develop your game prototype*:
