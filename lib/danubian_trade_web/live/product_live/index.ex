defmodule DanubianTradeWeb.ProductLive.Index do
  use DanubianTradeWeb, :live_view

  alias DanubianTrade.Products
  alias DanubianTrade.Products.Product
  alias DanubianTrade.Accounts.User

  @page_size 8

  @impl true
  def mount(params, session, socket) do
    current_user = find_current_user(session)
    {current_page, _} = (Map.get(params, "page") || "1") |> Integer.parse()
    filter = Map.get(params, "filter") || "all"

    {:ok,
     socket
     |> assign(:current_page, current_page)
     |> assign(:filter, filter)
     |> assign(:number_of_pages, page_count())
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

  defp apply_action(socket, :index, %{"filter" => filter}) do
    case filter do
      "all" ->
        socket
        |> assign(:filter, :all)
        |> assign(:current_page, 1)
        |> assign(:number_of_pages, page_count())
        |> assign(:products, list_products())

      "user" ->
        socket
        |> assign(:filter, :user)
        |> assign(:current_page, 1)
        |> assign(:number_of_pages, page_count(socket.assigns.current_user))
        |> assign(
          :products,
          user_products(socket.assigns.current_user, socket.assigns.current_page)
        )

      "non_user" ->
        socket
        |> assign(:filter, :non_user)
        |> assign(:current_page, 1)
        |> assign(:number_of_pages, page_count(socket.assigns.current_user, :exclusive))
        |> assign(
          :products,
          excluding_user_products(socket.assigns.current_user, socket.assigns.current_page)
        )
    end
  end

  defp apply_action(socket, :index, %{"page" => page}) do
    {current_page, _} = (page || "1") |> Integer.parse()

    socket
    |> assign(:current_page, current_page)
    |> assign(:products, list_products(current_page))
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

  @impl true
  def handle_event("filter_change", %{"filter" => %{"filter" => value}}, socket) do
    {:noreply, redirect(socket, to: "/products?filter=#{value}")}
  end

  defp ensure_not_nil(value), do: value || 0

  defp page_count(%User{email: email}, :exclusive),
    do:
      Products.count_products(email, :exclusive)
      |> ensure_not_nil()
      |> div(@page_size)

  defp page_count(%User{email: email}),
    do:
      Products.count_products(email)
      |> ensure_not_nil()
      |> div(@page_size)

  defp page_count,
    do:
      Products.count_products()
      |> ensure_not_nil()
      |> div(@page_size)

  defp user_products(%User{email: email}, current_page),
    do:
      offset(current_page)
      |> Products.list_products(@page_size, email)

  defp excluding_user_products(%User{email: email}, current_page),
    do:
      offset(current_page)
      |> Products.list_products(@page_size, email, :exclusive)

  defp list_products(current_page \\ 1),
    do:
      offset(current_page)
      |> Products.list_products(@page_size)

  defp offset(current_page), do: (current_page - 1) * @page_size
end
