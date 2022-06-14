defmodule DanubianTradeWeb.ProductLive.Show do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Accounts.User
  alias DanubianTrade.Products.Product
  alias DanubianTrade.Products
  alias DanubianTrade.Carts

  @impl true
  @spec mount(any, nil | maybe_improper_list | map, map) :: {:ok, map}
  def mount(_params, session, socket) do
    current_user = find_current_user(session)

    {:ok, socket |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_event("add_to_bag", _, socket), do: add_to_bag(socket, socket.assigns.current_user.confirmed_at)

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

  defp add_to_bag(socket, nil), do: {:noreply, socket |> put_flash(
    :error,
    "You must confirm your email address before you can add a product to your cart."
  )}

  defp add_to_bag(socket, _) do
    cart_input = %{
      user_id: socket.assigns.current_user.id,
      product_id: socket.assigns.product.id,
      quantity: socket.assigns.selected_quantity
    }

    Carts.create_cart(cart_input)

    {:noreply, socket
    |> push_event("hard-reload", %{})
  }
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
