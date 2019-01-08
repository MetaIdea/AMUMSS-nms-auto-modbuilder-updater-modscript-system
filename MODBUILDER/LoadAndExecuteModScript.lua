print(">>>     In LoadAndExecuteModScript.lua")
NumReplacements = 0
NumFilesAdded = 0

function HandleModScript(MOD_DEF)
	if MOD_DEF["MODIFICATIONS"]~=nil then
		for n=1,getn(MOD_DEF["MODIFICATIONS"]),1 do
			for m=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]),1 do
				if type(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"]) == "table" then
					for u=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"]),1 do		
						for i=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"]),1 do
							for k=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"]),1 do
								local PRECEDING_KEY_WORDS_SUB = nil
								if MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["PRECEDING_KEY_WORDS"] ~= nil then
									PRECEDING_KEY_WORDS_SUB = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["PRECEDING_KEY_WORDS"]
								elseif MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_AFTER_ENTRY"] ~= nil then
									PRECEDING_KEY_WORDS_SUB = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_AFTER_ENTRY"]						
								end
								ExchangePropertyValue
									(
									THIS_FOLDER_PATH .. "MODBUILDER" .. strchar(92) .. "MOD" .. strchar(92) .. gsub(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"][u],".MBIN",".EXML"),
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][1], 
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][2],
									PRECEDING_KEY_WORDS_SUB,
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["MATH_OPERATION"],
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH"],
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_TYPE"],
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH_TYPE"],
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["LINE_OFFSET"],
									MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["ADD"]
									)					
							end
						end
					end	
				else
					for i=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"]),1 do
						for k=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"]),1 do				
							local PRECEDING_KEY_WORDS_SUB = nil
							if MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["PRECEDING_KEY_WORDS"] ~= nil then
								PRECEDING_KEY_WORDS_SUB = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["PRECEDING_KEY_WORDS"]
							elseif MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_AFTER_ENTRY"] ~= nil then
								PRECEDING_KEY_WORDS_SUB = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_AFTER_ENTRY"]						
							end
							ExchangePropertyValue
								(
								THIS_FOLDER_PATH .. "MODBUILDER" .. strchar(92) .. "MOD" .. strchar(92) .. gsub(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"],".MBIN",".EXML"),
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][1], 
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][2],
								PRECEDING_KEY_WORDS_SUB,
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["MATH_OPERATION"],
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH"],
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_TYPE"],
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH_TYPE"],
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["LINE_OFFSET"],
								MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["ADD"]
								)					
						end
					end			
				end
			end
		end
	end
	--Add new files
	if MOD_DEF["ADD_FILES"]~=nil then
		for i=1,getn(MOD_DEF["ADD_FILES"]),1 do
			local FolderPath = THIS_FOLDER_PATH .. "MODBUILDER" .. strchar(92) .. "MOD" .. [[\]] .. GetFolderPathFromFilePath(MOD_DEF["ADD_FILES"][i]["FILE_DESTINATION"])
			local FilePath = THIS_FOLDER_PATH .. "MODBUILDER" .. strchar(92) .. "MOD" .. [[\]] .. MOD_DEF["ADD_FILES"][i]["FILE_DESTINATION"]
			local _,count = gsub(MOD_DEF["ADD_FILES"][i]["FILE_DESTINATION"], [[\]], "")	
			if count>0 then
				print("create folder: " .. FolderPath)
				execute("START /B /MIN cmd /c mkdir " .. FolderPath)	
				sleep(0.1)
			end 
			print("create file: " .. FilePath)
			if MOD_DEF["ADD_FILES"][i]["EXTERNAL_FILE_SOURCE"]==nil or MOD_DEF["ADD_FILES"][i]["EXTERNAL_FILE_SOURCE"]=="" then
				local FileData = MOD_DEF["ADD_FILES"][i]["FILE_CONTENT"]
				WriteToFile(gsub(FileData,"\n","",1), FilePath)
			else
				local FilePathSource = GetFolderPathFromFilePath(LoadFileData("CurrentModScript.txt")) .. [[\]] .. MOD_DEF["ADD_FILES"][i]["EXTERNAL_FILE_SOURCE"]
				--local FileData = LoadFileData(FilePathSource)
				--WriteToFile(FileData, FilePath)
				execute("START /B /MIN cmd /c xcopy /y /h /v /i " .. FilePathSource .. " " .. FolderPath)	
			end
			NumFilesAdded=NumFilesAdded+1
		end
	end
