function WriteToFile(output,file)
   local filehandle = openfile(file, 'w')
   if filehandle ~= nil then
      write(filehandle, output)
   end
   flush(filehandle)
   closefile(filehandle)
end

function WriteToFileAppend(output,file)
   local filehandle = openfile(file, 'a')
   if filehandle ~= nil then
      write(filehandle, output)
   end
   flush(filehandle)
   closefile(filehandle)
end

function LoadFileData(file)
   local filehandle = openfile(file, 'r')
   local data = read(filehandle, '*a')
   closefile(filehandle)
   return data
end

dostring(gsub(LoadFileData(LoadFileData("CurrentModScript.txt")),strchar(92),strchar(92) .. strchar(92)))

-- WriteToFile(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][1]["PAK_FILE_SOURCE"], "MOD_PAK_SOURCE.txt")
-- WriteToFile(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][1]["MBIN_CHANGE_TABLE"][1]["MBIN_FILE_SOURCE"], "MOD_MBIN_SOURCE.txt")


WriteToFile(NMS_MOD_DEFINITION_CONTAINER["MOD_FILENAME"], "MOD_FILENAME.txt")
WordWrap1 = "\n"
WordWrap2 = "\n"
for n=1,getn(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"]),1 do
	if n==getn(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"]) then WordWrap1 = "" end	
	if n==1 then WriteToFile(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["PAK_FILE_SOURCE"] .. WordWrap1, "MOD_PAK_SOURCE.txt")
	else WriteToFileAppend(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["PAK_FILE_SOURCE"] .. WordWrap1, "MOD_PAK_SOURCE.txt") end	
	for m=1,getn(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]),1 do
		if m==getn(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]) and n==getn(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"]) then WordWrap2 = "" end
		if n==1 and m==1 then WriteToFile(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"] .. WordWrap2, "MOD_MBIN_SOURCE.txt")
		else WriteToFileAppend(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"] .. WordWrap2, "MOD_MBIN_SOURCE.txt") end
		print(NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"])
	end
end
