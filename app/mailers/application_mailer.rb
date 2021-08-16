class ApplicationMailer < ActionMailer::Base
  default from: 'svt@iss-reshetnev.ru'
  append_view_path Rails.root.join('app', 'views', 'mailers')
end
