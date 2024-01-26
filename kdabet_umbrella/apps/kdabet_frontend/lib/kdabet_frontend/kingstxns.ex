defmodule KdabetFrontend.Kings.Transactions do
  @moduledoc """
  Transactions is a module that governs any transcations involving the Kadena Blockchain with respect to the Kadena Kings mint page
  """
  alias Kadena.Chainweb
  alias Kadena.Types.Command
  alias Kadena.Cryptography.KeyPair
  alias Kadena.Pact

  ## @network_id :mainnet01
  ## testnet04
  @network_id :testnet04
  @transfercap 700

  @spec prep_unsigned_txn(String.t()) :: map()
  def prep_unsigned_txn(mint_account) do
    code =
      "(use n_5382b05312493cdadba55b2928f839127f3f1a7e.kingsmintv11) (n_5382b05312493cdadba55b2928f839127f3f1a7e.kingsmintv11.reserve-mint \"kadena-kings-ng9\" \"k:#{mint_account}\")"

    env_data =
      %{
        kdabet_user: [mint_account]
      }

    ## return
    %{
      pactCode: code,
      envData: env_data,
      sender: "k:#{mint_account}",
      # @network_id,
      networkId: "testnet04",
      chainId: "1",
      gasLimit: 15000.0,
      gasPrice: 0.000001,
      signingPubKey: mint_account,
      ttl: 28_800,
      caps: [
        %{
          role: "Coin Transfer",
          description: "Capability to transfer designated amount of coin from sender to receiver",
          cap: %{
            name: "coin.TRANSFER",
            args: [
              "k:#{mint_account}",
              "k:ff512a9c7eb9041ef1e604d262e4f80fb4078d5e801ae83bb8465ec3bcb689c8",
              @transfercap
            ]
          }
        },
        %{
          role: "Gas",
          description: "allows the payer to pay gas",
          cap: %{
            name: "coin.GAS",
            args: []
          }
        }
      ]
    }
  end

  def check_dao_members() do
    {:ok, keypair} = KeyPair.generate()
    metadata = metadata(keypair.pub_key)
    env_data = %{}

    code =
      "(n_7763cd0330f59f3c66e431dcd63a2c5c5e2e0b70.dao-hive-factory.get-all-dao-members \"0l8AnwhJQ9KUE4VVtdj9Xkkk6XFT_vtZjaie1k5gdd0\")"

    {:ok, %Command{} = command} =
      Pact.ExecCommand.new()
      |> Pact.ExecCommand.set_network(@network_id)
      |> Pact.ExecCommand.set_metadata(metadata)
      |> Pact.ExecCommand.set_code(code)
      |> Pact.ExecCommand.set_data(env_data)
      |> Pact.ExecCommand.add_keypair(keypair)
      |> Pact.ExecCommand.build()

    call_chainweb(:local, command)
  end

  def get_kda_price() do
    {:ok, keypair} = KeyPair.generate()
    metadata = metadata(keypair.pub_key)
    env_data = %{}
    code = "(free.pay-oracle.get-kda-usd-price)"

    {:ok, %Command{} = command} =
      Pact.ExecCommand.new()
      |> Pact.ExecCommand.set_network(@network_id)
      |> Pact.ExecCommand.set_metadata(metadata)
      |> Pact.ExecCommand.set_code(code)
      |> Pact.ExecCommand.set_data(env_data)
      |> Pact.ExecCommand.add_keypair(keypair)
      |> Pact.ExecCommand.build()

    call_chainweb(:local, command)
  end

  @doc """
  Function: get_owned(account)

  Inputs: account: String.t() -> A Kadena k: accuont

  Return: list
  """
  # spec get_owned(String.t()) :: map()
  def has_minted(account) do
    {:ok, keypair} = KeyPair.generate()
    metadata = metadata(account)
    env_data = %{}

    code =
      "(use n_5382b05312493cdadba55b2928f839127f3f1a7e.kingsmintv11) (n_5382b05312493cdadba55b2928f839127f3f1a7e.kingsmintv11.has-minted \"kadena-kings-ng0\" \"king\" \"#{account}\")"

    {:ok, %Command{} = command} =
      Pact.ExecCommand.new()
      |> Pact.ExecCommand.set_network(@network_id)
      |> Pact.ExecCommand.set_metadata(metadata)
      |> Pact.ExecCommand.set_code(code)
      |> Pact.ExecCommand.set_data(env_data)
      |> Pact.ExecCommand.add_keypair(keypair)
      |> Pact.ExecCommand.build()

    call_chainweb(:local, command)
  end

  def get_balance(account) do
    {:ok, keypair} = KeyPair.generate()
    metadata = metadata(account)
    env_data = %{}
    code = "(coin.details \"#{account}\")"

    {:ok, %Command{} = command} =
      Pact.ExecCommand.new()
      |> Pact.ExecCommand.set_network(@network_id)
      |> Pact.ExecCommand.set_metadata(metadata)
      |> Pact.ExecCommand.set_code(code)
      |> Pact.ExecCommand.set_data(env_data)
      |> Pact.ExecCommand.add_keypair(keypair)
      |> Pact.ExecCommand.build()

    call_chainweb(:local, command)
  end

  def poll_transaction(request) do
    gas_account = "k:5f2d12b21de60f8c9a70904efcf88ca6dba582b260dfde857e5add4305d66493"
    metadata = metadata(gas_account)
    env_data = %{}
    code = ""

    {:ok, %Command{} = command} =
      Pact.ExecCommand.new()
      |> Pact.ExecCommand.set_network(@network_id)
      |> Pact.ExecCommand.set_metadata(metadata)
      |> Pact.ExecCommand.set_code(code)
      |> Pact.ExecCommand.set_data(env_data)
      |> Pact.ExecCommand.build()

    call_chainweb(:poll, command, request)
  end

  def sign_and_send(response, ep, request \\ nil) do
    signed =
      cond do
        is_map_key(response, "signedCmd") ->
          response["signedCmd"]

        true ->
          response
      end

    cmd = signed["cmd"]
    ## hash
    hash = Kadena.Types.PactTransactionHash.new(signed["hash"])
    ## get the signature
    signature =
      signed["sigs"]
      |> Enum.at(0)
      |> Map.get("sig")
      |> Kadena.Types.Signature.new()

    signed_command = %Command{
      cmd: cmd,
      hash: hash,
      sigs: [signature]
    }

    call_chainweb(ep, signed_command, request)
  end

  def call_chainweb(ep, cmd, request \\ nil) do
    case ep do
      :local ->
        Chainweb.Pact.local(cmd, network_id: @network_id, chain_id: 1)

      :send ->
        Chainweb.Pact.send([cmd], network_id: @network_id, chain_id: 1)

      :poll ->
        Chainweb.Pact.poll([request],
          network_id: @network_id,
          chain_id: 1
        )
    end
  end

  def metadata(mint_account) do
    ## Add a capability to the Keypair
    Kadena.Types.MetaData.new(
      creation_time: DateTime.utc_now() |> DateTime.to_unix(),
      ttl: 28_800,
      gas_limit: 150_000.0,
      gas_price: 0.000001,
      sender: "k:#{mint_account}",
      chain_id: "1"
    )
  end
end
