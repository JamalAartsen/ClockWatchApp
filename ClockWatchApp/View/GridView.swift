//
//  GridView.swift
//  ClockWatchApp
//
//  Created by Jamal Aartsen on 17/05/2023.
//

import SwiftUI

struct GridView: View {
    
    // MARK: - PROPERTIES
    @ObservedObject var clockTimer = ClockTimer()
    @State private var currentColumnIndices: [Int] = []
    @State private var targetColumnIndices: [Int] = []
    
    private let grid = GridAlgorithm()
    private let animationDuration: TimeInterval = 0.1

    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                ForEach(0..<grid.array[0].count) { column in
                    // HStack places content horizontally
                    HStack {
                        // Iterate over each row index
                        ForEach(0..<grid.array.count) { row in
                            // Retrieve the number from the gridArray at the current row and column
                            let number = grid.array[row][column]
                            
                            let _ = updateTargetColumnIndices()
                            let _ = animateNumbers()
                            
                            Text("\(number)")
                                .frame(width: 20, height: 20)
                                .padding(5)
                                .foregroundColor(colorForIndex(rowIndex: row, columnIndex: column))
                                .opacity(opacityForIndex(rowIndex: row, columnIndex: column))
                                .font(.system(size: 16))
                                .scaleEffect(scaleForIndex(rowIndex: row, columnIndex: column))
                                .background(
                                    backgroundColorForIndex(rowIndex: row, columnIndex: column)
                                )
                                .cornerRadius(10)
                                .animation(.spring(dampingFraction: 1), value: UUID())

                        } //: LOOP
                    } //: HSTACK
                } //: LOOP
            } //: VSTACK
            .onAppear {
                initializeIndices()
            }
        } //: ZSTACK
    }
}

// MARK: - FUNCTIONS
private extension GridView {
    
    func initializeIndices() {
        currentColumnIndices = Array(repeating: 0, count: grid.array.count)
        targetColumnIndices = Array(repeating: 0, count: grid.array.count)
    }
    
    func updateTargetColumnIndices() {
        for rowIndex in grid.array.indices {
            guard let currentTime = clockTimer.currentTime?[rowIndex] else {
                return
            }
            
            for (index, value) in grid.array[rowIndex].enumerated() {
                if value == currentTime {
                    DispatchQueue.main.async {
                        targetColumnIndices[rowIndex] = index
                    }
                }
            }
        }
    }
    
    func isBirthdayNumber(row: Int, column: Int) -> Bool {
        let fixedValues = grid.fixedvalues
        let fixedValuesWithoutLastTwo = fixedValues.dropLast(2)
        
        if row < fixedValuesWithoutLastTwo.count {
            return grid.array[row][column] == fixedValuesWithoutLastTwo[row]
        } else {
            return false
        }
    }
    
    func animateNumbers() {
        for rowIndex in grid.array.indices {
            guard rowIndex < currentColumnIndices.count else { return }
            
            let currentColumnIndex = currentColumnIndices[rowIndex]
            let targetColumnIndex = targetColumnIndices[rowIndex]
            
            let range = stride(from: currentColumnIndex, through: targetColumnIndex, by: targetColumnIndex > currentColumnIndex ? 1 : -1)
            
            for index in range {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(abs(index - currentColumnIndex)) * animationDuration) {
                    self.currentColumnIndices[rowIndex] = index
                }
            }
        }
    }
    
    func scaleForIndex(rowIndex: Int, columnIndex: Int) -> CGFloat {
        guard rowIndex < currentColumnIndices.count else { return 1.0 }
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return 1.1
        } else {
            return 0.8
        }
    }
    
    func colorForIndex(rowIndex: Int, columnIndex: Int) -> Color {
        guard rowIndex < currentColumnIndices.count else { return .gray }
        let isBirthdayNumber = isBirthdayNumber(row: rowIndex, column: columnIndex)
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return .white
        } else if isBirthdayNumber {
            return .blue
        }
        
        return .white
    }
    
    func opacityForIndex(rowIndex: Int, columnIndex: Int) -> CGFloat {
        guard rowIndex < currentColumnIndices.count else { return 0.3 }
        let isBirthdayNumber = isBirthdayNumber(row: rowIndex, column: columnIndex)
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return 1.0
        } else if isBirthdayNumber {
            return 0.8
        }
        
        return 0.4
    }
    
    func backgroundColorForIndex(rowIndex: Int, columnIndex: Int) -> Color {
        guard rowIndex < currentColumnIndices.count else { return .gray }
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return .white
                .opacity(0.1)
        } else {
            return .clear
        }
    }
}

// MARK: - PREVIEW
struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}


