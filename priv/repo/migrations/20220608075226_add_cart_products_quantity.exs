defmodule DanubianTrade.Repo.Migrations.AddCartProductsQuantity do
  use Ecto.Migration

  def change do
    alter table (:cart_products) do
      add :quantity, :integer, default: 1
    end
  end
end
