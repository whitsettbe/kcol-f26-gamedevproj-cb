# 1. Creating a level scene

The result of this section has been saved as `levels/basic_level_empty.tscn`. By copying this scene as a template, you can avoid following these steps yourself. That said, knowing how the scene is constructed is still valuable.

1. Create a new scene with a Node2D base. Save the scene in the `TornAsunder/levels` folder.
![1-01 create scene](1-01_create_scene.png)

2. Add three TileMapLayer nodes named `Floor`, `FloorOverlays`, and `FalseOverlays` (in that order). In the inspector, set each of them to use the Tile Set `TornAsunder/all_tiles.tres`.
![1-02 create TileMapLayer nodes](1-02_tile_map_layers.png)

3. Select the `Floor` node from the scene tree, select its `TileMap` tab from the dock at the bottom of the screen, and switch to the `Terrains` page of that tab. Select the purple `Floor` terrain and, making sure that the "Connect mode" tile is selected (the eight arrows), draw two floor regions in the scene. A good rule of thumb is for the regions to be about 10x10. Make sure to leave a 1-tile gap between the floors and the axes.
![1-03 floors](1-03_floors.png)

4. Select the `FloorOverlays` node from the scene tree, select its `Wall` terrain, and fill the map border with "Connect mode" - the surrounding wall should be 2 tiles thick, with a 3-tile gap between the two maps.
![1-04 border walls](1-04_border_walls.png)

5. Instace the `portal_in.tscn` scene twice, creating two nodes with names `EXIT_L` and `EXIT_R` (the names are important!). Place one in the left map and one in the right map.
![1-05 exit creation](1-05_exit_creation.png)

6. In the scene tree, put the portals between `Floor` and `FloorOverlays`. Then, for each portal, use in Inspect menu to turn on the `Is Exit` property.
![1-06 exit setup](1-06_exit_setup.png)

7. Create two instances of `block.tscn` called `Leonard` and `Roy` and place them after the `TileMapLayer` nodes in the scene tree. Move the blocks to the desired starting locations in the viewport.
![1-07 player creation](1-07_player_creation.png)

8. In the inspector, set Leonard and Roy to have `Block Type` of `Player`. This change will not yet be reflected in the sprites.
![1-08 player setup](1-08_player_setup.png)

9. Select the root node from the inspector and use the "Add Script" button to attach the `TornAsunder/levels/level_block_manager.gd` script to the level. This will open the script editor. Switching back to the 2d editor, you will see that nothing has changed yet, but that a blue script icon is now visible on the root node.
![1-09 script attachment](1-09_script_attachment.png)

10. Reload Godot, either by closing and re-opening the project or using the `Project > Reload Current Project` toolbar item. The players will now have their new sprites assigned automatically.
![1-10 reload](1-10_reload.png)

11. Using the Inspector tab, set Leonard to have `Block Color` of `Blue` and Roy to have `Block Color` of `Red`. Also switch Roy to have `Side` of `Right Player`. Now that the block-managing "tool" script is watching the level, it will automatically update the sprites.
![1-11 player setup 2](1-11_player_setup_2.png)

12. Open `res://scripts/multilevel.gd` and add the path to your level scene to the `level_paths` array.
![1-12 mulilevel connection](1-12_multilevel_connection.png)

13. Your level is now playable from the `res://scenes/multilevel.tscn` scene! (Viewport settings may be adjusted after the writing of this tutorial.)
![1-13 playable](1-13_playable.png)

# 2. Modifying a Level Scene

## 2a. Adding Unentangled Blocks

1. Instance the `block.tscn` scene. **In the scene tree, ensure the block is a direct child of the root!** The block should also appear after all of the tile layers in the scene tree. In the editor, drag the block to the desired grid-aligned location.
![2a-1 block add](2a-1_block_add.png)

2. Using the inspector, set the color of the block, and whether it should be rolling or not. The sprite will automatically update to match your selections.
![2a-2 color and shape set](2a-2_color_and_shape_set.png)

3. Repeat as desired. You can also copy and paste your existing blocks. (Be sure to give your blocks somewhat descriptive sprite names in the scene tree!) **Again, ensure all blocks are direct children of the root!**
![2a-3 many blocks](2a-3_many_blocks.png)

## 2b. Adding Entangled Blocks

1. Instance two blocks and put them in the same location on the left and right maps. Alignment of the locations is not enforced in code, but it is a convention of our game.
![2b-1 pair add](2b-1_pair_add.png)

2. In the inspector, switch both blocks to have `Block Type` of `Entangled`. An additional property called `Partner` should appear at the top of the inspector for each block.
![2b-2 set entangled](2b-2_set_entangled.png)

3. For each of the blocks, set the `Partner` property to the other block. The dropdown that appears should only list entangled blocks as possible partners. In this example, Block_Left should have partner Block_Right, and vice versa.
![2b-3 set partners](2b-3_set_partners.png)

4. Set the color and rolling properties as desired. These properties must match between entangled partners! When the scene is initialized, there are assertions in code to verify that these properties match, so you will be notified if you make a mistake here.
![2b-4 style blocks](2b-4_style_blocks.png)

5. Repeat as desired. If you copy and paste the existing blocks, you will need to manually set the `Partner` pointers to reference the new blocks instead of the old ones.
![2b-5 many pairs](2b-5_many_pairs.png)

## 2c. Adding More Walls

1. Select the `FloorOverlays` node and open its TileMap panel (bottom of screen). Switch to the Terrain tab and select the Wall terrain.
![2c-1 wall paint prep](2c-1_wall_paint_prep.png)

2. Ensuring that "Connect Mode" is selected, paint your desired walls into the viewport. (Note that some of the tiles in the below image are incorrectly connected - see issue #46.)
![2c-2 add walls](2c-2_add_walls.png)

3. Now, for visual reasons we would like the floor to have boundaries at walls. Select the `Floor` node, open its TileMap panel, select the Floor terrain (then the "Connect mode" tile, if not already selected), and erase the floor where it overlaps with walls.
![2c-3 erase extra floors](2c-3_erase_extra_floors.png)

## 2d. Adding Holes

1. Select the `FloorOverlays` node, switch to the Tiles tab, and select the hole tile (a black square).
![2d-1 select hole](2d-1_select_hole.png)

2. Paint holes in the desired locations.
![2d-2 draw holes](2d-2_draw_holes.png)

3. For visual effect, erase the floor under the holes as in step 2c-3.
![2d-3 erase floor](2d-3_erase_floor.png)