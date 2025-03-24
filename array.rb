class Array
    #make [] return '\0' if out of bounds
  def [](index)
    self.fetch(index, '\0') #override ruby built in [] method with super
  end

  def map(sequence = nil, &block)
    #we should check if the argument is actually a step or a range
    
    if sequence.is_a?(Range)
     #if the argument is a range, check if it is out of bounds
      if sequence.first < -self.length #account for negative indices
        return []  #if so, then return an empty array
      end
    end
    
    #if we have a step, check if it is out of bounds and return []
    if sequence.is_a?(Integer) && (sequence <= 0 || sequence >= self.length)
      return []  
    end
    
    #if we are not given a step argument, just return normal map function
    if sequence.nil?
        return super(&block)  
    end
    
    result = []
    
    #if we are dealing with a range argument
    if sequence.is_a?(Range)
      sequence.each do |i|
        if i < 0 #this handles the negative indices
            i = self.length + i
        end
        
        if i.between?(0, self.length - 1) #if i is in bounds 
            result << block.call(self[i]) 
        end
      end
      
    #if we are dealing with a step argument
    elsif sequence.is_a?(Integer) && sequence > 0 #if the step is 0 or negative, it is not valid
      (0...self.length).step(sequence) do |i|
          result << block.call(self[i])
      end
    end

    result
  end
  
end

# a = [1,2,34,5]
# puts a[1] # 2
# puts a[10] # '\0'
# p a.map(2..4) { |i| i.to_f} # [34.0, 5.0]
# p a.map { |i| i.to_f} # [1.0, 2.0, 34.0, 5.0]
# b = ["cat", "bat", "mat", "sat"]
# puts b[-1] # "sat"
# puts b[5] # '\0'
# p b.map(2..10) { |x| x[0].upcase + x[1,x.length] } # ["Mat", "Sat"]
# p b.map(2..4) { |x| x[0].upcase + x[1,x.length] } # ["Mat", "Sat"]
# p b.map(-3..-1) { |x| x[0].upcase + x[1,x.length] } # ["Bat", "Mat",“Sat”]
# p b.map { |x| x[0].upcase + x[1,x.length] } # ["Cat", "Bat", "Mat","Sat"]

#test cases start here
b = ["cat", "bat", "mat", "sat"]
#test case 1
puts b[-1]  # "sat"
#test case 2
puts b[-5]  # '\0' 
c = [1, 2, 34, 5]
#test case 3
p c.map(1..2) { |i| i.to_f }  #[2.0, 34.0]
#test case 4
p c.map(3..10) { |i| i.to_f }  #[5.0]
#test case 5
p c.map(0) { |i| i.to_f }  #[]
#test case 6
p c.map(-2) { |i| i.to_f }  #[]
