defmodule DanubianTrade.Repo.Migrations.AddClearUserCartTrigger do
  use Ecto.Migration

  def change do
    execute """
    create or replace trigger clear_user_cart
      after update
      on orders
      for each row
    begin
      update carts set deleted = 1 where user_id = new.user_id;
    end;
    """
  end
end
