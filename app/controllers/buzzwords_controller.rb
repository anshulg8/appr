class BuzzwordsController < ApplicationController

  def index
    @buzzwords = Buzzword.all
  end

end
