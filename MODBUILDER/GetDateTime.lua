--arg[1] == path to REPORT.txt
--arg[2] == path to MODBUILDER

if gVerbose == nil then dofile(arg[2]..[[LoadHelpers.lua]]) end
pv(">>>     In GetDateTime.lua")
gfilePATH = arg[1] --for Report()
THIS = "In GetDateTime: "

WriteToFile(os.date("%y%m%d-%H%M%S"),arg[2]..[[DateTime.txt]])
LuaEndedOk(THIS)
