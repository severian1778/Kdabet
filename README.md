# KDAbet Application

KDAbet is an opensource repository for the kdabet sportsbook betting dapp runnign on the Kadena Blockchain network.
The Umbrella application holds all of the necessary microservices as state independant applications with sub processes that can be compiled into various production runtimes in this folder.
To observe the possible runtimes please check mix.exs

eg:  iex(1)> mix release fullstack
     iex(2)> _build/dev/rel/fullstack/bin/fullstack start_iex

# Languages

##Main Language: 
  Elixir

##Substack:  
  Phoenix, Erlang, Tailwind, Alpine, Liveview, Surface-UI, Postgres

# Blockchain

The KDAbet system is designed to run in the Kadena L1 which ensures that transactions cannot be banned or limited.
We use the Kommiters Library to interact with the blockchain smart contract.  https://github.com/kommitters/kadena.ex

