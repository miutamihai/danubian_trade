defmodule DanubianTrade.Repo.Migrations.AddCartUserIdIndex do
  use Ecto.Migration

  def change do
    create unique_index :carts, [:id, :user_id]
  end
end
