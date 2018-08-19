# Real Estate Tests

A series of tests for Redfin and Zillow


## Requirements

- [Ruby](https://www.ruby-lang.org/en/downloads/): `sudo apt-get install ruby`
- [bundler](https://bundler.io/): `sudo gem install bundler`
- [Chrome](https://www.google.com/chrome/): download from Google or [follow these command-line instructions for Ubuntu-based distros](https://www.howopensource.com/2011/10/install-google-chrome-in-ubuntu-11-10-11-04-10-10-10-04/)

## Setup

### 1. Clone repo and install dependencies

```bash
git clone https://github.com/ericyd/real-estate-tests.git
cd real-estate-tests
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

[Rake](https://ruby.github.io/rake/) will run both the Cucumber (Redfin) and Rspec (Zillow) tests.

```bash
rake
```

This will test the following functionality:

- [redfin.com](https://www.redfin.com/): test basic authentication as well as searching properties with [Capybara](http://teamcapybara.github.io/capybara/) and [Cucumber](https://docs.cucumber.io/).
- [Zillow API](https://www.zillow.com/howto/api/APIOverview.htm): test property searching with [Faraday](https://github.com/lostisland/faraday) and [RSpec](http://rspec.info/).


If you prefer to run the tests individually, you can use

```bash
# zillow tests
rake spec
# redfin tests
rake features
# run linter
rake lint
```

## Compatibility

This was developed on Linux Mint 18.3 and tested with Ruby 2.3.1, 2.3.7, and 2.5.1
