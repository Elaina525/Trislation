import CryptoKit
import SwiftUI

    func baiduTranslate(text: String, from: String, to: String, completion: @escaping (String?, Error?) -> Void) {
        let appid = "20200426000430988"
        let secretKey = "s4MllyEWiYSeCyffV9Ab"
        let salt = String(arc4random_uniform(65536))

        let sign = appid + text + salt + secretKey
        let md5Sign = MD5(string: sign) // 确保你有一个适当的MD5函数

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
        request.httpBody = requestBody.percentEncoded() // 确保你有一个适当的百分比编码函数

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(BaiduTranslation.self, from: data) // 确保你有一个适当的BaiduTranslation结构体
                DispatchQueue.main.async {
                    let baiduTranslatedText = decodedData.trans_result.first?.dst ?? ""
                    completion(baiduTranslatedText, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }


extension Dictionary {
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

fileprivate func convertToShortLanguage(_ fullLanguage: String) -> String {
    let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
    let shortLanguages = ["en", "spa", "fra", "de", "zh", "jp", "ru", "ara"]

    if fullLanguage == "Auto" {
        return "auto"
    }
    let index = languages.firstIndex(of: fullLanguage) ?? 0
    return shortLanguages[index]
}


struct BaiduTranslation: Codable {
    let from: String
    let to: String
    let trans_result: [TransResult]
}

struct TransResult: Codable {
    let src: String
    let dst: String
}

