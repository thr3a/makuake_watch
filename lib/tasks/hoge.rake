namespace :scrape do
  agent = Mechanize.new
  agent.user_agent = 'Mac Safari'
  agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

  desc ""
  task hoge: :environment do
    url = "https://www.makuake.com/project/chikachikaidol/"
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
    p.save
  end

end
