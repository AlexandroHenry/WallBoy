//
//  NewsList.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/07.
//

import SwiftUI

struct NewsList: View {
    @State var showSafari = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Button {
                    showSafari.toggle()
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("한국경제")
                            Spacer()
                        }
                        
                        Text("뉴욕증시, 연중 최저치 경신…다우지수도 약세장 진입 - 한국경제")
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    .font(.callout.bold())
                    .foregroundColor(.primary)
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: "https://www.hankyung.com/finance/article/202209277512Y")!)
                }
                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.05)
                
                Button {
                    showSafari.toggle()
                } label: {
                    VStack(alignment: .leading) {
                        Text("뉴욕증시, 연중 최저치 경신…다우지수도 약세장 진입 - 한국경제")
                            .multilineTextAlignment(.leading)
                    }
                    .font(.callout.bold())
                    .foregroundColor(.primary)
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: "https://www.hankyung.com/finance/article/202209277512Y")!)
                }
                
            }
            .padding()
        }
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList()
    }
}

