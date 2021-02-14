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
if arg[2] then
    local macro_tb = {}
    for k,v in pairs(require(arg[2])) do
        macro_tb[arg[2] .. "." .. k] = v
    end
    os.execute("mkdir cc_temp")
    for i,v in ipairs(files) do
        local tfile = io.open("cc_temp/" .. v .. ".lua", "w+")
        for l in io.lines(v..".lua") do
            tfile:write(string.gsub(l,"("..arg[2]..".[A-Z_]+)", macro_tb), "\n")
        end
        tfile:close()
    end
    os.execute("luac cc_temp/"..table.concat(files, ".lua cc_temp/")..".lua")
else
    os.execute("luac "..table.concat(files, ".lua ")..".lua")
end
