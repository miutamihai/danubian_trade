defmodule DanubianTradeWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS
  alias DanubianTrade.Accounts

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.product_index_path(@socket, :index)}>
        <.live_component
          module={DanubianTradeWeb.ProductLive.FormComponent}
          id={@product.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.product_index_path(@socket, :index)}
          product: @product
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div class="relative z-10" aria-labelledby="modal-title" role="dialog" aria-modal="true" phx-remove={hide_modal()}>
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
      <div class="fixed z-10 inset-0 overflow-y-auto" phx-click-away={JS.dispatch("click", to: "#close")}
           phx-window-keydown={JS.dispatch("keydown", to: "#close")}
           phx-key="escape"
        >
        <div class="flex items-end sm:items-center justify-center h-full p-4 text-center sm:p-0">
          <div class="relative bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:max-w-lg sm:w-full">
            <%= if @return_to do %>
                <%= live_patch "", to: @return_to, id: "close", phx_click: hide_modal(), class: "close" %>
            <% else %>
              <span role="button" phx-click={hide_modal()} class="close"/>
            <% end %>
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end
end
