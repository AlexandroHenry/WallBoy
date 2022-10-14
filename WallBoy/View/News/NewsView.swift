//
//  NewsView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI
import NaturalLanguage

struct NewsView: View {
    @StateObject var googleNewsVM = GoogleNewsViewModel()
    @StateObject var yfNewsVM = YahooFinanceViewModel()
    @StateObject var investingStockVM = InvestingStockViewModel()
    
    @State var showSafari = false
    @State var searchText = ""
    
    @State var urlString = "https://duckduckgo.com"
    
    var body: some View {
        NavigationView {
            
            if searchText != "" {
                List {
                    ForEach(googleNewsVM.news, id: \.self) { item in
                        
                        Button {
                            self.urlString = item.link
                            self.showSafari.toggle()
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(item.source)
                                    Spacer()
                                }
                                .foregroundColor(.orange)

                                Text(item.title)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .font(.callout.bold())
                            .foregroundColor(.primary)
                            .padding(.vertical, 3)
                        }
                    }
                }
                .sheet(isPresented: $showSafari){
                    SafariView(url: URL(string: self.urlString)!)
                }
            
            } else {
                List {
                    ForEach(yfNewsVM.items, id: \.self) { item in
                        Button {
                            self.urlString = item.link
                            self.showSafari.toggle()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(item.source)
                                        Spacer()
                                    }
                                    .foregroundColor(.orange)

                                    Text(item.title)
                                        .foregroundColor(.primary)

                                    Text(item.pubDate.toString())
                                        .foregroundColor(.secondary)
                                }
                                .foregroundColor(.primary)
                                .font(.callout)

                                AsyncImage(
                                    url: URL(string: item.media),
                                    content: { image in
                                        image
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 120, maxHeight: 200)
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(maxWidth: 120, maxHeight: 200)
                                    }
                                )
                                .padding(.leading, 10)
                            }
                        }
                    }
                    
                    ForEach(investingStockVM.items, id: \.self) { item in
                        Button {
                            self.urlString = item.link
                            self.showSafari.toggle()
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(item.source)
                                        Spacer()
                                    }
                                    .foregroundColor(.orange)

                                    Text(item.title)
                                        .foregroundColor(.primary)

                                    Text(item.pubDate)
                                        .foregroundColor(.secondary)
                                }
                                .foregroundColor(.primary)
                                .font(.callout)

                                AsyncImage(
                                    url: URL(string: item.media),
                                    content: { image in
                                        image
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 120, maxHeight: 200)
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(maxWidth: 120, maxHeight: 200)
                                    }
                                )
                                .padding(.leading, 10)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showSafari){
                    SafariView(url: URL(string: self.urlString)!)
                }
                
            }
        }
        .navigationTitle("News")
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            
            let lang = detectedLanguage(for: searchText)!
            // 한글을 전송해줄경우 addingPercentEncoding 을 활용하자!!
            // 참고 : https://eeyatho.tistory.com/130
            print(lang)
            if lang == "Korean" || lang == "한국어" {
                googleNewsVM.loadKRGoogleNews(query: searchText)
            } else {
                googleNewsVM.loadUSGoogleNews(query: searchText)
            }
        }
        .onAppear {
            investingStockVM.loadData()
            yfNewsVM.loadData()
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

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}

extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}
