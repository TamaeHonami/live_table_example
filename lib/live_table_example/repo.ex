defmodule LiveTableExample.Repo do
  use Ecto.Repo,
    otp_app: :live_table_example,
    adapter: Ecto.Adapters.MyXQL
end
