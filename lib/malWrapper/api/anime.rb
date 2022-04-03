# frozen_string_literal: true

require File.expand_path("base", File.dirname(__FILE__))

module MalWrapper
  module API
    ##
    # Anime class
    # This class is used to get information about an anime
    class Anime
      # @return [MalWrapper::API::Base] the base api
      attr_reader :api

      ##
      # Initialize the Anime class
      # @param [String] base_url The base url of the mal api
      def initialize(base_url)
        @api = Base.new(base_url)
      end

      ##
      # Get ID of an anime
      # @param [String] name The name of the anime
      # @return [Integer] The id of the anime
      # @example
      #  anime = MalWrapper::API::Anime.new("https://api.myanimelist.net/v2/")
      #  anime.id("Jojo's Bizarre Adventure")
      def id(name)
        @api.parse(@api.build_query(Hash[
                                    :query => name,
                                    :type => "anime",
                                    :limit => 1
                                  ]))["data"].first["node"]["id"]
      end

      ##
      # Get all anime by a query
      # @param [String] query The query to search for
      # @return [Array] An array of anime
      # @example
      # anime = MalWrapper::API::Anime.new("https://api.myanimelist.net/v2/")
      # anime.find("Jojo's Bizarre Adventure", :limit => 10, :fields => %w[title synopsis])
      def find(query, limit: 100, offset: 0, fields: %w[])
        @api.parse(@api.build_query(Hash[
                                    :query => query,
                                    :type => "anime",
                                    :limit => limit,
                                    :offset => offset,
                                    :fields => fields
                                  ]))["data"].map { |anime| anime["node"] }
      end

      ##
      # Get the first anime responding to a query
      # @param [String] query The query to search for
      # @return [Hash] The anime
      # @example
      # anime = MalWrapper::API::Anime.new("https://api.myanimelist.net/v2/")
      # anime.first("Jojo's Bizarre Adventure", :fields => %w[title synopsis])
      def first(query, fields: %w[])
        find(query, :limit => 1, :fields => fields)["data"].first["node"]
      end

      ##
      # Get the anime ranking
      # @param [String] ranking_type The ranking type
      # @return [Array<Hash>] The anime ranking
      # @example
      # anime = MalWrapper::API::Anime.new("https://api.myanimelist.net/v2/")
      # anime.ranking("bypopularity", :limit => 10, :fields => %w[title synopsis rank])
      def ranking(ranking_type, limit: 100, offset: 0, fields: %w[])
        @api.parse(@api.build_query(Hash[
                                      :query => ranking_type,
                                      :type => "anime",
                                      :limit => limit,
                                      :offset => offset,
                                      :fields => fields,
                                      :separator => "?"
                                    ]))["data"].map { |anime| anime["node"] }
      end

      alias search find
    end
  end
end
