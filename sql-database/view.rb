require File.expand_path('controller.rb', __dir__)

class TodoView < TodoController
  puts "\nWelcome to Todo list."

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

    case option
    when 1 then TodoController.view_list
    when 2 then TodoController.view_task
    when 3 then TodoController.add_task
    when 4 then TodoController.edit_task
    when 5 then TodoController.remove_task
    when 6 then TodoController.exit_app
    else puts "\nPlease enter a valid option\n"
    end
  end
end

TodoView.new
