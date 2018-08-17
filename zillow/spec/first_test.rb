# not sure this is the best way to import the token
require_relative "../api"
require "faraday"
require "faraday_middleware"

# References
# https://www.zillow.com/howto/api/GetDeepSearchResults.htm
# https://www.zillow.com/howto/api/GetSearchResults.htm
# https://www.zillow.com/howto/api/GetUpdatedPropertyDetails.htm
# http://www.zillow.com/webservice/GetUpdatedPropertyDetails.htm?zws-id=X1-ZWz18ey83b4gsr_ako3m&zpid=48749425 


# declare search parameters
searchParams = {
  'zws-id' => ZillowAPI::TOKEN,
  'address' => '2028 NE Hancock St',
  'citystatezip' => '97212'
}

propertyDetailParams = {
  'zws-id'.to_sym => ZillowAPI::TOKEN,
  :zpid => '48749425'
}

# use middleware to automatically parse xml responses
conn = Faraday.new 'http://www.zillow.com/webservice' do |conn|
  conn.response :xml,  :content_type => /\bxml$/
  conn.adapter Faraday.default_adapter
end

RSpec.describe "Zillow API" do
  it "gets property details" do
    # get API
    res = conn.get 'http://www.zillow.com/webservice/GetUpdatedPropertyDetails.htm', propertyDetailParams

    # verify status and response message
    expect(res.status).to eq(200)
    body = res.body['updatedPropertyDetails']
    expect(body['message']['text']).to eq('Request successfully processed')

    # verify response address
    res_address = body['response']['address']
    expect(res_address['street']).to eq('2114 Bigelow Ave N')
    expect(res_address['zipcode']).to eq('98109')
  end

  it "gets search results" do
    # get API
    res = conn.get 'http://www.zillow.com/webservice/GetDeepSearchResults.htm', searchParams

    # verify status and response message
    expect(res.status).to eq(200)
    body = res.body['searchresults']
    expect(body['message']['text']).to eq('Request successfully processed')

    # verify result set
    results = body['response']['results']
    expect(results.length).to be >= 1
    expect(results['result']['address']['street']).to eq('2028 NE Hancock St')
  end
end


# puts searchParams


# this is a more ideal method, but right now need to just get some tests written
# 
# http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz18ey83b4gsr_ako3m&address=2028+NE+Hancock+St&citystatezip=97212
# conn = Faraday.new(:url => 'http://www.zillow.com/webservice')
# conn = Faraday::Connection.new 'http://www.zillow.com/webservice'
# response = conn.get '/GetUpdatedPropertyDetails.htm', propertyDetailParams




# response = Faraday.get 'http://www.zillow.com/webservice/GetDeepSearchResults.htm', searchParams
# puts response.body.length


# puts response.body