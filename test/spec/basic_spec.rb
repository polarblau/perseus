require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

describe Perseus, "Functional overview" do

  it "should convert SASS to HTML" do
    sass = <<-SASS
      #foo
        span.bar
          em
            color: red
    SASS
    html = <<-HTML
      <div id="foo">
        <span class="bar"><em>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</em></span>
      </div>
    HTML
    Perseus.compile(sass).must_be_same_as(html)
  end

end
