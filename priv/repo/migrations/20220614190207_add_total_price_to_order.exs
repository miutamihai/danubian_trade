defmodule DanubianTrade.Repo.Migrations.AddTotalPriceToOrder do
  use Ecto.Migration

  def change do
    alter table (:orders) do
      add :total_price, :decimal
    end
  end
end
