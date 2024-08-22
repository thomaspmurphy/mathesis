defmodule Mathesis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MathesisWeb.Telemetry,
      # Start the Ecto repository
      Mathesis.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mathesis.PubSub},
      # Start Finch
      {Finch, name: Mathesis.Finch},
      # Start the Endpoint (http/https)
      MathesisWeb.Endpoint
      # Start a worker by calling: Mathesis.Worker.start_link(arg)
      # {Mathesis.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mathesis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MathesisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
