defmodule DanubianTrade.Repo.Migrations.AddReimburseProductQuantityTrigger do
  use Ecto.Migration

  def change do
    execute """
    create or replace trigger reimburse_quantity_on_cart_removal
    before delete on cart_products
    for each row
        update products set quantity = quantity + old.quantity
        where id = old.product_id;
    """
  end
end
