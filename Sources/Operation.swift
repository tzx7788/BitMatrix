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
                operation.append(.AddRow(row1: row1, row2: row2))
                
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

extension BitMatrix {
    public func subMatrix(row1: Int = 0, col1: Int = 0,
                          row2 tempRow: Int = -1, col2 tempCol: Int = -1) ->BitMatrix! {
        var row2 = tempRow
        var col2 = tempCol
        if tempRow == -1 {
            row2 = self.numberOfRows - 1
        }
        if (col2 == -1 ) {
            col2 = self.numberOfColumns - 1
        }
        guard
            row1 >= 0 && col1 >= 0 &&
                row2 >= row1 && col2 >= col1 &&
                self.numberOfRows > row2 && self.numberOfColumns > col2
            else {
                return nil
        }
        var result = BitMatrix(numberOfRows: row2 - row1 + 1, numberOfColumns: col2 - col1 + 1)
        for row in 0..<row2 - row1 + 1 {
            for col in 0..<col2-col1 + 1 {
                result[row, col] = self[row + row1, col + col1]
            }
        }
        return result
    }
}

infix operator -- { associativity left }
func --<T:Element>(lhs:BitMatrix<T>, rhs:BitMatrix<T>) -> BitMatrix<T> {
    var result = BitMatrix<T>(numberOfRows: lhs.numberOfRows + rhs.numberOfRows, numberOfColumns: lhs.numberOfColumns + rhs.numberOfColumns)
    for row in 0..<lhs.numberOfRows {
        for col in 0..<lhs.numberOfColumns {
            result[row, col] = lhs[row, col]
        }
    }
    for row in 0..<rhs.numberOfRows {
        for col in 0..<rhs.numberOfColumns {
            result[row + lhs.numberOfRows, col + lhs.numberOfColumns] = rhs[row, col]
        }
    }
    return result
}


