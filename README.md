No Man's Sky auto batch modbuilder and updater with mod script lua definition system

Fully automatic mod builder that automates every step of nms modding and provides an easy to use lua script mod definition system.

How to use:
1. Put your No Man's Sky game folder path into NMS_FOLDER.txt
2. Choose a script from the ModScriptCollection folder or from anywhere else
3. Paste it into the ModScript folder
4. Start BuildMod.bat 
5. On creation finish you can decide [y/n] if the mod file gets installed too
6. Copy the mod that gets created in THIS folder to your game folder if you haven't 

What does this tool do ?
1. Downloads the latest MBINCompiler from github (needs Internet connection)
2. Reads especially made mods script lua files (NMS version independent modding)
3. Extracts the necessary .pak files from your NMS game folder
4. Decompiles the needed MBIN files 
5. Applies the changes defined in the lua mod script file to the decompiled .exml files 
6. Compresses the .exml files back to .pak (all *.MBIN,*.BIN,*.H,*.DDS,*.PC,*.WEM,*.TTF,*.TTC,*.TXT,*.XML files)
7. Copies the mods to:  A) NMS mods folder (optional), B) the root folder of this tool C) MODBUILDER/Builds folder 
8. Creates incremental builds in numbered order (MODBUILDER/Builds/IncrementalBuilds)

How to create your own lua mod definition scripts ?
It is self explanatory if you look at the scripts in the ModScriptCollection folder. Just copy one of them and adapt it for your mod.
For mods that depend on multiple pak sources and MBINs see Multi_PAK_Multi_MBIN_Example_Mod.lua to see how to do the correct nesting.
Note multiple {...} entries need to be sperated with a comma.

The real revolution is the mod script lua definition system that enables every modder to easily convert their mods to these scripts and finally
become independent of manual mod updates by hand.
Currently only value changes are supported so stay tuned for updates.

How to distrubute you mod script lua definition file ?
1. Upload it plain to nomansskymods.com or nexusmods with a link to a download of this tool or
2. Make a pull request on github, adding your script to the ModScriptCollection folder
3. Upload your mod in to the NMS modding discord server (mod releases channel or mod discussion), mention @Mjjstral if you want that I add it to the project for future releases

Many thank's to monkeyman192 for his huge efforts toward the NMS community and his work on the MBIN compiler.

Made by Mjjstral aka MetaIdea

Copyright MIT license

Contact: MetaIdea7@gmail.com



