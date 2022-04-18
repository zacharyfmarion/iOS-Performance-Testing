//
//  Performance_Tests.swift
//  Performance Tests
//
//  Created by Zachary Marion on 3/29/22.
//

import XCTest

// BASELINES
let APP_LAUNCH_ITERATION_COUNT = 3
let MAX_APP_LAUNCH_TIME = Float(3000)

class LaunchPerformanceTests: XCTestCase {
  let measureParser = MeasureParser()
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLaunchPerformance() throws {
    self.measureParser.capture { [weak self] in
      guard let self = self else { return }
      self.measureLaunchPerformance()
    }
    
    print(self.measureParser.results)
    let appLaunchTime = self.measureParser.getResult("Duration (AppLaunch)")
    XCTAssert(appLaunchTime != nil, "App launch time statistic not available")
    XCTAssert(appLaunchTime! < MAX_APP_LAUNCH_TIME, "App launch time took too long")
  }
  
  private func measureLaunchPerformance() {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      let measureOptions = XCTMeasureOptions.default
      measureOptions.iterationCount = APP_LAUNCH_ITERATION_COUNT
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()], options: measureOptions) {
        XCUIApplication().launch()
      }
    }
  }
}
