module Towable
  def can_tow?(pounds)
    pounds < 2000
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :model, :year

  @@number_of_vehicles = 0

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon"
  end

  def self.number_of_vehicles
    puts "Created #{@@number_of_vehicles} vehicles"
  end

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(number)
    @speed += number
    puts "Speed up #{number} mph"
  end

  def brake(number)
    @speed -= number
    puts "Slow down #{number} mph"
  end

  def shut_off
    @speed = 0
    puts "Shut off"
  end

  def speed
    puts "Current speed is #{@speed} mph"
  end

  def spray_paint(color)
    self.color = color
    puts "Your car is now #{color}."
  end

  def age
    "Your #{self.model} is #{years_old} years old"
  end

  private
    def years_old
      Time.now.year - self.year
    end
end

class MyCar < Vehicle

  NUMBER_OF_DOORS = 4

  def to_s
    "My car is a #{color}, #{year}, #{@model}."
  end
end

class MyTruck < Vehicle
  include Towable

  NUMBER_OF_DOORS = 2

  def to_s
    "My truck is a #{color}, #{year}, #{@model}."
  end
end

lumina = MyCar.new(1997, 'chevy lumina', 'white')
lumina.speed_up(20)
lumina.speed
lumina.speed_up(20)
lumina.speed
lumina.brake(20)
lumina.speed
lumina.brake(20)
lumina.speed
lumina.shut_off
lumina.speed

lumina.color = 'black'
puts lumina.color
puts lumina.year

lumina.spray_paint('red')

MyCar.gas_mileage(13, 351)

puts lumina

Vehicle.number_of_vehicles

puts lumina.age