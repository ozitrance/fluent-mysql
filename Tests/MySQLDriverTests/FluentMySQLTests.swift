import XCTest
@testable import MySQLDriver
import FluentTester

class FluentMySQLTests: XCTestCase {
    func testAll() throws {
        let driver = MySQLDriver.Driver.makeTest()
        let database = Database(driver)
        let tester = Tester(database: database)

        do {
            try tester.testAll()
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testForeignKey() throws {
        let driver = MySQLDriver.Driver.makeTest()
        let database = Database(driver)
        
        defer {
            try! database.delete(Atom.self)
            try! database.delete(Compound.self)
        }
        
        try database.create(Compound.self) { compounds in
            compounds.id(for: Compound.self)
            compounds.string("foo")
            compounds.index("foo")
        }
        
        try database.create(Atom.self) { atoms in
            atoms.id(for: Atom.self)
            atoms.string("name")
            atoms.index("name")
            atoms.foreignKey("name", references: "foo", on: Compound.self)
        }
    }

    static let allTests = [
        ("testAll", testAll),
        ("testForeignKey", testForeignKey)
    ]
}
