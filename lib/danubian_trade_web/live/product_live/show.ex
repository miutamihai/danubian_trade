defmodule DanubianTradeWeb.ProductLive.Show do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Accounts.User
  alias DanubianTrade.Products.Product
  alias DanubianTrade.Products
  alias DanubianTrade.Carts

  @impl true
  def mount(_params, session, socket) do
    current_user = find_current_user(session)

    {:ok, socket |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_event("add_to_bag", _, socket) do
    cart_input = %{
      user_id: socket.assigns.current_user.id,
      product_id: socket.assigns.product.id,
      quantity: socket.assigns.selected_quantity
    }

    Carts.create_cart(cart_input)

    {:noreply, socket |> put_flash(:info, "Product added to cart successfully")}
  end

  @impl true
  def handle_event("update_quantity", %{"quantity" => %{"quantity" => quantity}}, socket) do
    {:noreply,
     socket
     |> assign(:selected_quantity, quantity)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Products.get_product!(id)

    {:noreply,
     socket
     |> assign(:selected_quantity, "#{product.quantity}")
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, product)}
  end

  def edit?(%User{email: email}, %Product{creator: %User{email: creator_email}}) do
    email == creator_email
  end

  def edit?(_, _), do: false

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
