module ProfilesHelper
  def payment_link(title, url, truncate=0)
    title = title.truncate(truncate) unless truncate.zero?
    unless url.blank?
      title = link_to title, '', :href=> url, :target=> 'new'
    end
    title
  end
end