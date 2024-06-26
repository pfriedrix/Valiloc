//
//  LocationTest.swift
//
//
//  Created by Pfriedrix on 21.03.2024.
//

import XCTest
@testable import Valiloc

final class LocationTest: XCTestCase {
    
    var locationMeasurer: LocationMeasurer<LocationFilter>!
    var mockLocations: [Location] = []
    
    override func setUp() {
        super.setUp()
        mockLocations = (try? Location.loadMocks()) ?? []
        
        let locationFilter = LocationFilter()
        locationMeasurer = LocationMeasurer(filter: locationFilter)
    }
    
    override func tearDown() {
        locationMeasurer = nil
        mockLocations = []
        super.tearDown()
    }
    
    func testForEachLocationValidator() {
        let validator = ForEachValidator(mockLocations, id: \.timestamp) { location in
            LocationValidator(location: location)
        }
        
        XCTAssertFalse(validator.validate() == .valid, "Not all locations passed the validation.")
        
        let filtered = LocationFilter().filter(of: mockLocations)
        
        let filteredValidator = ForEachValidator(filtered, id: \.timestamp) { location in
            LocationValidator(location: location)
        }
        
        XCTAssertTrue(filteredValidator.validate() == .valid, "Not all locations passed the validation.")
    }
    
    func testlocationBuildValidator() throws {
        let locations = try Location.loadMocks()
        XCTAssertFalse(locations.isEmpty)
        
        let result = locations.compactMap {
            let result = LocationValidator(location: $0).validate()
            return result == .valid ? nil : $0
        }
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testDistanceCalculation() {
        let result = locationMeasurer.distance(of: mockLocations)
        let expectedDistance = Measurement<UnitLength>(value: 783.27, unit: .meters)
        
        XCTAssertEqual(result.value, expectedDistance.value, accuracy: 0.01, "The calculated distance does not match the expected value.")
    }
    
    func testAverageSpeedCalculation() {
        let result = locationMeasurer.averageSpeed(of: mockLocations, for: .kilometersPerHour)
        let expectedSpeed = Measurement<UnitSpeed>(value: 5.22, unit: .kilometersPerHour)
        
        XCTAssertEqual(result.value, expectedSpeed.value, accuracy: 0.01, "The calculated average speed does not match the expected value.")
    }
    
    func testAltitudeGainCalculation() {
        let result = locationMeasurer.altitudeGain(of: mockLocations)
        let expectedGain = Measurement<UnitLength>(value: 4.11, unit: .meters)
        
        XCTAssertEqual(result.value, expectedGain.value, accuracy: 0.01, "The calculated altitude gain does not match the expected value.")
    }
}
