# luacc
a luac wrapper, sort the input file by require chain, then pass them to luac
```bat
usage
lua cc.lua <entry point>
```

cc.lua use require(arg[1]) to parse the depends
