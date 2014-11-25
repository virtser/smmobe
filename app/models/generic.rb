# Gneneric static methos class to be re-used all over the application.
class Generic 

	def self.CampaignStatusPending
		return 1
	end
	def self.CampaignStatusRunning
		return 2
	end
	def self.CampaignStatusFinished
		return 3
	end

	def self.UserTypeAdmin
		return 1
	end
	def self.UserTypeFree
		return 2
	end
	def self.UserTypePremium
		return 3
	end

	def self.clean_phone(phone_number)
		phone_number = phone_number.to_s.gsub(/\.0$/, '') # removes decimal points (.0) at the end if column defined as number in Excel
		phone_number = Phony.normalize(phone_number)
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

	def self.get_mixpanel_key
		return "648a04e0a4fa0f365f862e5351746c8c"
	end
end