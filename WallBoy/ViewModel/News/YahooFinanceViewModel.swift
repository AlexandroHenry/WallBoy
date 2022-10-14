//
//  YahooFinanceViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

// MARK: 여기서 야후 rss 주소 찾음
// reference address : https://blog.feedspot.com/yahoo_rss_feeds/

import Foundation
import NaturalLanguage

struct YFItem: Hashable {
    var title: String
    var link : String
    var pubDate: Date
    var source: String
    var media: String

    init(details: [String: Any]) {
        title = details["title"] as? String ?? ""
        link = details["link"] as? String ?? ""
        pubDate = details["pubDate"] as? Date ?? Date.now
        source = details["source"] as? String ?? ""
        media = details["media"] as? String ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6wHc3OzKebPw9iQ9NMcjKRHSxIFKN2Ds2LQ&usqp=CAU"
    }
}

class YahooFinanceViewModel: NSObject, ObservableObject {

    @Published var items = [YFItem]()
    
    var xmlParser = XMLParser()
    
    var currentElement = ""
    var newsItems = [[String: String]]()
    var newsItem = [String: String]()
    
    var newsTitle = ""
    var pubDate = ""
    var source = ""
    var link = ""
    var media = ""

    func loadData() {
        let urlString = "https://finance.yahoo.com/news/rssindex"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        guard let xmlParser = XMLParser(contentsOf: url) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
}

extension YahooFinanceViewModel: XMLParserDelegate {
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            newsItem = [String : String]()
            newsTitle = ""
            link = ""
            pubDate = ""
            source = ""
            media = ""
        }
        
        if elementName == "media:content" {
            self.media = attributeDict["url"]!
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            newsItem["title"] = newsTitle;
            newsItem["link"] = link;
            newsItem["pubDate"] = pubDate;
            newsItem["source"] = source;
            newsItem["media"] = media;
            
            newsItems.append(newsItem)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "title") {
            newsTitle += string
        } else if (currentElement == "pubDate") {
            pubDate = string
        } else if (currentElement == "source") {
            source = string
        } else if (currentElement == "link") {
            link = string
        } else if (currentElement == "media") {
            media = string
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //Called when the parsing is complete
        parsingCompleted()
    }

    func parsingCompleted() {
        DispatchQueue.main.async {
            self.items = self.newsItems.map { YFItem(details: $0) }
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
