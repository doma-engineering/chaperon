defmodule Chaperon.Export.JSON do
  @moduledoc """
  JSON metrics export module.
  """

  @behaviour Chaperon.Exporter

  alias Chaperon.Scenario.Metrics

  @columns [
             :total_count,
             :max,
             :mean,
             :min
           ] ++ for(p <- Metrics.percentiles(), do: {:percentile, p})

  @doc """
  Encodes metrics of given `session` into JSON format.
  """
  @impl Chaperon.Exporter
  def encode(session, _opts \\ []) do
    data =
      session.metrics
      |> Enum.map(fn
        {{:call, {mod, func}}, vals} ->
          %{
            action: :call,
            module: inspect(mod),
            function: func,
            metrics: metrics(vals)
          }

        {{{:error, {:http, code}}, {action, url}}, vals} ->
          %{
            error: %{http: code},
            action: action,
            url: url,
            metrics: metrics(vals)
          }

        {{action, url}, vals} ->
          %{action: action, url: url, metrics: metrics(vals)}

        {action, vals} ->
          %{action: action, metrics: metrics(vals)}
      end)
      |> Jason.encode!()

    {:ok, data}
  end

  @impl Chaperon.Exporter
  def write_output(lt_mod, options, data, filename) do
    runtime_config = Keyword.get(options, :config, %{})
    Chaperon.write_output_to_file(lt_mod, runtime_config, data, filename <> ".json")
  end

  def metrics([]), do: %{}

  def metrics([v | vals]) do
    Map.merge(metrics(v), metrics(vals))
  end

  def metrics(vals) when is_map(vals) do
    metrics =
      vals
      |> Map.take(@columns)
      |> Enum.map(fn
        {{:percentile, p}, val} ->
          {"percentile_#{p}", round(val)}

        {k, v} ->
          {k, round(v)}
      end)
      |> Enum.into(%{})

    session_name = vals[:session_name]

    if session_name && String.trim(session_name) != "" do
      %{vals[:session_name] => metrics}
    else
      metrics
    end
  end
end
