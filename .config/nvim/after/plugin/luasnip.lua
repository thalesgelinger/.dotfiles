local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node


ls.add_snippets("lua", {
    s("hello", {
        t('print("hello world")')
    })
})

-- Custom React Native snippets
--ls.add_snippets("javascriptreact", {
--    -- useState snippet (rs)
--    s("rs", {
--        t("const ["),
--        i(1, "state"),
--        t(", set"),
--        f(function(args)
--            local state = args[1][1]
--            return state:gsub("^%l", string.upper)
--        end, { 1 }),
--        t("] = useState("),
--        i(2, "initialState"),
--        t(");"),
--    }),
--
--    -- useEffect snippet (re)
--    s("re", {
--        t("useEffect(() => {"),
--        t({ "", "\t" }),
--        i(1, "// effect code"),
--        t({ "", "\treturn () => {" }),
--        t({ "", "\t\t" }),
--        i(2, "// cleanup code"),
--        t({ "", "\t};" }),
--        t({ "", "}, [" }),
--        i(3, "dependencies"),
--        t("]);"),
--    }),
--
--    -- FlatList snippet (rfl)
--    s("rfl", {
--        t("<FlatList"),
--        t({ "", "\tdata={" }),
--        i(1, "data"),
--        t("}"),
--        t({ "", "\trenderItem={({ item }) => (" }),
--        t({ "", "\t\t" }),
--        i(2, "<View><Text>{item.title}</Text></View>"),
--        t({ "", "\t)}" }),
--        t({ "", "\tkeyExtractor={item => item." }),
--        i(3, "id"),
--        t(".toString()}"),
--        t({ "", "\t" }),
--        i(4, "// additional props"),
--        t({ "", "/>" }),
--    }),
--});

-- Extend to other JS/TS filetypes
--ls.filetype_extend("javascript", { "javascriptreact" })
--ls.filetype_extend("typescript", { "javascriptreact" })
--ls.filetype_extend("typescriptreact", { "javascriptreact" })
