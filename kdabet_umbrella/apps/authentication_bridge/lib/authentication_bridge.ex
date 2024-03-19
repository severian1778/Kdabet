defmodule AuthenticationBridge do
  @moduledoc """
  AuthenticationBridge keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  Controls the online state of the server through UFW to drop all traffic

  to gain access to the system variable add:

  SUDO="echo <password> | sudo -S"

  where <password> is you computer password

  to /etc/environment

  THis is needed to access the UFW firewall for ubuntu
  """
  @sudo System.get_env("SUDO")
  @doc """
  start_repos/1
  Starts the 3 database repo connections
  Retunrs a list of respective PIDS's for each server instance
  Errors if one of the repos are started lready
  """
  def start_repos() do
    children =
      [AuthenticationBridge.Repo1, AuthenticationBridge.Repo2, AuthenticationBridge.Repo3]
      |> Enum.reduce([], fn mod, acc -> acc ++ [child_spec(mod)] end)

    Supervisor.start_link(
     children,
      strategy: :one_for_one
    )
  end

  def stop_repos() do
    [AuthenticationBridge.Repo1, AuthenticationBridge.Repo2, AuthenticationBridge.Repo3]
    |> Enum.each(fn mod ->
      Supervisor.stop(mod)
    end)
  end

  @doc """
  AuthenticationBridge.ufw/1, enables or disables UFW firewall

  For creating a rule for a port:

  iex> command = "allow from 192.168.0.1 to any port 4000"

  iex> AuthenticationBridge.ufw(command)
  """
  def ufw(:enable), do: sudo("ufw", "enable")
  def ufw(:disable), do: sudo("ufw", "disable")
  def ufw(:reload), do: sudo("ufw", "reload")
  def ufw(command), do: sudo("ufw", command)

  @doc """
  Provides specific access to system commands
  """
  defp sudo(command, args) do
    "#{@sudo} #{command} #{args}"
    |> String.to_charlist()
    |> :os.cmd()
  end

  defp child_spec(child) do
    %{
      id: child,
      start: {child, :start_link, []},
      restart: :temporary,
      shutdown: :infinity,
      type: :supervisor,
      modules: [child]
    }
  end
end
