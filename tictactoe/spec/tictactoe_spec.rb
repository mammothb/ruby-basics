require "./lib/tictactoe.rb"

RSpec.describe TicTacToe do
  describe "#game_ended?" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")

    it "triggers when there is a win condition" do
      symbols = ["O", "X"]
      win_conditions = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
        [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
      symbols.each do |symbol|
        win_conditions.each do |indices|
          game = TicTacToe.new(p1, p2)
          indices.each { |i| game.board.values[i] = symbol }
          expect(game.game_ended?).to eql(true)
        end
      end
    end

    it "triggers when board is full" do
      game = TicTacToe.new(p1, p2)
      game.board.values.length.times { |i| game.board.values[i] = i.to_s }
      expect(game.game_ended?).to eql(true)
    end

    it "does not trigger when board is not full with no win condition" do
      game = TicTacToe.new(p1, p2)
      (game.board.values.length - 1).times do |i|
        game.board.values[i] = i.to_s
      end
      expect(game.game_ended?).to eql(false)
    end

    it "does not trigger when board is empty" do
      game = TicTacToe.new(p1, p2)
      expect(game.game_ended?).to eql(false)
    end
  end

  describe "#flip_coin" do
    it "assigns the player going first with 'X'" do
      p1 = Player.new("Alice")
      p2 = Player.new("Bob")
      game = TicTacToe.new(p1, p2)
      game.flip_coin

      expect(game.current_player.symbol).to eql("X")
      game.switch_player
      expect(game.current_player.symbol).to eql("O")
    end
  end

  describe "#get_index" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    game = TicTacToe.new(p1, p2)
    game.board.values[4] = "X"

    let(:input) { "2\n" }
    let(:bad_input) { "a\n" }
    let(:invalid_input) { "20\n" }
    let(:occupied_input) { "5\n" }

    it "returns index as integer" do
      allow(game).to receive(:gets).and_return(input)
      expect(game.get_index).to eq(2)
    end

    it "keeps trying until it gets a valid input" do
      allow(game).to receive(:gets).and_return(bad_input, invalid_input,
        occupied_input, input)
      expect(game).to receive(:gets).exactly(4).times
      expect(game.get_index).to eq(2)
    end
  end

  describe "#winner" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    p1.symbol = "O"
    p2.symbol = "X"
    it "triggers when there is a win condition" do
      win_conditions = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
        [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
      [p1, p2].each do |player|
        win_conditions.each do |indices|
          game = TicTacToe.new(p1, p2)
          indices.each { |i| game.board.values[i] = player.symbol }
          expect(game.winner).to eql("#{player.name} is the winner!")
        end
      end
    end

    it "shows draw then there is no win condition" do
      game = TicTacToe.new(p1, p2)
      game.board.values.length.times { |i| game.board.values[i] = i.to_s }
      expect(game.winner).to eql("It's a draw.")
    end

    it "returns nil when board is no full" do
      game = TicTacToe.new(p1, p2)
      expect(game.winner).to eql(nil)
      (game.board.values.length - 1).times do |i|
        game.board.values[i] = i.to_s
      end
      expect(game.winner).to eql(nil)
    end
  end

  describe "#prepared?" do
    p1 = Player.new("Alice")
    p2 = Player.new("Bob")
    game = TicTacToe.new(p1, p2)

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
    game = TicTacToe.new(p1, p2)

    let(:turn_1) { "5\n" }
    let(:turn_2) { "1\n" }
    let(:turn_3) { "2\n" }
    let(:turn_4) { "4\n" }
    let(:turn_5) { "8\n" }

    it "runs to completion" do
      allow(game).to receive(:gets).and_return(turn_1, turn_2, turn_3,
        turn_4, turn_5)
      expect(game).to receive(:gets).exactly(5).times
      game.play
    end
  end
end