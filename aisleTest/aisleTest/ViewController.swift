//
//  ViewController.swift
//  aisleTest
//
//  Created by Angus Yi on 2021/9/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        postData()
    }

    private func postData() {
        let url = URL(string: "https://apistage2.aisleconnect.us/ac.server/oauth/token")
        let parameter = ["grant_type": "password",
                         "username": "paul.lin@lineagenetworks.com",
                         "password": "welcome1",
                         "client_id": "my-client",
                         "client_secret": "my-secret",
                         "scope": "read"]
//        // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = "userId=300&title=My urgent task&completed=false";
//        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = parameter.percentEncoded()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            print(httpResponse.statusCode)
            if httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } else {
                print("login fail")
            }
        }
        
        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

