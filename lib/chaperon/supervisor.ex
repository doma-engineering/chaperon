defmodule Chaperon.Supervisor do
  import Supervisor.Spec

  def start_link do
    children = [
      supervisor(Chaperon.Master.Supervisor, []),
      supervisor(Chaperon.Worker.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Chaperon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end