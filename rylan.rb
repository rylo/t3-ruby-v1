class Test
  def initialize
    foo = Hash.new { |hash, key| hash[key] = Hash.new }
    foo["a"][1] = "one"
    foo["a"][2] = "a two"
    foo["b"][3] = "b three"
    foo["a"][4] = "b four"
    foo["a"].each {|k,v| p "#{k}  #{v}"}
    p 'Here\'s the test hash: '
    p foo
    p foo['a']
  end
end