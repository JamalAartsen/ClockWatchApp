//
//  GridAlgorithm.swift
//  ClockWatchApp
//
//  Created by Jamal Aartsen on 17/05/2023.
//

import Foundation

class GridAlgorithm {
    
    let clockTimer = ClockTimer()
    var array: [[Int]] = [[]]
    var fixedvalues = [1, 3, 0, 7, 1, 9, 9, 8]
    
    init() {
        array = createArray(fixedValues: fixedvalues)
    }
}

extension GridAlgorithm {
    
    func createArray(fixedValues: [Int]) -> [[Int]] {
        // Initialize a 10x10 array with all elements set to 0
        var arr = Array(repeating: [Int](repeating: 0, count: 10), count: 10)
        var fixedValuesArray = fixedValues
        
        // Loop over each array in the 2D array
        for i in 0 ..< arr.count {
            // Create a set containing all possible values (0 to 9)
            var values = Set(0...9)
            
            // Check if the fixedValuesArray contains less than 10 elements and add randomnumer to it.
            if fixedValuesArray.count < 10 {
                let randomNumber = Int.random(in: 0...9)
                fixedValuesArray.append(randomNumber)
                self.fixedvalues = fixedValuesArray
            }
            
            // If the current array index is less than the number of fixed values,
            // set the fixed value at position 5 in the array and remove it from the set of values
            if i < fixedValuesArray.count {
                let fixedValuesArray = fixedValuesArray[i]
                arr[i][5] = fixedValuesArray
                values.remove(fixedValuesArray)
            }
            
            // Loop over each element in the current array
            for j in 0 ..< arr[i].count {
                // If the element is not at position 5, choose a random value from the set of available values
                if j != 5 {
                    // Called when there are no values
                    guard let randomValue = values.randomElement() else {
                        fatalError("Ran out of available values")
                    }
                    
                    // Set the current element to the randomly chosen value and remove it from the set of available values
                    arr[i][j] = randomValue
                    values.remove(randomValue)
                }
            }
        }
        
        return arr
    }
    
    func printGrid() {
        let fixedValues = [1, 3, 0, 7, 1, 9, 9, 8]
        let randomArray = createArray(fixedValues: fixedValues)
        
        for j in 0..<randomArray[0].count {
            for i in 0..<randomArray.count {
                print(String(format: "%3d", randomArray[i][j]), terminator: " ")
            }
            print()
        }
    }
}
