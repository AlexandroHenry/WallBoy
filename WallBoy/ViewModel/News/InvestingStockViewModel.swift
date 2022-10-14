//
//  InvestingStockViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

// MARK: Investing.com rss
// reference address : https://www.investing.com/webmaster-tools/rss

import Foundation
import NaturalLanguage

struct InvestingStockItem: Hashable {
    var title: String
    var link : String
    var pubDate: String
    var source: String
    var media: String

    init(details: [String: Any]) {
        title = details["title"] as? String ?? ""
        link = details["link"] as? String ?? ""
        pubDate = details["pubDate"] as? String ?? ""
        source = details["source"] as? String ?? ""
        media = details["media"] as? String ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6wHc3OzKebPw9iQ9NMcjKRHSxIFKN2Ds2LQ&usqp=CAU"
    }
}

class InvestingStockViewModel: NSObject, ObservableObject {

    @Published var items = [InvestingStockItem]()
    
    var xmlParser = XMLParser()
    
    var currentElement = ""
    var newsItems = [[String: String]]()
    var newsItem = [String: String]()
    
    var title = ""
    var link = ""
    var pubDate = ""
    var source = ""
    var media = ""
    
    var tempMedia = ""

    func loadData() {
        let urlString = "https://www.investing.com/rss/news_25.rss"
//        let urlString = URL(string: "https://www.investing.com/rss/news_285.rss")!
//        let urlString = URL(string: "https://www.investing.com/rss/news.rss")!
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("dataTaskWithRequest Error: \(error)")
                return
            }

            guard let data = data else {
                print("dataTaskWithRequest data is nil")
                return
            }
            
            guard let xmlParser = XMLParser(contentsOf: url) else { return }
            xmlParser.delegate = self;
            xmlParser.parse()
        }
        task.resume()

    }
}

extension InvestingStockViewModel: XMLParserDelegate {
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            newsItem = [String : String]()
            title = ""
            link = ""
            pubDate = ""
            source = ""
        }
        
        if elementName == "enclosure" {
            self.tempMedia = attributeDict["url"]!
        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            newsItem["title"] = title;
            newsItem["link"] = link;
            newsItem["pubDate"] = pubDate;
            newsItem["source"] = source;
            newsItem["media"] = self.tempMedia;
            
            newsItems.append(newsItem)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "title") {
            title += string
        } else if (currentElement == "pubDate") {
            pubDate += string
        } else if (currentElement == "author") {
            source += string
        } else if (currentElement == "link") {
            link += string
        } else if (currentElement == "enclosure") {
            media = tempMedia
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //Called when the parsing is complete
        parsingCompleted()
    }

    func parsingCompleted() {
        DispatchQueue.main.async {
            self.items = self.newsItems.map { InvestingStockItem(details: $0) }
        }
    }

    func detectedLanguage<T: StringProtocol>(for string: T) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(String(string))
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLanguage
    }
}

