defmodule DanubianTrade.Repo.Migrations.AddClearCartsTrigger do
  use Ecto.Migration

  def change do
    execute """
    create or replace trigger clear_user_cart
      after update
      on orders
      for each row
    begin
      declare former_cart_id int;
      select id into former_cart_id from carts where user_id = new.user_id;
      delete from cart_products where cart_id = former_cart_id;
      delete from carts where id = former_cart_id;
    end;
    """
  end
end
