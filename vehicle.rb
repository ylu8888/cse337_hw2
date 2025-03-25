module Towable
  def can_tow?(pounds)
    pounds < 2000
  end

  def stability_control
    puts "Activating towing stability control for hauling…"
  end
end

module SelfDriving
  def engage_autopilot
    @autopilot = true
    puts "Autopilot engaged."
  end

  def disengage_autopilot
    @autopilot = false
    puts "Autopilot disengaged."
  end

  def stability_control
    puts "Activating lane-centering stability control for autopilot…"
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :year, :model, :color, :current_speed

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    @@number_of_vehicles
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    @current_speed = 0 if @current_speed < 0
    puts "You push the brake and decelerate #{number} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "Let's park the vehicle!"
  end

  def spray_paint(given_color)
    @color = given_color
    puts "Your new #{@color} paint job looks great!"
  end

  def self.gas_mileage(gallons, miles)
  "#{(miles.to_f / gallons).round} miles per gallon of gas"
  end
end

class MyCar < Vehicle
  include Towable
  NUMBER_OF_DOORS = 4

  def to_s
    "My car is a #{@color}, #{@year}, #{@model}!"
  end

  def shut_down
    @current_speed = 0
    puts "Let's park the car!"
  end
end

class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2

  def to_s
    "My truck is a #{@color}, #{@year}, #{@model}!"
  end

  def shut_down
    @current_speed = 0
    puts "Let's park the truck!"
  end
end

class ElectricCar < MyCar
  include SelfDriving

  attr_accessor :battery_charge

  def initialize(year, model, color, battery_charge = 100)
    super(year, model, color)
    @battery_charge = [[battery_charge, 100].min, 0].max
  end

  def stability_control
    Towable.instance_method(:stability_control).bind(self).call
  end

  def speed_up(number)
    if @battery_charge <= 0
      puts "Battery is depleted. Cannot accelerate!"
      return
    end
    super
    @battery_charge -= 10
    puts "Battery decreased by 10%."
  end

  def current_battery
    puts "Battery level: #{@battery_charge}%"
  end

  def charge_battery
    @battery_charge = 100
    puts "Battery fully charged!"
  end

  def shut_down
    @current_speed = 0
    if @autopilot.nil?
      puts "Shutting down the battery-powered motor!\nLet’s park the car!"
    elsif @autopilot
      @autopilot = false
      puts "Disengaging and terminating self-driving services!\nShutting down the battery-powered motor!\nLet’s park the car!"
    else
      puts "Terminating self-driving services!\nShutting down the battery-powered motor!\nLet’s park the car!"
    end
  end
end


puts lumina = MyCar.new(1997, 'chevy lumina', 'white')
puts lumina.speed_up(20)
puts lumina.current_speed
puts lumina.speed_up(20)
puts lumina.current_speed
puts lumina.to_s
puts lumina.brake(20)
puts lumina.current_speed
puts lumina.brake(20)
puts lumina.current_speed
puts lumina.shut_down
puts MyCar.gas_mileage(13, 351)
puts lumina.spray_paint("red")
puts ram = MyTruck.new(1990, 'GMC', "black")
puts ram.can_tow?(1000)
puts lumina.can_tow?(3000)
puts tesla = ElectricCar.new(2021, 'Tesla Plaid', "blue", 80)
puts tesla.current_battery
puts tesla.speed_up(30)
puts tesla.current_speed
puts tesla.current_battery
puts tesla.speed_up(30)
puts tesla.brake(20)
puts tesla.current_speed
puts tesla.current_battery
puts tesla.charge_battery
puts tesla.current_battery
puts tesla.engage_autopilot
puts tesla.speed_up(100)
puts tesla.shut_down
puts tesla.can_tow?(1500)
puts lumina.stability_control
puts tesla.stability_control
