defmodule GenApi.User do
  use Ecto.Schema

  schema "users" do
    field :points, :integer
    timestamps()
  end
end
