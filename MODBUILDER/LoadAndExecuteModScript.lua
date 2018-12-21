function HandleModScript(MOD_DEF)
	for n=1,getn(MOD_DEF["MODIFICATIONS"]),1 do
		for m=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]),1 do
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
						THIS_FOLDER_PATH .. "MODBUILDER" .. strchar(92) .. "MOD" .. strchar(92) .. gsub(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"],".MBIN",".EXML"),
						strchar(34) .. MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][1] .. strchar(34), 
						MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][2],
						PRECEDING_KEY_WORDS_SUB
						)
				end
			end
		end
	end
end

function LoadFileData(file)
   local filehandle = openfile(file, 'r')
   local data = read(filehandle, '*a')
   closefile(filehandle)
   return data
end

THIS_FOLDER_PATH = LoadFileData("THIS_FOLDER_PATH.txt")
THIS_FOLDER_PATH = strsub(THIS_FOLDER_PATH, 1, strlen(THIS_FOLDER_PATH)-1)
	
function ExchangePropertyValue(file, property, value, preceding_key_words)
	print("\n" .. file, "\n", property, value)
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
	local TextFileTable = ParseTextFileIntoTable(file)
	local preceding_key_words_found = 0
	local line = ""	
	local j = 1
	local CurrentLine = 0
	for i=1,getn(TextFileTable),1 do
		line=TextFileTable[i]
		if (line ~= nil) then
			if preceding_key_words_empty == 0 and preceding_key_words_found == 0 then 
				if type(preceding_key_words) == "table" then
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
			if strfind(line, property) and ( (preceding_key_words_empty == 1) or ( (preceding_key_words_empty == 0) and (preceding_key_words_found == 1) ) ) then	
				local initial_pos = strfind(line, property)
				local start_pos = strfind(line, "value=", initial_pos)
				local end_pos = strfind(line, '"', start_pos+7)
				local exstring = strsub(line, start_pos+7, end_pos-1)
				local newline = gsub(line, exstring, value)	
				print("LUA: Exchanged line: " .. line .. " with line: " .. newline)
				-- print(newline)
				TextFileTable[i] = newline
				preceding_key_words_found = 0
				WriteToFile(ConvertLineTableToText(TextFileTable), file)
				break
			end
		end
	end
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


