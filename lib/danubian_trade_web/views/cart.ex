defmodule DanubianTradeWeb.Cart do
  use Phoenix.Component
  alias DanubianTrade.Carts

  def render(assigns) do
    assigns =
      get_cart_products(assigns)
      |> calculate_subtotal()

    ~H"""
      <script>
        const closeCart = () => {
          document.getElementById('cart').style.display = 'none';
        }
        const removeItemFromCart = (id, userId) =>{
            let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
            fetch(`/remove_product/${userId}/${id}`, {
              method: 'POST',
              headers: {
                'x-csrf-token': csrfToken,
              }
            })
            .then(() => location.reload())
        }
        const addOrder = userId => {
            let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
            fetch(`/add_order/${userId}`, {
              method: 'POST',
              headers: {
                'x-csrf-token': csrfToken,
              }
            })
            .then(() => location.reload())
        }

      </script>
      <div id="cart" class="relative z-10" aria-labelledby="slide-over-title" role="dialog" aria-modal="true" style="display: none">
          <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
          <div class="fixed inset-0 overflow-hidden">
              <div class="absolute inset-0 overflow-hidden">
                  <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
                      <div class="pointer-events-auto w-screen max-w-md">
                          <div class="flex h-full flex-col overflow-y-scroll bg-white shadow-xl">
                              <div class="flex-1 overflow-y-auto py-6 px-4 sm:px-6">
                                  <div class="flex items-start justify-between">
                                      <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">Shopping cart</h2>
                                      <div class="ml-3 flex h-7 items-center">
                                          <button onclick="closeCart()" type="button" class="-m-2 p-2 text-gray-400 hover:text-gray-500">
                                              <span class="sr-only">Close panel</span>
                                              <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none"
                                                  viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"
                                                  aria-hidden="true">
                                                  <path stroke-linecap="round" stroke-linejoin="round"
                                                      d="M6 18L18 6M6 6l12 12" />
                                              </svg>
                                          </button>
                                      </div>
                                  </div>

                                  <div class="mt-8">
                                      <div class="flow-root">
                                        <%= if length(@cart_products) > 0 do %>
                                          <ul role="list" class="-my-6 divide-y divide-gray-200">
                                            <%= for product <- @cart_products do %>
                                                <li class="flex py-6">
                                                    <div
                                                        class="h-24 w-24 flex-shrink-0 overflow-hidden rounded-md border border-gray-200">
                                                        <img src={product.image}
                                                            alt={product.name}
                                                            class="h-full w-full object-cover object-center">
                                                    </div>

                                                    <div class="ml-4 flex flex-1 flex-col">
                                                        <div>
                                                            <div
                                                                class="flex justify-between text-base font-medium text-gray-900">
                                                                <h3>
                                                                    <a href="#"> <%= product.name %> </a>
                                                                </h3>
                                                                <p class="ml-4"><%= product.total %> RON</p>
                                                            </div>
                                                        </div>
                                                        <div class="flex flex-1 items-end justify-between text-sm">
                                                            <p class="text-gray-500">Qty <%= product.quantity %></p>

                                                            <div class="flex">
                                                                <button type="button" onclick={"removeItemFromCart(#{product.id}, #{@current_user.id})"}
                                                                    class="font-medium text-indigo-600 hover:text-indigo-500">Remove</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </li>
                                            <% end %>
                                          </ul>
                                          <% else %>
                                            <div style="min-height: 60vh" class="flex items-center justify-center">
                                                <div class="relative p-8 text-center border border-gray-200 rounded-lg">
                                                    <h2 class="text-2xl font-medium">
                                                    There's nothing here...
                                                    </h2>
                                                    <p class="mt-4 text-sm text-gray-500">
                                                        You can add products to your cart by clicking on the "Add to bag" button
                                                    </p>
                                                </div>
                                            </div>
                                          <% end %>
                                      </div>
                                  </div>
                              </div>

                              <div class="border-t border-gray-200 py-6 px-4 sm:px-6">
                                  <div class="flex justify-between text-base font-medium text-gray-900">
                                      <p>Subtotal</p>
                                      <p><%= @subtotal %> RON</p>
                                  </div>
                                  <p class="mt-0.5 text-sm text-gray-500">Shipping and taxes calculated at checkout.</p>
                                  <div class="mt-6">
                                      <a onclick={"addOrder(#{@current_user.id})"} style="cursor: pointer"
                                          class={(if @cart_products |> length > 0, do: "", else: "aeterial ") <> "flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-6 py-3 text-base font-medium text-white shadow-sm hover:bg-indigo-700"}>Checkout</a>
                                  </div>
                                  <div class="mt-6 flex justify-center text-center text-sm text-gray-500">
                                      <p>
                                          or <button type="button" onclick="closeCart()"
                                              class="font-medium text-indigo-600 hover:text-indigo-500">Continue Shopping<span
                                                  aria-hidden="true"> &rarr;</span></button>
                                      </p>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
    """
  end

  defp get_cart_products(assigns) do
    cart_products = Carts.get_user_cart_products(assigns.current_user.id)

    assigns
    |> assign(:cart_products, cart_products)
  end

  defp calculate_subtotal(assigns) do
    subtotal =
      Enum.reduce(assigns.cart_products, 0, fn %{total: total}, acc -> Decimal.add(acc, total) end)

    assigns
    |> assign(:subtotal, subtotal)
  end
end
