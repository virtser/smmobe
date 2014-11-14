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

def self.get_campaign_run_interval
	return 3  # 3 days
end