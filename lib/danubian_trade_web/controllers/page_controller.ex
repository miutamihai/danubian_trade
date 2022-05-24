defmodule DanubianTradeWeb.PageController do
  use DanubianTradeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
