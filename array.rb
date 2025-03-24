class Array
    #make [] return '\0' if out of bounds
  def [](index)
    super(index) || '\0'  #override ruby built in [] method with super
  end

  def map(sequence = nil, &block)
    #we should check if the argument is actually a step or a range
    
    if sequence.is_a?(Range)
     #if the argument is a range, check if it is out of bounds
      if sequence.first < -self.length || sequence.last >= self.length
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

a = [1,2,34,5]
puts a[1] # 2
puts a[10] # '\0'
p a.map(2..4) { |i| i.to_f} # [34.0, 5.0]
p a.map { |i| i.to_f} # [1.0, 2.0, 34.0, 5.0]
