defmodule Mathesis.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :author, :string
    field :year, :integer
    field :content, :string
    field :publisher, :string

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:content, :author, :publisher, :year])
    |> validate_required([:content, :author, :publisher, :year])
  end
end
