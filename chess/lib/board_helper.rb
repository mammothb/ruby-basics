require_relative "./pieces/pieces.rb"

module BoardHelper
  def is_a_piece?
    Proc.new { |node| node.is_a?(Piece) }
  end

  # Returns true if any element the move hash is nil
  #
  # nil elements are a result of chess move notation going beyond the
  # limit of a..h/1..8
  def include_nil?(move)
    move.values.flatten.include?(nil)
  end

  # def all_pieces(values)
  #   values.flatten.select(&is_a_piece?)
  # end

  # def king_pos(values, king)
  #   all_pieces(values).find { |piece| piece.symbol == king }.pos
  # end

  # def opponent_pieces(values, color)
  #   all_pieces(values).select { |piece| piece.color != color }
  # end

  def print_board(values, size)
    result = "\n    #{("A".."H").to_a.join("   ")}\n"
    result += "  +-#{(["-"] * size).join("-+-")}-+\n"
    values.reverse.each_with_index do |row, i|
      result += "#{size - i} | "
      result += row.map do |piece|
        piece.is_a?(Piece) ? piece.symbol : piece
      end.join(" | ")
      result += " | #{size - i}\n"
      result += "  +-#{(["-"] * size).join("-+-")}-+\n"
    end
    result += "    #{("A".."H").to_a.join("   ")}"
  end
end