
class SendTextController < ApplicationController
	@@input_count = 0
	@@location = Geocoder.search("Austin, TX")

	def index
	end

	def process_sms
		if @@input_count == 0
			@@location = Geocoder.search(params["Body"])
			@body = '' # set location to text message if there is not one yet
		else
			@body = params["Body"] # otherwise set the command to equal the text message
		end
		@@input_count = 1
		
		ForecastIO.configure do |configuration| 
		  configuration.api_key = 'afe7d9eca604d31e23d47b7062511b0d'
		end

		@forecast = ForecastIO.forecast(@@location[0].latitude, @@location[0].longitude) # set weather forecast for the location


		if @body.downcase == 'weather'
			render 'weather.xml.erb', :content_type => 'text/xml' # sent text message to user
		else
			render 'weather.xml.erb', :content_type => 'text/xml'
		end

	end

	def send_text_message
    number_to_send_to = params[:number_to_send_to]
    message = params[:message]

    twilio_sid = "AC0efcecadadf271dda76f44c41111e345"
    twilio_token = "234321480deab317429df46b3c073a4b"
    twilio_phone_number = "8327421996"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "#{message}"
    )

    render 'index'
  end
end
