//
//  Operation.swift
//  BitMatrix
//
//  Created by Tang Zhixiong on 08/08/2016.
//
//

import Foundation

extension BitMatrix {
    
    static public func generate_inversedMatrixes(size:Int ,randTimes: Int = 100) -> (BitMatrix<T>, BitMatrix<T>) {
        var a = BitMatrix(unitSquareForSize: size)
        var b = BitMatrix(unitSquareForSize: size)
        var operation = [Operation]()
        for _ in 0..<randTimes {
            let row1 = Int(arc4random()) % size
            var row2 = Int(arc4random()) % size
            if row1 == row2  {
                row2 = ( row2 + 1 ) % size
            }
            if Int(arc4random()) % 2 == 0 {
                operation.append(.SwitchRow(row1: row1, row2: row2))
            } else {
                operation.append(.SwitchRow(row1: row1, row2: row2))
                
            }
        }
        for index in 0..<randTimes {
            a.perform(operation: operation[index])
            b.perform(operation: operation[randTimes - 1 - index])
        }
        return (a,b)
    }
    
    private mutating func perform(operation: Operation) {
        switch operation {
        case .SwitchRow(let row1, let row2):
            for col in 0..<self.numberOfRows {
                let temp = self[row1, col]
                self[row1, col] = self[row2, col]
                self[row2, col] = temp
            }
        case .AddRow(let row1, let row2):
            for col in 0..<self.numberOfRows {
                self[row1, col] = self[row1, col] ^ self[row2, col];
            }
        }
    }
    
}


private enum Operation {
    case SwitchRow(row1: Int, row2: Int)
    case AddRow(row1: Int, row2: Int)
}

