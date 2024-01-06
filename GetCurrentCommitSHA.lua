local function execute(command)
 local file = io.popen(command)
 local result = file:read("*all")
 file:close()
 return result
end

local sha = execute("git rev-parse HEAD")
local commit_name = execute("git log -1 --pretty=format:\"%s\"")

commit_sha = sha:gsub("^%s+", "")
commit_sha = sha:gsub("%s+$", "")

commit_name = commit_name:gsub("^%s+", "")
commit_name = commit_name:gsub("%s+$", "")

local file = io.open("commit_info.txt", "w")
	file:write("SHA: " ..commit_sha.. "\n")
	file:write("NAME: " ..commit_name.. "\n")
	file:close()