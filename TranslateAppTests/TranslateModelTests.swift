//
//  BaiduTranslateModelTests.swift
//  TranslateAppTests
//
//  Created by Xiaolong Guo on 14/10/2023.
//
import Foundation
import XCTest
@testable import TranslateApp

final class TranslateModelTests: XCTestCase {

    func testBaiduTranslate() {
        let model = BaiduTranslateModel()
        let expectation = XCTestExpectation(description: "Translation request completed")

        model.baiduTranslate(text: "Hello", from: "English", to: "Chinese") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "你好")
            }
        }
        
        model.baiduTranslate(text: "你好", from: "Auto", to: "English") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "hello")
            }
        }

        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testDeeplTranslate() {
        let model = DeeplTranslateModel()
        let expectation = XCTestExpectation(description: "Translation request completed")

        model.deeplTranslate(text: "Hello", from: "English", to: "Chinese") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "您好")
            }
        }

        model.deeplTranslate(text: "你好", from: "Auto", to: "English") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "How are you?")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGoogelTranslate() {
        let model = GoogleTranslateModel()
        let expectation = XCTestExpectation(description: "Translation request completed")

        model.googleTranslate(text: "Hello", from: "English", to: "Chinese") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "你好")
            }
        }

        model.googleTranslate(text: "你好", from: "Auto", to: "English") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "Hello")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAzureTranslate() {
        let model = AzureTranslateModel()
        let expectation = XCTestExpectation(description: "Translation request completed")

        model.azureTranslate(text: "Hello", from: "English", to: "Chinese") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "你好")
            }
        }

        model.azureTranslate(text: "你好", from: "Auto", to: "English") { translation, error in
            XCTAssertNil(error, "Translation request should not produce an error")
            XCTAssertNotNil(translation, "Translation should not be nil")
            expectation.fulfill()
            if let translation = translation {
                XCTAssertEqual(translation, "Hello")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
