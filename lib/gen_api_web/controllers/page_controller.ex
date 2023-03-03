defmodule GenApiWeb.PageController do
  use GenApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
