import XCTest
import Foundation
@testable import Sunrisers

final class SunrisersUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    var nextSevenDays: [Date] {
        var days = [Date]()
        var date = Date()
        
        for _ in 0...6 {
            date.addTimeInterval(3600*24)
            days.append(date)
        }
        
        return days
    }

    @MainActor
    func testListOfDates_whenRefreshed_isPopulated() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["mocked-services"]
        app.launch()

        app.buttons["arrow.clockwise.square.fill"].tap()
        debugPrint(app.buttons)
        
        let expectedLabels =
        nextSevenDays.map { date in
            "\(date.formatted(date: .numeric, time: .omitted)), 06:15"
        }
        
        expectedLabels.forEach { label in
            XCTAssertTrue(app.buttons[label].waitForExistence(timeout: 1))
        }
    }
}


