
public protocol Element:Equatable {
    static var one: Self { get }
    static var zero: Self { get }
    static func &(lhs: Self, rhs: Self) -> Self
    static func ^(lhs: Self, rhs: Self) -> Self
}

public struct BitMatrix<T:Element>: Equatable {
    
    private var data: [[T]]
    public let numberOfRows: Int
    public let numberOfColumns: Int
    
    public init(numberOfRows: Int, numberOfColumns: Int, value: T = T.zero) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.data = Array(repeating: Array(repeating: T.zero, count: numberOfColumns), count: numberOfRows)
    }
    

    public init(unitSquareForSize size: Int) {
        self.init(numberOfRows:size, numberOfColumns: size)
        for row in 0..<size {
            self[row,row] = T.one
        }
    }
    
    public subscript(_ row: Int, _ col: Int) -> T {
        get {
            return self.data[row][col]
        }
        mutating set(newValue) {
            self.data[row][col] = newValue
        }
    }
}

public func ==<T>(lhs: BitMatrix<T>, rhs:BitMatrix<T>) -> Bool {
    guard
        lhs.numberOfColumns == rhs.numberOfColumns &&
        lhs.numberOfRows    == rhs.numberOfRows
        else {
            return false
    }
    for row in 0..<lhs.numberOfRows {
        for col in 0..<rhs.numberOfColumns {
            if lhs[row, col] != rhs[row, col] {
                return false
            }
        }
    }
    return true
}

public func *<T>(lhs: BitMatrix<T>, rhs:BitMatrix<T>) -> BitMatrix<T>! {
    guard
        lhs.numberOfColumns == rhs.numberOfRows else {
            return nil
    }
    var matrix = BitMatrix<T>(numberOfRows: lhs.numberOfRows, numberOfColumns: rhs.numberOfColumns)
    for row in 0..<lhs.numberOfRows {
        for col in 0..<rhs.numberOfColumns {
            for index in 0..<lhs.numberOfColumns {
                matrix[row, col] = matrix[row, col] ^ (lhs[row, index] & rhs[index, col])
            }
        }
    }
    return matrix
}

public func +<T>(lhs: BitMatrix<T>, rhs:BitMatrix<T>) -> BitMatrix<T>! {
    guard
        lhs.numberOfColumns == rhs.numberOfColumns &&
            lhs.numberOfRows    == rhs.numberOfRows
        else {
            return nil
    }
    var matrix = BitMatrix<T>(numberOfRows: lhs.numberOfRows, numberOfColumns: lhs.numberOfColumns)
    for row in 0..<lhs.numberOfRows {
        for col in 0..<lhs.numberOfColumns {
            matrix[row, col] = lhs[row, col] ^ rhs[row, col]
        }
    }
    return matrix
}

extension BitMatrix: CustomStringConvertible {
    public var description: String {
        var result = ""
        for row in 0..<self.numberOfRows {
            for col in 0..<self.numberOfColumns {
                result = result + " \(self[row, col])"
            }
            result = result + "\n"
        }
        return result
    }
}
