defmodule DanubianTrade.Repo.Migrations.AddProductImage do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :image, :text
    end
  end
end
