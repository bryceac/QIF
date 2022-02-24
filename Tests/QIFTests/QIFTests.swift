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
    
    func parseQIFString() {
        let samHill = QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hill Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared)

        let fakeStreetElectronics = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Fake Street Electronics", address: "Fake street Electronics", amount: -200, category: "Gifts", memo: "Head set", status: nil)

        let velociraptorEntertainment = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Velociraptor Entertainment", address: "Velociraptor Entertainment", amount: 50000, category: nil, memo: "Pay Day", status: nil)
        
        let type = QIFType.bank
        
        let qif = QIF(type: type, transactions: [
            samHill,
            fakeStreetElectronics,
            velociraptorEntertainment
        ])
        
        let text = """
        !Type:Bank
        D\(Date())
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        
        D\(Date())
        T-200
        PFake Street Electronics
        MHead set
        AFake Street Electronics
        LGifts
        ^
        
        D\(Date())
        T50000
        PVelociraptor Entertainment
        MPay Day
        AVelociraptor Entertainment
        ^
        """
        
        if let parsedQIF = QIF(text) {
            XCTAssertEqual(qif, parsedQIF)
        }
    }
}
