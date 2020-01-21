gVerbose = (io.open("luaVerbose.txt") ~= nil) 
if gVerbose then print("   [==[LUA Verbose ON]==]") end
gfilePATH = ".\\" --for Report()

gTracing = ""
function pv(...)
  if gVerbose then
    local temp = ""
    local num = select("#",...)
    for i=1,num do
      local text = select(i,...)
      if text == nil then text = "nil" end
      if type(text) == "boolean" then
        if text then
          text = "True"
        else
          text = "False"
        end
      end
      temp = temp..text
    end
    temp = "[==["..temp.."]==]"
    if gTracing ~= "" then
      print(temp.."   T: "..gTracing)
    else
      print(temp)
    end
  end
  gTracing = ""
end

pv(">>>     In LoadHelpers.lua")

function IsFileExist(filename)
  local Exist = false
  if filename == nil or filename == "" then return Exist end
  local filehandle = io.open(filename,"r")
  Exist = (filehandle ~= nil)
  if Exist then filehandle:close() end
  return Exist
end

function GetFileSize(filename)
  local filehandle = assert(io.open(filename,"r"),"io.open: Cannot open file to parse: "..filename)
  local size = filehandle:seek("end")    -- get file size
  filehandle:close()
  return size
end

function GetFileCreationDate(filename)
  local filehandle = io.popen( "dir "..filename.." /T:W", "r" )
  local LineTable = {}
  local line = assert(filehandle:read("l"),"read: cannot read line from file: "..filename)
  while line ~= nil do 
    table.insert(LineTable, line) 
    line = filehandle:read("l")
  end

  filehandle:close()
  return LineTable
end

