defmodule DanubianTrade.Repo.Migrations.AddCartUserIdFunction do
  use Ecto.Migration

  def change do
    execute """
    create or replace function get_user_cart_id(
    user_id_input integer
    ) returns integer
    begin
    return (select id from carts where user_id = user_id_input and deleted = 0);
    end;
    """
  end
end
