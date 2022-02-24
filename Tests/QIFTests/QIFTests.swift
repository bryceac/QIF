import XCTest
@testable import QIF

final class QIFTests: XCTestCase {
    func parseTransaction() {
        let transactionText = """
        D\(Date())
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        let samHill = QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hill Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared)
        
        if let parsedTransaction = QIFTransaction(transactionText) {
            XCTAssertEqual(parsedTransaction, samHill)
        }
    }
    
    func parseType() {
        let typeText = "!Type:Bank"
        
        let bank = QIFType.bank
        
        if let type = QIFType(typeText) {
            XCTAssertEqual(type, bank)
        }
    }
}
