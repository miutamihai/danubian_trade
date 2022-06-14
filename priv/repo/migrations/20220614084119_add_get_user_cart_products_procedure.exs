defmodule DanubianTrade.Repo.Migrations.AddGetUserCartProductsProcedure do
  use Ecto.Migration

  def change do
    execute """
    create or replace procedure get_user_cart_products(
        user_id_input int
    )
    begin
        select p.id, p.name, p.image, cp.quantity, p.price * cp.quantity as total
        from products as p
                 inner join cart_products cp on p.id = cp.product_id
                 inner join carts c on cp.cart_id = c.id
        where c.user_id = user_id_input;
    end;
    """
  end
end
