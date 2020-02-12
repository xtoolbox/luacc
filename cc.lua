local old_require = _G.require
local req_tree = {}
local cur_req = req_tree
local collect_require = function(x)
    local last_req = cur_req
	cur_req[x] = cur_req[x] or {}
    cur_req = cur_req[x]
    local r = old_require(x)
    cur_req = last_req
    return r
end
_G.require = collect_require
require(arg[1])
local counts = {}
local files = {}
function count_req(t)
    local r = 1
    for k,v in pairs(t) do
        local c = counts[k] or count_req(v)
        if not counts[k] then
            files[#files+1] = k
			counts[k] = c
        end
        r = r + c
    end
    return r
end
count_req(req_tree)
table.sort(files, function(v1,v2)  return counts[v1]<counts[v2] end)
os.execute("luac "..table.concat(files, ".lua ")..".lua")
