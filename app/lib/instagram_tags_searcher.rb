require 'open-uri'
require 'json'
require 'cgi'

module InstagramTagsSearcher
  def self.fetch_data(url)
    header = {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; WOW64) ' \
                      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 ' \
                      'Safari/537.36 Core/1.53.3357.400 QQBrowser/9.6.11858.400'
    }
    JSON::parse(URI.open(url, header).read)
  rescue JSON::ParserError
    nil
  end

  def self.from_top(tag, amount)
    tag = CGI.escape(tag)
    data = fetch_data("https://www.instagram.com/explore/tags/#{tag}/?__a=1")
    # posts_count = data['graphql']['hashtag']['edge_hashtag_to_media']['count'].to_i

    return [[], []] if data.nil?

    moretags = []
    codes = []

    data['graphql']['hashtag']['edge_hashtag_to_top_posts']['edges'].each do |post|
      begin
        words = post['node']['edge_media_to_caption']['edges'][0]['node']['text'].split
      rescue
        codes << post['node']['shortcode']
        next
      end

      local_tags = search_tags(words)

      if local_tags.size < 30
        codes << post['node']['shortcode']
      end

      moretags += local_tags
    end

    [moretags.uniq, codes]
  end

  def self.search_tags(words)
    words.select do |word|
      word.start_with?('#') && word.count('#') == 1 && word.length > 2
    end
  end

  def self.from_first_comment(code)
    data = fetch_data("https://www.instagram.com/p/#{code}/?__a=1")

    return [] if data.nil?

    comments_count = data['graphql']['shortcode_media']['edge_media_to_parent_comment']['count']

    if comments_count > 0
      first_comment = data['graphql']['shortcode_media']['edge_media_to_parent_comment']['edges'][0]
      if first_comment
        first_comment_text = first_comment['node']['text'].split
      else
        first_comment_text = []
      end

      search_tags(first_comment_text)
    else
      []
    end
  end

  def self.sort_by_frequency(tags, amount)
    low = []
    middle = []
    high = []

    tags.each do |tag|
      sleep(rand(1..4) * 0.1)

      begin
        tag_url = CGI.escape(tag[1..-1])
        data = fetch_data("https://www.instagram.com/explore/tags/#{tag_url}/?__a=1")
      rescue
        next
      end

      next if data.nil?

      posts_count = data['graphql']['hashtag']['edge_hashtag_to_media']['count'].to_i

      if posts_count > amount[0] && posts_count <= amount[1]
        low << tag
      elsif posts_count > amount[1] && posts_count <= amount[2]
        middle << tag
      elsif posts_count > amount[2] && posts_count <= amount[3]
        high << tag
      end
    end

    [low, middle, high]
  end

  def self.search(tag)
    amount = [10_000, 100_000, 1_000_000, 20_000_000]

    new_tags, codes = from_top(tag, amount)

    if codes.count > 0
      codes.each do |code|
        more_tags = from_first_comment(code)
        new_tags += more_tags
      end
    end

    new_tags = new_tags.uniq

    low = []
    middle = []
    high = []

    new_tags.each_slice(30) do |slice|
      l, m, h = sort_by_frequency(slice, amount)

      low += l
      middle += m
      high += h

      sleep 60
    end

    [low, middle, high]
  end
end
