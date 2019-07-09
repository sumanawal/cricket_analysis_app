require 'csv'

CSV.open('1000851.csv', 'r') do |csv|
  puts csv
  return
end;nil