defmodule DanubianTrade.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
