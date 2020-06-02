class TagsController < ApplicationController
  before_action :set_tag, only: [:show]

  def index
    @tags = Tag.all
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    @tag.tag = sanitize_tag(@tag.tag)

    if @tag.save
      TagsFetcherJob.perform_later(@tag.id)

      redirect_to tags_path, notice: 'Tag was successfully created.'
    else
      render :new
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(
      :tag, :status, :low_frequency_tags, :middle_frequency_tags,
      :high_frequency_tags
    )
  end

  def sanitize_tag(tag)
    tag = tag[1..-1] if tag.start_with?('#')
    CGI.escape(tag)
  end
end
