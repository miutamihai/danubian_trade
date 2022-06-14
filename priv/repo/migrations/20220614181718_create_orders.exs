defmodule DanubianTrade.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :number, :string

      timestamps()
    end

    create table(:order_products) do
      add :order_id, references(:orders)
      add :product_id, references(:products)

      timestamps()
    end
  end
end
