defmodule DanubianTrade.Repo.Migrations.AddDeletedToCarts do
  use Ecto.Migration

  def change do
    alter table (:carts) do
      add :deleted, :boolean, default: false
    end
  end
end
