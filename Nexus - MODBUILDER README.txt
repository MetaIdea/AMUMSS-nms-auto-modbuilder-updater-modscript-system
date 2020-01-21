Revolutionary No Man's Sky AMUMSS (auto modbuilder-updater with MOD script definition system)
Fully automatic mod builder that automates every step of NMS modding and provides an easy to use lua script mod definition system.
NEXUSMODS: https://www.nexusmods.com/nomanssky/mods/957: https://www.nexusmods.com/nomanssky/mods/957

How to use ?  SEE BELOW
What does this tool do ? SEE BELOW
What are the possibilities for modders ? SEE BELOW
How to Create your own lua mod definition scripts ? SEE BELOW
How to Create a Patch for an existing MOD PAK ? SEE BELOW
How to Distribute you mod script lua definition file ? SEE BELOW
SCRIPT MOD LIST (included), SEE BELOW

For BEYOND:

 * This tool works for BEYOND as long as MBINCompiler can compile/decompile the MBIN touched by the script

     NOW FOR THE GOOD STUFF!

NEW in Version 3.1.5W : 
 * With only one PAK in ModScript folder (and no script present) AMUMSS will do an automatic un-packing/decompiling of the PAKs (look in ModScript sub-folders for results) 
	  and, if a script was included in the PAK, will ask the user if he/she wants to use that script in RE-BUILDING the PAK.
 * MapFileTree files are now only created/updated when missing or older than their NMS pak file
 * Now allows the use of "IGNORE" for the value of the last member of a SPECIAL_KEY_WORDS pair.  This is specially useful when the value could be changed by NMS.
 * Added MBIN_FILE_SOURCE alternate syntax #3 allowing a modder to create a new path-filename MBIN based on an original NMS one.
 * Now using an x64 version of lua when the os is also x64, otherwise falling back to x86 version
 * Added new rule to force INTEGER_TO_FLOAT conversion when it makes sense for the modder 
 * Added "Advanced Script Rules" Tip #1 for advanced modders with script taking a long time to execute
 * Added "Advanced Script Rules" Tip #2 for advanced modders with script using concatenation in loops
 * Allowed scripts processing to continue when a ModScript script fails to load but others are ok
 * Corrected bug where some part of a "Property name" was also replaced with a new value

 Previous Versions : 
 * Added VALUE_MATCH_OPTIONS allowing the use of "=", "~=", "<", "<=", ">" and ">=" with a VALUE_MATCH value 
 * Added REGEX search/replace operation on the EXML involved BEFORE and/or AFTER script processing
 * Added os.clock, os.date, os.difftime, os.time, os.tmpname to available lua syntax in a script
 * Added code detecting and (a user message) indicating to NOT "Run as administrator" as it will prevent AMUMSS from working correctly
 * Added the option to SKIP re-creating MapTreeFiles DURING script processing to speed up modding development
 * Corrected search behavior when using SPECIAL_KEY_WORDS multiple pairs to find a section
 * You can check conflicts in the MODS folder (still at the MBIN file level) by just running the tool
     Even if you don't have any script in ModScript folder (A WARNING will be issued) * Using the script MapFileTree_UPDATER.lua, you can create all the MapFileTrees you want...
     By default, the script is already preloaded with all the "GLOBALS".  Just add / remove any MBIN you are interested in from the list and process the script.  Remember that MapFileTree files are automatically created / updated each time you run a script
 * Added MapFileTree file automatic creation in MapFileTrees folder which can GREATLY help a modder find the right 
   SPECIAL_KEY_WORDS and PRECEDING_KEY_WORDS as well as understand the structure of an EXMLHere is a Sample:
      MapFileTree: METADATA\SIMULATION\ECOSYSTEM\ROLEDESCRIPTIONTABLES\AIR\AIRTABLECOMMON.EXML
         LINE   LEVEL
      [       3] [ 0]["GcCreatureRoleDescriptionTable"]
      [       4] [ 1]  ["RoleDescription"]
      [       5] [ 2]    ["GcCreatureRoleDescription.xml"]
      [       6] [ 3]      ["CreatureRole"]
      [       7] [ 4]        [SPECIALNAME: {"CreatureRole","Bird"},]
      [       9] [ 3]      ["CreatureType"]
      [      10] [ 4]        [SPECIALNAME: {"CreatureType","None"},]
      [      24] [ 2]    ["GcCreatureRoleDescription.xml"]
      [      25] [ 3]      ["CreatureRole"]
      [      26] [ 4]        [SPECIALNAME: {"CreatureRole","Bird"},]
      [      28] [ 3]      ["CreatureType"]
      [      29] [ 4]        [SPECIALNAME: {"CreatureType","None"},]
      [      46] [ 1]  ["TileType"]
      [      47] [ 2]    [SPECIALNAME: {"TileType","Base"},]
      [      49] [ 1]  ["LifeLevel"]
      [      50] [ 2]    [SPECIALNAME: {"LifeSetting","Dead"},]
      [      52] [ 0][/Data]

 * Saving a pakname_content.txt file with the created pak when a COMBINED MOD is created
   The content file is also copied to MODS along with the pak when the user request it (thanks Lo2k for suggestion)
 * ModExtraFilesToInclude folder where you, the modder, can put ANY extra files to be INCLUDED in the created PAK
 * EXML_Helper folder containing copies of the original and modified files so modders can view and compare the EXML files during script development
 * To start developping a NEW script for a mod, just fill-in the "MOD_FILENAME", "PAK_FILE_SOURCE" and "MBIN_FILE_SOURCE" fields
   using the script "TEMPLATE.lua" in ModScriptCollection\LearningExamples
 * Now you can find the decompiled original file in EXML_Helper\ORG_EXML and the modded file in EXML_Helper\MOD_EXML
   and can use them to develop a suitable script...
 * The tool generates NMS_pak_list.txtPretty.lua containing ALL file names content of the paks in the NMS PCBANKS folder for convenience 
 * Added Script plus NMS MODS paks Conflict Detection at the file level in the generated REPORT.txt file (minor bug correction)
   so you can see which of the scripts AND paks in MODS need to be combined with others.   
   >>> A reference to the NMS PAK filename is also displayed for convenience in building a script.
 * Added the lua script themselves in the generated paks for reference.
 * Added an example script showing the use of For-Loops in the scripts.  See ADD_REMOVE_FORLOOP_usage-Recipes.lua
   in the ModScriptCollection\LearningExamples\Advanced folder.

