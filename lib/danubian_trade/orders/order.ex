defmodule DanubianTrade.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :number, :string
    many_to_many :products, DanubianTrade.Products.Product,
      join_through: DanubianTrade.Orders.OrderProducts

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:number])
    |> validate_required([:number])
  end
end
