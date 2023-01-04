defmodule LiveTableExampleWeb.PageController do
  use LiveTableExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
