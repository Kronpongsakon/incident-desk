namespace :users do
  desc "Create a user with a role (customer or agent). Password comes from the PASSWORD env var or a prompt."
  task :create, %i[ email_address role ] => :environment do |_task, args|
    abort "Usage: bin/rails \"users:create[email@example.com,customer|agent]\"" if args[:email_address].blank? || args[:role].blank?
    abort "Role must be one of: #{User::ROLES.join(", ")}" unless User::ROLES.include?(args[:role])

    password = ENV["PASSWORD"].presence || begin
      require "io/console"
      console = IO.console or abort "No terminal to prompt for a password. Set the PASSWORD env var instead."
      entered = console.getpass("Password: ")
      abort "Passwords do not match." unless entered == console.getpass("Confirm password: ")
      entered
    end

    user = User.create_with_role!(email_address: args[:email_address], password: password, role: args[:role])
    puts "Created #{user.role} #{user.email_address}"
  rescue ActiveRecord::RecordInvalid => e
    abort "Could not create user: #{e.record.errors.full_messages.to_sentence}"
  end
end
