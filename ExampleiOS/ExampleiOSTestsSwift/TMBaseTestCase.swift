//
//  File.swift
//  
//
//  Created by Adriana Elizondo on 01/04/24.
//

import Foundation
import XCTest

class TMBaseTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        createTempDirectory()
    }
    
    override func tearDown() {
        removeAllItemsInsideTempDirectory()
        super.tearDown()
    }
    
    // MARK: - Temp directory utils
    func tempTestDirectory() -> URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent("com.tumblr.sdk")
    }
    
    func tempFileURL() -> URL {
        return tempTestDirectory().appendingPathComponent(UUID().uuidString)
    }
    
    @discardableResult
    func removeAllItemsInsideTempDirectory() -> Bool {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: tempTestDirectory().path)
        var result = true
        
        while let fileName = enumerator?.nextObject() as? String {
            let fileURL = tempTestDirectory().appendingPathComponent(fileName)
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    @discardableResult
    func createTempDirectory() -> Bool {
        do {
            try FileManager.default.createDirectory(at: tempTestDirectory(), withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
}
