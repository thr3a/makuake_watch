class ProjectsController < ApplicationController
  # フィルターをかけてから一覧表示
  before_action :search, only: :index

  # GET /
  def index
    @projects = @projects.paginate(page: params[:page], per_page: 30)
    @success_rate = Project.where(flag:2).count.fdiv(Project.where(flag:[0,2]).count)*100
  end

  # GET /project/:id
  def show
    @project = Project.find_by id: params[:id]
    # 取得開始からスタートダッシュの３時間を取得
    pp1 = ProjectProgress.where(project_id: params[:id]).first(3).map{|a|a.attributes}
    # 毎日０時を取得
    pp2 = ProjectProgress.where("project_id= ? AND hour(created_at) = ?", params[:id], 15).map{|a|a.attributes}
    pp = pp1.concat pp2
    # グラフ用に各項目を配列化
    @money = pp.map{|a|a["money"]}
    @supporter_num = pp.map{|a|a["supporter_num"]}
    @date = pp.map{|a|a["date"].strftime('%-m月%d日 %H時')}
    @per = @project.project_progresses.order(:date)[-1].money*100 / @project.goal_money
end

  private
    # Only allow a trusted parameter "white list" through.
    def project_params
      params[:project]
    end

    def search
      @search = Form.new params[:form]
      @projects = Project.includes :project_progresses
      if params.present?
        if @search.order.present?
          case @search.order
          when "date_asc"
            @projects = @projects.s_order("created_at", "asc")
          when "date_desc"
            @projects = @projects.s_order("created_at", "desc")
          when "g_money_asc"
            @projects = @projects.s_order("goal_money","asc")
          when "g_money_desc"
            @projects = @projects.s_order("goal_money","desc")
          end
        end
        @projects = @projects.s_title @search.title if @search.title.present?
      end
    else
      @projects = @projects.s_order("created_at", "desc")
    end
end