end

function GetFolderPathFromFilePath(path)
	local _,count = gsub(path, [[\]], "")
	if count == 0 then return ""
	elseif count == 1 then return strsub(path, 1, strfind(path, [[\]])-1) end
	local temp1 = gsub(path, [[\]], "X_TEMP_X", count-1)
	local temp2 = strsub(temp1, 1, strfind(temp1, [[\]])-1)
	return gsub(temp2, "X_TEMP_X", [[\]])
end

function sleep(s)
	if s==nil then s=1 end
	local i=clock()+s 
	print("wait for " .. s .. " seconds ...") 
	while(clock()<i) do 
		--print("wait for " .. i-clock() .. " seconds") 
	end
	print("wait for " .. s .. " seconds finished") 
end

function ExtractString(text,start_str,end_str)
	local start_pos = strfind(text, start_str)
	local end_pos = strfind(text, end_str, start_pos)
	return strsub(text, start_pos, end_pos)
end

function LoadFileData(file)
   local filehandle = openfile(file, 'r')
   local data = read(filehandle, '*a')
   closefile(filehandle)
   return data
end

THIS_FOLDER_PATH = LoadFileData("THIS_FOLDER_PATH.txt")
THIS_FOLDER_PATH = strsub(THIS_FOLDER_PATH, 1, strlen(THIS_FOLDER_PATH)-1)

LAST_FILE = ""
TextFileTable = {}
	
