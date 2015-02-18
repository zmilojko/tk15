class RegistrationMailer < ActionMailer::Base
  default from: "taival@taivalsprintti.fi"
  
  def welcome_email(user)
    mail to: user['email'],
         bcc: 'zeljko@z-ware.fi',
         subject: 'Tervetuloa TaivalSprinttiin!'
  end
end
