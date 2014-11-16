# Gneneric static methos class to be re-used all over the application.
class Generic 

	def self.clean_phone(phone_number)
		phone_number = phone_number.to_s.tr("+", "")
		phone_number = phone_number.to_s.tr("-", "")
		phone_number = phone_number.to_s.tr("(", "")
		phone_number = phone_number.to_s.tr(")", "")
		phone_number = phone_number.to_s.tr(" ", "")
		return phone_number
	end	

	def self.transform_phone(phone_number)
		# Add Israeli country code if none was entered
		if phone_number.length == 9 || phone_number.length == 10
			if phone_number[0] == '0'
				phone_number[0] = ''
			end		

			phone_number = "972" + phone_number
		end 
		return phone_number
	end

	def self.get_campaign_run_interval
		return 3  # 3 days
	end

end