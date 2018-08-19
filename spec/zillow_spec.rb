require 'zillow/api'
require 'faraday'
require 'faraday_middleware'

# API endpoint references
# https://www.zillow.com/howto/api/GetDeepSearchResults.htm
# https://www.zillow.com/howto/api/GetSearchResults.htm
# https://www.zillow.com/howto/api/GetUpdatedPropertyDetails.htm

# Convenience class for handling the deeply nested response body
class ResponseBody
  attr_reader :address

  def initialize(body)
    @top = body.keys.first
    @body = body[@top]
    @address = @body['response']['results']['result']['address'] unless @body['response'].nil?
  end

  def message_text
    @body['message']['text']
  end

  def message_code
    @body['message']['code']
  end

  def street
    @address['street'] unless @address.nil?
  end

  def zipcode
    @address['zipcode'] unless @address.nil?
  end

  def city
    @address['city'] unless @address.nil?
  end

  def state
    @address['state'] unless @address.nil?
  end
end

RSpec.describe 'Zillow API' do
  before(:all) do
    @zwsid = { 'zws-id' => ZillowAPI::TOKEN }

    # use middleware to automatically parse xml responses
    @conn = Faraday.new(:url => 'http://www.zillow.com/webservice') do |faraday|
      faraday.response :xml, :content_type => /\bxml$/
      faraday.adapter Faraday.default_adapter
    end
  end

  it 'should search by zipcode' do
    # set expected values
    address = '2028 NE Hancock St'
    citystatezip = '97212'

    # get API
    res = @conn.get '/webservice/GetDeepSearchResults.htm',
                    @zwsid.merge('address' => address, 'citystatezip' => citystatezip)
    # verify status and response message
    body = ResponseBody.new(res.body)
    expect(res.status).to eq(200)
    expect(body.message_text).to eq('Request successfully processed')
    expect(body.message_code).to eq('0')

    # verify result set
    expect(body.street).to eq(address)
    expect(body.zipcode).to eq(citystatezip)
  end

  it 'should search by city/state' do
    # set expected values
    address = '8426 SE 8th Ave'
    citystatezip = 'Portland,OR'

    # get API
    res = @conn.get '/webservice/GetDeepSearchResults.htm',
                    @zwsid.merge('address' => address, 'citystatezip' => citystatezip)

    # verify status and response message
    body = ResponseBody.new(res.body)
    expect(res.status).to eq(200)
    expect(body.message_text).to eq('Request successfully processed')
    expect(body.message_code).to eq('0')

    # verify result set
    expect(body.street).to eq(address)
    expect(body.city).to eq(citystatezip.split(',')[0])
    expect(body.state).to eq(citystatezip.split(',')[1])
  end

  it 'should notify client when no matches found' do
    # set expected values
    address = '800000 does not exist'
    citystatezip = '97212'

    # get API
    res = @conn.get '/webservice/GetDeepSearchResults.htm',
                    @zwsid.merge('address' => address, 'citystatezip' => citystatezip)

    # verify status and response message
    body = ResponseBody.new(res.body)
    expect(res.status).to eq(200)
    expect(body.message_text).to eq('Error: no exact match found for input address')
    expect(body.message_code).to eq('508')
    expect(body.address.nil?).to eq(true)
  end

  it 'should notify client when invalid ZWS-ID is used' do
    # set expected values
    address = '2028 NE Hancock St'
    citystatezip = '97212'

    # get API
    res = @conn.get '/webservice/GetDeepSearchResults.htm',
                    'address' => address, 'citystatezip' => citystatezip

    # verify status and response message
    body = ResponseBody.new(res.body)
    expect(res.status).to eq(200)
    expect(body.message_text).to eq(
      'Error: invalid or missing ZWSID parameter'
    )
    expect(body.message_code).to eq('2')
    expect(body.address.nil?).to eq(true)
  end

  # this test passes but isn't in the scope of the assignment so
  # no effort was made to refactor it
  it 'gets property details by ZPID' do
    # set expected values
    zpid = '48749425'

    # get API
    res = @conn.get '/webservice/GetUpdatedPropertyDetails.htm',
                    @zwsid.merge('zpid' => zpid)

    # verify status and response message
    body = res.body['updatedPropertyDetails']
    expect(res.status).to eq(200)
    expect(body['message']['text']).to eq('Request successfully processed')

    # verify response address
    expect(body['response']['address']['street']).to eq('2114 Bigelow Ave N')
    expect(body['response']['address']['zipcode']).to eq('98109')
  end
end
