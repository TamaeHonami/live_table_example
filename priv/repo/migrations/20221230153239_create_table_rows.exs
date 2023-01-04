defmodule LiveTableExample.Repo.Migrations.CreateTableRows do
  use Ecto.Migration

  def change do
    create table(:table_rows) do
      add :order, :integer, null: false
      add :table_id, references(:tables, on_delete: :delete_all)

      timestamps()
    end

    create index(:table_rows, [:table_id])
  end
end
