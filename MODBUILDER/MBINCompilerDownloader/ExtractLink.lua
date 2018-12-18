function GetURL()
	local URL = ""
	local line = ""
	local filehandle = openfile("temp.txt", 'r')
	for i=1,2000,1 do
		line=read(filehandle, '*l')
		if line ~= nil then 
			--WriteToFile("test","templua.txt")		
			if strfind(line, "MBINCompiler.exe") then				
				local start_pos = strfind(line,'"')
				if start_pos ~= nil then 
					local end_pos   = strfind(line," rel=",start_pos)
					local exstring = strsub(line,start_pos+1,end_pos-2)
					URL = "https://github.com" .. exstring
				end	
				closefile(filehandle)
				WriteToFile(URL,"temp.txt")
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

GetURL()


		
		-- filehandle = openfile(file, 'w+')
		-- write(filehandle,data_to_exec)