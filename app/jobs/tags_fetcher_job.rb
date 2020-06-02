class TagsFetcherJob < ApplicationJob
  queue_as :tags_fetcher

  def perform(tag_id)
    tag = Tag.find(tag_id)

    tag.status_processing!

    low, middle, high = InstagramTagsSearcher.search(tag.tag)

    tag.update!(
      low_frequency_tags: low,
      middle_frequency_tags: middle,
      high_frequency_tags: high,
      status: :finished
    )
  end
end
