# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GenApi.Repo.insert!(%GenApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# populate the datbase with 1,000,000 records when ecto.setup is run

# make a timestamps
now =
  NaiveDateTime.utc_now()
  |> NaiveDateTime.truncate(:second)

# generate params for 1,000,000 users batched in 20k
user_params =
  1..50
  |> Enum.map(fn _ ->
    Enum.map(1..20_000, fn _ -> %{points: 0} end)
    |> Enum.map(&Map.merge(&1, %{inserted_at: now, updated_at: now}))
  end)

# Batch insert all users taking into account that pg will only handle around 65k params at a time
user_params
|> Enum.map(fn list -> GenApi.Repo.insert_all(GenApi.User, list) end)
