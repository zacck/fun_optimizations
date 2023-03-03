# GenApi

This is a Phoenix application that's quite fun to figure out with batching and optimizations:

It Does the following
- When the app starts, a `genserver` is launched which:
    - Has 2 elements as state:
        - A random number (let's call it the `min_number`), [0 - 100]
        - A timestamp (which indicates the last time someone queried the genserver, defaults to `nil` for the first query)
    - Runs every minute and when it runs:
        - Should update every user's points in the database (using a random number generator [0-100] for each)
        - Refresh the `min_number` of the genserver state with a new random number
    - Accepts a `handle_call` that:
        - Queries the database for all users with more points than `min_number` but only retrieve a max of 2 users.
        - Updates the genserver state `timestamp` with the current timestamp
        - Returns the users just retrieved from the database, as well as the timestamp of the **previous `handle_call`**


Set up and Run it as follows
  * You will need a `localhost` postgres setup with `postgres` as user and `postgres` as password
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Once the application starts you can visit `localhost:4000` to see the results and everytime you update that page you may get different results depending on the random state of the GenServer


# Caveats

Most of the functionality in this appication is implemented either in SQL or in plain elixir
the functions are there mainly to expose results rather than perform computations. Due to this
and the random nature of the updates needed I eschewed unit tests however it would be an interesting conversation on what should be tested and what shouldn't at this level.

Perhaps the initial seeding of the application could be done in SQL and could be much faster however I did not consider that as in general it is accepted that seeding and initializing will take a moment or so.
