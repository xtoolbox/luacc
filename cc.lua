-- cc.lua
-- a luac wrapper, sort the input file by require chain, then pass them to luac
local opts = {}
local files = {}
local parse_only = false
-- gather option and input files
for i=1,#arg do
    local v = arg[i]
    if v:sub(1,1) == "-" then
        opts[#opts+1] = v
        if v:sub(1,2) == '-o' then
            opts[#opts+1] = arg[i+1]
            i = i + 1
        end
        parse_only = parse_only or (v:sub(1,2) == '-p')
    else
        files[#files+1] = v
    end
end
-- build option
local cmd_opt = ""
for i,v in ipairs(opts) do
    cmd_opt = cmd_opt .. " " .. v
end

local req_chain = {}
for i,v in ipairs(files) do req_chain[v] = {} end
local function get_require(name)
    for l in io.lines(name) do
        string.gsub(l, "require%s*%(%s*\"([^\"]+)\"%s*%)%s*", function(require_name)
            require_name = require_name .. ".lua"
            local t = req_chain[name]
            if t then
                t[require_name] = true
                for k,v in pairs(req_chain[require_name] or {}) do
                    t[k] = v
                end
            end
        end)
    end
    return r
end
for i,v in ipairs(files) do get_require(v) end

local function count(t)
    local r = 0
    for k,v in pairs(t) do r = r + 1 end
    return r
end
local function concat(t, sep)
    local r, s = "", ""
    for k,v in pairs(t) do
        r = r .. s .. k
        s = sep
    end
    return r
end

files = {}
for k,v in pairs(req_chain) do
    files[#files + 1] = {k,count(v)}
end
table.sort(files, function(v1,v2) return v1[2] < v2[2] end)
local cmd_file = ""
local seq = ""
for i,v in ipairs(files) do
    cmd_file = cmd_file .. " " .. v[1]
    seq = seq .. " " .. v[1] .. ":r("..concat(req_chain[v[1]], ",") .. ")  "
end

if parse_only then
print("require chain", seq)
print("invoke luac"..cmd_opt..cmd_file)
end

os.execute("luac"..cmd_opt..cmd_file)

