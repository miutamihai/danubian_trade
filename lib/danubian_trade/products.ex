defmodule DanubianTrade.Products do
  import Ecto.Query, warn: false
  alias DanubianTrade.Repo

  alias DanubianTrade.Products.Product

  defp listing_query(offset, limit) do
    from p in Product,
      limit: ^limit,
      offset: ^offset
  end

  defp counting_query do
    from p in Product,
      select: count(p.id)
  end

  defp by_email_query(email) do
    from product in Product,
      join: user in assoc(product, :creator),
      where: user.email == ^email
  end

  defp excluding_email_query(email) do
    from product in Product,
      join: user in assoc(product, :creator),
      where: user.email != ^email
  end

  def by_email(email, :exclusive) do
    excluding_email_query(email)
    |> Repo.all()
    |> Repo.preload(:creator)
  end

  def by_email(email) do
    by_email_query(email)
    |> Repo.all()
    |> Repo.preload(:creator)
  end

  def count_products do
    counting_query()
    |> Repo.one()
  end

  def list_products(offset \\ 0, limit \\ 8) do
    listing_query(offset, limit)
    |> Repo.all()
    |> Repo.preload(:creator)
  end

  def get_product!(id),
    do:
      Repo.get!(Product, id)
      |> Repo.preload(:creator)

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
