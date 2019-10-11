require "csv"
require "google/apis/civicinfo_v2"
require "erb"


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"

  begin
    legislators = civic_info.representative_info_by_address(
        address: zipcode,
        levels: "country",
        roles: ["legislatorUpperBody", "legislatorLowerBody"]
    ).officials
  rescue
    "You can find your representatives by visiting " +
        "www.commoncause.org/take-action/find-elected-officials"
  end
end

def clean_phone_number(number)
  number = number.scan(/\d/).join("")
  number = number[1..10] if number.length == 11 && number[0] == "1"
  number.length == 10 ? number : "0000000000"
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  filename = "output/thanks_#{id}.html"
  File.open(filename, "w") { |file| file.write(form_letter) }
end

def find_max_indices(arr)
  arr.each_index.select { |i| arr[i] == arr.max }
end

puts "EventManager Initialized!"

template_letter = File.read("form_letter.html.erb")
erb_template = ERB.new template_letter

registration_hour = Array.new(24, 0)
registration_wday = Array.new(7, 0)

contents = CSV.open("event_attendees.csv", headers: true,
    header_converters: :symbol)
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone = clean_phone_number(row[:homephone])
  date = row[:regdate]
  date_time = DateTime.strptime(date, "%m/%d/%y %H:%M")
  registration_hour[date_time.hour] += 1
  registration_wday[date_time.wday] += 1

  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)

  puts "#{phone}"
end
peak_hours = find_max_indices(registration_hour).map do |h|
  "#{h}00".rjust(4, "0")
end
p "Peak hours: #{peak_hours.join(", ")}"
peak_wdays = find_max_indices(registration_wday).map do |wday|
  Date::DAYNAMES[wday]
end
p "Peak days: #{peak_wdays.join(", ")}"