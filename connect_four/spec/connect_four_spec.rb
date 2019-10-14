require "./lib/connect_four.rb"

RSpec.describe ConnectFour do
  describe "#game_over?" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")

    it "returns true when the board is full" do
      game = ConnectFour.new(p1, p2)
      game.board.length.times do |i|
        game.board[i].length.times do |j|
          game.board[i][j].value = "#{i}#{j}"
        end
      end
      expect(game.game_over?).to eql(true)
    end

    it "returns true when there is a win condition" do
      game = ConnectFour.new(p1, p2)
      (Board::NUM_ROW - 1).times do |i|
        Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
      end
      # Horizontal
      (0..3).each { |n| game.board[1][1 + n].value = "11" }
      expect(game.game_over?).to eql(true)

      (Board::NUM_ROW - 1).times do |i|
        Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
      end
      # Vertical
      (0..3).each { |n| game.board[2 + n][2].value = "22" }
      expect(game.game_over?).to eql(true)

      (Board::NUM_ROW - 1).times do |i|
        Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
      end
      # diagonal (ne-sw)
      (0..3).each { |n| game.board[3 - n][4 - n].value = "34" }
      expect(game.game_over?).to eql(true)

      (Board::NUM_ROW - 1).times do |i|
        Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
      end
      # diagonal (nw-ss)
      (0..3).each { |n| game.board[4 - n][3 + n].value = "43" }
      expect(game.game_over?).to eql(true)
    end
  end

  describe "#valid_move?" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")

    it "returns false if column number is out of bounds" do
      game = ConnectFour.new(p1, p2)
      expect(game.valid_move?(-1)).to eql(false)
      expect(game.valid_move?(7)).to eql(false)
    end

    it "returns false if column is full" do
      game = ConnectFour.new(p1, p2)
      Board::NUM_COL.times do |j|
        Board::NUM_ROW.times do |i|
          expect(game.valid_move?(j)).to eql(true)
          game.board[i][j].value = "#{i}#{j}"
        end
        expect(game.valid_move?(j)).to eql(false)
      end
    end
  end

  describe "#switch_player" do
    it "changes the current player" do
      p1 = Player.new("Alice")
      p2 = Player.new("Bob")
      game = ConnectFour.new(p1, p2)

      expect(game.current_player.name).to eql(p1.name)
      game.switch_player
      expect(game.current_player.name).to eql(p2.name)
    end
  end

  describe "#get_column" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    game = ConnectFour.new(p1, p2)
    Board::NUM_ROW.times { |i| game.board[i][4].value = "X" }

    let(:input) { "2\n" }
    let(:bad_input) { "a\n" }
    let(:invalid_input) { "20\n" }
    let(:occupied_input) { "5\n" }

    it "returns column as integer" do
      allow(game).to receive(:gets).and_return(input)
      expect(game.get_column).to eq(2)
    end

    it "keeps trying until it gets a valid input" do
      allow(game).to receive(:gets).and_return(bad_input, invalid_input,
        occupied_input, input)
      expect(game).to receive(:gets).exactly(4).times
      expect(game.get_column).to eq(2)
    end
  end

  describe "#winner" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    p1.symbol = "O"
    p2.symbol = "X"
    it "triggers when there is a win condition" do
      [p1, p2].each do |player|
        game = ConnectFour.new(p1, p2)
        Board::NUM_ROW.times do |i|
          Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
        end
        (0..3).each { |n| game.board[2 + n][2].value = player.symbol }
        puts game.board

        expect(game.winner).to eql("#{player.name} is the winner!")
      end
    end

    it "shows draw then there is no win condition" do
      game = ConnectFour.new(p1, p2)
      Board::NUM_ROW.times do |i|
        Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
      end
      expect(game.winner).to eql("It's a draw.")
    end

    it "returns nil when board is no full" do
      game = ConnectFour.new(p1, p2)
      (Board::NUM_ROW - 1).times do |i|
        Board::NUM_COL.times { |j| game.board[i][j].value = "#{i}#{j}" }
      end
      expect(game.winner).to eql(nil)
    end
  end

  describe "#prepared?" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    game = ConnectFour.new(p1, p2)

    it "return false if not all players are assigned symbols" do
      expect(game.prepared?).to eql(false)
      p1.symbol = "X"
      expect(game.prepared?).to eql(false)
      p1.symbol = nil
      p2.symbol = "X"
      expect(game.prepared?).to eql(false)
      p2.symbol = nil
    end

    it "return true if all players are assigned symbols" do
      p1.symbol = "X"
      p2.symbol = "O"
      expect(game.prepared?).to eql(true)
    end
  end

  describe "#play" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    p1.symbol = "X"
    p2.symbol = "O"
    game = ConnectFour.new(p1, p2)

    let(:turn_1) { "1\n" }
    let(:turn_2) { "2\n" }
    let(:turn_3) { "1\n" }
    let(:turn_4) { "3\n" }
    let(:turn_5) { "1\n" }
    let(:turn_6) { "4\n" }
    let(:turn_7) { "1\n" }

    it "runs to completion" do
      allow(game).to receive(:gets).and_return(turn_1, turn_2, turn_3,
        turn_4, turn_5, turn_6, turn_7)
      expect(game).to receive(:gets).exactly(7).times
      game.play
    end
  end
end