class UnregHostMailer < ActionMailer::Base
  default from: 'svt@iss-reshetnev.ru'

  def send_email(content, invent_num)
    mail(to: ENV['EMAILS_HOSTREG'], subject: "Инвентаризация: Событие не создано для инв.№ #{invent_num}", body: content)
  end
end
