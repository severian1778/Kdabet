## This file serves as a working exmaple of the usage of Kadena library to generate public and private keys
alias KdabetFrontend.Accounts.User
alias KdabetFrontend.Repo
alias Kadena.Cryptography.KeyPair

{:ok, keypair} = KeyPair.generate()

Repo.insert(%User{
  name: "Bushman",
  password: "password",
  privatekey: keypair.secret_key,
  publickey: keypair.pub_key
})
