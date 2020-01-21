-- ****************************************************
-- main
-- ****************************************************

--arg[1] == path to REPORT.txt
--arg[2] == path to MODBUILDER

if gVerbose == nil then dofile(arg[2]..[[LoadHelpers.lua]]) end --.\MODBUILDER\
pv(">>>     In CheckGlobalReplacements.lua")
gfilePATH = arg[1] --to use by LoadHelpers.Report()
THIS = "In CheckGlobalReplacements: "

local LogTable = ParseTextFileIntoTable(arg[1]..[[REPORT.txt]])
local ScriptName = ""
local ActionCount = -1
local ScriptCount = -1

local NoProblems = true
Report("")
for i=1,#LogTable do
  local line = LogTable[i]
  if line ~= nil and string.find(line,"Starting to process script",1,true) ~= nil then
    ScriptName = StripInfo(line," [","]")
  end
  if line ~= nil and string.find(line,"Ended script processing with",1,true) ~= nil then
    ActionCount = tonumber(StripInfo(line," ["," action"))
  end
  if ScriptName ~= "" and ActionCount >= 0 then
    local ScriptTable = ParseTextFileIntoTable(arg[1]..[[ModScript\]]..ScriptName)
    for j=1,#ScriptTable do
      local line = ScriptTable[j]
      if line ~= nil and string.find(line,"global replacements",1,true) ~= nil then
        ScriptCount = tonumber(StripInfo(line,"--"," global"))
      end
    end
    
    local state = "ERROR"
    if ScriptCount == ActionCount then
      state = "INFO"
    elseif ScriptCount == -1 then
      ScriptCount = "???"
      state = "WARNING"
    end
    
    if state ~= "INFO" then
      NoProblems = false
      -- Report("")
      Report("",ScriptName..": "..ScriptCount.." global replacements / "..ActionCount.." action(s)",state)
    end
    
    --reset for next script
    ScriptName = ""
    ActionCount = -1
    ScriptCount = -1
  end
end

if NoProblems then
  Report("","ALL scripts are OK!")
end

LuaEndedOk(THIS)
