import XCTest
@testable import QIF

final class QIFTests: XCTestCase {
    func parseTransaction() throws {
        let transactionText = """
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
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
        
        let parsedTransaction = try QIFTransaction(transactionText)
            
        XCTAssertEqual(parsedTransaction, samHill)
    }
    
    func parseTransactionWithExplicitSplit() throws {
        let transactionText = """
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        SOpening Balance
        EBonus for new Account
        $50
        ^
        """
        
        let samHill = QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hill Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared, splits: [
            QIFSplit(category: "Opening Balance", memo: "Bonus for new Account", amount: 50)
        ])
        
        let parsedTransaction = try QIFTransaction(transactionText)
            
        XCTAssertEqual(parsedTransaction, samHill)
    }
    
    func transactionParsingFailsDueToMissingDate() {
        let transactionText = """
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFTransaction(transactionText))
    }
    
    func transactionParsingFailsDueToWrongDateFormat() {
        let testString = """
        D03/04/20
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFTransaction(testString))
    }
    
    func transactionParsingFailsWhenAmountIsMissing() {
        let transactionText = """
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFTransaction(transactionText))
    }
    
    func transactionParsingFailsWhenAmountIsNotNumerical() {
        let transactionText = """
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFTransaction(transactionText))
    }
    
    func parseQIFSection() throws {
        let sampleSectionText = """
        !Type:Bank
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        let expectedSection = QIFSection(type: .bank, transactions: Set([
            QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hil Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared)
        ]))
        
        let qifSection = try QIFSection(sampleSectionText)
        
        XCTAssertEqual(qifSection, expectedSection)
    }
    
    func parseQIFSectionWithWhitespace() throws {
        let sampleSectionText = """
        
        !Type:Bank
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertNoThrow(try QIFSection(sampleSectionText))
    }
    
    func parsingQIFSectionFailsWhenTypeIsMissing() {
        let sampleSectionText = """
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFSection(sampleSectionText))
    }
    
    func parsingQIFSectionFailsWithoutProperFormatting() {
        let sampleSectionText = """
        Bank
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFSection(sampleSectionText))
    }
    
    func parsingQIFSectionFailsWhenTypeIsInvalid() {
        let sampleSectionText = """
        !Type:hero
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        """
        
        XCTAssertThrowsError(try QIFSection(sampleSectionText))
    }
    
    func parseQIFString() throws {
        let samHill = QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hill Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared)

        let fakeStreetElectronics = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Fake Street Electronics", address: "Fake street Electronics", amount: -200, category: "Gifts", memo: "Head set", status: nil)

        let velociraptorEntertainment = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Velociraptor Entertainment", address: "Velociraptor Entertainment", amount: 50000, category: nil, memo: "Pay Day", status: nil)
        
        let qif = QIF(sections: [
            "Bank": QIFSection(type: .bank, transactions: Set([
                samHill,
                fakeStreetElectronics,
                velociraptorEntertainment
            ]))
        ])
        
        let text = """
        !Type:Bank
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T500
        CX
        N1260
        PSam Hill Credit Union
        MOpen Account
        ASam Hill Credit Union
        LOpening Balance
        ^
        
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T-200
        PFake Street Electronics
        MHead set
        AFake Street Electronics
        LGifts
        ^
        
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: Date()))
        T50000
        PVelociraptor Entertainment
        MPay Day
        AVelociraptor Entertainment
        ^
        """
        
        let parsedQIF = try QIF(text)
        
        XCTAssertEqual(qif, parsedQIF)
    }
    
    func writeQIF() {
        let samHill = QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hill Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared)

        let fakeStreetElectronics = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Fake Street Electronics", address: "Fake street Electronics", amount: -200, category: "Gifts", memo: "Head set", status: nil)

        let velociraptorEntertainment = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Velociraptor Entertainment", address: "Velociraptor Entertainment", amount: 50000, category: nil, memo: "Pay Day", status: nil)
        
        let qif = QIF(sections: [
            "Bank": QIFSection(type: .bank, transactions: Set([
                samHill,
                fakeStreetElectronics,
                velociraptorEntertainment
            ]))
        ])
        
        let DOCUMENTS_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let testFile = DOCUMENTS_DIRECTORY.appendingPathComponent("test").appendingPathExtension("qif")
        
        XCTAssertNoThrow(try qif.save(to: testFile))
    }
    
    func readFile() throws {
        let samHill = QIFTransaction(date: Date(), checkNumber: 1260, vendor: "Sam Hill Credit Union", address: "Sam Hill Credit Union", amount: 500, category: "Opening Balance", memo: "Open Account", status: .cleared)

        let fakeStreetElectronics = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Fake Street Electronics", address: "Fake street Electronics", amount: -200, category: "Gifts", memo: "Head set", status: nil)

        let velociraptorEntertainment = QIFTransaction(date: Date(), checkNumber: nil, vendor: "Velociraptor Entertainment", address: "Velociraptor Entertainment", amount: 50000, category: nil, memo: "Pay Day", status: nil)
        
        let qif = QIF(sections: [
            "Bank": QIFSection(type: .bank, transactions: Set([
                samHill,
                fakeStreetElectronics,
                velociraptorEntertainment
            ]))
        ])
        
        let DOCUMENTS_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let testFile = DOCUMENTS_DIRECTORY.appendingPathComponent("test").appendingPathExtension("qif")
        
        let parsedQIF = try QIF.load(from: testFile)
        
        XCTAssertEqual(parsedQIF, qif)
    }
}
