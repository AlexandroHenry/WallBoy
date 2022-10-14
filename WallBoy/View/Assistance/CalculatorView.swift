//
//  CalculatorView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/21.
//

import SwiftUI

struct CalculatorView: View {
    
    @State var bidAmount = ""
    
    var body: some View {
        VStack(spacing: 30) {
            
            HStack {
                Spacer()
                
                Text("$")
                
                if bidAmount == "" || bidAmount == "0." {
                    Text("0")
                        .font(.system(size: 50))
                } else {
                    Text(bidAmount)
                        .font(.system(size: 50))
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("1")
                        .onTapGesture {
                            bidAmount += "1"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("2")
                        .onTapGesture {
                            bidAmount += "2"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("3")
                        .onTapGesture {
                            bidAmount += "3"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("4")
                        .onTapGesture {
                            bidAmount += "4"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("5")
                        .onTapGesture {
                            bidAmount += "5"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("6")
                        .onTapGesture {
                            bidAmount += "6"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("7")
                        .onTapGesture {
                            bidAmount += "7"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("8")
                        .onTapGesture {
                            bidAmount += "8"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("9")
                        .onTapGesture {
                            bidAmount += "9"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text(".")
                        .onTapGesture {
                            let dotCount = bidAmount.filter{$0 == "."}.count
                            
                            if dotCount < 1 {
                                if bidAmount == "" {
                                    bidAmount += "0."
                                } else {
                                    bidAmount += "."
                                }
                            }
                            
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("0")
                        .onTapGesture {
                            bidAmount += "0"
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.primary.opacity(0))
                    
                    Text("⌫")
                        .onTapGesture {
                            if bidAmount != "" {
                                bidAmount.removeLast()
                            }
                        }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
            }
        }
        .font(.largeTitle.bold())
        .foregroundColor(.green)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
