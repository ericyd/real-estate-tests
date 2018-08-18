# Real Estate Tests

A series of tests for Redfin and Zillow

Ruby version 2.3.1p112
gem version 2.6.12
Bundler version 1.15.1


## Requirements

- [Ruby](https://www.ruby-lang.org/en/downloads/) (version 2.3.1 was used to develop the tests)
- [bundler](https://bundler.io/): `gem install bundler`


## Setup

### 1. Install dependencies

```bash
bundle install
```

If you get an error about nokogiri failing to install, follow the instructions at
<http://www.nokogiri.org/tutorials/installing_nokogiri.html>

### 2. Install Chromedriver

These tests run with the headless Chrome driver for Selenium.

Download chromedriver 2.41 from
<http://chromedriver.storage.googleapis.com/index.html?path=2.41/>
and add to your $PATH

on Linux (assuming you are in a directory on your $PATH):

```bash
wget http://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
unzip chromedriver_linux64.zip chromedriver
```


## Run tests

You must run `cucumber` and `rspec` independently
<!-- TODO: investigate `rake` to simplify -->

```bash
cucumber && rspec spec/zillow_spec.rb
```

This will test the following functionality:

- [redfin.com](https://www.redfin.com/): test basic authentication as well as searching properties with [Capybara](http://teamcapybara.github.io/capybara/) and [Cucumber](https://docs.cucumber.io/).
- [Zillow API](https://www.zillow.com/howto/api/APIOverview.htm): test property searching with [Faraday](https://github.com/lostisland/faraday) and [RSpec](http://rspec.info/).


<!-- 

Some thoughts from the internet on the project setup

<https://stackoverflow.com/questions/9549450/how-to-setup-a-basic-ruby-project>
<https://stackoverflow.com/questions/614309/ideal-ruby-project-structure>

-->
