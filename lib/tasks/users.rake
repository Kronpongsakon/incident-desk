namespace :users do
  desc "Create a user with an email and a role (customer or agent). Password from PASSWORD env var or a prompt."
  task :create, %i[ email_address role ] => :environment do |_task, args|
    email_address, role = args.values_at(:email_address, :role)
    abort "Usage: bin/rails \"users:create[email@example.com,customer|agent]\"" if email_address.blank? || role.blank?
    abort "Role must be one of: #{User::ROLES.join(", ")}" unless User::ROLES.include?(role)

    password = ENV["PASSWORD"].presence || begin
      require "io/console"
      $stdin.tty? ? $stdin.getpass("Password for #{email_address}: ") : $stdin.gets
    end.to_s.chomp
    abort "Password must not be blank" if password.blank?

    user = User.new(email_address: email_address, password: password)
    user.add_role role

    if user.save
      puts "Created #{role} #{user.email_address}"
    else
      abort "Could not create user: #{user.errors.full_messages.to_sentence}"
    end
  end
end
