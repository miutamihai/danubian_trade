defmodule DanubianTrade.Repo.Migrations.AddCartUserId do
  use Ecto.Migration

  def change do
    alter table(:carts) do
      add :user_id, references(:users)
    end
  end
end
