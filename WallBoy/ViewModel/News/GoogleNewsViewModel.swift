//
//  GoogleNewsViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import Foundation
import NaturalLanguage

struct GoogleNewsItem: Codable, Hashable {
    var title: String
    var link: String
    var pubDate: String
    var source: String
    
    init(details: [String: Any]) {
        title = details["title"] as? String ?? ""
        link = details["link"] as? String ?? ""
        pubDate = details["pubDate"] as? String ?? ""
        source = details["source"] as? String ?? ""
    }
}


class GoogleNewsViewModel: NSObject, ObservableObject {
    
    @Published var news = [GoogleNewsItem]()
    
    var xmlParser = XMLParser()
    
    var currentElement = ""
    var newsItems = [[String: String]]()
    var newsItem = [String: String]()
    
    var newsTitle = ""
    var pubDate = ""
    var source = ""
    var link = ""
    
    func loadUSGoogleNews(query: String) {
        let urlString = "https://news.google.com/rss/search?q=\(query)&hl=en-US&gl=US&ceid=US:en"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        guard let xmlParser = XMLParser(contentsOf: url) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
    func loadKRGoogleNews(query: String) {
        let urlString = "https://news.google.com/rss/search?q=\(query)&hl=ko&gl=KR&ceid=KR:ko"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        guard let xmlParser = XMLParser(contentsOf: url) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
}


extension GoogleNewsViewModel: XMLParserDelegate {
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            newsItem = [String : String]()
            newsTitle = ""
            pubDate = ""
            source = ""
            link = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            newsItem["title"] = newsTitle;
            newsItem["pubDate"] = pubDate;
            newsItem["source"] = source;
            newsItem["link"] = link;
            
            newsItems.append(newsItem)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == "title") {
            newsTitle += string
        } else if (currentElement == "pubDate") {
            pubDate += string
        } else if (currentElement == "source") {
            source += string
        } else if (currentElement == "link") {
            link += string
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //Called when the parsing is complete
        parsingCompleted()
    }

    func parsingCompleted() {
        DispatchQueue.main.async {
            self.news = self.newsItems.map { GoogleNewsItem(details: $0) }
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
