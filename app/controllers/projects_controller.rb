class ProjectsController < ApplicationController
  before_action :search, only: :index

  # GET /
  def index
    @projects = @projects.paginate(page: params[:page], per_page: 30)
  end

  # GET /project/:id
  def show
    @project = Project.find_by id: params[:id]
    pp1 = ProjectProgress.where(project_id: params[:id]).first(3).map{|a|a.attributes}
    pp2 = ProjectProgress.where("project_id= ? AND hour(created_at) = ?", params[:id], 15).map{|a|a.attributes}
    pp = pp1.concat pp2
    @money = pp.map{|a|a["money"]}
    @supporter_num = pp.map{|a|a["supporter_num"]}
    @date = pp.map{|a|a["date"].strftime('%-m月%d日 %H時')}
end

  private
    # Only allow a trusted parameter "white list" through.
    def project_params
      params[:project]
    end

    def search
      @search = Form.new params[:form]
      @projects = Project.includes :project_progresses
      @projects = @projects.s_title @search.title if @search.title.present?
      @projects = @projects.s_order @search.order if @search.order.present?
    end

end
