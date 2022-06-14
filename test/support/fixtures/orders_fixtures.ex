defmodule DanubianTrade.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DanubianTrade.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        number: "some number"
      })
      |> DanubianTrade.Orders.create_order()

    order
  end
end
