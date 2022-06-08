defmodule DanubianTrade.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :quantity, :integer

      timestamps()
    end
  end
end
