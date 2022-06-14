defmodule DanubianTrade.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :number, :string
    field :total_price, :float
    many_to_many :products, DanubianTrade.Products.Product,
      join_through: DanubianTrade.Orders.OrderProducts

    belongs_to :user, DanubianTrade.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:number])
    |> validate_required([:number])
  end
end
