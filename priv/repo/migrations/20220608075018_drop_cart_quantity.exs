defmodule DanubianTrade.Repo.Migrations.DropCartQuantity do
  use Ecto.Migration

  def change do
    alter table(:carts) do
      remove :quantity
    end
  end
end
