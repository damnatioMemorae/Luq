package = "luq"
version = "scm-0"

source       = { url = "git://github.com/damnatioMemorae/luq.git" }
description  = {
        summary  = "A small single-file Functional library for Lua",
        detailed = "A small hobby-project library which brings Functional Programming to Lua",
        homepage = "http://github.com/damnatioMemorae/luq.git",
        license  = "MIT/X11",
}
dependencies = { "lua >= 5.1" }
build        = {
        type             = "none",
        install          = { lua = { luq = "luq.lua" } },
        copy_directories = {},
}
