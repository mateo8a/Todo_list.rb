=begin
	This program is an interactive todo list.
	The user is allowed to perform many actions, including:

=end

#Modules

module Menu
	
	def menu
		"Welcome to the program where you can create your own Todo list! Input:
1 to add a task
2 to show all your tasks
3 to update a task 
4 to delete a task
5 to write your Todo list to a text file 
6 to read a Todo list from a file
7 to toggle the status of a task 
Q to quit the program."
	end

	def show
		menu
	end

end

module Promptable
	def prompt(message = "What would you like to do with your Todo list?", prompt_symbol = ":> ")
		puts message
		print prompt_symbol
		gets.chomp
	end
end

#Classes:

class List

	attr_reader :all_tasks

	def initialize
		@all_tasks = Array.new
	end

	def add(task)
		@all_tasks << task
	end

	def show
		#@all_tasks.map {|task| puts task.description}
		@all_tasks.map do |task| 					#Alternatively: all_tasks.map.with_index { |l, i| "(#{i.next}): #{l.description}"}
			task_index = @all_tasks.index(task) + 1
            "(#{task_index}): #{task.description}" 
        end
	end

	def delete(task_number)
		@all_tasks.delete_at(task_number - 1)
	end

	def update(task_number, updated_task)
		@all_tasks[task_number - 1] = updated_task
	end

	def toggle(task_number)
		@all_tasks[task_number - 1].toggle_status
	end

	def to_machine1 
		@all_tasks.map do |task|
			"#{task.represent_status} #{task.description}"
		end
	end

	def write_to_file(filename)
		string_for_file = @all_tasks.map(&:to_machine).join("\n")	#Abbreviation: (&:description) == {|i| i.description}
        #string_for_file = @all_tasks.map(&:description).join("\n") 
        IO.write(filename, string_for_file)
	end

	def read_from_file(filename)
		(IO.read(filename).split("\n")).each do |task| #Alternatively, IO.readlines(filename).each do |line| \n add(Task.new(line.chomp)) \n end
			new_status, task_to_add = task.split(" : ")
			new_boolean = new_status == "[X]" ? true : false #Alternatively, new_boolean = new_status.include?("X")
			add(Task.new(task_to_add.strip, new_boolean))
		end
	end

	def indexx(i)
		@all_tasks[i]
	end

	def length
		@all_tasks.length
	end

end


class Task

	attr_reader :description
	attr_accessor :status

	def initialize(description, status = false)
		@description = description
		@status = status
	end

    def completed?
        @status
    end

    def to_machine
		"#{represent_status} : #{description}"
	end

	def toggle_status
		@status = !completed? 
	end

	private

	def represent_status
		completed? ? "[X]" : "[ ]"
	end

end


#Program runner - Code to run the program:

if __FILE__ == "todo_list.rb"

	include Menu
	include Promptable

	my_list = List.new
	puts "You have a new list! Time to fill it up with all your chores and fantasies."

    until (user_input = prompt(show).downcase) == "q" #'show' can be replaced by 'menu'.
    	case user_input
    	    when "1"
    		    new_task = prompt("What task do you want to add?")
    		    my_list.add(Task.new(new_task))
    		    puts "The task '#{new_task}' was added to your list!"
    	    when "2"
    	    	puts "Here is your list, dear client."
    		    puts my_list.show
    		when "3"
    			puts my_list.show
    			task_number = (prompt("Give me the number of the task you want to update", "Task number: ")).to_i 
    			if task_number > my_list.length
    				puts "Such a task doesn't exist. You thought you could fool me but you can't!"
    			else
    			    updated_task = Task.new(prompt("What do you want the new task to be?", "Update task with: "))
    			    my_list.update(task_number, updated_task)
    			    puts "Task number #{task_number} has been updated successfully!"
    			end
    		when "4"
    			puts "Here is your list!"
    			puts my_list.show
    			task_number = (prompt("Input the number of the task you want to delete.", "Task number: ")).to_i 
    			deleted_task = (my_list.indexx(task_number - 1)).description
    			my_list.delete(task_number)
    			puts "The task '#{deleted_task}' was deleted from your Todo list."
    		when "5"
    			filename = prompt("What will be the name of the file you'll write on?")
    		    my_list.write_to_file(filename)
    			puts "Great! A file named '#{filename}' was created."
    		when "6"
    			filename = prompt("What's the name of the file where the list is in?")
    			my_list.read_from_file(filename)
    		when "7"
    			puts my_list.show
    			task_number = (prompt("Which task do you want to update?" , "Task number: ")).to_i
    			my_list.toggle(task_number)
    	    else
    		    puts "Your input is invalid, try again!"    		
    	end
    end

    puts "Thanks for using our program!"
end