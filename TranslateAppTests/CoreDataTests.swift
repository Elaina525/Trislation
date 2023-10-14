import XCTest
import CoreData
@testable import TranslateApp

class CoreDataTests: XCTestCase {
    lazy var persistentContainer: NSPersistentContainer = {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: "Translation")
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        return container
        }()
    
    
        func testCheckDatabase() {
            // Create a test TranslatedText object in the managedObjectContext
            let context = CoreDataTests().persistentContainer.newBackgroundContext()
                expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                    return true
                }
            let translatedText = TranslatedText(context: context)
            translatedText.original_text = "Test Original Text"
            translatedText.target_language = "Test Target Language"

            // Save the object
            do {
                try context.save()
            } catch {
                XCTFail("Failed to save TranslatedText object: \(error)")
            }

            // Create a TranslateResultView instance for testing
            let translateResultView = TranslateResultView(originalText: "Test Original Text")

            // Call checkDatabase function
            let result = translateResultView.checkDatabase()
            
            XCTAssertTrue(result, "checkDatabase should return true for an existing entry")
        }
    // Unit test for updateFavouriteInDatabase function
    func testUpdateFavouriteInDatabase() {
        let context = CoreDataTests().persistentContainer.newBackgroundContext()
            expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
        // Create a test TranslatedText object in the managedObjectContext
        let translatedText = TranslatedText(context: context)
        translatedText.original_text = "Test Original Text"

        // Save the object
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save TranslatedText object: \(error)")
        }

        // Create a TranslateResultView instance for testing
        let translateResultView = TranslateResultView(originalText: "Test Original Text")

        // Set isFavourite to true
        translateResultView.isFavourite = true

        // Call updateFavouriteInDatabase function
        translateResultView.updateFavouriteInDatabase()

        // Fetch the TranslatedText object again
        let fetchRequest: NSFetchRequest<TranslatedText> = TranslatedText.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "original_text == %@", "Test Original Text")

        do {
            let results = try context.fetch(fetchRequest)
            if let existingEntry = results.first {
                XCTAssertTrue(existingEntry.favourite, "Favourite field should be updated to true")
            }
        } catch {
            XCTFail("Failed to fetch TranslatedText object: \(error)")
        }
    }

    // Unit test for saveToDatabase function
    func testSaveToDatabase() {
        let context = CoreDataTests().persistentContainer.newBackgroundContext()
            expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
        // Create a TranslateResultView instance for testing
        let translateResultView = TranslateResultView(originalText: "Test Original Text")

        // Set some values and call saveToDatabase function
        translateResultView.translatedText1 = "Test Translated Text 1"
        translateResultView.translatedText2 = "Test Translated Text 2"
        translateResultView.translatedText3 = "Test Translated Text 3"
        translateResultView.isFavourite = true
        translateResultView.leftLanguage = "English"
        translateResultView.rightLanguage = "Spanish"

        translateResultView.saveToDatabase()

        // Fetch the TranslatedText object from the database
        let fetchRequest: NSFetchRequest<TranslatedText> = TranslatedText.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "original_text == %@", "Test Original Text")

        do {
            let results = try context.fetch(fetchRequest)
            if let savedEntry = results.first {
                XCTAssertEqual(savedEntry.original_text, "Test Original Text")
                XCTAssertEqual(savedEntry.translated_text1, "Test Translated Text 1")
                XCTAssertEqual(savedEntry.translated_text2, "Test Translated Text 2")
                XCTAssertEqual(savedEntry.translated_text3, "Test Translated Text 3")
                XCTAssertTrue(savedEntry.favourite)
                XCTAssertEqual(savedEntry.source_language, "English")
                XCTAssertEqual(savedEntry.target_language, "Spanish")
            } else {
                XCTFail("TranslatedText object not found in the database")
            }
        } catch {
            XCTFail("Failed to fetch TranslatedText object: \(error)")
        }
    }
}
