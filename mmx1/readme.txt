MegaED X v1.0
Halloween release (31/10/2010)

ROMs supported:
 - Megaman X1 USA 1.0
 - Megaman X1 USA 1.1
 - Megaman X1 EUR 1.0

Compatible with:
 - Windows NT 5.1 and later
Know issuses:
 - Sometimes the size of the editor is a bit little XD
 - The "play" button can't load roms that in its path there are spaces
 - If the editor start to be crazy, delete C:\Windows\MegaEDX.ini
 - On ReactOS 0.3.12 cause BSOD o.O"

Commands:
 PgUP / PgDOWN: Scroll between levels
 Q / W: Change Objects
 A / S: Change Palettes
 Z / X: Change Tiles
 O / P: Change level point
 S / D: Change debug infos
 D:     View infos
 B:     Background viewer
 C:     Checkpoint viewer
 E:     Collision viewer
 

Changelog from Megaman X Editor 0.7.1
 - Moved from C# to C++ rewriting the entire editor
 - .Net framework no longer required
 - Now the entire level can be viewed on main window
 - Palette, tileset, tile mapping, block and scene editor separated
 - Free dynamic palettes are now supported (press A or S)
 - Free dynamic tiles are supported (press Z or X)
 - Now the editor load the fontset from the game
 - Various infos about the level added
 - Added collision viewer
 - Now palette editor can tell you which are the offset that they come from
 - Tileset editor now tell you if the tile that you have select it's lock by ASM, is compress or uncompress
 - You able to edit and save compressed tiles
 - Now you can edit the collisions of Tile mappings
 - Background viewer implemented
 - Background editor implemented
 - High speed rendering implemented
 - The editor use a virtual space of tile mapping to speedup the level viewer
 - The editor save the current size and position of the window
 - ROM can test on an emulator pressing a single button on the editor
 - The editor now load last rom used (if you want)
 - The editor now load the last level loaded
 - Checkpoint editor removed
 - Checksum fixer removed
 - Offset converter removed
 - Sprite editor removed
 - Text editor removed