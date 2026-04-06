---
name: rover-backend-dev
description: Build backend apps with Rover. Use this whenever the user wants to create or modify Rover APIs, routes, request validation, response builders, middleware, auth flows, database usage, migrations, WebSocket handlers, or CLI-driven backend workflows with the `rover` binary and Lua APIs.
---

# Rover Backend Dev

Use this skill to build apps with Rover, not to hack on Rover internals.

## Scope

- Use the `rover` CLI.
- Write Rover apps in Lua.
- Use public Rover APIs from docs at `https://rover.lu`.
- Do not assume Rust, Cargo, or Rover repo internals matter.

## Main workflow

1. Create or edit a Lua app.
2. Use Rover server APIs like `rover.server`, `rover.guard`, `rover.db`.
3. Validate with `rover check`.
4. Format with `rover fmt`.
5. Run with `rover run`.
6. Use `rover db ...` when migrations are involved.

## CLI commands

```bash
rover run path/to/app.lua
rover check path/to/app.lua
rover fmt path/to/app.lua
rover build path/to/app.lua --out my-app
rover db migrate
rover db rollback --steps 1
rover db status
rover db reset --force
rover lsp
```

## Server mental model

- Start with `local api = rover.server {}`.
- Routes come from table shape.
- `function api.users.get(ctx)` means `GET /users`.
- `function api.users.p_id.get(ctx)` means `GET /users/:id`.
- Use `p_<name>` for path params.
- Return `api` at the end.

Example:

```lua
local api = rover.server {}
local g = rover.guard

function api.users.post(ctx)
  local body = ctx:body():expect {
    name = g:string():required(),
    email = g:string():required(),
  }

  return api.json:status(201, {
    ok = true,
    user = body,
  })
end

return api
```

## Context API

Reach for these first:

- `ctx.method`
- `ctx.path`
- `ctx:headers()`
- `ctx:query()`
- `ctx:params()`
- `ctx:body()`

Body helpers:

- `:json()`
- `:as_string()`
- `:text()`
- `:bytes()`
- `:expect(schema)`

## Validation rules

- Use `rover.guard` for request validation.
- Use `ctx:body():expect { ... }` for structured JSON input.
- `ctx:body():json()` and `ctx:body():expect(...)` need JSON `Content-Type`.
- Prefer explicit validation over hand-rolled checks.

## Response builders

Use Rover response builders instead of ad hoc response shapes when possible:

- `api.json(...)`
- `api.text(...)`
- `api.html(...)`
- `api.redirect(...)`
- `api:error(status, message)`
- `api.no_content()`
- `api.raw(...)`

Plain Lua tables also become JSON responses.

## Middleware and errors

- Use `before`, `after`, and `on_error` patterns supported by Rover.
- Keep middleware explicit and readable.
- Prefer consistent `api:error(...)` responses for failures.
- Use `on_error` when the app needs shared error formatting.

## Database rules

- Connect with `local db = rover.db.connect()`.
- Use Rover query DSL for CRUD.
- Use `rover.db.guard` for schema definitions.
- Use migrations for schema changes.
- Think in two layers: runtime queries and migration files.

Example:

```lua
local db = rover.db.connect { path = "rover.sqlite" }

local users = db.users:find():all()
local user = db.users:find():by_id(1):first()
db.users:insert({ name = "Ada" })
db.users:update():by_id(1):set({ name = "Ada Lovelace" }):exec()
db.users:delete():by_id(1):exec()
```

Migration shape:

```lua
function change()
  migration.users:create({
    id = rover.db.guard:integer():primary():auto(),
    email = rover.db.guard:string():unique(),
  })
end
```

## WebSocket + auth work

- Use Rover's public APIs and examples from docs.
- Keep handlers explicit and app-level.
- Prefer small readable flows over dynamic abstractions.

## Docs source

- Use `https://rover.lu` as source of truth for public behavior.
- Prefer guides for backend server, context API, response builders, database, migrations, CLI.
- If the active project includes Rover app code, inspect that project's Lua files for existing patterns.

## Pitfalls

- Do not mention Cargo or Rust implementation details.
- Do not assume the user is inside Rover's repo.
- Do not reference local filesystem paths from your own machine.
- Do not invent new routing conventions outside Rover's DSL.
- Do not change schema directly when migrations are the right tool.

## Good response style

- Talk in terms of Rover CLI + Lua APIs.
- Show small runnable Lua snippets.
- Mention exact `rover` commands to verify.
- Keep guidance app-focused.
