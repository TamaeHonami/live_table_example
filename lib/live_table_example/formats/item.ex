defmodule LiveTableExample.Formats.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "table_items" do
    field :context, :string
    field :order, :integer
    belongs_to :row, LiveTableExample.Formats.Row

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:context, :order])
    |> validate_required([:context, :order])
  end
end
