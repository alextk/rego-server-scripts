namespace :svn do

  desc 'Create new svn repository at /home/regoco/svn/'
  task :create_repository do
    name = ask_input('Please enter new repository name: ')
    exit_with_message("Error: repository name can't be empty") if name.empty?

    repository_path = "/home/regoco/svn/repositories/#{name}"
    # check that repository wiht that name doesn't already exist
    exit_with_message("Error: repository already exists at: #{repository_path}") if File.exists?('repository_path')

    puts "Creating repository at: #{repository_path}"

    sh "svnadmin create #{repository_path}" do |ok, res|
      exit_with_message("Filed to run svnadmin") if !ok
    end
    sh "svn import /home/regoco/svn/tmp/new_svn_project_template file:///#{repository_path} -m \"created project\"" do |ok, res|
      exit_with_message("Filed to import layout") if !ok
    end
    sh "chown -R nobody:nobody #{repository_path}" do |ok, res|
      exit_with_message("Filed to change permissions to nobody") if !ok
    end

    puts "Repository created successfully!"
  end
end

# ----------------------------Helper methods------------------------------------------
def ask_input(message)
  print message
  STDIN.gets.chomp.strip
end

def exit_with_message(message)
  puts message
  exit(1)
end
