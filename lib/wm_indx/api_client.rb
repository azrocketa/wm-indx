# frozen_string_literal: true

require 'rubygems'
require 'digest'
require 'json'
require 'net/http'
require 'socket'
require 'date'
require 'uri'

module WmIndx
  class ApiClient
    attr_accessor :user, :pass, :wmid

    INDX_API_PAGE = 'https://api.indx.market:443/api/v2'.freeze
    INDX_API_LANG = 'en-EN'.freeze

    def initialize(user, pass, wmid)
      @user = user
      @pass = pass
      @wmid = wmid
    end

    def api_balance
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/Balance")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash } }

      api_request(api_url, api_post)
    end

    def api_tools
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/Tools")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash } }

      api_request(api_url, api_post)
    end

    def api_history_trading(tool_id: 60, date_start: nil, date_end: nil)
      date_start ||= (Date.today - 31).strftime("%Y%m%d")
      date_end   ||= Date.today.strftime("%Y%m%d")

      api_url  = URI.parse("#{INDX_API_PAGE}/trade/HistoryTrading")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid};#{tool_id};#{date_start};#{date_end}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash },
                  'Trading': { 'ID': tool_id, 'DateStart': date_start, 'DateEnd': date_end } }

      api_request(api_url, api_post)
    end

    def api_history_transaction(tool_id: 60, date_start: nil, date_end: nil)
      date_start ||= (Date.today - 31).strftime("%Y%m%d")
      date_end   ||= Date.today.strftime("%Y%m%d")

      api_url  = URI.parse("#{INDX_API_PAGE}/trade/HistoryTransaction")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid};#{tool_id};#{date_start};#{date_end}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash },
                  'Trading': { 'ID': tool_id, 'DateStart': date_start, 'DateEnd': date_end } }

      api_request(api_url, api_post)
    end

    def api_offer_my
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/OfferMy")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash } }

      api_request(api_url, api_post)
    end

    def api_offer_list(tool_id: 60)
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/OfferList")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid};#{tool_id}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash },
                  'Trading': { 'ID': tool_id } }

      api_request(api_url, api_post)
    end

    def api_offer_add(tool_id: 60, count: 0, is_anonymous: true, is_bid: true, price: 0.0)
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/OfferAdd")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid};#{tool_id}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash },
                  'Offer': { 'ID': tool_id, 'Count': count, 'IsAnonymous': is_anonymous, 'IsBid': is_bid, 'Price': price } }

      api_request(api_url, api_post)
    end

    def api_offer_delete(offer_id)
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/OfferDelete")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid};#{offer_id}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash },
                  'OfferId': offer_id }

      api_request(api_url, api_post)
    end

    def api_tick(tool_id: 60, kind: 1)
      api_url  = URI.parse("#{INDX_API_PAGE}/trade/tick")
      api_hash = Digest::SHA256.base64digest("#{@user};#{@pass};#{INDX_API_LANG};#{@wmid};#{tool_id};#{kind}")
      api_post = { 'ApiContext': { 'Login': @user, 'Wmid': @wmid, 'Culture': INDX_API_LANG, 'Signature': api_hash },
                  'Tick': { 'ID': tool_id, 'Kind': kind } }

      api_request(api_url, api_post)
    end

    private

    def api_request(url, post)
      # Create the HTTP objects
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      request = Net::HTTP::Post.new(url.request_uri, headers)
      request.body = post.to_json

      # Send the request
      response = http.request(request)

      # Check http status code
      if response.code.to_i == 200
        response.body
      else
        raise "{'status':'error','http_code':'#{response.code}','body':'#{response.body}'}"
      end
    end

  end
end
