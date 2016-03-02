namespace :scrape do
  agent = Mechanize.new
  agent.user_agent = 'Mac Safari'
  agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

  desc ""
  task find: :environment do
    page = agent.get "https://www.makuake.com/discover/projects/new/"
    projects = page.search('a.projectLink').map {|p| p[:href].split('/').last}
    projects.select {|id| !Project.exists?(id: id)}.each do |id|
      begin
        page = agent.get "https://www.makuake.com/project/#{id}/"
        Project.new(
          platform: "makuake",
          flag: 1,
          id: id,
          title: page.at('.projectTtl').inner_text,
          genre: page.at('a.projectTag')[:href].split('/').last,
          owner_id: page.at('a.aboutOwnLink')[:href].split('/').last,
          content: page.at('.leftProjectDetail').inner_text,
          goal_money: page.at('.stMoneyGoal').inner_text.gsub(/[^\d]/, '').to_i,
          deadline: Time.at(page.body.match(/var end = (\d+);/)[1].to_i)
        ).save!
        ProjectProgress.create!(
          project_id: id,
          money: page.at('.stMoneyNum').inner_text.gsub(/[^\d]/, '').to_i,
          supporter_num: page.at('.stSupoNum').inner_text.gsub(/[^\d]/, '').to_i,
          date: Time.now
        )
        Rails.logger.info "find::200 #{id}"
      rescue => e
        Rails.logger.error "find::#{id} : #{e.class} : #{e.message}"
        next
      end
    end
  end

  desc ""
  task check: :environment do
    Project.where(flag: 1).each do |p|
      begin
        url = "https://www.makuake.com/project/#{p.id}/"
        page = agent.get url
        if page.at('.shienEnd').nil?
          ProjectProgress.create!(
            project_id: p.id,
            money: page.at('.stMoneyNum').inner_text.gsub(/[^\d]/, '').to_i,
            supporter_num: page.at('.stSupoNum').inner_text.gsub(/[^\d]/, '').to_i,
            date: Time.now
          )
        else
          per = p.project_progresses.order(:date)[-1].money*100 / p.goal_money
          if per >= 100
            p.update!(flag: 2)
          else
            p.update!(flag: 0)
          end
        end
        Rails.logger.info "check::200 #{p.id}"
      rescue => e
        Rails.logger.error "check::#{p.id} : #{e.class} : #{e.message}"
        next
      end
    end
  end

  task debug: :environment do
    begin
      url = "https://www.makuake.com/project/knot/"
      page = agent.get url
      p = Project.new
      p.platform = "makuake"
      p.flag = 1
      p.id = url.split('/').last
      p.title = page.at('.projectTtl').inner_text
      p.genre = page.at('a.projectTag')[:href].split('/').last
      p.owner_id = page.at('a.aboutOwnLink')[:href].split('/').last
      p.content = page.at('.leftProjectDetail').inner_text
      p.goal_money = page.at('.stMoneyGoal').inner_text.gsub(/[^\d]/, '').to_i
      p.deadline = Time.at(page.body.match(/var end = (\d+);/)[1].to_i)
      p.save!
      Rails.logger.info "debug::200 #{p.id}"
    rescue => e
      Rails.logger.error "debug::#{p.id} : #{e.class} : #{e.message}"
      next
    end
  end

  task find_all: :environment do
    i = 1
    while true
      page = agent.get "https://www.makuake.com/discover/projects/new/#{i}"
      i += 1
      break if page.at('.pageRightLast').nil?
      projects = page.search('a.projectLink').map {|p| p[:href].split('/').last}
      projects.select {|id| !Project.exists?(id: id)}.each do |id|
        begin
          page = agent.get "https://www.makuake.com/project/#{id}/"
          Project.new(
            platform: "makuake",
            flag: 1,
            id: id,
            title: page.at('.projectTtl').inner_text,
            genre: page.at('a.projectTag')[:href].split('/').last,
            owner_id: page.at('a.aboutOwnLink')[:href].split('/').last,
            content: page.at('.leftProjectDetail').inner_text,
            goal_money: page.at('.stMoneyGoal').inner_text.gsub(/[^\d]/, '').to_i,
            deadline: Time.at(page.body.match(/var end = (\d+);/)[1].to_i)
          ).save!
          ProjectProgress.create!(
            project_id: id,
            money: page.at('.stMoneyNum').inner_text.gsub(/[^\d]/, '').to_i,
            supporter_num: page.at('.stSupoNum').inner_text.gsub(/[^\d]/, '').to_i,
            date: Time.now
          )
          Rails.logger.info "find::200 #{id}"
        rescue => e
          Rails.logger.error "find::#{id} : #{e.class} : #{e.message}"
          next
        end
      end
    end
  end
end
