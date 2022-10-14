//
//  TestView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/21.
//

import SwiftUI

struct TestView: View {
    @State var nicknameEdit: Bool = false
    @State var nicknameText = ""
    @State var aboutMe = ""
    
    // MARK: 사진 촬영
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    // MARK: Modal
    @State private var showingCredits = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Group {
                    Button {
                        showingCredits.toggle()
                        print(selectedImage)
                    } label: {
                        
                        if selectedImage != nil {
                            Image("ProfileIMG")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.gray, lineWidth: 3))
                                .frame(width: 250, height: 250)
                        } else {
//                            Image(uiImage: selectedImage!)
                            Image(systemName: "check")
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.gray, lineWidth: 3))
                                .frame(width: 250, height: 250)
                        }
                        
                    }
                    
                    HStack {
                        if nicknameEdit {
                            
                            TextEditor(text: $nicknameText)
                                .frame(width: 150, height: 30)
                                .border(.green, width: 1)
                            
                            Button {
                                
                                self.nicknameEdit.toggle()
                            } label: {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                            }
                            
                            Button {
                                
                                self.nicknameEdit.toggle()
                            } label: {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                            }
                            
                        } else {
                            Text("Hello, world!")
                                .font(.title)
                            
                            Button {
                                self.nicknameEdit.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }

                    }
                }
                
                Divider()
                
                
                Group {
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("소개 :")
                            Spacer()
                            Text("안녕하세요. 제 이름은 하승철이라고 합니다.")
                            Spacer()
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("자산 :")
                            Spacer()
                            Text("$ 890,129,122,111")
                            Spacer()
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("개인설정 :")
                            Spacer()
                            Text("88 명")
                            Spacer()
                        }
                    }
                    .foregroundColor(.primary)
                }
                
                Divider()
                
                NavigationLink {
                    Text("블로그 뷰")
                } label: {
                    Text("나의 블로그")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .frame(width: 350, height: 50)
                .background(.green)
                
                NavigationLink {
                    Text("초기화")
                } label: {
                    Text("초기화")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .frame(width: 350, height: 50)
                .background(.red)
            }
            .padding()
        }
        .navigationTitle("프로필")
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        .sheet(isPresented: $showingCredits) {
            VStack {
                Button {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                    
                    showingCredits.toggle()
                } label: {
                    Text("사진 촬영")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .frame(width: 350, height: 50)
                .background(.green)
                
                Button {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                    
                    showingCredits.toggle()
                } label: {
                    Text("앨범에서 등록")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .frame(width: 350, height: 50)
                .background(.green)
            }
            .presentationDetents([.height(200)])
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
