defmodule MathesisWeb.QuoteLive.Index do
  use MathesisWeb, :live_view

  alias Mathesis.Quotes
  alias Mathesis.Quotes.Quote

  @impl true
  def mount(_params, _session, socket) do
    filter = %{author: ""}
    sort = %{field: "author", order: "asc"} # Default sort
    {:ok, assign(socket, quotes: list_quotes(sort), filter: filter, sort: sort)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Quote")
    |> assign(:quote, Quotes.get_quote!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Quote")
    |> assign(:quote, %Quote{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Quotes")
    |> assign(:quote, nil)
  end

  @impl true
  def handle_info({MathesisWeb.QuoteLive.FormComponent, {:saved, quote}}, socket) do
    {:noreply, update(socket, :quotes, fn quotes -> [quote | quotes] end)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    quote = Quotes.get_quote!(id)
    {:ok, _} = Quotes.delete_quote(quote)

    {:noreply, update(socket, :quotes, fn quotes -> Enum.reject(quotes, &(&1.id == quote.id)) end)}
  end

  def handle_event("filter", %{"filter" => %{"author" => author}}, socket) do
    filter = %{author: author}
    quotes = list_quotes(socket.assigns.sort, author) # Use current sort state
    {:noreply, assign(socket, filter: filter, quotes: quotes)}
  end

  def handle_event("sort", %{"field" => field}, socket) do
    current_sort = socket.assigns.sort
    new_order = if current_sort.field == field && current_sort.order == "asc", do: "desc", else: "asc"
    new_sort = %{field: field, order: new_order}

    {:noreply, assign(socket, quotes: list_quotes(new_sort), sort: new_sort)}
  end

  defp list_quotes(sort, author \\ "") do
    Quotes.list_quotes()
    |> Enum.filter(fn quote -> String.contains?(String.downcase(quote.author), String.downcase(author)) end)
    |> Enum.sort_by(
      &Map.get(&1, String.to_atom(sort.field)),
      if(sort.order == "asc", do: &<=/2, else: &>=/2)
    )
  end

  defp truncate(text, options \\ []) do
    max_length  = options[:length] || 50
    omission    = options[:omission] || "..."

    cond do
      not String.valid?(text) -> text
      String.length(text) < max_length -> text
      true ->
        length_with_omission = max_length - String.length(omission)
        "#{String.slice(text, 0, length_with_omission)}#{omission}"
    end
  end
end
