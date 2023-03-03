defmodule GenApiWeb.PageController do
  use GenApiWeb, :controller


  def index(conn, _params) do
    results = GenServer.call(:randomizer, :query)
    json(conn, results)
  end
end
