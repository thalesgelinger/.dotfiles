---
name: rover-ui-dev
description: Build UI apps with Rover. Use this whenever the user wants to create or modify Rover UI screens, TUI apps, signals, derived state, effects, tasks, modifiers, themes, component trees, keyed lists, or UI workflows driven by the `rover` binary and Lua APIs.
---

# Rover UI Dev

Use this skill to build apps with Rover UI, not to work on Rover internals.

## Scope

- Use the `rover` CLI.
- Write Rover UI in Lua.
- Use public Rover APIs from docs at `https://rover.lu`.
- Do not assume Rust, Cargo, or Rover repo internals matter.

## Main workflow

1. Create or edit a Lua UI app.
2. Define `function rover.render() ... end`.
3. Use `rover.ui`, `rover.tui`, signals, derived state, tasks, and modifiers.
4. Format with `rover fmt`.
5. Validate with `rover check` when useful.
6. Run with `rover run`, usually with a platform flag for UI work.

## CLI commands

```bash
rover run path/to/app.lua
rover run path/to/app.lua --platform stub
rover run path/to/app.lua --platform tui
rover run path/to/app.lua --platform web
rover check path/to/app.lua
rover fmt path/to/app.lua
rover build path/to/app.lua --out my-app
rover lsp
```

## UI mental model

- Entry point is global `function rover.render() ... end`.
- State is signal-based.
- UI comes from Lua constructors in `rover.ui`.
- TUI-specific helpers come from `rover.tui`.
- Think fine-grained reactive UI, not React hooks.

Example:

```lua
local ui = rover.ui

function rover.render()
  local count = rover.signal(0)
  local doubled = rover.derive(function()
    return count.val * 2
  end)

  return ui.column {
    ui.text { "Count: " .. count },
    ui.text { "Double: " .. doubled },
    ui.button {
      label = "inc",
      on_click = function()
        count.val = count.val + 1
      end,
    },
  }
end
```

## State rules

- Use `rover.signal(initial)` for writable state.
- Read and write with `.val`.
- Use `rover.derive(function() ... end)` for computed state.
- Use `rover.effect(function() ... end)` for side effects.
- Use `rover.on_destroy(function() ... end)` for cleanup.

## Important signal caveat

- Arithmetic and string concat can compose with signals.
- Comparison operators and logical operators do not create derived signals.
- For conditions like `count.val > 5`, use `rover.derive`.

Good:

```lua
local is_big = rover.derive(function()
  return count.val > 5
end)
```

## Core UI pieces

Use `rover.ui` components like:

- `text`
- `button`
- `input`
- `checkbox`
- `image`
- `column`
- `row`
- `view`
- `stack`
- `when`
- `each`

## TUI pieces

Use `rover.tui` for terminal apps:

- `select`
- `tab_select`
- `scroll_box`
- `textarea`
- `nav_list`
- `separator`
- `badge`
- `progress`
- `paginator`
- `full_screen`

Only use `rover.tui` when the app is meant for TUI.

## Dynamic UI rules

- Prefer `ui.when(cond, fn)` for reactive conditional UI.
- Prefer `ui.each(items, render, key_fn?)` for reactive lists.
- Use stable keys for lists.
- Avoid plain Lua `if` for reactive branches that should update live.

## Tasks and async UI

- `rover.task(fn)` creates a task.
- `rover.spawn(fn)` starts background work immediately.
- `rover.delay(ms)` yields inside tasks.
- `rover.interval(ms, fn)` runs now, then every interval.
- `rover.task.cancel(task)` stops a task.

Use tasks for timers, polling, background refresh, and event-driven UI flows.

## Styling and themes

- Use `rover.ui.mod` as the style builder.
- Chain modifiers like `:width(...)`, `:height(...)`, `:bg_color(...)`, `:padding(...)`.
- Modifier order matters for wrapper-like ops.
- Use `rover.ui.theme`, `rover.ui.extend_theme(...)`, and `rover.ui.set_theme(...)`.
- Prefer theme tokens over repeated hardcoded values.

Example:

```lua
local ui = rover.ui
local mod = ui.mod

function rover.render()
  return ui.view {
    mod = mod:width("full"):height("full"):bg_color("surface"):padding("md"),
    ui.text { "Hello" },
  }
end
```

## Platform guidance

- Use `--platform stub` for quick UI checks.
- Use `--platform tui` for terminal apps.
- Use `--platform web` for web UI runtime.
- Do not assume perfect parity across stub, TUI, and web.
- Verify target-specific behavior with the right `rover run` command.

## Docs source

- Use `https://rover.lu` as source of truth for public behavior.
- Prefer guides for UI runtime, signals, TUI runtime, and CLI.
- If the active project includes Rover UI code, inspect that project's Lua files for existing patterns.

## Pitfalls

- Do not mention Cargo or Rust implementation details.
- Do not assume the user is inside Rover's repo.
- Do not reference local filesystem paths from your own machine.
- Do not explain Rover UI as React hooks or a VDOM system.
- Do not promise platform parity without checking.

## Good response style

- Talk in terms of Rover CLI + Lua APIs.
- Show small runnable UI snippets.
- Mention exact `rover` commands to run the app.
- Keep guidance focused on app behavior and state flow.
