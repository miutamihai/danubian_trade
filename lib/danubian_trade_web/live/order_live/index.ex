defmodule DanubianTradeWeb.OrderLive.Index do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Orders

  @impl true
  def mount(_params, session, socket) do
    current_user = find_current_user(session)

    {:ok, socket
    |> assign(:current_user, current_user)
    |> assign(:orders, list_orders(current_user))
  }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
  end

  defp list_orders(current_user) do
    Orders.list_orders(current_user.id)
    |> Enum.map(fn order ->
      %{
        order
        | total_price: order.total_price |> Decimal.from_float() |> Decimal.to_string(:normal)
      }
    end)
  end
end
