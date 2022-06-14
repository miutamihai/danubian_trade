defmodule DanubianTrade.Repo.Migrations.AddRemoveFromCartProcedure do
  use Ecto.Migration

  def change do
    execute """
      create or replace procedure remove_from_cart(
      product_id_input integer,
      user_id_input integer
      )
      begin
      declare cart_id integer;
      start transaction;

      select id into cart_id from carts where user_id = user_id_input;

      delete from cart_products where cart_id = cart_id and product_id = product_id_input;
      end;
    """
  end
end
