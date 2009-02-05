class Bookmark < ActiveRecord::Base

  acts_as_taggable_on :keywords

  before_create :scrape_and_populate

  def self.front_page
    find :all
  end 

  def title_or_url
    title.empty? ? url : title
  end

  def webscrape
    scrape_and_populate
    save!
  end

  def meta_name(value)
    result = value.attributes['name']
    result ||= value.attributes['http-equiv']
    result.downcase
  end

  private 

  def scrape_and_populate(overwrite = false)
    doc = Hpricot(open(url))
    value = doc/:title
    self.title = value.nil? ? '' : value.first.inner_html
    values = doc/:meta
    values.each do |value|
      puts value.attributes.inspect
      name = meta_name(value)
      content = value.attributes['content']
      self.description = content if name == 'description' and (self.description.empty? or overwrite)
      self.author = content if name == 'author' and (self.author.nil? or self.author.empty? or overwrite)
      self.keyword_list = content if name == 'keywords' and (self.keyword_list.empty? or overwrite)
    end
  end

  private 

end
