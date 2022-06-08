defmodule DanubianTrade.Repo.Migrations.AddCartProducts do
  use Ecto.Migration

  def change do
    create table(:cart_products) do
      add :cart_id, references(:carts)
      add :product_id, references(:products)
    end
  end
end
