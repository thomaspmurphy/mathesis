defmodule Mathesis.QuotesTest do
  use Mathesis.DataCase

  alias Mathesis.Quotes

  describe "quotes" do
    alias Mathesis.Quotes.Quote

    import Mathesis.QuotesFixtures

    @invalid_attrs %{author: nil, year: nil, content: nil, publisher: nil}

    test "list_quotes/0 returns all quotes" do
      quote = quote_fixture()
      assert Quotes.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = quote_fixture()
      assert Quotes.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      valid_attrs = %{author: "some author", year: 42, content: "some content", publisher: "some publisher"}

      assert {:ok, %Quote{} = quote} = Quotes.create_quote(valid_attrs)
      assert quote.author == "some author"
      assert quote.year == 42
      assert quote.content == "some content"
      assert quote.publisher == "some publisher"
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quotes.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = quote_fixture()
      update_attrs = %{author: "some updated author", year: 43, content: "some updated content", publisher: "some updated publisher"}

      assert {:ok, %Quote{} = quote} = Quotes.update_quote(quote, update_attrs)
      assert quote.author == "some updated author"
      assert quote.year == 43
      assert quote.content == "some updated content"
      assert quote.publisher == "some updated publisher"
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Quotes.update_quote(quote, @invalid_attrs)
      assert quote == Quotes.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{}} = Quotes.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Quotes.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = quote_fixture()
      assert %Ecto.Changeset{} = Quotes.change_quote(quote)
    end
  end
end
