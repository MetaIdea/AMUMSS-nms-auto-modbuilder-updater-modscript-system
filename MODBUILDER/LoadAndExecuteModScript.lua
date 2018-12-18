function HandleModScript(MOD_DEF)
	for n=1,getn(MOD_DEF["MODIFICATIONS"]),1 do
		for m=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]),1 do
			for i=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"]),1 do
				for k=1,getn(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"]),1 do
					ExchangePropertyValue
						(
						gsub(THIS_FOLDER_PATH," ","") .. "MODBUILDER" .. strchar(92) .. "MOD" .. strchar(92) .. gsub(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"],".MBIN",".EXML"),
						strchar(34) .. MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][1] .. strchar(34), 
						MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"][k][2],
						MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_AFTER_ENTRY"]
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

function ExchangePropertyValue(file, property, value, replace_after_entry)
	print(file)
	if replace_after_entry ~= "" and replace_after_entry ~= nil then replace_after_entry = strchar(34) .. replace_after_entry .. strchar(34) end
	local filedata = LoadFileData(file)	
	local filehandle = openfile(file, 'r')
	local replace_after_entry_found = 0
	local TextChunkToReplace = ""
	local line = ""	
	local _,linecount = gsub(filedata,"\n","")
	for i=1,linecount+1,1 do
		line=read(filehandle, '*l')
		if (line ~= nil) then
			if strfind(line, replace_after_entry) then replace_after_entry_found = 1 end	
			if replace_after_entry_found == 1 then TextChunkToReplace = TextChunkToReplace .. line .. "\n" end
			if strfind(line, property) and ( (replace_after_entry == "" or replace_after_entry == nil) or ( (replace_after_entry ~= "" and replace_after_entry ~= nil) and replace_after_entry_found == 1 ) ) then	
				local initial_pos = strfind(line, property)
				local start_pos = strfind(line, "value=", initial_pos)
				local end_pos = strfind(line, '"', start_pos+7)
				local exstring = strsub(line, start_pos+7, end_pos-1)
				local newline = gsub(line, exstring, value)	
				local TextChunkToReplaceMod = gsub(TextChunkToReplace, line, newline)
				if replace_after_entry == "" or replace_after_entry == nil then filedata = gsub(filedata, line, newline)
				else filedata = gsub(filedata, TextChunkToReplace, TextChunkToReplaceMod) end
				replace_after_entry_found = 0
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


