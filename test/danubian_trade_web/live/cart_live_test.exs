defmodule DanubianTradeWeb.CartLiveTest do
  use DanubianTradeWeb.ConnCase

  import Phoenix.LiveViewTest
  import DanubianTrade.CartsFixtures

  @create_attrs %{quantity: "some quantity"}
  @update_attrs %{quantity: "some updated quantity"}
  @invalid_attrs %{quantity: nil}

  defp create_cart(_) do
    cart = cart_fixture()
    %{cart: cart}
  end

  describe "Index" do
    setup [:create_cart]

    test "lists all carts", %{conn: conn, cart: cart} do
      {:ok, _index_live, html} = live(conn, Routes.cart_index_path(conn, :index))

      assert html =~ "Listing Carts"
      assert html =~ cart.quantity
    end

    test "saves new cart", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.cart_index_path(conn, :index))

      assert index_live |> element("a", "New Cart") |> render_click() =~
               "New Cart"

      assert_patch(index_live, Routes.cart_index_path(conn, :new))

      assert index_live
             |> form("#cart-form", cart: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#cart-form", cart: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.cart_index_path(conn, :index))

      assert html =~ "Cart created successfully"
      assert html =~ "some quantity"
    end

    test "updates cart in listing", %{conn: conn, cart: cart} do
      {:ok, index_live, _html} = live(conn, Routes.cart_index_path(conn, :index))

      assert index_live |> element("#cart-#{cart.id} a", "Edit") |> render_click() =~
               "Edit Cart"

      assert_patch(index_live, Routes.cart_index_path(conn, :edit, cart))

      assert index_live
             |> form("#cart-form", cart: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#cart-form", cart: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.cart_index_path(conn, :index))

      assert html =~ "Cart updated successfully"
      assert html =~ "some updated quantity"
    end

    test "deletes cart in listing", %{conn: conn, cart: cart} do
      {:ok, index_live, _html} = live(conn, Routes.cart_index_path(conn, :index))

      assert index_live |> element("#cart-#{cart.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cart-#{cart.id}")
    end
  end

  describe "Show" do
    setup [:create_cart]

    test "displays cart", %{conn: conn, cart: cart} do
      {:ok, _show_live, html} = live(conn, Routes.cart_show_path(conn, :show, cart))

      assert html =~ "Show Cart"
      assert html =~ cart.quantity
    end

    test "updates cart within modal", %{conn: conn, cart: cart} do
      {:ok, show_live, _html} = live(conn, Routes.cart_show_path(conn, :show, cart))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cart"

      assert_patch(show_live, Routes.cart_show_path(conn, :edit, cart))

      assert show_live
             |> form("#cart-form", cart: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#cart-form", cart: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.cart_show_path(conn, :show, cart))

      assert html =~ "Cart updated successfully"
      assert html =~ "some updated quantity"
    end
  end
end
