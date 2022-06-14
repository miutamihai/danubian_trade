defmodule DanubianTradeWeb.OrderLive.Index do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Orders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, list_orders())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  defp list_orders do
    Orders.list_orders()
  end
end
