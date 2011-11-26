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


