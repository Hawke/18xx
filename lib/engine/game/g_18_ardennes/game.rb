# frozen_string_literal: true

require_relative '../base'
require_relative '../stubs_are_restricted'
require_relative 'entities'
require_relative 'map'
require_relative 'market'
require_relative 'meta'
require_relative 'tiles'
require_relative 'trains'

module Engine
  module Game
    module G18Ardennes
      class Game < Game::Base
        include_meta(G18Ardennes::Meta)
        include StubsAreRestricted
        include Entities
        include Map
        include Market
        include Tiles
        include Trains

        MIN_BID_INCREMENT = 5
        MUST_BID_INCREMENT_MULTIPLE = true
        COMPANY_SALE_FEE = 0 # Fee for selling Guillaume-Luxembourg to the bank.

        CAPITALIZATION = :incremental
        HOME_TOKEN_TIMING = :par

        MUST_BUY_TRAIN = :always # Just for majors, minors are handled in #must_buy_train?

        def setup
          super

          setup_tokens
        end

        def new_auction_round
          Engine::Round::Auction.new(self, [
            G18Ardennes::Step::HomeHexTile,
            G18Ardennes::Step::MinorAuction,
          ])
        end

        def stock_round
          Round::Stock.new(self, [
            Engine::Step::DiscardTrain,
            Engine::Step::Exchange,
            Engine::Step::SpecialTrack,
            Engine::Step::BuySellParSharesCompanies,
          ])
        end

        def operating_round(round_num)
          Round::Operating.new(self, [
            Engine::Step::Bankrupt,
            G18Ardennes::Step::Track,
            G18Ardennes::Step::Token,
            G18Ardennes::Step::CollectForts,
            G18Ardennes::Step::Route,
            G18Ardennes::Step::Dividend,
            Engine::Step::DiscardTrain,
            Engine::Step::BuyTrain,
          ], round_num: round_num)
        end
      end
    end
  end
end
