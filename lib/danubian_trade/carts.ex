defmodule DanubianTrade.Carts do
  @moduledoc """
  The Carts context.
  """

  import Ecto.Query, warn: false
  alias DanubianTrade.Repo

  alias DanubianTrade.Carts.Cart

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    DanubianTrade.Repo.query!(
      "call add_cart(?, ?, ?)",
      [attrs.user_id, attrs.product_id, attrs.quantity]
    )
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  def get_user_cart_products(user_id) do
    {:ok, %MyXQL.Result{rows: rows}} = Repo.query("call get_user_cart_products(?)", [user_id])

    rows
    |> Enum.map(fn row ->
      %{
        id: Enum.at(row, 0),
        name: Enum.at(row, 1),
        image: Enum.at(row, 2),
        quantity: Enum.at(row, 3),
        total: Enum.at(row, 4)
      }
    end)
  end

  def remove_item_from_cart(attrs \\ %{}) do
    DanubianTrade.Repo.query!(
      "call remove_from_cart(?, ?)",
      [attrs.product_id, attrs.user_id]
    )
  end
end
