defmodule DanubianTradeWeb.AddOrderController do
  use DanubianTradeWeb, :controller
  alias DanubianTrade.Carts
  alias DanubianTrade.Orders

  def index(conn, %{"user_id" => raw_user_id}) do
    {user_id, _} = Integer.parse(raw_user_id)

    cart_id = Carts.get_user_cart_id(user_id)
    order_number = :crypto.mac(:hmac, :sha256, raw_user_id, DateTime.utc_now() |> DateTime.to_string())
    |> Base.encode16
    |> String.slice(0..9)

    new_order_input = %{
      order_number: order_number,
      cart_id: cart_id
    }

    Orders.create_order(new_order_input)

    send_resp(conn, 201, "")
  end
end
