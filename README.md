# PhoenixHateoas

[Hateoas](https://es.wikipedia.org/wiki/HATEOAS) is a way to provide additional information to an API consumer, about additional available endpoints that will help it navigate through the data.

PhoenixHateoas is a library for Elixir's [Phoenix Framework](https://www.phoenixframework.org/), that will help you creating Hateoas links in your application.

## Requeriments

PhoenixHateoas needs your application to be done with `Phoenix`. It only works with Json API, being implemented with the standard configuration (using standard endpoints and functions).

## Installation

Add `phoenix_hateoas` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_hateoas, "~> 0.1.0", git: "https://github.com/alexanderttalvarez/phoenix_hateoas.git"}
  ]
end
```

## Setting up

You have several options for adding `phoenix_hateoas` to you Phoenix application. Just add the plug `PhoenixHateoas.Plug`. Generic instructions regarding how to add a plug can be found in the [official Phoenix website](https://hexdocs.pm/phoenix/plug.html):

1) Inside the specific controller you want to add `Hateoas` to:
```elixir
defmodule MyAppWeb.MyController do
  use MyAppWeb, :controller

  plug PhoenixHateoas.Plug
```

2) Inside your `router.ex`:
```elixir
scope "/", MyAppWeb do
  plug PhoenixHateoas.Plug

  resources "/users", UserController
end
```

3) Inside a pipeline, within your `router.ex`:
```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug PhoenixHateoas.Plug
end
```

## Result

When calling an endpoint, you will see that the additional data is found:
```json
"_links": [
  {
    "href": "/api/v1/users/1",
    "rel": "self"
  },
  {
    "href": "/api/v1/users",
    "rel": "index"
  }
],
```

## Current state

At the moment, only the `self` and `index` endpoints are implemented. Following steps will be adding the `next` and `previous` links when visiting a single element.
