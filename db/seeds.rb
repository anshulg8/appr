# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
User.create!(name: "Anshul Garg",
             email: "anshul@example.com",
             password: "foobar",
             password_confirmation: "foobar",
             company: "Confidential"
             )
20.times do |n|
  name  = Faker::Name.unique.name
  email = Faker::Internet.unique.email
  password = "password"
  company = Faker::Company.unique.name
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               company: company
             )
end

# Microposts
users = User.order(:created_at).take(10)
25.times do
  content = Faker::Movie.quote
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

buzzwords = ["cryptocurrency", "bitcoin", "blockchain", "distributed ledger technology", "mining", "miners", "public ledger", "permissioned ledger", "double spend", "altcoin", "ethereum", "hard fork", "bitcoin cash", "genesis block", "hash rate", "smart contracts", "ico", "distributed application", "oracles", "nodes", "digital wallet", "private keys", "hardware security modules", "51% attack", "address", "asic/asic miner", "block", "block height", "block reward", "distributed & central ledger", "fork", "halving", "hashrate", "multisig", "node", "p2p", "pow", "pos", "public/private key", "signature", "smart contract"]

buzzwords.each do |buzzword|
  Buzzword.create(name: buzzword)
end
