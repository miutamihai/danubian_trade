defmodule DanubianTrade.Carts.CartProducts do
  use Ecto.Schema

  schema "cart_products" do
    belongs_to :cart, DanubianTrade.Carts.Cart
    belongs_to :product, DanubianTrade.Products.Product
    field :quantity, :integer
  end
end