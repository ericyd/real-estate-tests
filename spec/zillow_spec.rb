require "zillow/api"
require "faraday"
require "faraday_middleware"

# API endpoint references
# https://www.zillow.com/howto/api/GetDeepSearchResults.htm
# https://www.zillow.com/howto/api/GetSearchResults.htm
# https://www.zillow.com/howto/api/GetUpdatedPropertyDetails.htm


RSpec.describe "Zillow API" do
  before(:all) do 
    zwsid = { 'zws-id' => ZillowAPI::TOKEN }

    # declare search parameters
    @searchParams = zwsid.merge({
      'address' => '2028 NE Hancock St',
      'citystatezip' => '97212'
    })

    @propertyDetailParams = zwsid.merge({
      'zpid' => '48749425'
    })

    # use middleware to automatically parse xml responses
    @conn = Faraday.new(:url => 'http://www.zillow.com/webservice') do |faraday|
      faraday.response :xml,  :content_type => /\bxml$/
      faraday.adapter Faraday.default_adapter
    end
  end

  it "gets property details" do
    # get API
    res = @conn.get '/webservice/GetUpdatedPropertyDetails.htm', @propertyDetailParams

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
    res = @conn.get '/webservice/GetDeepSearchResults.htm', @searchParams

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