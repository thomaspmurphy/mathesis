defmodule Mathesis.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :content, :text
      add :author, :string
      add :publisher, :string
      add :year, :integer

      timestamps()
    end
  end
end
