require_relative "board.rb"

module Movement
  module Unlimited
    def distance
      Board::SIZE
    end
  end

  module SingleStep
    def distance
      1
    end
  end

  module Straight
    def directions
      [[0, 1], [0, -1], [-1, 0], [1, 0]]
    end
  end

  module Diagonal
    def directions
      [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    end
  end

  module OmniDirectional
    include Diagonal

    def directions
      [[0, 1], [0, -1], [-1, 0], [1, 0]] + super
    end
  end
end