function ExchangePropertyValue(file, property, value, preceding_key_words, math_operation, value_match, replace_type, value_match_type, line_offset, text_to_add)
	print("    Looking for >>> "..property..": New value will be >>> \""..value.."\"")  
	if replace_type ~= nil and not strfind(replace_type, "RAW") then
		property = strchar(34) .. property .. strchar(34)
	end
	preceding_key_words_empty = 0
	if type(preceding_key_words) == "table" then	
		if getn(preceding_key_words) == 0 then
			preceding_key_words_empty = 1
		else
			if preceding_key_words[1] == "" or preceding_key_words[1] == nil then 
				preceding_key_words_empty = 1
			end			
		end
		if preceding_key_words_empty == 0 then
			local preceding_key_words = CopyTable(preceding_key_words)		
			for z=1,getn(preceding_key_words),1 do
				preceding_key_words[z] = strchar(34) .. preceding_key_words[z] .. strchar(34)
			end		
		end
	elseif type(preceding_key_words) == "string" then
		if preceding_key_words == "" or preceding_key_words == nil then 
			preceding_key_words_empty = 1
		else
			preceding_key_words = strchar(34) .. preceding_key_words .. strchar(34)			
		end
	end
	--if LAST_FILE ~= file then 
		TextFileTable = ParseTextFileIntoTable(file) 
	--end
	LAST_FILE = file
	local preceding_key_words_found = 0
	local line = ""	
	local j = 1
	for i=1,getn(TextFileTable),1 do
		line=TextFileTable[i]
		if replace_type ~= nil and strfind(replace_type, "RAW") then
			if strfind(line, property) then 
				print("raw replacement of: " .. property .. " with: " .. value)
				TextFileTable[i]=gsub(line,property,value) 
			end
		else
			local TextMod = ""			
			if (line ~= nil) then
				if preceding_key_words_empty == 0 and preceding_key_words_found == 0 then 
					if type(preceding_key_words) == "table" then
						--if property == "y" then print(line, preceding_key_words[j]) end
						if strfind(line, preceding_key_words[j]) then 
							if j == getn(preceding_key_words) then 
								preceding_key_words_found = 1
							end
							j = j+1
						end
					elseif type(preceding_key_words) == "string" then
						if strfind(line, preceding_key_words) then
							preceding_key_words_found = 1									
						end
					end
				end											
				if (strfind(line, property) or strfind(property, "IGNORE")) and ( (preceding_key_words_empty == 1) or ( (preceding_key_words_empty == 0) and (preceding_key_words_found == 1) ) ) then	
					local offset = 0
					local offset_sign = "+"
					if line_offset ~= nil and line_offset ~= "" then
						offset_sign = strsub(line_offset,1,1)
						offset = tonumber(strsub(line_offset,2))	
					end
					local exstring = ExtractValueFromLine(line,property)					
					if value_match == nil or value_match == "" or strfind('"' .. exstring .. '"', value_match) then
						if value_match_type == nil or value_match_type == "" or ( value_match_type == "number" and type(tonumber(exstring)) == value_match_type) or ( value_match_type == "string" and type(exstring) == value_match_type) then 
							if text_to_add == nil or text_to_add == "" then --if not replace_type == "ADD" then
								if line_offset ~= nil and line_offset ~= "" then
									if offset_sign == "+" then 
										line=TextFileTable[i+offset] 
										if getn(TextFileTable) >= i+offset then
											i=i+offset
										end
									elseif offset_sign == "-" then 
										line=TextFileTable[i-offset]
										if 1 >= i-offset then
											--i=i-offset										
										end
									end							
									exstring = ExtractValueFromLine(line,property)
								end	
								local newline = ""
								local newvalue = 0
								if math_operation == nil or math_operation == "" then
									newvalue = value
								elseif strlen(math_operation) == 1 then
									newvalue = IntegerIntegrity(ExecuteMathOperation(math_operation,tonumber(exstring),tonumber(value)),property)
								elseif strfind(strsub(math_operation, 2, 3),"F:") then
									newvalue = IntegerIntegrity(ExecuteMathOperation(strsub(math_operation, 1, 1),tonumber(TranslateMathOperatorCommandAndGetValue(TextFileTable, strsub(math_operation, 4), i, "forward")),tonumber(value)),property)	
								elseif strfind(strsub(math_operation, 2, 3),"L:") then 
									newvalue = IntegerIntegrity(ExecuteMathOperation(strsub(math_operation, 1, 1),tonumber(ExtractValue(TextFileTable[i+tonumber(strsub(math_operation, 4))])),tonumber(value)),property) 								
								elseif strfind(strsub(math_operation, 2, 4),"FB:") then
									newvalue = IntegerIntegrity(ExecuteMathOperation(strsub(math_operation, 1, 1),tonumber(TranslateMathOperatorCommandAndGetValue(TextFileTable, strsub(math_operation, 5), i, "backward")),tonumber(value)),property)	
								elseif strfind(strsub(math_operation, 2, 4),"LB:") then 
									newvalue = IntegerIntegrity(ExecuteMathOperation(strsub(math_operation, 1, 1),tonumber(ExtractValue(TextFileTable[i-tonumber(strsub(math_operation, 5))])),tonumber(value)),property)								
								else
									newvalue = value
								end
								newline = gsub(line, exstring, newvalue)
								print("LUA: Exchanged line: " .. line .. " with line: " .. newline)
								NumReplacements = NumReplacements + 1
								TextFileTable[i] = newline
							else
								local _,linecount = gsub(text_to_add,"\n","")
								if line_offset ~= nil and line_offset ~= "" then
									if offset_sign == "+" then
										line=TextFileTable[i+offset]
										--if getn(TextFileTable) >= i+offset+linecount+1 then
											i=i+offset
										--end
									elseif offset_sign == "-" then
										line=TextFileTable[i-offset]
									end
								end	
								for k=1,i,1 do
									TextMod = TextMod .. TextFileTable[k] .. "\n"
								end
								TextMod = TextMod ..  text_to_add .. "\n"
								for k=i+1,getn(TextFileTable)-1,1 do
									TextMod = TextMod .. TextFileTable[k] .. "\n"
								end
								TextMod = TextMod .. TextFileTable[getn(TextFileTable)]
								print("LUA: Added text after line: " .. line)
								i=i+linecount
								WriteToFile(gsub(TextMod,"\n\n","\n"), file)
								preceding_key_words_found = 0								
								break --temporary fix
							end
							preceding_key_words_found = 0
							if (replace_type == nil or replace_type == "") then break
							elseif replace_type ~= nil and not strfind(replace_type,"ALL") then break
							end
						end
					end
				end
			end
		end
	end
	if text_to_add == nil or text_to_add == "" then
		WriteToFile(ConvertLineTableToText(TextFileTable), file)	
	else
		--WriteToFile(TextMod, file)	
	end
