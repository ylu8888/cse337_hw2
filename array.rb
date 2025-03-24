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
      (0...self.length).step(sequence) do |i| # use built in step method and iterate 
          result << block.call(self[i]) #execute the block for every i in range of step
      end
    end

    result
  end
  
end

#test cases start here
b = ["cat", "bat", "mat", "sat"]
#test case 1
puts b[-1]  # "sat"
puts b[-5]  # '\0' 
c = [1, 2, 34, 5]
#test case 2
p c.map(1..2) { |i| i.to_f }  #[2.0, 34.0]
#test case 3
p c.map(3..10) { |i| i.to_f }  #[5.0]
#test case 4
p c.map(0) { |i| i.to_f }  #[]
p c.map(-2) { |i| i.to_f }  #[]
#test case 5
b = ["cat", "bat", "mat", "sat"]
p b.map { |x| x.upcase } #["CAT", "BAT", "MAT", "SAT"]
