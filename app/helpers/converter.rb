helpers do
	def day_converter(days_scheduled_string)
		days = {}
		
		days["1"] = "Mon"
		days["2"] = "Tues"
		days["3"] = "Wed"
		days["4"] = "Thur"
		days["5"] = "Fri"
		days["6"] = "Sat"
		days["0"] = "Sun"

		nice_string = ''
		
		days_scheduled_string.each_char do |c|
			nice_string += days[c] + " "
		end
		
		return nice_string
	end
end
