defmodule LiveTableExampleWeb.TableLive.FormComponent do
  use LiveTableExampleWeb, :live_component

  alias LiveTableExampleWeb.TableView
  alias LiveTableExample.Formats
  alias LiveTableExample.Formats.Header
  alias LiveTableExample.Formats.Row
  alias LiveTableExample.Formats.Item

  @impl true
  def render(assigns) do
    TableView.render("form_component.html", assigns)
  end

  @impl true
  def update(%{table: table} = assigns, socket) do
    params = %{
      headers: [%{label: "Objective"}, %{label: "Weight"}],
      rows: [
        %{
          items: [%{context: ""}, %{context: ""}]
        }
      ]
    }

    changeset =
      Formats.change_table(table, params)
      |> Formats.cast_assoc_headers()
      |> Formats.cast_assoc_rows()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"table" => table_params}, socket) do
    changeset =
      socket.assigns.table
      |> Formats.change_table(table_params)
      |> Formats.cast_assoc_headers()
      |> Formats.cast_assoc_rows()
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"table" => table_params}, socket) do
    save_table(socket, socket.assigns.action, table_params)
  end

  def handle_event("add_row", _params, socket) do
    new_items_params =
      socket.assigns.changeset.changes
      |> Map.get(:headers, socket.assigns.table.headers)
      |> Enum.map(fn _header ->
        %{context: ""}
      end)

    row_changeset = Formats.change_row(%Row{}, %{items: new_items_params})

    rows =
      socket.assigns.changeset.changes
      |> Map.get(:rows, [])
      |> Enum.concat([row_changeset])

    changeset =
      socket.assigns.changeset
      |> Formats.put_assoc_rows(rows)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("delete_row", %{"index" => index}, socket) do
    {i, _} = Integer.parse(index)

    rows =
      socket.assigns.changeset.changes
      |> Map.get(:rows)
      |> List.delete_at(i)

    changeset =
      socket.assigns.changeset
      |> Formats.put_assoc_rows(rows)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("add_col", %{"index" => index}, socket) do
    {i, _} = Integer.parse(index)

    headers =
      socket.assigns.changeset.changes
      |> Map.get(:headers, socket.assigns.table.headers)
      |> Enum.with_index()
      |> Enum.reduce([], fn {header, index}, acc ->
        case i == index do
          true ->
            acc = [Formats.change_header(%Header{}) | acc]
            [header | acc]

          false ->
            [header | acc]
        end
      end)
      |> Enum.reverse()

    existing_rows = Map.get(socket.assigns.changeset.changes, :rows, [])

    rows =
      case Enum.empty?(existing_rows) do
        true ->
          existing_rows

        false ->
          existing_rows
          |> Enum.map(fn row ->
            existing_items = Map.get(row.changes, :items, [])

            case Enum.empty?(existing_items) do
              true ->
                row

              false ->
                update_in(row.changes.items, fn items ->
                  items
                  |> Enum.with_index()
                  |> Enum.reduce([], fn {item, index}, acc ->
                    case i == index do
                      true ->
                        acc = [Formats.change_item(%Item{}) | acc]
                        [item | acc]

                      false ->
                        [item | acc]
                    end
                  end)
                  |> Enum.reverse()
                end)
            end
          end)
      end

    changeset =
      socket.assigns.changeset
      |> Formats.put_assoc_headers(headers)
      |> Formats.put_assoc_rows(rows)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("delete_col", %{"index" => index}, socket) do
    {i, _} = Integer.parse(index)

    headers =
      socket.assigns.changeset.changes
      |> Map.get(:headers, socket.assigns.table.headers)
      |> List.delete_at(i)

    existing_rows = Map.get(socket.assigns.changeset.changes, :rows, [])

    rows =
      case Enum.empty?(existing_rows) do
        true ->
          existing_rows

        false ->
          existing_rows
          |> Enum.map(fn row ->
            case Map.get(row.changes, :items, []) |> Enum.empty?() do
              true ->
                row

              false ->
                update_in(row.changes.items, fn items ->
                  items
                  |> List.delete_at(i)
                end)
            end
          end)
      end

    changeset =
      socket.assigns.changeset
      |> Formats.put_assoc_headers(headers)
      |> Formats.put_assoc_rows(rows)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  defp save_table(socket, :edit, table_params) do
    case Formats.update_table(socket.assigns.table, table_params) do
      {:ok, _table} ->
        {:noreply,
         socket
         |> put_flash(:info, "Table updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_table(socket, :new, table_params) do
    case Formats.create_table(table_params) do
      {:ok, _table} ->
        {:noreply,
         socket
         |> put_flash(:info, "Table created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
