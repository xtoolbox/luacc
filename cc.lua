local old_require = _G.require
local counts = {}
local current_count = 0
_G.require = function(x)
    local last_count = current_count
    current_count = 1
    local r = old_require(x)
    counts[x] = counts[x] or current_count
    current_count = last_count + counts[x]
    return r
end
require(arg[1])
local files = {}
for k,v in pairs(counts) do files[#files+1] = k end
table.sort(files, function(v1,v2)  return counts[v1]<counts[v2] end)
os.execute("luac "..table.concat(files, ".lua ")..".lua")
