defmodule XMAVLink.Util.Application do
  @moduledoc false

  use Application

  def start(_, _) do
    children = [XMAVLink.Util.Supervisor]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
