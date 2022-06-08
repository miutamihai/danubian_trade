defmodule DanubianTrade.Repo.Migrations.AddProductCreator do
  use Ecto.Migration

  def change do
    alter table :products do
      add :creator_id, references(:users)
    end
  end
end
