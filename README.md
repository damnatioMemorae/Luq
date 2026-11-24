# luq

Luq is a single-file FP (Functional Programming) library for Lua started as a hobby project. Luq is named after Linq in
C# and the large amount of letter `q` in the library :p. I maintain the library myself without any use of AI and will
incrementally add new features.

## Simple usage

There are two ways to import the library:

``` lua
local luq = require "luq" -- Classic approach

require "luq" () -- Put everything from the library into a global namespace `_G`
```

## Features

### Case

```lua
local fruit = "apple"
case (fruit) {
        apple  = function() print("apple") end,
        banana = function() print("banana") end,
        _      = function() print("idk") end -- `_` is used as a wildcard pattern
}
```

`case` is a curried function of two arguments first of which is a value being matched against patterns and the second
one is a table of Key-value pairs where each `key` is a pattern to be matched against and `value` is an action performed
when successfully matched. By default `case` passes its value to the action:

```lua
local fruit = "apple"
case (fruit) {
        apple  = print, -- prints the value of `fruit` (in this case prints "apple")
        banana = print, -- prints nothing since value does not match the pattern
        _      = function() print("idk") end
}
```

Since the value is passed as a parameter to the pattern as well functions can be used as a pattern too:

```lua
local fruit = "apple"
case (fruit) {
        [function(_)
                return _ == "apple" and _
        end]   = print,
        banana = print,
        _      = function() print("idk") end,
}
```

Notice that any pattern predicate function must return its input arg on success, basic way of creating predicates is:

```lua
local function isEven(_)
        return _ % 2 == 0 and _ -- returns the input number if it is even
end
```

Or pattern is supported as well and is created by using a table as a `key`:

```lua
local fruit = "apple"
case (fruit) {
        [{ "apple", "banana" }] = print, -- will print either "apple" or "banana" depending on the value
        _                       = function() print("idk") end,
}
```

It is useful when you want to perform same action for different cases.

You can use predicate function in OR pattern as well:

```lua
local fruit = "apple"
local strq  = function(x) return type (x) == "string" and x end
local gt    = function(x) return function(_) return _ > x and _ end end
case (fruit) {
        [{ strq, gt(4) }] = print, -- will print either a string or a number that is greater than 4
        _                 = function() print("idk") end,
}
```

### Thunks

Thunk is a mechanism that allows you to capture function args withou calling that function:

```lua
local foo = print -- assigns the function value `print` to variable `foo`
local bar = thunk(print)("bar") -- creates and assigns a new function that performs print("bar") when called
```

Here `local bar = thunk(print)("bar")` is the same as:

```lua
local bar = function()
        print("bar")
end
```

It plays well with `case`:

```lua
local T     = thunk
local fruit = "apple"
case (fruit) {
        apple  = T(print)("This is an apple"),
        banana = T(print)("This is a banana"),
        _      = T(print)("idk") ,
}
```

## TODO

- Extend `case` to handle complicated data structures as patterns
