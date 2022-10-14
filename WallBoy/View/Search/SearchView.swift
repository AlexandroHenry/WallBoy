//
//  SearchView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var searchText = ""
    @AppStorage("isEnglish") private var isEnglish = true
    
    var filteredStocks: [StockInformation] {
        modelData.stockInfo.filter { stock in
            stock.symbol.contains(searchText) || stock.name.contains(searchText) || stock.nameKR.contains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredStocks, id: \.self) { stock in
                    
                    NavigationLink {
                        StockDetailView(stock: stock)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: stock.logoURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 7)
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(.trailing, 10)
                            
                            if isEnglish {
                                Text(stock.name)
                                    .font(.title2)
                            } else {
                                VStack(alignment: .leading){
                                    Text(stock.nameKR)
                                        .font(.title2)
                                    Text(stock.name)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Search")
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(ModelData())
    }
}
