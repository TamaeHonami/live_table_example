defmodule LiveTableExample.Repo.Migrations.CreateTableHeaders do
  use Ecto.Migration

  def change do
    create table(:table_headers) do
      add :label, :string
      add :order, :integer, null: false
      add :table_id, references(:tables, on_delete: :delete_all)

      timestamps()
    end

    create index(:table_headers, [:table_id])
  end
end
