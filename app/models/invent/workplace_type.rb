module Invent
  class WorkplaceType < BaseInvent
    self.primary_key = :workplace_type_id
    self.table_name = "#{table_name_prefix}workplace_type"

    DESCR = {
      rm_pk: 'Стационарное рабочее место включает в себя системный блок или моноблок с подключенными к нему
периферийными устройствами. В состав одного рабочего место может входить только один компьютер.',
      rm_mob: 'Мобильное рабочее место представляет из себя ноутбук или планшет. В состав одного рабочего места
может входить только одно устройство.',
      rm_net_print: 'Рабочее место печати - это отдельностоящее устройство печати/сканирование, работающее автономно,
либо с возможностью печати по сети. В состав может входить: сетевой принтер (или подключенный через принт-сервер),
сетевой МФУ, инженерные системы печати. Одно рабочее место включает одно устройство печати.',
      rm_server: 'Серверное рабочее место - это компьютер, использующийся для нужд организации или совместной работы
(файлообмен, веб-сайты, системы контроля версий и т.п.). Одно серверное рабочее место включает в себя одно устройство.',
      rm_equipment: 'Тип рабочего места "Оборудование" должен включать хотя бы одну единицу техники'
    }.freeze

    SECURITY_ROOM = 'Для защищаемых помещений вынос, ремонт и другие действия с техникой должны согласовываться с Лебедевым Р. В. или Хандожко А. В.'.freeze

    has_many :workplaces, dependent: :restrict_with_error
  end
end
