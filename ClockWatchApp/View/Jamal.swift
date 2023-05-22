import SwiftUI

struct Jamal: View {
    private let grid = GridAlgorithm()
    
    @State private var currentColumnIndices: [Int] = []
    @State private var targetColumnIndices: [Int] = []
    private let animationDuration: TimeInterval = 0.1
    private let scaleFactor: CGFloat = 1.2
    
    @ObservedObject var clockTimer = ClockTimer()
        
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                ForEach(grid.array[0].indices, id: \.self) { columnIndex in
                    HStack {
                        ForEach(grid.array.indices, id: \.self) { rowIndex in
                            
                            
                            let _ = updateTargetColumnIndices()
                            let _ = animateNumbers()
                            
                            Text("\(grid.array[rowIndex][columnIndex])")
                                .frame(width: 20, height: 20)
                                .padding(5)
                                .foregroundColor(colorForIndex(rowIndex: rowIndex, columnIndex: columnIndex))
                                .scaleEffect(scaleForIndex(rowIndex: rowIndex, columnIndex: columnIndex))
                                .background(
                                    backgroundColorForIndex(rowIndex: rowIndex, columnIndex: columnIndex)
                                )
                                .cornerRadius(10)
                                .animation(.spring(dampingFraction: 1))
    
                        }
                    }
                }
            }
            .onAppear {
                initializeIndices()
            }
        }
    }
    
    private func initializeIndices() {
        currentColumnIndices = Array(repeating: 0, count: grid.array.count)
        targetColumnIndices = Array(repeating: 0, count: grid.array.count)
    }
    
    private func updateTargetColumnIndices() {
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
        
    private func animateNumbers() {
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
    
    private func scaleForIndex(rowIndex: Int, columnIndex: Int) -> CGFloat {
        guard rowIndex < currentColumnIndices.count else { return 1.0 }
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return 1
        } else {
            return 0.8
        }
    }
    
    private func colorForIndex(rowIndex: Int, columnIndex: Int) -> Color {
        guard rowIndex < currentColumnIndices.count else { return .gray }
        let isBirthdayNumber = isBirthdayNumber(row: rowIndex, column: columnIndex)
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return .white
        } else if isBirthdayNumber {
            return .blue
        } else {
            return .gray
        }
    }
    
    private func backgroundColorForIndex(rowIndex: Int, columnIndex: Int) -> Color {
        guard rowIndex < currentColumnIndices.count else { return .gray }
        
        let currentColumnIndex = currentColumnIndices[rowIndex]
        
        if columnIndex == currentColumnIndex {
            return .white
                .opacity(0.1)
        } else {
            return .clear
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
}

struct Jamal_Previews: PreviewProvider {
    static var previews: some View {
        Jamal()
    }
}
