[![Build Status](https://travis-ci.org/Wolox/wor-prof.svg?branch=master)](https://travis-ci.org/Wolox/wor-prof)
[![Code Climate](https://codeclimate.com/github/Wolox/wor-prof/badges/gpa.svg)](https://codeclimate.com/github/Wolox/wor-prof)
[![Test Coverage](https://codeclimate.com/github/Wolox/wor-prof/badges/coverage.svg)](https://codeclimate.com/github/Wolox/wor-prof/coverage)

# Wor-Prof

Wor-prof (Wprof) is a gem for Ruby On Rails which its only purpose is to measure a RoR app's performance through a profile with different times of response. In order to accomplish that, Wprof uses ActiveSupport::Notifications (available in Rails since v4.0.2) to capture every action from his controllers. However, there's more. when using httparty in your project, you can capture every done request to external services. Do you have one or two methods that would like to know how long they take to execute? With Wprof you can find out.

Then, every data obtained can be reported in several ways, choose one from the Rails logger: database file, CSV text or go ahead and do a Post request wherever you want... Do it both synchronously or asynchronously.

### Installation 

Add the next line to the gemfile from your Rails application:

```ruby
gem 'wor-prof'
```

And then, execute:
```bash
$ bundle install
```
**That's it!!** At server execution, WProf immediately begins to work with default settings, so you won't need to configure anything if it matches with your needs, otherwise you can check **Available Settings** [here!](https://github.com/Wolox/wor-prof/wiki/User-Guide#available-configurations)

## Complete User Guide!?? Where??

If you want to know more about this gem and how use it correctly, please visit Wiki sections. There you will find all configurations available and every detail.

[WIKI LINK -ALL DOCS HERE!](https://github.com/Wolox/wor-prof/wiki)

[ENGLISH VERSION](https://github.com/Wolox/wor-prof/wiki/User-Guide)

[VERSION ESPAÑOL](https://github.com/Wolox/wor-prof/wiki/Guia-de-Usuario)

## Notes!!!

This gem use [HTTParty](https://github.com/jnunemaker/httparty) and [Sidekiq](https://github.com/mperham/sidekiq).
If you don't know anything about they, take a look in their repos!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`bundle exec rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request
---
## About ##

*This project was **developed** by ***[Maximiliano Colombo](https://github.com/mcolombo87)*** at ***[Wolox](http://www.wolox.com.ar).****

**Maintainers:** [Maximiliano Colombo](https://github.com/mcolombo87).

**Contributors:** Waiting For You!!!
[Samir Tapiero](https://github.com/blacksam07)

![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

---
## License

**wor-prof** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/wor-prof/master/LICENSE.md).

    Copyright (c) 2019 Wolox

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

