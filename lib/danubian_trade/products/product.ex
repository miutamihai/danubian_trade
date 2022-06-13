defmodule DanubianTrade.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :decimal
    field :image, :string
    field :quantity, :integer
    belongs_to :creator, DanubianTrade.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :image, :quantity, :creator_id])
    |> validate_required([:name, :description, :price, :image, :quantity, :creator_id])
  end
end
