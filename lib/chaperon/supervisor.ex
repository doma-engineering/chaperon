defmodule Chaperon.Supervisor do
  @moduledoc """
  Root supervisor for all Chaperon processes & supervisors.
  """

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  def children do
    common_children = [
      Chaperon.Master.Supervisor,
      {Task.Supervisor, name: Chaperon.Worker.Supervisor, strategy: :one_for_one},
      {Chaperon.Scenario.Metrics, []},
      :hackney_pool.child_spec(
        :chaperon,
        timeout: 20_000,
        max_connections: 200_000
      )
    ]

    common_children =
      if Chaperon.API.HTTP.enabled?() do
        common_children ++ [{Chaperon.API.HTTP, []}]
      else
        common_children
      end

    case Application.get_env(:chaperon, Chaperon.Export.InfluxDB, nil) do
      nil ->
        common_children

      _ ->
        [Chaperon.Export.InfluxDB.child_spec() | common_children]
    end
  end
end
