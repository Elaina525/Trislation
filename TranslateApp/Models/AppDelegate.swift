import CoreData
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Translation") // 使用你的 Core Data 模型文件的名字
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // import CoreData when using this
        // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        // UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            if let url = Bundle.main.url(forResource: "Sample", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            {
                let managedContext = persistentContainer.viewContext
                for dict in jsonArray {
                    let entity = NSEntityDescription.entity(forEntityName: "TranslatedText", in: managedContext)!
                    let translatedText = NSManagedObject(entity: entity, insertInto: managedContext)

                    translatedText.setValue(dict["favourite"] as? Bool, forKey: "favourite")
                    translatedText.setValue(Date(), forKey: "date")
                    translatedText.setValue(UUID(), forKey: "id")
                    translatedText.setValue(dict["original_text"] as? String, forKey: "original_text")
                    translatedText.setValue(dict["source1"] as? String, forKey: "source1")
                    translatedText.setValue(dict["source2"] as? String, forKey: "source2")
                    translatedText.setValue(dict["source3"] as? String, forKey: "source3")
                    translatedText.setValue(dict["source_language"] as? String, forKey: "source_language")
                    translatedText.setValue(dict["target_language"] as? String, forKey: "target_language")
                    translatedText.setValue(dict["translated_text1"] as? String, forKey: "translated_text1")
                    translatedText.setValue(dict["translated_text2"] as? String, forKey: "translated_text2")
                    translatedText.setValue(dict["translated_text3"] as? String, forKey: "translated_text3")

                    do {
                        try managedContext.save()
                        print("Data saved successfully!")
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            } else {
                print("Error loading or parsing Sample.json")
            }

            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }

        do {
            let managedContext = persistentContainer.viewContext // 直接使用 self.persistentContainer

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TranslatedText")
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                print(item.value(forKey: "original_text") ?? "No Name")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return true
    }
}