end

function ExtractValueFromLine(line,property)
	local initial_pos = 1
	local exstring = ""
	local exstring, end_pos, start_pos
	if not strfind(property, "IGNORE") and property~=nil then initial_pos = strfind(line, property) end
	start_pos = strfind(line, "value=", initial_pos)
	if start_pos ~= nil then
		end_pos = strfind(line, [["]], start_pos+7)
		exstring = strsub(line, start_pos+7, end_pos-1)	
	end
	return exstring
end

function CreateModDefintionFile(file1,file2)
	local ValueNameVanilla, ValueVanilla, ValueNameMod, ValueMod, LineMod, LineVanilla
	ModDef = ""
	TextFileTableVanilla = ParseTextFileIntoTable(file1)
	TextFileTableMod = ParseTextFileIntoTable(file2)
	for i=1,getn(TextFileTableVanilla),1 do
		ValueNameVanilla, ValueVanilla = ExtractPropertyAndValueFromLine(TextFileTableVanilla[i])
		ValueNameMod, ValueMod = ExtractPropertyAndValueFromLine(TextFileTableMod[i])
		if ValueNameVanilla~=nil and ValueVanilla~=nil and ValueNameMod~=nil and ValueMod~=nil then
			--print(ValueNameVanilla, ValueVanilla, ValueNameMod, ValueMod)
			if not strfind(ValueMod, ValueVanilla) and strfind(ValueNameMod, ValueNameVanilla) then
				local ValueNameVanilla_ = strsub(ValueNameVanilla,2,strlen(ValueNameVanilla)-1)
				local ValueMod_ = strsub(ValueMod,2,strlen(ValueMod)-1)
				local ValueVanilla_ = strsub(ValueVanilla,2,strlen(ValueVanilla)-1)				
				local TabString1 = strrep("\t", 9-floor((strlen(ValueNameVanilla_)/4)+0.5))
				local TabString2 = strrep("\t", 2-floor((strlen(ValueMod_)/4)+0.5))
				ModDef = ModDef .. "{ " .. [["]] .. ValueNameVanilla_ .. [["]] .. ", " .. TabString1 .. [["]] .. ValueMod_ .. [["]] .. " }, " .. TabString2 .. [[--Original ]] .. [["]] .. ValueVanilla_ .. [["]] .. "\n"		
			end
		end
	end
	WriteToFile(ModDef, "MODDEF.lua")
end

function ExtractPropertyAndValueFromLine(line)
	--print(line)
	local start_pos1, end_pos1, exstring1, start_pos2, end_pos2, exstring2 
	start_pos1 = strfind(line, "name=")
	if start_pos1 == nil then return end
	end_pos1 = strfind(line, '"', start_pos1+6)
	exstring1 = strsub(line, start_pos1+5, end_pos1)
	start_pos2 = strfind(line, "value=", end_pos1)
	if start_pos2 == nil then return end
	end_pos2 = strfind(line, '"', start_pos2+7)
	exstring2 = strsub(line, start_pos2+6, end_pos2)
	--print(exstring1, exstring2)
	return exstring1, exstring2
end

function TranslateMathOperatorCommandAndGetValue(TextFileTable, SearchKeyProperty, pos, direction)
	if direction == "forward" then
		for k=pos,getn(TextFileTable),1 do
			if (strfind(TextFileTable[k], SearchKeyProperty) or strfind(SearchKeyProperty, "IGNORE")) then
				return ExtractValue(TextFileTable[k])
			end
		end
	elseif direction == "backward" then
		for k=pos,1,-1 do
			if (strfind(TextFileTable[k], SearchKeyProperty) or strfind(SearchKeyProperty, "IGNORE")) then
				return ExtractValue(TextFileTable[k])
			end
		end		
	end
end

function IntegerIntegrity(number,property)
	if strfind(property,"Amount") or strfind(property,"Cost") then return floor(number+0.5)
	else return number end
end

function InsertTextIntoTable(table, text, pos)
	local TextFileTableMod = {}
	local TextTableToInsert = ConvertTextIntoTable(text)
	for k=1,pos,1 do
		tinsert(TextFileTableMod, table[k])
	end
	for k=1,getn(TextTableToInsert),1 do
		tinsert(TextFileTableMod, TextTableToInsert[k])
	end
	for k=pos+1,getn(table),1 do
		tinsert(TextFileTableMod, table[k])
	end
	return TextFileTableMod
end	

function ConvertTextIntoTable(text)
	local LineTable = {}
	local CurrentLine = ""
	while strfind(text, "\n") do
		CurrentLine = strsub(text, 1, strfind(line,"\n")+1)
		tinsert(LineTable,CurrentLine)
		text = gsub(text, CurrentLine .. "\n", "")  --error replaces all
	end
	return LineTable
end

function ExecuteMathOperation(math_operation,operand1,operand2)
	if math_operation == "*" then 
		return tonumber(operand1)*tonumber(operand2)
	elseif math_operation == "+" then 
		return tonumber(operand1)+tonumber(operand2)			
	elseif math_operation == "-" then 
		return tonumber(operand1)-tonumber(operand2)			
	elseif math_operation == "/" or math_operation == ":" then 
		return tonumber(operand1)/tonumber(operand2)
	else
		return 1
	end
end

function ExtractValue(line)
	local start_pos = strfind(line, "value=")
	local end_pos = strfind(line, '"', start_pos+7)
	local exstring = strsub(line, start_pos+7, end_pos-1)
	return exstring
end

function ExchangeEveryPropertyValue(file, property, value, preceding_key_words, math_operation, value_match, replace_type)
	--print("\n" .. file, "\n", property, value)
	local TextFileTable = ParseTextFileIntoTable(file)
	local line = ""	
	local CurrentLine = 0
	for i=1,getn(TextFileTable),1 do
		line=TextFileTable[i]
		if (line ~= nil) and strfind(line, property) then
			local initial_pos = strfind(line, property)
			local start_pos = strfind(line, "value=", initial_pos)
			local end_pos = strfind(line, '"', start_pos+7)
			local exstring = strsub(line, start_pos+7, end_pos-1)
			if value_match == nil or value_match == "" or strfind('"' .. exstring .. '"', value_match) then
				local newline = ""
				if math_operation == "*" then 
					newline = gsub(line, exstring, tonumber(exstring)*tonumber(value))	
				elseif math_operation == "+" then 
					newline = gsub(line, exstring, tonumber(exstring)+tonumber(value))
				elseif math_operation == "-" then 
					newline = gsub(line, exstring, tonumber(exstring)-tonumber(value))				
				elseif math_operation == "/" or math_operation == ":" then 
					newline = gsub(line, exstring, tonumber(exstring)/tonumber(value))				
				else
					newline = gsub(line, exstring, value)			
				end
				print("LUA: Exchanged line: " .. line .. " with line: " .. newline)
				TextFileTable[i] = newline				
			end
		end
	end
	WriteToFile(ConvertLineTableToText(TextFileTable), file)
end


function ConvertLineTableToText(LineTable)
	local Text = ""
	for i=1,getn(LineTable)-1,1 do
		Text = Text .. LineTable[i] .. "\n"
	end
	Text = Text .. LineTable[getn(LineTable)]
	return Text
end

function ParseTextFileIntoTable(file)
	local filehandle = openfile(file, 'r')
	local LineTable = {}
	local LineCount = 0
	line = read(filehandle, '*l')
	while line ~= nil do 
		LineCount=LineCount+1
		tinsert(LineTable, line) 
		line = read(filehandle, '*l') 
	end
	closefile(filehandle)	
	return LineTable, LineCount
end

function CopyTable(table_to_clone)
	local TableClone = {}
	for k,v in table_to_clone do
		tinsert(TableClone,v)
	end
	return TableClone
end

function ReplaceLastLine(TextChunk, line, newline)
	local _,linecount = gsub(TextChunk,"\n","")
	local TempTextChunk = gsub(TextChunk,"\n","X_TEMP_LINEBREAK_X",linecount-2)
	TempTextChunk = gsub(TempTextChunk, "\n" .. line, "\n" .. newline, 1)
	return gsub(TempTextChunk,"X_TEMP_LINEBREAK_X","\n")
end

function ReplaceLastEmptyLine(TextChunk)
	local _,linecount = gsub(TextChunk,"\n","")
	local TempTextChunk = gsub(TextChunk,"\n","X_TEMP_LINEBREAK_X",linecount-1)
	TempTextChunk = gsub(TempTextChunk, "\n", "")
	return gsub(TempTextChunk,"X_TEMP_LINEBREAK_X","\n")
end

function ExchangePropertyValueOLD(file, property, value, preceding_key_words)
	print(file)
	preceding_key_words_empty = 0	
	if type(preceding_key_words) == "table" then
		if getn(preceding_key_words) == 0 then
			preceding_key_words_empty = 1
		else
			if preceding_key_words[1] == "" or preceding_key_words[1] == nil then 
				preceding_key_words_empty = 1
			end			
		end
		if preceding_key_words_empty == 0 then
			for z=1,getn(preceding_key_words),1 do
				preceding_key_words[z] = strchar(34) .. preceding_key_words[z] .. strchar(34)
			end		
		end
	elseif type(preceding_key_words) == "string" then
		if preceding_key_words == "" or preceding_key_words == nil then 
			preceding_key_words_empty = 1
		else
			preceding_key_words = strchar(34) .. preceding_key_words .. strchar(34)			
		end
	end
	local filedata = LoadFileData(file)	
	local filehandle = openfile(file, 'r')
	local preceding_key_words_found = 0
	local preceding_key_words_found_initial = 0
	local TextChunkToReplace = ""
	local line = ""	
	local j = 1
	local CurrentLine = 0
	local _,linecount = gsub(filedata,"\n","")
	for i=1,linecount+1,1 do
		line=read(filehandle, '*l')
		if (line ~= nil) then
			if preceding_key_words_empty == 0 and preceding_key_words_found == 0 then 
				if type(preceding_key_words) == "table" then
					if strfind(line, preceding_key_words[j]) then 
						if j == getn(preceding_key_words) then 
							preceding_key_words_found = 1
						end
						preceding_key_words_found_initial = 1
						j = j+1
					end
				elseif type(preceding_key_words) == "string" then
					if strfind(line, preceding_key_words) then
						preceding_key_words_found = 1
						preceding_key_words_found_initial = 1										
					end
				end
			end
			if preceding_key_words_found_initial == 1 then 
				CurrentLine=CurrentLine+1			
				if CurrentLine == 1 then 
					TextChunkToReplace = TextChunkToReplace .. line
				else
					TextChunkToReplace = TextChunkToReplace .. "\n" .. line
				end
			end
			if strfind(line, property) and ( (preceding_key_words_empty == 1) or ( (preceding_key_words_empty == 0) and (preceding_key_words_found == 1) ) ) then	
				local initial_pos = strfind(line, property)
				local start_pos = strfind(line, "value=", initial_pos)
				local end_pos = strfind(line, '"', start_pos+7)
				local exstring = strsub(line, start_pos+7, end_pos-1)
				local newline = gsub(line, exstring, value)	
				if preceding_key_words_empty == 1 then 
					filedata = gsub(filedata, line, newline)
				else 
					TextChunkToReplaceMod = ReplaceLastLine(TextChunkToReplace, line, newline)
					filedata,c = gsub(filedata, TextChunkToReplace, TextChunkToReplaceMod, 1) 
				end
				preceding_key_words_found = 0
				preceding_key_words_found_initial = 0
				closefile(filehandle)
				WriteToFile(filedata, file)
				break
			end
		end
	end
end

function WriteToFile(output,file)
   local filehandle = openfile(file, 'w')
   if filehandle ~= nil then
      write(filehandle, output)
   end
   flush(filehandle)
   closefile(filehandle)
end

dofile("LoadScriptAndFilenames.lua")
HandleModScript(NMS_MOD_DEFINITION_CONTAINER)

print("\n    XXXXX Ended with "..NumReplacements.." replacement(s) made and " .. NumFilesAdded .. " files added " .. "XXXXX\n")
