class Product < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  class SearchService
    attr_reader :query

    def initialize(query)
      @query = query
    end

    def search
      response =
        case @query
        when Hash
          Product.search({
            query: {
              bool: {
                should: queries
              }
            }
          })
        else
          Product.search(@query)
        end

      response.records
    end

    def property_keys
      @property_keys ||=
        begin
          query = 'select distinct k from (select skeys(properties) as k from products) as dt'
          results = ActiveRecord::Base.connection.execute(query)
          results.each_with_object([]) { |rows, columns| columns << rows['k'] }
        end
    end

  private

    def queries
      @query.each_with_object([]) do |(key, value), search|
        search << { match: { key => value } }
      end
    end
  end
end
