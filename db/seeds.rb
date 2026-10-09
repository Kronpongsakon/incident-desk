# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# There is no sign-up, so seeds create one customer and one agent. Their password comes from SEED_PASSWORD:
#
#   SEED_PASSWORD=... bin/rails db:seed
seed_password = ENV["SEED_PASSWORD"].presence

{ "customer@example.com" => "customer", "agent@example.com" => "agent" }.each do |email_address, role|
  next if User.exists?(email_address: email_address)

  abort "Set SEED_PASSWORD to seed the #{role} user (#{email_address})." unless seed_password

  User.create_with_role!(email_address: email_address, password: seed_password, role: role)
end
