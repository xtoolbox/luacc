# luacc
a luac wrapper, sort the input file by require chain, then pass them to luac

usage, lua cc.lua <same argument format of luac>

# example
There a 4 files named a.lua, b.lua, c.lua, d.lua

a.lua
```lua
print("a")
```

b.lua
```lua
require("a")
print("b")
```

c.lua
```lua
require("b")
print("c")
```

d.lua
```lua
require("c")
print("d")
```
## Command line
```batch
lua [path to cc.lua/]cc.lua -p *a
```

## Output
```bat
require chain    a.lua:r()   b.lua:r(a.lua)   c.lua:r(b.lua,a.lua)   d.lua:r(c.lua,b.lua,a.lua)
invoke luac -p a.lua b.lua c.lua d.lua
```
