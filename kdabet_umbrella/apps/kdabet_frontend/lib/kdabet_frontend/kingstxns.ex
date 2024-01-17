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
      "(use n_5382b05312493cdadba55b2928f839127f3f1a7e.kingsmintv9) (n_5382b05312493cdadba55b2928f839127f3f1a7e.kingsmintv9.reserve-mint \"kadena-kings-ng7\" \"k:#{mint_account}\")"

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
              "kdabet_operation",
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

# |> Pact.ExecCommand.add_keypair(keypair)
# |> Pact.ExecCommand.add_keypair(keypair1)

# caps = [
#  Kadena.Types.Cap.new(
#    name: "coin.TRANSFER",
#    args: [
#      "k:5f2d12b21de60f8c9a70904efcf88ca6dba582b260dfde857e5add4305d66493",
#      "kdabet_operation",
#      @transfercap
#    ]
#  )
# ]

# {:ok, keypair1} =
#  KeyPair.from_secret_key("33eaa1cc4a8499564468b267614a7e5d49dcf63e233f67140cb656ef54a23bd9")

# {:ok, keypair2} =
#  KeyPair.from_secret_key("20d6240709ee58ab032aac5399ee5969d341c4bf367d624b3bbc8fc2b0278e5f")

## USER KEY
# {:ok, keypair3} =
#  KeyPair.from_secret_key("3c176518988f0e503a70ec806fa11d6e50975ef67e0792713daab4bca67dc11a")

# kdabet_admin: [keypair1.pub_key],
# kdabet_operation: [keypair2.pub_key],

# caps = [
#  Kadena.Types.Cap.new(
#    name: "coin.TRANSFER",
#    args: [
#      "k:5f2d12b21de60f8c9a70904efcf88ca6dba582b260dfde857e5add4305d66493",
#      "kdabet_operation",
#      @transfercap
#    ]
#  )
# ]

## Add a capability to the Keypair
# keypair = Kadena.Types.KeyPair.add_caps(keypair3, caps)

# metadata =
#  Kadena.Types.MetaData.new(
#    creation_time: DateTime.utc_now() |> DateTime.to_unix(),
#    ttl: 28_800,
#    gas_limit: 150_000,
#    gas_price: 0.000001,
#    sender: "k:#{mint_account}",
#    chain_id: "1"
#  )

# "(use n_f871836427da13a92d7aa56aaf3387827444ca64.kingsmint_test) (n_f871836427da13a92d7aa56aaf3387827444ca64.kingsmint_test.reserve-mint \"kadena-kings-2\" \"k:5f2d12b21de60f8c9a70904efcf88ca6dba582b260dfde857e5add4305d66493\")"

# {:ok, %Command{} = command} =
#  Pact.ExecCommand.new()
#  |> Pact.ExecCommand.set_network(@network_id)
#  |> Pact.ExecCommand.set_metadata(metadata)
#  |> Pact.ExecCommand.set_code(code)
#  |> Pact.ExecCommand.set_data(env_data)
#  |> Pact.ExecCommand.build()

# |> Pact.ExecCommand.add_signer(signer1)
# |> Pact.ExecCommand.add_keypair(keypair)
# |> Pact.ExecCommand.add_keypair(keypair1)

## make the local request
## response = Chainweb.Pact.local(command, network_id: @network_id, chain_id: 1) |> IO.inspect()

# {:ok, command}
