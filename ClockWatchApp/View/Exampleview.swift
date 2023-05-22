//
//  Exampleview.swift
//  ClockWatchApp
//
//  Created by Jamal Aartsen on 17/05/2023.
//

import SwiftUI

struct Exampleview: View {
    @State private var numbers: [Int] = Array(0...9).shuffled()
    @State private var currentIndex: Int = 0
    @State private var targetIndex: Int = 0
    private let animationDuration: TimeInterval = 0.05
    private let scaleFactor: CGFloat = 1.5

    var body: some View {
        VStack {
            ForEach(numbers.indices, id: \.self) { index in
                Text("\(numbers[index])")
                    .foregroundColor(colorForIndex(index))
                    .scaleEffect(scaleForIndex(index))
                    .animation(.easeInOut(duration: animationDuration))
            }
        }
        .onAppear {
            startAnimationTimer()
        }
    }

    private func startAnimationTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                updateTargetIndex()
                animateNumbers()
            }
        }
    }

    private func updateTargetIndex() {
        targetIndex = Int.random(in: 0..<numbers.count)
    }

    private func animateNumbers() {
        let range = stride(from: currentIndex, through: targetIndex, by: targetIndex > currentIndex ? 1 : -1)
        
        for index in range {
            print("💯 Index: \(index)")
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(abs(index - currentIndex)) * animationDuration) {
                self.currentIndex = index
            }
        }
    }

    private func colorForIndex(_ index: Int) -> Color {
        if index == currentIndex {
            return .blue
        } else {
            return .black
        }
    }
    
    private func scaleForIndex(_ index: Int) -> CGFloat {
           if index == currentIndex {
               return scaleFactor
           } else {
               return 1.0
           }
       }
}


struct Exampleview_Previews: PreviewProvider {
    static var previews: some View {
        Exampleview()
    }
}
