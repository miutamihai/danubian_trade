defmodule DanubianTradeWeb.ProductLive.EmptyState do
  use DanubianTradeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(:action, fn -> [] end)}
  end
end
