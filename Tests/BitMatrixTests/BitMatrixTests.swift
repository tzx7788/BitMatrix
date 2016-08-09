import XCTest
import Foundation
@testable import BitMatrix

struct Byte: Element,CustomStringConvertible {
    var data: Int
    var description: String {
        return String(format: "%02x", self.data)
    }
    static var zero = Byte(0)
    static var one = Byte(1)
    init(_ data: Int) {
        self.data = data
    }
}

func ==(lhs: Byte, rhs: Byte) -> Bool {
    return lhs.data == rhs.data
}

func &(lhs: Byte, rhs: Byte) -> Byte {
    var p = 0, hbs = 0;
    var a = lhs.data;
    var b = rhs.data;
    for _ in 0..<8 {
        if (b & 1 == 1) {
            p ^= a;
        }
        
        hbs = a & 0x80;
        a <<= 1;
        if hbs > 0 {
            a ^= 0x1b;
        } // 0000 0001 0001 1011
        
        b >>= 1;
    }
    return Byte(p & 0xff)
}
func ^(lhs: Byte, rhs: Byte) -> Byte {
    return Byte(lhs.data ^ rhs.data)
}

class BitMatrixTests: XCTestCase {
    func testExample() {
        let m = BitMatrix<Byte>(numberOfRows: 4, numberOfColumns: 4)
        print("\(m)")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testMultiply() {
        var a = BitMatrix<Byte>(numberOfRows: 4, numberOfColumns: 4)
        a[0,0] = Byte(0x02); a[0,1] = Byte(0x03); a[0,2] = Byte(0x01); a[0,3] = Byte(0x01);
        a[1,0] = Byte(0x01); a[1,1] = Byte(0x02); a[1,2] = Byte(0x03); a[1,3] = Byte(0x01);
        a[2,0] = Byte(0x01); a[2,1] = Byte(0x01); a[2,2] = Byte(0x02); a[2,3] = Byte(0x03);
        a[3,0] = Byte(0x03); a[3,1] = Byte(0x01); a[3,2] = Byte(0x01); a[3,3] = Byte(0x02);
        var b = BitMatrix<Byte>(numberOfRows: 4, numberOfColumns: 4)
        b[0,0] = Byte(0x0e); b[0,1] = Byte(0x0b); b[0,2] = Byte(0x0d); b[0,3] = Byte(0x09);
        b[1,0] = Byte(0x09); b[1,1] = Byte(0x0e); b[1,2] = Byte(0x0b); b[1,3] = Byte(0x0d);
        b[2,0] = Byte(0x0d); b[2,1] = Byte(0x09); b[2,2] = Byte(0x0e); b[2,3] = Byte(0x0b);
        b[3,0] = Byte(0x0b); b[3,1] = Byte(0x0d); b[3,2] = Byte(0x09); b[3,3] = Byte(0x0e);
        let p = a * b
        print(a)
        print(b)
        print(p!)
    }
    
    func testInversedMatrixes() {
        let matrixes = BitMatrix<Byte>.generate_inversedMatrixes(size: 20, randTimes: 100)
        let a = matrixes.0
        let b = matrixes.1
        let p = a * b
        print(a)
        print(b)
        print(p!)
    }
    
    func testElements() {
        var a = BitMatrix<Byte>(numberOfRows: 4, numberOfColumns: 4)
        let array = [
            Byte(0x00),Byte(0x04),Byte(0x08),Byte(0x0c),
            Byte(0x01),Byte(0x05),Byte(0x09),Byte(0x0d),
            Byte(0x02),Byte(0x06),Byte(0x0a),Byte(0x0e),
            Byte(0x03),Byte(0x07),Byte(0x0b),Byte(0x0f),
        ]
        a.elements = array
        print(a)
        print(a.elements)
        XCTAssert(a.elements == array)
    }


    static var allTests : [(String, (BitMatrixTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
