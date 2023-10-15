import CryptoKit
import SwiftUI

/// An observable object for translating text using the Baidu Translation API.
class BaiduTranslateModel: ObservableObject {
    
    // Translate text from one language to another using the Baidu API
    /// Translate text from one language to another using the Baidu API.
    ///
    /// - Parameters:
    ///   - text: The text to be translated.
    ///   - from: The source language.
    ///   - to: The target language.
    ///   - completion: A closure to handle the translation result or error.
    func baiduTranslate(text: String, from: String, to: String, completion: @escaping (String?, Error?) -> Void) {
        let appid = "20200426000430988"
        let secretKey = "s4MllyEWiYSeCyffV9Ab"
        let salt = String(arc4random_uniform(65536))

        let sign = appid + text + salt + secretKey
        let md5Sign = MD5(string: sign) // Make sure you have an appropriate MD5 function

        let urlString = "https://fanyi-api.baidu.com/api/trans/vip/translate?"

        guard let url = URL(string: urlString) else { return }

        let requestBody: [String: Any] = [
            "appid": appid,
            "q": text,
            "from": convertToShortLanguage(from),
            "to": convertToShortLanguage(to),
            "salt": salt,
            "sign": md5Sign,
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBody.percentEncoded() // Make sure you have an appropriate percent encoding function

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(BaiduTranslation.self, from: data) // Make sure you have an appropriate BaiduTranslation struct
                DispatchQueue.main.async {
                    let baiduTranslatedText = decodedData.trans_result.first?.dst ?? ""
                    completion(baiduTranslatedText, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

    // Calculate the MD5 hash of a given string
    /// Calculate the MD5 hash of a given string.
    ///
    /// - Parameter string: The input string.
    /// - Returns: The MD5 hash of the input string.
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    // Convert the full language name to its short form
    /// Convert the full language name to its short form.
    ///
    /// - Parameter fullLanguage: The full name of the language.
    /// - Returns: The short form of the language.
    fileprivate func convertToShortLanguage(_ fullLanguage: String) -> String {
        let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
        let shortLanguages = ["en", "spa", "fra", "de", "zh", "jp", "ru", "ara"]

        if fullLanguage == "Auto" {
            return "auto"
        }
        let index = languages.firstIndex(of: fullLanguage) ?? 0
        return shortLanguages[index]
    }
}

// Extension to convert a dictionary to percent-encoded data
/// An extension to convert a dictionary to percent-encoded data.

extension Dictionary {
    /// Convert a dictionary to percent-encoded data.
    ///
    /// - Returns: The percent-encoded data.
    func percentEncoded() -> Data? {
        return map { key, value in
            let escape = CharacterSet.urlQueryAllowed
            let keyString = "\(key)".addingPercentEncoding(withAllowedCharacters: escape) ?? ""
            let valueString = "\(value)".addingPercentEncoding(withAllowedCharacters: escape) ?? ""
            return "\(keyString)=\(valueString)"
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

// Struct to represent the response from Baidu Translation API
/// A struct to represent the response from the Baidu Translation API.

struct BaiduTranslation: Codable {
    let from: String
    let to: String
    let trans_result: [TransResult]
}

// Struct to represent translation result
/// A struct to represent translation result.
struct TransResult: Codable {
    let src: String
    let dst: String
}
