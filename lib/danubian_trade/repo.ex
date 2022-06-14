defmodule DanubianTrade.Repo do
  use Ecto.Repo,
    otp_app: :danubian_trade,
    adapter: Ecto.Adapters.MyXQL
end
