module ApplicationHelper
  def markdown(text)
    return "" if text.nil?
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    auto_link(markdown.render(text))
  end
end
