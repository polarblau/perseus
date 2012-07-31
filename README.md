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

### Examples

<table width="100%">
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr>
<th>SASS</th>
<th>HTML</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<pre style="border: none">
<code>#foo
  .bar
    h1
      color: red</code>
</pre>
</td>
<td>
<pre>
<code>&lt;div id=&quot;foo&quot;&gt;
  &lt;div class=&quot;bar&quot;&gt;
    &lt;h1&gt;Lorem ipsum&lt;/h1&gt;
  &lt;/div&gt;
&lt;/div&gt;</code>
</pre>
</td>
</tr>
<tr>
<td>
<pre style="border: none">
<code>#foo
  // @content: Hello World
  h2
    color: red</code>
</pre>
</td>
<td>
<pre>
<code>&lt;div id=&quot;foo&quot;&gt;
  &lt;h2&gt;Hello World&lt;/h2&gt;
&lt;/div&gt;</code>
</pre>
</td>
</tr>
</tbody>
</table>