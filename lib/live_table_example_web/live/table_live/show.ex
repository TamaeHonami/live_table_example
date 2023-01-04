defmodule LiveTableExampleWeb.TableLive.Show do
  use LiveTableExampleWeb, :live_view

  alias LiveTableExample.Formats
  alias LiveTableExampleWeb.TableView

  @impl true
  def render(assigns) do
    TableView.render("show.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:table, Formats.get_table!(id))}
  end

  defp page_title(:show), do: "Show Table"
  defp page_title(:edit), do: "Edit Table"
end
