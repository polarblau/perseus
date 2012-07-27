class Hash
  def flush!
    contents = self.dup
    self.clear
    contents
  end
end
