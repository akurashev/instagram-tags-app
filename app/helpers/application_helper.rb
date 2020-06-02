module ApplicationHelper
  def status_icon(tag)
    case tag.status
    when 'new'
      'queue'
    when 'processing'
      'hourglass_empty'
    when 'finished'
      'done'
    end
  end
end
