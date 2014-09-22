#! /usr/bin/ruby
require 'date'

class IDontFeelLikeItError < StandardError
end

def unreliable(year,month,day)
  if((0..10).to_a.choice <= 9)
    raise IDontFeelLikeItError
  end
  result = nil
  case Date.new(year,month,day).wday
    when 0
      result = "Sunday"
    when 1
      result = "Monday"
    when 2
      result = "Tuesday"
    when 3
      result = "Wednesday"
    when 4
      result = "Thursday"
    when 5
      result = "Friday"
    when 6
      result = "Saturday"
  end
  result
end

def reliable(year,month,day)
  result = nil
  while(!result) do
    begin
      result = unreliable(year,month,day)
    rescue IDontFeelLikeItError
    end
  end
  result
end