What does this tool do ?
1. Downloads the latest MBINCompiler from github (needs Internet connection)
2. Reads especially made mod script lua files (NMS version independent modding)
3. Extracts the necessary .pak files from your NMS game folder
4. Decompiles the needed MBIN files to EXML files
5. Applies the changes defined in the lua mod script files to the decompiled .exml files 
6. Compresses the .exml files back to .pak (all *.MBIN,*.BIN,*.H,*.DDS,*.PC,*.WEM,*.TTF,*.TTC,*.TXT,*.XML files)
7. Copies the mods to: A) NMS mods folder (optional), B) CreatedModPAKs folder of this tool and C) Builds folder 
8. Creates incremental builds in numbered order in Builds/IncrementalBuilds
9. Check for conflicts between Scripts that modify the same files and reports findings so you can choose to combine them 
    if you want to get the full effect of each script/mod 

How to use:
0. Unzip download into a folder like C:\AMUMSS (not under any OS controlled folder)
1. Choose/Copy a script from the ModScriptCollection folder or from anywhere else or create one yourself
2. Paste it into the ModScript folder
3. Start (double-click) BuildMod.bat
4. If asked, put your No Man's Sky game folder path into NMS_FOLDER.txt, otherwise the tool will find the game files
5. Answer a few questions and the tool will do its processing, let it finish (review the REPORT.txt file if necessary)
6. Copy the mod that gets created in the CreatedModPAKs folder to your game folder if you haven't made that choice at the start of processing
    Note: You can combine multiple mods and even make PATCH mods (see below on how to do this)

What are the possibilities for modders ?
     See the learning examples and the Script Rules explained in the file Script_Rules.txt included.
You have many convenient ways to change, replace or add/remove values or code. E.g. you can multiply all values of a certain type with ease,
replace all values that match a certain type or value and much more. You can also add code, add new files either by defining the code
in the lua script file itself or by external source.

How to Create your own lua mod definition scripts ?
	Look at the scripts in the ModScriptCollection and LearningExamples + Commented folders.
Just copy one of them and adapt it for your mod.  Note multiple {...} entries need to be separated with a comma.
     +++++  Script Rules are explained in the file Script_Rules.txt included  +++++
For mods that depend on multiple pak sources and MBINs see Multi_PAK_Multi_MBIN_Example_Mod.lua to see how to do the correct nesting.
The real revolution is the mod script lua definition system that enables every modder to easily convert their mods to these scripts and 
finally become mostly independent of manual mod updates.

How to Create a Patch for an existing MOD PAK ?
	Background:
