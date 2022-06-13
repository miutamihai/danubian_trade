defmodule DanubianTradeWeb.ProductLive.Show do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Accounts.User
  alias DanubianTrade.Products.Product
  alias DanubianTrade.Products

  @impl true
  def mount(_params, session, socket) do
    current_user = find_current_user(session)

    {:ok, socket |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_event("add_to_bag", _, socket) do
    IO.puts "THERE"

    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Products.get_product!(id))}
  end

  def edit?(%User{email: email}, %Product{creator: %User{email: creator_email}}) do
    email == creator_email
  end

  def edit?(_, _), do: false

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
