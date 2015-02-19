class RegistrationMailer < ActionMailer::Base
  default from: "Taivalsprintti noreply@taivalsprintti.fi"
  
  def welcome_email(user)
    mail to: user['email'],
         bcc: 'zeljko@z-ware.fi,katariina@z-ware.fi',
         subject: 'Tervetuloa TaivalSprinttiin!'
  end
end
