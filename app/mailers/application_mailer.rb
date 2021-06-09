class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILJET_ADRESS']
  layout 'mailer'
end
