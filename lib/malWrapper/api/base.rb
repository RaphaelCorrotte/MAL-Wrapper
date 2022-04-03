# frozen_string_literal: true

require "rest-client"

module MalWrapper
  ##
  # This class is used to call the MyAnimeList API.
  module API
    class Base
      include RestClient
      HEADERS = Hash[
        :"X-MAL-CLIENT-ID" => "a04596c8d00de6bc279c7c690b12b665"
      ]
      attr_reader :base_url

      ##
      # Initializes the API class.
      # @param [String] base_url The base url of the API.
      def initialize(base_url)
        @base_url = base_url
      end

      ##
      # Calls the API and returns the response.
      # @param [String] param the param to call the api.
      # @return [Object] the response of the API.
      def parse(param)
        url = @base_url + param
        response = RestClient.get(url, HEADERS)
        JSON.parse(response)
      end

      ##
      # Build a query
      # @param [Hash] params the param to call the api.
      # @return [String] the built query
      # @example
      # build_query(Hash[
      #   :type => "anime",
      #   :query => "Jujutsu",
      #   :limit => "10",
      #   :offset => "0",
      #   :fields => %w[synopsis my_list_status]
      #   :separator => "?"
      # ])
      def build_query(params)
        authorized_keys = %i[type query limit offset fields]
        params.transform_keys!(&:to_s)

        raise ArgumentError, "Missing required keys: #{%w[type query].select { |k| k unless params.key?(k) }.join(", ")}" unless %w[type query].all? { |key| params.key?(key) }

        params.select! { |key, _| authorized_keys.include?(key.to_sym) }

        if params["query"].match(/\d+/) || params["separator"] == "?"
          "#{@base_url.end_with?("/") ? "" : "/"}#{params["type"]}/#{params["query"]}?fields=#{params["fields"].join(",")}"
        else
          args = params.map do |k, v|
            next "#{k}=#{v.join(",")}" if k == "fields"

            "#{k}=#{v}" unless %w[type query].include?(k)
          end

          "#{@base_url.end_with?("/") ? "" : "/"}#{params["type"]}?q=#{params["query"]}&#{args.filter { |q| q }.join("&")}"
        end
      end
    end
  end
end
