class ProjectsController < ApplicationController

  # GET /
  def index
    @projects = Project.paginate(page: params[:page], per_page: 30)
  end

  # GET /project/:id
  def show
    @project = Project.find_by id: params[:id]
    hoge = ProjectProgress.where(project_id: params[:id]).order(:date)
    @money = hoge.pluck(:money)
    @supporter_num = hoge.pluck(:supporter_num)
    @date = hoge.pluck(:date).map {|d|
      if d.hour == 0
        d.strftime('%-m月%d日 %H')
      else
        d.strftime('%H')
      end
    }
end

  private
    # Only allow a trusted parameter "white list" through.
    def project_params
      params[:project]
    end
end
