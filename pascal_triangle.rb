def findEncryption(numbers)
  if numbers.length == 1 #if theres only 1 number left then return it
    return numbers[0].to_s
  end

  if numbers.length == 2 #if theres two numbers in the array
    a = numbers[0] % 10 #take the rightmost digit
    b = numbers[1] % 10 
    return a.to_s + b.to_s #add them in string form and return
  end
  
  while numbers.length > 2  #otherwise we keep looping
    temp = [] #temporarily store the next iteration of values

    numbers.each_cons(2) do |a, b| #each_cons generates consecutive pairs from array
      temp << (a + b) % 10 #add the sum and do module 10 to get the last digit
    end

    numbers = temp #set numbers equal to the temp array
  end
  
  return numbers.join #join all elements into string

end

#Test Cases
puts findEncryption([66])
puts findEncryption([8,8,8,8])  
puts findEncryption([5, 0]) 
puts findEncryption([1, 2, 3, 4])
puts findEncryption([8, 1, 4, 8])
