# Returns true if any element the move hash is nil
#
# nil elements are a result of chess move notation going beyond the
# limit of a..h/1..8
def include_nil?(move)
  move.values.flatten.include?(nil)
end
