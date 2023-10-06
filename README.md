# The KDAbet Application Stack

KDAbet is an opensource repository for the kdabet sportsbook betting dapp runnign on the Kadena Blockchain network.
The Umbrella application holds all of the necessary microservices as state independant applications with sub processes that can be compiled into various production runtimes in this folder.
To observe the possible runtimes please check mix.exs

eg: <br /> iex(1)> mix release fullstack<br /> iex(2)> _build/dev/rel/fullstack/bin/fullstack start_iex

# Languages

## Main Language: 
  Elixir

## Substack:  
  Phoenix, Erlang, Tailwind, Alpine, Liveview, Surface-UI, Postgres

# Blockchain

The KDAbet system is designed to run in the Kadena L1 which ensures that transactions cannot be banned or limited.
We use the Kommiters Library to interact with the blockchain smart contract.  https://github.com/kommitters/kadena.ex

# Code Checking

We use credo to check the health of the code base in the production level folder.
Please try:  *mix credo* 
in bash to check the state of the umbrella.
