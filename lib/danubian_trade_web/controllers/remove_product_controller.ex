defmodule DanubianTradeWeb.RemoveProductController do
  use DanubianTradeWeb, :controller
  alias DanubianTrade.Carts

  def index(conn, %{"id" => raw_product_id, "user_id" => raw_user_id}) do
    {user_id, _} = Integer.parse(raw_user_id)
    {product_id, _} = Integer.parse(raw_product_id)
    input = %{
      product_id: product_id,
      user_id: user_id
    }

    Carts.remove_item_from_cart(input)

    send_resp(conn, 201, "")
  end
end
