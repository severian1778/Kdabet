defmodule KdabetFrontend.Kings.Transactions do
  @moduledoc """
  Transactions is a module that governs any transcations involving the Kadena Blockchain with respect to the Kadena Kings mint page
  """
  alias Kadena.Chainweb
  alias Kadena.Cryptography.KeyPair
  alias Kadena.Types.Command
  alias Kadena.Pact

  @network_id :testnet04
  @transfercap 700

  ## @spec mint_token(atom(), String.t(), String.t(), String.t() | nil) :: {atom()}
  def mint_token(mint_account) do
    {:ok, keypair1} =
      KeyPair.from_secret_key("33eaa1cc4a8499564468b267614a7e5d49dcf63e233f67140cb656ef54a23bd9")

    {:ok, keypair2} =
      KeyPair.from_secret_key("20d6240709ee58ab032aac5399ee5969d341c4bf367d624b3bbc8fc2b0278e5f")

    ## USER KEY
    {:ok, keypair3} =
      KeyPair.from_secret_key("3c176518988f0e503a70ec806fa11d6e50975ef67e0792713daab4bca67dc11a")

    caps = [
      Kadena.Types.Cap.new(
        name: "coin.TRANSFER",
        args: [
          "k:5f2d12b21de60f8c9a70904efcf88ca6dba582b260dfde857e5add4305d66493",
          "kdabet_operation",
          @transfercap
        ]
      )
    ]

    IO.inspect(keypair3)
    ## Add a capability to the Keypair
    keypair = Kadena.Types.KeyPair.add_caps(mint_account, caps)

    metadata =
      Kadena.Types.MetaData.new(
        creation_time: DateTime.utc_now() |> DateTime.to_unix(),
        ttl: 28_800,
        gas_limit: 150_000,
        gas_price: 0.000001,
        sender: "k:#{keypair1.pub_key}",
        chain_id: "1"
      )

    env_data =
      %{
        kdabet_admin: [keypair1.pub_key],
        kdabet_operation: [keypair2.pub_key],
        minter: [keypair3.pub_key]
      }

    code = "(free.pay-oracle.get-kda-usd-price)"

    # "(use n_f871836427da13a92d7aa56aaf3387827444ca64.kingsmint_test) (n_f871836427da13a92d7aa56aaf3387827444ca64.kingsmint_test.reserve-mint \"kadena-kings-2\" \"k:5f2d12b21de60f8c9a70904efcf88ca6dba582b260dfde857e5add4305d66493\")"

    IO.inspect(keypair2)

    {:ok, %Command{} = command} =
      Pact.ExecCommand.new()
      |> Pact.ExecCommand.set_network(@network_id)
      |> Pact.ExecCommand.set_metadata(metadata)
      |> Pact.ExecCommand.set_code(code)
      |> Pact.ExecCommand.set_data(env_data)
      |> Pact.ExecCommand.add_keypair(keypair)
      |> Pact.ExecCommand.add_keypair(keypair1)
      |> Pact.ExecCommand.build()

    ## make the local request
    response = Chainweb.Pact.local(command, network_id: @network_id, chain_id: 1)

    {:ok, response}
  end
end
