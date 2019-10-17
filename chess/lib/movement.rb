module Movement
  module MultiStep
    def distance
      8
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

    def straight_directions
      [[0, 1], [0, -1], [-1, 0], [1, 0]]
    end
  end

  module Diagonal
    def directions
      [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    end

    def diagonal_directions
      [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    end
  end

  module OmniDirectional
    include Diagonal
    include Straight

    def directions
      diagonal_directions + straight_directions
    end
  end
end
