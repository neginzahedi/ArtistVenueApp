//
//  ArtistVenueAppTests.swift
//  ArtistVenueAppTests
//
//  Created by Negin Zahedi on 2023-10-12.
//

import XCTest
@testable import ArtistVenueApp

final class ArtistVenueAppTests: XCTestCase {
    
    // MARK: - Testing Async Methods
    
    func testFetchArtists() async {
        // Given
        let dataManager = DataManager.shared
        // When
        let result = try? await dataManager.fetchArtists()
        // Then
        XCTAssertNotNil(result)
        XCTAssert(result!.capacity > 0)
    }
    
    func testFetchArtistPerformances() async{
        // Given
        let dataManager = DataManager.shared
        // When
        let result = try? await dataManager.fetchArtistPerformances(artistID: 4)
        // Then
        XCTAssertNotNil(result)
        XCTAssert(result!.capacity >= 0)
    }
    
    func testFetchImage() async{
        // Given
        let dataManager = DataManager.shared
        let invalidURL = URL(string: "\(dataManager.BASE_IMG_URL)/v/The+Dive.png")
        let validURL = URL(string: "\(dataManager.BASE_IMG_URL)/venues/The+Dive.png")
        // When
        let resultInvalid = try? await dataManager.fetchImage(url: invalidURL!)
        let resultValid = try? await dataManager.fetchImage(url: validURL!)
        // Then
        XCTAssertNil(resultInvalid)
        XCTAssertNotNil(resultValid)
    }
    
    // MARK: - Testing Helper Methods
    
    func testTwoWeekRange() {
        // Given
        let customDate = "2023-10-01"
        let expectedOutput = "from=2023-10-01&to=2023-10-14"
        // When
        // Converting the 'customDate' to Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: customDate)!
        // Getting the result of the twoWeekRange function
        let result = DataManager.twoWeekRange(from: date)
        // Then
        XCTAssertEqual(result, expectedOutput, "Date conversion result does not match expected date")
    }
    
    func testFormatTimeString(){
        // Given
        let expectedOutput = "6:00 PM"
        // When
        let result = try? DataManager.formatTimeString("2026-08-02T18:00:00")
        // Then
        XCTAssertEqual(result, expectedOutput, "Time hr is not formatted properly")
    }
    
    func testFormatDateString(){
        // Given
        let expectedOutput = "Aug 2, 2026"
        // When
        let result = try? DataManager.formatDateString("2026-08-02T18:00:00")
        // Then
        XCTAssertEqual(result, expectedOutput, "Date is not formatted properly")
    }
    
    func testGetImageURL(){
        // Given
        let dataManager = DataManager.shared
        // When
        let result = try? dataManager.getImageURL(name: "The Dive", type: "venues")
        // Then
        XCTAssertEqual(result, URL(string:"\(dataManager.BASE_IMG_URL)/venues/The+Dive.png"))
    }
}
