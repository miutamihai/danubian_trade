defmodule DanubianTrade.Repo.Migrations.AddDecrementQuantityTriggerOnUpdate do
  use Ecto.Migration

  def change do
    execute """
    create or replace trigger decrement_quantity_insert
    after update on cart_products
    for each row
    update products
    set quantity = quantity - (new.quantity - old.quantity)
    where id = new.product_id;
    """
  end
end
