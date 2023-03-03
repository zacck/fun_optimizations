defmodule GenApi.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GenApi.Repo

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
end
