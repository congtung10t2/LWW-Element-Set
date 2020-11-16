//
//  TestLWWElementSet.swift
//  TestLWWElementSet
//
//  Created by TungImac on 11/15/20.
//

import XCTest

class TestLWWElementSet: XCTestCase {
  let timestamps = (0...2).map {
    return Date(timeIntervalSinceReferenceDate: TimeInterval($0 * 10 * 60))
  }
  func testAdd() {
    let sampleSets = LwwElementSet<String>()
    sampleSets.add("id1", timestamp: timestamps[0])
    sampleSets.add("id1", timestamp: timestamps[1])
    sampleSets.add("id2", timestamp: timestamps[2])
    sampleSets.add("id2", timestamp: timestamps[1])
    XCTAssertTrue(sampleSets.lookup("id1") == timestamps[1])
    XCTAssertTrue(sampleSets.lookup("id2") == timestamps[2])
  }
  
  func testRemove() {
    let sampleSets = LwwElementSet<String>()
    sampleSets.add("id1", timestamp: timestamps[0])
    sampleSets.add("id1", timestamp: timestamps[1])
    sampleSets.remove("id1", timestamp: timestamps[0])
    XCTAssertTrue(sampleSets.lookup("id1") == timestamps[1])
    sampleSets.remove("id1", timestamp: timestamps[2])
    XCTAssertTrue(sampleSets.lookup("id1") == nil)
    sampleSets.remove("id5")
    XCTAssertTrue(sampleSets.removeExist(contain: "id5") == nil)
  }
  
  func testMerge() {
    let sampleSets1 = LwwElementSet<String>()
    sampleSets1.add("id1", timestamp: timestamps[0])
    sampleSets1.add("id2", timestamp: timestamps[0])
    sampleSets1.remove("id3", timestamp: timestamps[1])
    XCTAssertTrue(sampleSets1.lookup("id2") == timestamps[0])
    
    let sampleSets2 = LwwElementSet<String>()
    sampleSets2.add("id3", timestamp: timestamps[2])
    sampleSets2.add("id1", timestamp: timestamps[1])
    sampleSets1.remove("id2", timestamp: timestamps[2])
    sampleSets1.merge(with: sampleSets2)
    XCTAssertTrue(sampleSets1.lookup("id2") == nil)
    XCTAssertTrue(sampleSets1.lookup("id1") == timestamps[1])
    XCTAssertTrue(sampleSets1.lookup("id3") == timestamps[2])
    sampleSets1.remove("id3", timestamp: timestamps[1])
    XCTAssertTrue(sampleSets1.lookup("id3") == timestamps[2])
    sampleSets1.remove("id3", timestamp: timestamps[2])
    XCTAssertTrue(sampleSets1.lookup("id3") == nil)
  }
}
