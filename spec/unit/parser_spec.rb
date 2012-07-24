require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Parser do

  def styles
    <<-STYLES
#foo .bar
  span.bar
    em
      color: red
    strong
      color: green
    STYLES
  end

  before do
    @parser = Perseus::Parser.new(styles)
  end

end
