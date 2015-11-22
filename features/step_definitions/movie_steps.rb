require 'uri'
require 'cgi'

def path_to(page_name)
    case page_name
    when /^the (RottenPotatoes )?home\s?page$/ then '/movies'
    end
end
  

# Add a declarative step here for populating the DB with movies.
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    m = Movie.create movie
    m.save!
  end
#  warn Movie.all.pluck(:title)
#  fail "Unimplemented"
end
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end
# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  fail "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /^(?:|I )press '([^"]*)'$/ do |button|
  click_button(button)
end

When /^(?:|I )check the following ratings: (.*)/ do |rating_list|
  rating_list.split(',').each do |rating|
    rating = rating.strip
    check("ratings_#{rating}")
  end
end

When /^(?:|I )uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.split(',').each do |rating|
    rating = rating.strip
    uncheck("ratings_#{rating}")
  end
end

Then /I should (not )?see movies of ratings:(.*)$/ do |neg, rating_list|
  rating_list.split(',').each do |rating|
    rating = rating.strip
    verf = "should"
    if neg
      verf = "should_not"
    end
    page.send verf.to_sym, have_xpath('//table/tbody/tr/td[count(//table/thead/tr/th[.="Rating"]/preceding-sibling::th)+1]',  :text => /^#{rating}$/)
  end
end

Then /I should see all the movies/ do
  page.should have_xpath('//table/tbody/tr', count: Movie.count)
end

When(/^I follow "(.*?)"$/) do |link|
  click_link(link)
end

Then /I should see movies ordered by "(.*)"/ do |order_by|
  ml = page.all(:xpath, "//table/tbody/tr/td[count(//table/thead/tr/th/a[.=\"#{order_by}\"]/../preceding-sibling::th)+1]").map {|x| x.text}
  ml.each_cons(2).all?{|i,j| i <= j} or \
  raise "Movies NOT ordered by #{order_by}:\n #{ml}"
end