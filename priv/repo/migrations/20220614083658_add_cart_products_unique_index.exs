defmodule DanubianTrade.Repo.Migrations.AddCartProductsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index :cart_products, [:cart_id, :product_id]
  end
end
