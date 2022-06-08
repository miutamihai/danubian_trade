defmodule DanubianTrade.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    many_to_many :products, DanubianTrade.Products.Product,
      join_through: DanubianTrade.Carts.CartProducts

    belongs_to :user, DanubianTrade.Users.User
    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
