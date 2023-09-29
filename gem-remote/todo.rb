require 'todo'

puts "\nWelcome to Todo list.\n\n"

loop do
  puts "\nMenu\n----\n"\
       "1. List All Tasks\n"\
       "2. Display One Task\n"\
       "3. Create Task\n"\
       "4. Edit Task\n"\
       "5. Delete Task\n"\
       "6. Exit\n\n"\
       "Choose an option :"

  option = gets.chomp.strip.to_i
  puts "\n"

  case option
  when 1 then Todo.view_list
  when 2 then Todo.view_task
  when 3 then Todo.add_task
  when 4 then Todo.edit_task
  when 5 then Todo.remove_task
  when 6 then exit
  else puts "\nPlease enter a valid option"
  end
end