Mods in NMS are loaded from top to bottom (when listed in alphabetical order).
Lower mods that modify the same file in any above mod will win all changes to that file

	So, to make a Patch for a mod PAK, you could manually do (see below for MODBUILDER help):

 * Extract from that mod PAK the file you want to change, it gives you a .MBIN
 * Decompile the .MBIN to .EXML format using the appropriate MBINCompiler version
 * Find what you want to change and make these changes to the .EXML file
 * Recompile the .EXML file to .MBIN using the "latest" MBINCompiler version
 * Pack this new .MBIN file to a .PAK (name it as you like as "Patch_xyz.pak")
 * Make sure the name is lower than the original PAK file in alphabetical order
 * Place both files into your NMS MODS folder
 * Verify that the DISABLEMODS.TXT file in PCBANKS folder is still deleted
 * Enjoy

   Using the .EXML file from the mod PAK ensure that most if not all of the changes made by the MOD
   will be saved and the MOD will continue to work as intended.
   In using the Patch, only if you change something that affects that MOD, will that change how the MOD works
   otherwise the MOD AND YOUR CHANGES will work as planned by you.

MODBUILDER can help in creating the "Patch_xyz.pak":
   A. Create a simple script with the changes you want to an .EXML file (steps 1, 2 and 3 above)
   B. Copy the Script AND the MOD PAK you want to patch in the ModScript folder (steps 4, 5, 6, 7, 8 are handled by MODBUILDER)
   C. MODBUILDER will attempt to use your MBIN_FILE_SOURCE name in the mod PAK if found
     *** That will preserve the mod PAK changes unless you change the same exact values with your patch ***
   D. A new mod PAK will be created in the CreatedModPAKs folder
   E. Use that PAK in 6- above (if you did not let MODBUILDER do it for you)

How to Distribute you mod script lua definition file ?
1. Upload it plain to nexusmods with a link to a download or
2. Upload your mod into the NMS modding discord server (mod releases 
    channel or mod discussion), mention @Mjjstral if you want that I add it 
    to the project for future releases
3. Post a link to the commentary section on nexus

SCRIPT MOD LIST (included): 
(Note: Some Mods here are for demonstration purposes only, they may require changes to values or even logic of what is changed.
            But most are perfectly functional.  Test them on a new save when in doubt!)

ADD_REMOVE_Recipes
AlienWordsInEnglish
AlwaysDay
AllShipsMaxSlots | AllShipsMaxSlots+SClass
AmbientGameMode
BetterFlight-LOW+FAST+REVERSE+10xPulseSpeed+ZeroPulseDelay
BiomeForceType | BiomePerStarTypeChange
BuildEverythingEverywhere | BuildEverythingEverywhereNoCollision | BuildingsOnPlanetsRemoved
CostReduction
CreatureSizeAndSpawnRateIncrease
DenserForests
DisableSaving
EqualyDistributedBiomes
ForceVRMode
ForestDensityAndSizeIncrease
GodMode
horizontal_wings | static_horiz_s_wings | Y_wings
IntroLogoSkip
JetpackWalkSwimSpeed
LearnMoreWords
LodDistanceScale
LongerAndThickerGalaxyLines
MiningLaserSpeed
MissionCooldownTimer
MoreScreenFilters
MoreWeaponDamage
NaturalFlight | NaturalFlight_3_Speeds | NaturalFlight_Fast_Brakes
NoChargePortal
NoHazardDamage
NoPirates | NoPirates_Extended | NoPirates+NoRandomSentinels | NoPirates+NoRandomSentinels_Extended
NoRandomSentinels | NoRandomSentinels_Extended
NoShipsOnPlanet
NoWarpCameraShake
OnlyLushBiomes
PassiveFiends
PlanetGenerationModTemplate (UNFINISHED, TEMPLATE)
PlantSizeIncreaseCompact | PlantSizeIncreaseScaleEdition | PlantSizeIncreaseScaleEditionMinMax
PortalOnSpacestation
Reverse+Hover+Underwater+10xPulseSpeed
RewardPercentage100
ScanTimesAndRangeImprove
ShipGunTerrainDamage
ShipRangeIncrease
SpeedIncreaseActions | SpeedIncreaseAnalysis
SpeedIncreaseGrowthAndHarvest
SpeedIncreaseVehicles
SpeedIncreaseRefiners
StackMultiplier
SuperformulaSuperTerrainExperiment (demo only, experimental)
TerrainEditorMod
TorchImprovement
TradeCostReduction
UnlimitedHyperDriveDistance_UnlimitedJetPack_ZeroLaunchCost
UnlimitedPhotoMode+NoClip+Speed3x
WeatherDisabled

Many thanks to monkeyman192 for his huge efforts toward the NMS community and his work on the MBIN compiler.
Many thanks to Wbertro (aka TheBossBoy) for much further improvements.
Many thanks to clampi, Erikin84, Fuklebark, Lo2k, Marbrook, petrik, Seekker, for bug reporting, further improvements and for sharing scripts.

Original idea by Mjjstral aka MetaIdea
Copyright MIT license
Contact: MetaIdea7@gmail.com or Wbertro@gmail.com