defmodule LiveTableExampleWeb.TableLive.Index do
  use LiveTableExampleWeb, :live_view

  alias LiveTableExample.Formats
  alias LiveTableExample.Formats.Table
  alias LiveTableExampleWeb.TableView

  @impl true
  def render(assigns) do
    TableView.render("index.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tables, list_tables())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Table")
    |> assign(:table, Formats.get_table!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Table")
    |> assign(:table, %Table{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tables")
    |> assign(:table, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    table = Formats.get_table!(id)
    {:ok, _} = Formats.delete_table(table)

    {:noreply, assign(socket, :tables, list_tables())}
  end

  defp list_tables do
    Formats.list_tables()
  end
end
