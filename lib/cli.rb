require "pry"

class CLI 

    def user_input
        gets.chomp
    end

    def self.quit
        system "clear"
        exit!
    end 


    def run
        clear_screen
        puts "You are entering the FBI's 50 most wanted database"
        puts ""
        main_menu
    end 

    def main_menu
        clear_screen
        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Access Records'
            menu.choice 'Update Records'
            menu.choice 'Create New Records'
            menu.choice 'Delete Records'
            menu.choice 'Exit'
        end 
        
        case my_menu
        when "Access Records" 
            access_records
        when "Update Records"
            update_records
        when "Create New Records"
            create_new_records
        when "Delete Records"
            delete_records
        when "Exit"
            CLI.quit
        end
    end


    def access_records
        clear_screen

        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Access Fugitive Data'
            menu.choice 'Access Crime Data'
            menu.choice 'Main Menu'
            menu.choice 'Exit'
        end 
       
        case my_menu
        when "Access Fugitive Data"
            fugitive_data
        when "Access Crime Data"
            crime_data
        when "Main Menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 

    end 

    
    def fugitive_data
        clear_screen
        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Find by name'
            menu.choice 'Find by location'
            menu.choice 'Data analysis'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Find by name"
            print "Enter name: "
            input = user_input
            found_fugitive = Fugitive.find_by(name: input.upcase)
            if !found_fugitive 
                puts "Fugitive not found, verify spelling."
            else
                found_fugitive.print_data
            end

        when "Find by location"
            print "Enter location: "
            input = user_input
            found_city = City.find_by(name: input.downcase.gsub(/\s/,""))
            if !found_city
                puts "City not found, verify spelling."
            else 
                found_fugitives = found_city.fugitives
                found_fugitives.map {|fugitive| fugitive.print_data}
            end   
        when "Data analysis"
            analyze_fugitive_data
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end
    end 

    def analyze_fugitive_data
        clear_screen

        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Oldest fugitive'
            menu.choice 'Youngest fugitive'
            menu.choice 'Average age'
            menu.choice 'Most common hair color'
            menu.choice 'Most wanted'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Oldest fugitive"
            puts ""
            puts "The oldest fugitive currently in our database is: "
            puts ""
            Fugitive.oldest_fugitive.print_data      
        when "Youngest fugitive"
            puts ""
            puts "The youngest fugitive currently in our database is: "
            puts ""
            Fugitive.youngest_fugitive.print_data      
        when "Average age"
            puts ""
            puts "The average age of the fugitives in our database is #{Fugitive.average_age}."
            puts ""
        when "Most common hair color"
            puts ""
            puts "The most common hair color for fugitives in our database is: #{Fugitive.most_common_hair_color}."
            puts ""
        when "Most wanted"
            puts ""
            puts "The most wanted fugitive in our database is: "
            puts ""
            Fugitive.all.first.print_data
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end
    end 



    def crime_data
        clear_screen

        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Find by fugitive'
            menu.choice 'Find by city'
            menu.choice 'Most common location'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Find by fugitive"
            puts ""
            print "Enter name: "
            input = user_input
            found_fugitive = Fugitive.find_by(name: input.upcase)
            if !found_fugitive 
                puts "Fugitive not found, verify spelling."
            else
                puts "#{input} is wanted for the following crimes:"
                found_crimes = Crime.all.select {|crime| crime.fugitive_id == found_fugitive.id}
                found_crimes.map {|crime| crime.print_data}
            end
        when "Find by city" 
            puts ""
            print "Enter city name: "
            input = user_input
            found_city = City.find_by(name: input.downcase.gsub(/\s/,""))
            if !found_city 
                puts ""
                puts "City not found, verify spelling."
            else
                puts ""
                puts "The follow crimes were found in #{input}:"
                puts ""
                found_crimes = Crime.all.select {|crime| crime.city_id == found_city.id}
                found_crimes.map {|crime| crime.print_data}
            end
        
        when "Most common location"
            puts ""
            puts "The most common location where crimes in our databased have occured is #{Crime.most_common_location.capitalize()}."
            puts ""
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 

    end

   
    def update_records
        clear_screen
        prompt = TTY::Prompt.new
        my_menu = prompt.select("Locate fugitive record by:") do |menu|
            menu.choice 'Update fugitive data'
            menu.choice 'Update crime data'
            menu.choice 'Update city data'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end 

        case my_menu
        when "Update fugitive data"
            update_fugitive
        when "Update crime data"
            update_crime        
        when "Update city data"
            update_city
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 

    end 

    def update_fugitive
        prompt = TTY::Prompt.new
        my_menu = prompt.select("Locate fugitive record by:") do |menu|
            menu.choice 'Name'
            menu.choice 'Id'
        end 
        
        case my_menu
        when "Name" 
            puts ""
            print "Enter name to locate fugitive record: "
            input = user_input.upcase
            entry = Fugitive.find_by(name: input)
        when "Id"
            puts ""
            print "Enter ID to locate fugitive record: "
            input = user_input.strip.to_i
            entry = Fugitive.find(input)
        end

        if !entry 
            puts ""
            puts "Fugitive not located."
        else 
            puts ""
            entry.print_data
            puts ""
            prompt = TTY::Prompt.new
            update_menu = prompt.select("Select category to update:") do |menu|
                menu.choice 'Name'
                menu.choice 'Alias'
                menu.choice 'Age'
                menu.choice 'Hair color'
                menu.choice 'Eye color'
                menu.choice 'At large?'
                menu.choice 'Gender'
                menu.choice 'Warning'
                menu.choice 'Scars and marks'
                menu.choice 'Main menu'
                menu.choice 'Exit'
            end

            case update_menu
            when 'Name'
                puts ""
                puts "Fugitive name was previously recorded as #{entry.name.downcase.capitalize()}."
                puts ''
                print "Please enter new name: "
                input = user_input.upcase
                entry.update(name: input)
                puts ''
                puts "Name has been updated to #{entry.name.downcase.capitalize()}."
            when 'Alias'
                puts ''
                puts "Fugitive alias was previously recorded as #{entry.alias.downcase.capitalize()}."
                puts ''
                print "Please enter an additional alias: "
                input = user_input.downcase
                aliases = "#{entry.alias}, #{input}."
                entry.update(alias: aliases)
                puts ''
                puts "Alias has been updated to #{entry.alias.downcase.capitalize()}."
            when 'Age'
                puts ''
                puts "Fugitive age was previously recorded as #{entry.age}."
                puts ''
                print "Please enter new age: "
                input = user_input.to_i
                entry.update(age: input)
                puts ''
                puts "Age has been updated to #{entry.age}."
            when 'Hair color'
                puts ''
                puts "Fugitive hair color was previously recorded as #{entry.hair_color.downcase.capitalize()}."
                puts ''
                print "Please enter new hair color: "
                input = user_input.downcase
                entry.update(hair_color: input)
                puts ''
                puts "Hair color has been updated to #{entry.hair_color.downcase.capitalize()}."
            when 'Eye color'
                puts ''
                puts "Fugitive's eye color was previously recorded as #{entry.eye_color.downcase.capitalize()}."
                puts ''
                print "Please enter new eye color: "
                input = user_input.downcase.capitalize()
                entry.update(eye_color: input)
                puts ''
                puts "Eye color has been updated to #{entry.eye_color.downcase.capitalize()}."
            when 'At large?'
                # puts "Suspect is still at large"

            when 'Gender'
                puts ''
                puts "Fugitive gender was previously recorded as #{entry.gender.downcase.capitalize()}."
                puts ''
                print "Please enter new gender: "
                input = user_input.downcase.capitalize()
                entry.update(gender: input)
                puts ''
                puts "Gender has been updated to #{entry.gender.downcase.capitalize()}."

            when 'Warning'
                puts ''
                puts "Fugitive warning was previously recorded as #{entry.warning}."
                puts ''
                print "Please enter new warning: "
                input = user_input.upcase
                entry.update(warning: input)
                puts ''
                puts "Warning has been updated to #{entry.warning}."

            when 'Scars and marks'
                puts ''
                puts "Fugitive scars and marks were previously recorded as #{entry.scars_and_marks.downcase.capitalize()}."
                puts ''
                print "Please enter additional scars and marks: "
                input = user_input.downcase
                scars = "#{entry.scars_and_marks}, #{input}."
                entry.update(scars_and_marks: scars)
                puts ''
                puts "Scars and marks have been updated to #{entry.scars_and_marks.downcase.capitalize()}."
            when 'Main menu'
                clear_screen
                main_menu
            when "Exit"
                CLI.quit
            end 
        

        end 


     end 



    def update_city
    end 


    def create_new_records
        clear_screen

        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Add fugitive'
            menu.choice 'Add crime'
            menu.choice 'Add city'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Add fugitive"
            new_fugitive
        when "Add crime"
            new_crime
        when "Add city"
            new_city
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 
    end 

    def new_fugitive
        fugitive_new = Fugitive.new
        puts "Enter fugitive name: "
        fugitive_new.name = gets.chomp.upcase
        puts "Enter fugitive alias: "
        fugitive_new.alias = gets.chomp
        puts "Enter fugitive age: "
        fugitive_new.age = gets.chomp.to_i
        puts "Enter fugitive hair color: "
        fugitive_new.hair_color = gets.chomp.downcase
        puts "Enter fugitive eye color: "
        fugitive_new.eye_color = gets.chomp.downcase.capitalize()
        fugitive_new.at_large = true
        puts "Enter fugitive gender: "
        fugitive_new.gender = gets.chomp.downcase.capitalize()
        puts "Enter fugitive warning: "
        fugitive_new.warning = gets.chomp.upcase
        puts "Enter fugitive scars and marks: "
        fugitive_new.scars_and_marks = gets.chomp.downcase.capitalize()

        fugitive_new.save
        puts "Fugitive has been saved to database, fugitive_id is : #{fugitive_new.id}. "
    end 

    def new_crime
        crime_new = Crime.new
        puts "Enter fugitive ID: "
        crime_new.fugitive_id = gets.chomp.strip.to_i
        puts "Enter city ID: "
        crime_new.city_id = gets.chomp.strip.to_i
        puts "Enter description: "
        crime_new.description = gets.chomp
        puts "Enter subject: "
        crime_new.subject = gets.chomp
        puts "Enter reward: "
        crime_new.reward = gets.chomp

        crime_new.save
        puts "Crime has been saved to database, crime_id is : #{crime_new.id}."
    end 

    def new_city
        city_new = City.find_or_create_by(name: gets.chomp.downcase.gsub(/\s+/, ""))
        puts "City_id is #{city_new.id}. "
    end 

    def delete_records
        clear_screen
        
        prompt = TTY::Prompt.new
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Delete fugitive'
            menu.choice 'Delete crime'
            menu.choice 'Delete city'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Delete fugitive"
            delete_fugitive
        when "Delete crime"
            delete_crime
        when "Delete city"
            delete_city
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 
    end 

    def delete_fugitive
        puts "Enter fugitive_id to remove fugitive from database: "
        input = gets.chomp.strip.to_i
        Fugitive.all.find(input).destroy
        puts "This fugitive has been removed from the database. "
    end 

    def delete_crime
        puts "Enter crime_id to remove from crime from database: "
        input = gets.chomp.strip.to_i
        Crime.all.find(input).destroy
        puts "This crime has been removed from the database. "
    end 

    def delete_city
        puts "Enter city_id to remove from city from database: "
        input = gets.chomp.strip.to_i
        City.all.find(input).destroy
        puts "This city has been removed from the database. "
    end

    def clear_screen
        system "clear"
    end

end 