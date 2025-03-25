module Towable  
  def can_tow?(pounds)  
    pounds < 2000  #if weight is under 2000 then return true
  end

  def stability_control  
    puts "Activating towing stability control for hauling…"  
  end

end

module SelfDriving
  #enable and disable autopilot and set the boolean
  def engage_autopilot
    @autopilot = true
    puts "Autopilot engaged."
  end

  def disengage_autopilot
    @autopilot = false
    puts "Autopilot disengaged."
  end

  def stability_control #stability contorl for self driving car
    puts "Activating lane-centering stability control for autopilot…"
  end

end

class Vehicle
  @@number_of_vehicles = 0 #track # of vehciles created
  attr_accessor :year, :model, :color, :current_speed #attributes for vehicle for  getters/setters

  def initialize(year, model, color) #constructor that initializes the vehicle object
    @year = year 
    @model = model
    @color = color
    @current_speed = 0
    @@number_of_vehicles += 1 #increment num of vehicle every time one is initialized

  end

  def self.number_of_vehicles
    @@number_of_vehicles #return number of vehicles made
  end

  def speed_up(number)
    @current_speed += number #increase speed by the number given
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number #decrease speed by number given
    @current_speed = 0 if @current_speed < 0 # limit to 0 if goes below
    puts "You push the brake and decelerate #{number} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph." #display current speed of car
  end

  def shut_down
    @current_speed = 0 #when car shuts down, set curr speed to 0
    puts "Let's park the vehicle!"
  end

  def spray_paint(given_color)
    @color = given_color #change color of vehcile
    puts "Your new #{@color} paint job looks great!"
  end

  def self.gas_mileage(gallons, miles) #calculate gas mileage
  "#{(miles.to_f / gallons).round} miles per gallon of gas" #use float conversion and round up to prevent 0 error
  end

end

class MyCar < Vehicle # mycar inherits from vehicle
  include Towable
  NUMBER_OF_DOORS = 4

  def to_s #describe the car
    "My car is a #{@color}, #{@year}, #{@model}!"
  end

  def shut_down #set speed to 0 when shutting down and print msg
    @current_speed = 0
    puts "Let's park the car!"
  end

end

class MyTruck < Vehicle #mytruck inherits from vehicle
  include Towable #both truck and car need to include towable
  NUMBER_OF_DOORS = 2

  def to_s #describe the truck
    "My truck is a #{@color}, #{@year}, #{@model}!"
  end

  def shut_down
    @current_speed = 0 #set speed 0 and print msg
    puts "Let's park the truck!"
  end

end

class ElectricCar < MyCar #inherts from my car which inherits from vehicle
  include SelfDriving
  attr_accessor :battery_charge #attribute for getter and setter

  def initialize(year, model, color, battery_charge = 100) 
    super(year, model, color)
    @battery_charge = [[battery_charge, 100].min, 0].max #initialize constructor and set battery charge between 0 and 100
  end

  def stability_control #override stability control from towable module
    Towable.instance_method(:stability_control).bind(self).call
  end

  def speed_up(number) #override speed up to consider the battery charge
    if @battery_charge - 10 <= 0 #if we have no battery, print it
      puts "Battery is depleted. Cannot accelerate!"
      return
    end
    super
    @battery_charge -= 10 #decrease battery by 10 everytime we speed up
    puts "Battery decreased by 10%."
  end

  def current_battery #display current battery
    puts "Battery level: #{@battery_charge}%"
  end

  def charge_battery #charge battery to 100 and print msg
    @battery_charge = 100
    puts "Battery fully charged!"
  end

  def shut_down
    @current_speed = 0
    if @autopilot.nil? #check if autopilot was ever turned on before shutting down
      puts "Shutting down the battery-powered motor!\nLet’s park the car!"
    elsif @autopilot
      @autopilot = false #terminate autopilot if it was on
      puts "Disengaging and terminating self-driving services!\nShutting down the battery-powered motor!\nLet’s park the car!"
    else
      puts "Terminating self-driving services!\nShutting down the battery-powered motor!\nLet’s park the car!"
    end
  end
end


#Test case 1: check electric car initial battery
puts Hyundai = ElectricCar.new(2024, "Hyundai Electric", "Blue", 80)
puts Hyundai.current_battery
puts Hyundai.speed_up(20) 
puts Hyundai.current_battery

#Test case 2: check charged up electric car
puts Hyundai.current_battery
puts Hyundai.charge_battery
puts Hyundai.current_battery

#Test case 3: check if can speed up when battery is low 
puts Rivian  = ElectricCar.new(2021, "Rivian Electric", "Grey", 5)
puts Rivian.current_battery
puts Rivian.speed_up(20)

#Test case 4: new car and speed up
puts Totoya  = MyCar.new(2015, "Toyota Sienna", "Black")
puts Totoya.speed_up(30) 
puts Totoya.current_speed

#Test case 5: Lets park the truck
puts Ford = MyTruck.new(2025, "Ford F-150", "Black")
puts Ford.speed_up(40)
puts Ford.shut_down
puts Ford.current_speed 
