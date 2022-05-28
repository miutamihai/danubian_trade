defmodule DanubianTrade.Repo.Migrations.ChangePriceType do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :price, :decimal, precision: 10, scale: 2
    end

  end
end
