import XCTest
@testable import TranslateApp


class SpeechToTextTests: XCTestCase {

    var speechToText: SpeechToText!

    override func setUp() {
        super.setUp()
        speechToText = SpeechToText()
    }

    override func tearDown() {
        speechToText = nil
        super.tearDown()
    }

    func testToggleRecording() {
        // Test that isRecording toggles when the method is called
        XCTAssertFalse(speechToText.isRecording)
        speechToText.toggleRecording(language: "Auto")
        XCTAssertTrue(speechToText.isRecording)
        speechToText.toggleRecording(language: "Auto")
        XCTAssertFalse(speechToText.isRecording)
    }

    func testLanguageChange() {
        // Test changing the speech recognizer language
        speechToText.languageChange(language: "Spanish")
        XCTAssertEqual(speechToText.speechRecognizer?.locale.identifier, "es_ES")
        speechToText.languageChange(language: "Auto")
        XCTAssertEqual(speechToText.speechRecognizer?.locale.identifier, "en_US")
    }

}
