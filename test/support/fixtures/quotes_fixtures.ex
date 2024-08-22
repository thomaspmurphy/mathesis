defmodule Mathesis.QuotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mathesis.Quotes` context.
  """

  @doc """
  Generate a quote.
  """
  def quote_fixture(attrs \\ %{}) do
    {:ok, quote} =
      attrs
      |> Enum.into(%{
        author: "some author",
        content: "some content",
        publisher: "some publisher",
        year: 42
      })
      |> Mathesis.Quotes.create_quote()

    quote
  end
end
