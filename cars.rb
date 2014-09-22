#! /usr/bin/ruby

class Car

  def initialize(year,make,model,color,vin,price)
    @year = year
    @make = make
    @model = model
    @color = color
    @vin = vin
    @price = price
  end

  # cars are immutable
  attr_accessor :year, :make, :model, :color, :vin, :price

  def <=> (other)
    self.year > other.year ? 1 : self.year < other.year ? -1 : 0
  end

  def to_s
    str = ""
    str << (year.to_s + " ")
    str << (make + " ")
    str << (model + ", ")
    str << (color + " ")
    str << ("(" + vin + "): ")
    str << ("$" + price.to_s)
    str
  end

end

# keep track of all cars created in this instance of the program
allCars = Array.new

# accepts lines from stdin according to conditions supplied in proc
def readLine(prompt,proc)
  print prompt
  return false if !(line = gets)
  line.chomp!
  if(proc)
    while(!proc.call(line))
      puts "Invalid input"
      print prompt
      return false if !(line = gets)
      line.chomp!
    end
  end
  return line
end

# =================================================== #
# ===== procs to check for valid input from user ==== #
# =================================================== #

#check if the given string is an integer
integersOnly = lambda do |inputLine|
  result = true
  inputLine.each_char do |character|
    break (result = false) if !(('0'..'9').include? character)
  end
  result
end

#allow integer or decimal numbers
integersOrDecimalOnly = lambda do |inputLine|
  result = true
  inputLine.each_char do |character|
    break (result = false) if (!integersOnly.call(character) && character != '.')
  end
  result
end

#check if the given string only contains characters
charactersOnly = lambda do |inputLine|
  result = true
  inputLine.each_char do |character|
    break (result = false) if (!(('a'..'z').include? character) && !(('A'..'Z').include? character) && character != " ") 
  end
  result
end

#check if the given string is alphanumeric
alphanumericOnly = lambda do |inputLine|
  result = true
  inputLine.each_char do |character|
    break (result = false) if (!integersOnly.call(character) && !charactersOnly.call(character))
  end
  result
end

puts "========================================"
puts "Welcome to Bargain Bob's Discount Autos!"
puts "----------------------------------------"
puts "(a)dd a new car"
puts "(d)elete a car"
puts "(l)ist all cars"
puts "(q)uit"
puts "----------------------------------------"

while(line = readLine("Enter your choice: ",lambda{ |inputLine| ["a","d","l","q"].include? inputLine  }))
  puts "----------------------------------------"
  case line
    when "a"
      year =  readLine("Year: ", integersOnly).to_i
      make =  readLine("Make: ", alphanumericOnly)
      model = readLine("Model: ", alphanumericOnly)
      color = readLine("Color: ", charactersOnly)
      vin =   readLine("VIN: ", alphanumericOnly)
      price = readLine("Price: ",integersOrDecimalOnly).to_f
      allCars << Car.new(year,make,model,color,vin,price)
      allCars.sort!
    when "d"
      puts "(0) cancel"
      0.upto(allCars.size - 1) do |index|
        puts("(#{index + 1}) " + allCars[index].to_s)
      end
      if((index = (readLine("Car to delete: ", lambda{ |line| integersOnly.call(line) && (0..allCars.size).include?(line.to_i)} ).to_i - 1)) != -1)
          allCars.delete_at(index)
      end
    when "l"
      total = 0
      allCars.each do |car|
        puts car.to_s 
        total += car.price.to_f
      end
      puts "TOTAL VALUE: $#{total}"
    when "q"
      exit(0)
  end
  puts "----------------------------------------"
end
