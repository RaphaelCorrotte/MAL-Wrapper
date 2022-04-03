# frozen_string_literal: true

require File.expand_path("base", File.dirname(__FILE__))

module MalWrapper
  module API
    class Manga
      # @return [MalWrapper::API::Base] the base api
      attr_reader :api

      ##
      # Initialize the Anime class
      # @param [String] base_url The base url of the mal api
      def initialize(base_url)
        @api = Base.new(base_url)
      end

      ##
      # Get ID of a manga
      # @param [String] name The name of the manga
      # @return [Integer] The id of the manga
      # @example
      #  anime = MalWrapper::API::Manga.new("https://api.myanimelist.net/v2/")
      #  anime.id("Jojo's Bizarre Adventure")
      def id(name)
        @api.parse(@api.build_query(Hash[
                                      :query => name,
                                      :type => "manga",
                                      :limit => 1
                                    ]))["data"].first["node"]["id"]
      end

      ##
      # Get all mangas by a query
      # @param [String] query The query to search for
      # @return [Array] An array of mangas
      # @example
      # manga = MalWrapper::API::Manga.new("https://api.myanimelist.net/v2/")
      # manga.find("Seven Deadly Sins", :limit => 10, :fields => %w[title synopsis])
      def find(query, limit: 100, offset: 0, fields: %w[])
        @api.parse(@api.build_query(Hash[
                                      :query => query,
                                      :type => "manga",
                                      :limit => limit,
                                      :offset => offset,
                                      :fields => fields
                                    ]))["data"].map { |manga| manga["node"] }
      end

      ##
      # Get the first manga responding to a query
      # @param [String] query The query to search for
      # @return [Hash] The manga
      # @example
      # manga = MalWrapper::API::manga.new("https://api.myanimelist.net/v2/")
      # manga.first("Seven Deadly SIns", :fields => %w[title synopsis])
      def first(query, fields: %w[])
        find(query, :limit => 1, :fields => fields)["data"].first["node"]
      end

      ##
      # Get the manga ranking
      # @param [String] ranking_type The ranking type
      # @return [Array<Hash>] The anime ranking
      # @example
      # manga = MalWrapper::API::Manga.new("https://api.myanimelist.net/v2/")
      # manga.ranking("bypopularity", :limit => 10, :fields => %w[title synopsis rank])
      def ranking(ranking_type, limit: 100, offset: 0, fields: %w[])
        @api.parse(@api.build_query(Hash[
                                      :query => ranking_type,
                                      :type => "manga",
                                      :limit => limit,
                                      :offset => offset,
                                      :fields => fields,
                                      :separator => "?"
                                    ]))["data"].map { |manga| manga["node"] }
      end

      alias search find
    end
  end
end
