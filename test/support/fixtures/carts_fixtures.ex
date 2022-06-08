defmodule DanubianTrade.CartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DanubianTrade.Carts` context.
  """

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{
        quantity: "some quantity"
      })
      |> DanubianTrade.Carts.create_cart()

    cart
  end
end
