defmodule DanubianTradeWeb.ProductLive.Index do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Products
  alias DanubianTrade.Products.Product

  @page_size 8

  @impl true
  def mount(params, session, socket) do
    current_user = find_current_user(session)
    product_count = DanubianTrade.Products.count_products()
    {current_page, _} = (Map.get(params, "page") || "1") |> Integer.parse()

    {:ok,
     socket
     |> assign(:current_page, current_page)
     |> assign(:number_of_pages, div(product_count, @page_size))
     |> assign(:current_user, current_user)
     |> assign(:products, list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, %{"page" => page}) do
    {current_page, _} = (page || "1") |> Integer.parse()

    socket
    |> assign(:current_page, current_page)
    |> assign(:products, list_products(current_page * @page_size))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products(current_page \\ 0) do
    Products.list_products(current_page, @page_size)
  end
end
