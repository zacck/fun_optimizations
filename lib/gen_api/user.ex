defmodule GenApi.User do
  use Ecto.Schema
  import Ecto.Query
  alias GenApi.Repo
  alias GenApi.User

  # Add an encoder for our user structs so we can show them in JSON
  @derive {Jason.Encoder, only: [:id, :points]}
  schema "users" do
    field :points, :integer
    timestamps()
  end


  # update all the records in the database with a new random number
  # usually one would do this in the context but since it's our only
  # functioality I'll do it here to avoid adding more files
  def update_user_points() do
    # Since we have a million records I reckon the fastest way of upating them
    # is running raw SQL to update them in place,
    # if we had multiples of millions and some complex selection criteria
    # we could have batched the work and used a temporary table to do the work
    # and then replaced our table with the new one which would be discarded as soon as we are done with it
    result = Ecto.Adapters.SQL.query(Repo, "UPDATE users SET points = random()*(101-1)+1", [], [timeout: :infinity])

    case result do
      {:ok, _} -> :ok
      # lets log out the failure so someone can handle it
      _ -> IO.puts("Update user points failed at #{NaiveDateTime.utc_now()}")
    end
  end

  # let's fetch at max two users with more than a specified number of points
  def max_two_users_over(more_than) do
    query =
      from u in User,
      where: u.points > ^more_than,
      order_by: fragment("RANDOM()"),
      limit: 2

    Repo.all(query)
  end
end
