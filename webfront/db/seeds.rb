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
