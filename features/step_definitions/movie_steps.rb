# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
#  page.body.should =~ /[.\D]*#{e1}[.\D]*#{e2}/
  (page.body.index(e1)-page.body.index(e2)).should < 0
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rating|
    if (uncheck) then
      step "I uncheck \"ratings_#{rating}\""
    elsif
      step "I check \"ratings_#{rating}\""
    end
  end
end

Then /I should see the following movies: (.*)/ do |movies|
  movies.split(", ").each do |movie|
    page.should have_content(movie)
  end
end

Then /I should not see the following movies: (.*)/ do |movies|
  movies.split(", ").each do |movie|
    page.should_not have_content(movie)
  end
end

Then /I should see all of the movies/ do
  page.all('table#movies tr').count.should == 11
end

Then /I should see none of the movies/ do
  page.all('table#movies tr').count.should == 1
end


Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  @movie = Movie.find_by_title(title)
  @movie.director.should eql director
end