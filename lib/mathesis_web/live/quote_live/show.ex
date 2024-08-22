defmodule MathesisWeb.QuoteLive.Show do
  use MathesisWeb, :live_view

  alias Mathesis.Quotes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:quote, Quotes.get_quote!(id))}
  end

  defp page_title(:show), do: "Show Quote"
  defp page_title(:edit), do: "Edit Quote"
end
