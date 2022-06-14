defmodule DanubianTrade.Orders.OrderProducts do
  use Ecto.Schema

  schema "order_products" do
    belongs_to :order, DanubianTrade.Orders.Order
    belongs_to :product, DanubianTrade.Products.Product
  end
end
