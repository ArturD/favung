if Task.count == 0
  puts "== creating new task (n+1) =="
  task = Task.new(
    :name => "n + 1", 
    :short_name => "N", 
    :git_path => "https://github.com/ArturD/favung_example_task")
  task.description= "Read single number n. Than n more numbers. Foreach x in these n numbers, print x+1."
  task.save!
else
  puts "== some tasks already exist =="
end

if User.where(:role => "admin").count == 0
  puts "== creating new admin (admin@favung.com , pass: changeme) =="
  puts " !!! CHANGE PASSWORD FOR THIS USER !!!  "
  user = User.new :email => "admin@favung.com", :password => "changeme"
  user.role = "admin"
  user.save!
else 
  puts "== admin exists =="
end

if User.where(:role => "user").count == 0
  puts "== creating new user (user@favung.com, pass: changeme) =="
  puts " !!! CHANGE PASSWORD FOR THIS USER !!!  "
  User.create! :email => "user@favung.com", :password => "changeme"
else 
  puts "== user exists =="
end


>>>>>>> admin_panel
