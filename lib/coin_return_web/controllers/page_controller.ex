defmodule CoinReturnWeb.PageController do
  use CoinReturnWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
