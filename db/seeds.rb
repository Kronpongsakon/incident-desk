# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# There is no sign-up, so seeds create one customer and one agent.
# Their password comes from SEED_PASSWORD; it is never stored in the repo.
password = ENV["SEED_PASSWORD"].presence

if password.nil?
  puts "Skipping seed users: set SEED_PASSWORD to create customer@example.com and agent@example.com."
else
  { "customer@example.com" => :customer, "agent@example.com" => :agent }.each do |email_address, role|
    User.find_or_create_by!(email_address: email_address) do |user|
      user.password = password
      user.add_role role
    end
  end
end
