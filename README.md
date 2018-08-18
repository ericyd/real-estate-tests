# Real Estate Tests

A series of tests for Redfin and Zillow

Ruby version 2.3.1p112
gem version 2.6.12
Bundler version 1.15.1


## Contents

- `/redfin`: tests for Redfin using Ruby, Cucumber, and Capybara
- `/zillow`: tests for Zillow using Ruby, RSpec, and Faraday




## Redfin

1. Gemfile -> add cucumber and capybara
  (I dont think rspec needs to be there...???)
2. run `bundler install`
3. run `cucumber --init`
4. add features
5. add stepdefs
6. run `cucumber` to execute the tests

TODO: figure out what a rakefile does

If you get an error about nokogiri failing to install, use the instructions at:
<http://www.nokogiri.org/tutorials/installing_nokogiri.html> - 
`sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev`


If you get an error about capybara-webkit failing to install, use the instructions at:
<https://www.debugpoint.com/2016/01/how-to-solve-qmake-error-qmake-no-such-file-or-directory/> - 
`sudo apt-get install qt4-qmake libqt4-dev libqtwebkit-dev`


Download chromedriver 2.41 from
<http://chromedriver.storage.googleapis.com/index.html?path=2.41/>
and add to your $PATH

on Linux:

```bash
wget http://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
unzip chromedriver_linux64.zip chromedriver
```


## Some ideas on the setup

<https://stackoverflow.com/questions/9549450/how-to-setup-a-basic-ruby-project>
<https://stackoverflow.com/questions/614309/ideal-ruby-project-structure>



## Running tests

Currently have to run `cucumber` and `rspec` independently

```bash
cucumber
rspec spec/zillow_spec.rb
```