function IsFile2Newest(file1,file2)
  pv("["..file1.."]")
  pv("["..file2.."]")
  local File2IsNewest = false
  os.remove("NewerFile.txt")
  os.execute([[START /wait "" /B /MIN cmd /c xcopy /DYLR "]]..file1
        ..[[" "]]..file2..[[*" | findstr /BC:"0" >nul && echo|set /p="]]..file2..[[ is newer">"NewerFile.txt"]])
  File2IsNewest = IsFileExist("NewerFile.txt")
  os.remove("NewerFile.txt")
  return File2IsNewest
end

function WriteToFile(output,filename)
  -- print(io.open(filename,"w")) --wbertro: for debug
  local filehandle = assert(io.open(filename,"w"),"io.open: Cannot open file to write: "..filename)
  if filehandle ~= nil then
    filehandle:write(output)
    filehandle:flush()
    filehandle:close()
  end
end

function WriteToFileAppend(output,filename)
  local filehandle = assert(io.open(filename,"a+"),"io.open: Cannot open file to append: "..filename)
  if filehandle ~= nil then
    filehandle:write(output)
    filehandle:flush()
    filehandle:close()
  end
end

function LoadFileData(filename)
  local data = ""
  if IsFileExist(filename) then
    local filehandle = assert(io.open(filename,"r"),"io.open: Cannot open file to load: "..filename)
    data = assert(filehandle:read("a"),"read: cannot read file: "..filename)
    filehandle:close()
  end
  return data
end

function ParseTextFileIntoTable(filename)
  local LineTable = {}
  local LineCount = 0
  if IsFileExist(filename) then
    local filehandle = assert(io.open(filename,"r"),"io.open: Cannot open file to parse: "..filename)
    local line = assert(filehandle:read("l"),"read: cannot read line from file: "..filename)
    while line ~= nil do 
      LineCount=LineCount+1
      table.insert(LineTable, line) 
      line = filehandle:read("l")
    end
    filehandle:close()
  end
  return LineTable, LineCount
end

function ConvertLineTableToText(LineTable)
	return table.concat(LineTable, "\n")
end

do
  --To retrieve a table from a text file
  function table.load( sfile )
    local ftables,err = loadfile( sfile )
    if err then return _,err end
    local tables = ftables()
    for idx = 1,#tables do
       local tolinki = {}
       for i,v in pairs( tables[idx] ) do
          if type( v ) == "table" then
            tables[idx][i] = tables[v[1]]
          end
          if type( i ) == "table" and tables[i[1]] then
            table.insert( tolinki,{ i,tables[i[1]] } )
          end
       end
       -- link indices
       for _,v in ipairs( tolinki ) do
          tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
       end
    end
    return tables[1]
  end

  local function basicSerialize(o)
    if type(o) == "number" then
      return tostring(o)
    else   -- assume it is a string
      return string.format("%q", o)
    end
    -- return string.format([["%s"]], o)
  end

  --To save a table to a text file
  function table.save(filename, value, saved)
    saved = saved or {}       -- initial value
    io.write(filename, " = ")
    if type(value) == "number" or type(value) == "string" then
      io.write(basicSerialize(value), "\n")
    elseif type(value) == "table" then
      if saved[value] then    -- value already saved?
        io.write(saved[value], "\n")  -- use its previous filename
      else
        saved[value] = filename   -- save filename for next time
        io.write("{}\n")     -- create a new table
        for k,v in pairs(value) do      -- save its fields
          local fieldfilename = string.format("%s[%s]", filename, basicSerialize(k))
          table.save(fieldfilename, v, saved)
        end
      end
    else
      error("cannot save a " .. type(value))
    end
  end
end

function SaveTable(filename,MyTable)
  io.output(filename)
  local name = string.sub(filename,1,string.find(filename,".",1,true)-1)
  table.save(name, MyTable)
  io.close()
end

function Round(number)
  return math.floor(number+0.5)
end

local function math_sign(v)
	return (v >= 0 and 1) or -1
end

local function math_round(v, multi)
	multi = multi or 1
	return math.floor((v/multi) + (math_sign(v) * 0.5)) * multi
end

function string.round(value)
  local dotPosition = string.find(value,".",1,true)
  if dotPosition == nil then return value end
  local afterDotString  = string.sub(value,dotPosition+1)
  if string.find(afterDotString,"0000",1,true) or string.find(afterDotString,"9999",1,true) then
    value = tostring(math_round(tonumber(value),0.001))
  end
  return value
end

function trim(s)
   --to force the return of only first arg of string.gsub
   --if used with table.insert: it will confuse it when the second arg is returned
  local r = string.gsub(s,"^%s*(.-)%s*$", "%1")
  return r
end

function StripInfo(Info,cut1,cut2)
  --if Info == nil then return nil end
  if type(Info) == "number" then Info = tostring(Info) end
  local _,stop = string.find(Info,cut1,1,true)
  if stop==nil then return Info end
  local result = string.sub(Info,stop+1)
  if cut2~=nil then
    local start = string.find(result,cut2,1,true)
    if start==nil then return Info end
    result = string.sub(result,1,start-1)
  end
  return result
end

function StripPath(filename,cutter)
  local start,stop = string.find(filename,cutter,1,true)
  local result = string.sub(filename,stop+1)
  return result
end

CurrentKeyWordsAndAll = {}

do
  local seen={}
  function GetLuaCurrentKeyWordsAndAll(t,tab,AllInfo,parent)
    seen[t]=true
    local s={}
    local n=0
    for k in pairs(t) do
      n=n+1
      s[n]=k
    end
    table.sort(s)

    for k,v in ipairs(s) do
      if AllInfo then
        parent = parent or ""
        print("["..parent..v.."]")
      else
        print("["..v.."]")
      end
      table.insert(CurrentKeyWordsAndAll,v)
      local possibleParent = v
      v=t[v]
      if type(v)=="table" and not seen[v] then
        if AllInfo then
          -- if parent == "" then
            parent = possibleParent.."."
          -- end
          GetLuaCurrentKeyWordsAndAll(v,tab.."\t",AllInfo,parent)
          parent = ""
        end
      end
    end
  end
end

--function Report(msg,Info,msgType) --TODO: maybe change order
function Report(Info,msg,msgType)
  -- the order is: msgType..msg..Info
  -- msgType default is (0 spaces)[INFO]:, otherwise it is (4 spaces)[msgType]:
  -- Info will appear inside [], any space before the first letter is transferred in front of the []
  -- msg will appear without change
  
  if Info == nil then return end
  if Info == "" and msg == nil then
    msgType = "" --to force a blank line to output
  end
  if msg == nil then msg = "" end

  if msgType == nil then
    msgType = "[INFO]: "
  elseif msgType ~= "" then
    msgType = "    ["..msgType.."]: "
  end
  
  local chain = "" --derived from Info
  local say = "" --final complete message
  if type(Info) == "table" then
    for z=1,#Info do
      chain = chain..Info[z]..[[, ]]
    end		
  elseif type(Info) == "string" then
    chain = Info
  elseif type(Info) == "boolean" then
    if Info then
      chain = "true"
    else
      chain = "false"
    end
  else
    chain = "???"
    say = "ERROR: in Report(): type(Info) is "..type(Info)
    print(say)
  end
  if chain ~= "" then
    local spacer = string.match(chain,"^%s*")
    if spacer == nil then spacer = "" end
    chain = " "..spacer.."["..trim(chain).."]"
  end
  -- if msg ~= "" then
    -- msg = " "..msg
  -- end
  say = msgType..msg..chain
  -- print("***** "..say.." *****")
  WriteToFileAppend(say.."\n", gfilePATH.."REPORT.txt")
end

function ShowTime(Time)
  return os.date("%H:%M:%S",Time)
end

function FolderExists(path)
  local result = false
  local tempname = string.sub(os.tmpname(),2)
  -- print(path..tempname)
  local filehandle = io.open(path..tempname,"w")
	if filehandle ~= nil then
    -- print(filehandle)
		io.close(filehandle)
		result = true
	end
  os.remove([["]]..path..tempname..[["]])
  return result
end

function GetFolderPathFromFilePath(path)
	assert(path ~= nil)
  path = string.gsub(path,[[/]],[[\]])
  local _,count = string.gsub(path,[[\]],"")
	if count == 0 then
    return ""
	elseif count == 1 then
    return string.sub(path,1,string.find(path,[[\]]) - 1)
  end
	local temp1 = string.gsub(path,[[\]],"X_TEMP_X",count-1)
	local temp2 = string.sub(temp1,1,string.find(temp1,[[\]])-1)
	return string.gsub(temp2,"X_TEMP_X",[[\]])
end

function TestNoNil(Info,...)
  local FoundNoNil = true
  local args = { n = select("#", ...), ... }
  for i=1,args.n do
    if args[i] == nil then
      print("BUG: "..Info..", arg["..i.."] is nil")
      FoundNoNil = false
    end
  end
  return FoundNoNil
end

--not used
function sleep(s)
	if s==nil then s=1 end
	local i=os.clock()+s 
	print("        waiting for " .. s .. " seconds ...") 
	while(os.clock()<i) do 
		--print("wait for " .. i-clock() .. " seconds") 
	end
    print("         finished waiting for " .. s .. " seconds") 
end


do
  local path = ""
  if os.getenv("_bMASTER_FOLDER_PATH") ~= nil then
    path = os.getenv("_bMASTER_FOLDER_PATH")..[[MODBUILDER\]]
  end
  
  function LuaStarting()
    pv("      +++++++++  LuaStarting  +++++++++")
    if os.remove(path..[[LuaEndedOk.txt]]) then
      pv("       LuaEndedOk.txt removed")
    end
  end

  function LuaEndedOk(Info)
    if Info == nil then Info = "" end
    pv("       --------  LuaEndedOk   -------- "..Info)
    WriteToFile("",path..[[LuaEndedOk.txt]])
  end

  LuaStarting()
end

