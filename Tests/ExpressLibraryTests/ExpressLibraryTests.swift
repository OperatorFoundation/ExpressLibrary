import XCTest
@testable import ExpressLibrary

final class ExpressLibraryTests: XCTestCase
{
    func testListPorts() throws
    {
        print(SerialController.instance.ports)
    }
}
