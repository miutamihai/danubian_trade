defmodule DanubianTrade.Repo.Migrations.AddDecrementQuantityTrigger do
  use Ecto.Migration

  def change do
    execute """
    create or replace trigger decrement_quantity
    after insert on cart_products
    for each row
    update products
    set quantity = quantity - new.quantity
    where id = new.product_id;
    """
  end
end
