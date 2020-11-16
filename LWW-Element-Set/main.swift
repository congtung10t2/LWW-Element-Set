//
//  main.swift
//  LWW-Element-Set
//
//  Created by TungImac on 11/15/20.
//

import Foundation
public class LwwElementSet<T: Hashable> {
  private var addSet = [T: Date]()
  private var removeSet = [T: Date]()
  
  func add(_ item: T, timestamp: Date = Date()) {
    if let previousAddTime = lookup(item), previousAddTime >= timestamp {
        return
    }
    addSet[item] = timestamp
  }
  
  func remove(_ item: T, timestamp: Date = Date()) {
      guard lookup(item) != nil else {
          return
      }
      removeSet[item] = timestamp
  }
  
  func merge(with sets: LwwElementSet<T>){
    addSet.merge(sets.addSet) { max($0, $1) }
    removeSet.merge(sets.removeSet) { max($0, $1) }
  }
  
  func lookup(_ item: T) -> Date? {
    guard let createAt = addSet[item] else {
      return nil
    }
    guard let removeAt = removeSet[item] else {
      return createAt
    }
    return createAt > removeAt ? createAt : nil
  }
}

//For testing remove
extension LwwElementSet {
  func removeExist(contain: T) -> Date? {
    return removeSet[contain]
  }
}
