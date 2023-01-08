defmodule Chaperon.Master.Supervisor do
  @moduledoc """
  Supervisor for the globally registered `Chaperon.Master` load test runner process.
  """

  use DynamicSupervisor

  @name __MODULE__

  def start_link([]) do
    DynamicSupervisor.start_link(@name, [], name: @name)
  end

  def start_master do
    DynamicSupervisor.start_child(@name, {Chaperon.Master, []})
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(
      strategy: :one_for_one
    )
  end
end
