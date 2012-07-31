*This gem is under development and has not been released. This documentation describes an incomplete feature set.*

# perseus [![Build Status](https://secure.travis-ci.org/polarblau/perseus.png?branch=master)](http://travis-ci.org/polarblau/perseus)

Perseus converts stylesheets (SASS, SCSS or CSS) into HTML using fake content. 
The result can be influenced using documenting comments.

The gem allows for the creation of styleguides based on a selection of stylesheets with minimal additional effort,
reinforces best practices for writing and structuring self–documenting styles.

### Usage

```ruby
styles = '#foo'
engine = Perseus::Engine.new(styles)
engine.render # => <div id="foo"></div>
```