defmodule MathesisWeb.QuoteLiveTest do
  use MathesisWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mathesis.QuotesFixtures

  @create_attrs %{author: "some author", year: 42, content: "some content", publisher: "some publisher"}
  @update_attrs %{author: "some updated author", year: 43, content: "some updated content", publisher: "some updated publisher"}
  @invalid_attrs %{author: nil, year: nil, content: nil, publisher: nil}

  defp create_quote(_) do
    quote = quote_fixture()
    %{quote: quote}
  end

  describe "Index" do
    setup [:create_quote]

    test "lists all quotes", %{conn: conn, quote: quote} do
      {:ok, _index_live, html} = live(conn, ~p"/quotes")

      assert html =~ "Listing Quotes"
      assert html =~ quote.author
    end

    test "saves new quote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/quotes")

      assert index_live |> element("a", "New Quote") |> render_click() =~
               "New Quote"

      assert_patch(index_live, ~p"/quotes/new")

      assert index_live
             |> form("#quote-form", quote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#quote-form", quote: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/quotes")

      html = render(index_live)
      assert html =~ "Quote created successfully"
      assert html =~ "some author"
    end

    test "updates quote in listing", %{conn: conn, quote: quote} do
      {:ok, index_live, _html} = live(conn, ~p"/quotes")

      assert index_live |> element("#quotes-#{quote.id} a", "Edit") |> render_click() =~
               "Edit Quote"

      assert_patch(index_live, ~p"/quotes/#{quote}/edit")

      assert index_live
             |> form("#quote-form", quote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#quote-form", quote: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/quotes")

      html = render(index_live)
      assert html =~ "Quote updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes quote in listing", %{conn: conn, quote: quote} do
      {:ok, index_live, _html} = live(conn, ~p"/quotes")

      assert index_live |> element("#quotes-#{quote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#quotes-#{quote.id}")
    end
  end

  describe "Show" do
    setup [:create_quote]

    test "displays quote", %{conn: conn, quote: quote} do
      {:ok, _show_live, html} = live(conn, ~p"/quotes/#{quote}")

      assert html =~ "Show Quote"
      assert html =~ quote.author
    end

    test "updates quote within modal", %{conn: conn, quote: quote} do
      {:ok, show_live, _html} = live(conn, ~p"/quotes/#{quote}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Quote"

      assert_patch(show_live, ~p"/quotes/#{quote}/show/edit")

      assert show_live
             |> form("#quote-form", quote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#quote-form", quote: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/quotes/#{quote}")

      html = render(show_live)
      assert html =~ "Quote updated successfully"
      assert html =~ "some updated author"
    end
  end
end
