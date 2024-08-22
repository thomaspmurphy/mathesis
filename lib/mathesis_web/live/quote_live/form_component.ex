defmodule MathesisWeb.QuoteLive.FormComponent do
  use MathesisWeb, :live_component

  alias Mathesis.Quotes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage quote records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="quote-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:author]} type="text" label="Author" class="border border-gray-300 rounded p-2" />
        <div class="flex flex-col">
          <label for="quote_content" class="font-semibold">Content</label>
          <div class="relative">
            <div class="absolute left-0 top-0 h-full w-1 bg-gray-400"></div>
            <.input field={@form[:content]} type="textarea" label="" class="border border-gray-300 rounded p-2 pl-6" placeholder="Enter quote content" rows="5" style="resize: none;" />
          </div>
        </div>
        <.input field={@form[:publisher]} type="text" label="Publisher" class="border border-gray-300 rounded p-2" />
        <.input field={@form[:year]} type="number" label="Year" class="border border-gray-300 rounded p-2" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Quote</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{quote: quote} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Quotes.change_quote(quote))
     end)}
  end

  @impl true
  def handle_event("validate", %{"quote" => quote_params}, socket) do
    changeset = Quotes.change_quote(socket.assigns.quote, quote_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"quote" => quote_params}, socket) do
    save_quote(socket, socket.assigns.action, quote_params)
  end

  defp save_quote(socket, :edit, quote_params) do
    case Quotes.update_quote(socket.assigns.quote, quote_params) do
      {:ok, quote} ->
        notify_parent({:saved, quote})

        {:noreply,
         socket
         |> put_flash(:info, "Quote updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_quote(socket, :new, quote_params) do
    case Quotes.create_quote(quote_params) do
      {:ok, quote} ->
        notify_parent({:saved, quote})

        {:noreply,
         socket
         |> put_flash(:info, "Quote created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
