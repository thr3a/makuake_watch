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
        url = "https://www.makuake.com/project/#{id}/"
        page = agent.get url
        p = Project.new
        p.platform = "makuake"
        p.id = url.split('/').last
        p.title = page.at('.projectTtl').inner_text
        p.genre = page.at('a.projectTag')[:href].split('/').last
        p.owner_id = page.at('a.aboutOwnLink')[:href].split('/').last
        p.content = page.at('.leftProjectDetail').inner_text
        p.money = page.at('.stMoneyNum').inner_text.gsub(/[^\d]/, '').to_i
        p.goal_money = page.at('.stMoneyGoal').inner_text.gsub(/[^\d]/, '').to_i
        p.deadline = Time.at(page.body.match(/var end = (\d+);/)[1].to_i)
        p.supporter_num = page.at('.stSupoNum').inner_text.gsub(/[^\d]/, '').to_i
        p.save!
        Rails.logger.info "find::200 #{p.id}"
      rescue => e
        Rails.logger.error "find::#{p.id} : #{e.class} : #{e.message}"
        next
      end
    end
  end
end
