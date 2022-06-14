defmodule DanubianTrade.Repo.Migrations.MakeOrderIdUnique do
  use Ecto.Migration

  def change do
    create unique_index :orders, [:number]
  end
end
