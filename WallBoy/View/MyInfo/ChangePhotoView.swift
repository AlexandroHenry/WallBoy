//
//  ChangePhotoView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/21.
//

import SwiftUI
import AVFoundation

struct ChangePhotoView: View {
    var body: some View {
        ProfileCameraView()
    }
}

struct ChangePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePhotoView()
    }
}

struct ProfileCameraView: View {
    
    @StateObject var camera = ProfileCameraModel()
    
    var body: some View {
        ZStack {
            
            // Going to be Camera preview
            ProfileCameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                
                Spacer()
                
                HStack {
                    // if taken showing save and again take button...
                    if camera.isTaken {
                        HStack {
                            
                            Button{
                                camera.retake()
                            } label: {
                                Text("다시찍기")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(.white)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                            Button{
                                if !camera.isSaved{ camera.savePic() }
                            } label: {
                                Text(camera.isSaved ? "Saved" : "Save")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    } else {
                        Button {
                            camera.takePic()
                        } label: {
                            ZStack {
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .frame(width: 65, height: 65)
                            }
                        }
                    }
                    
                }
                .frame(height: 75)
                .padding()
            }
        }
        .onAppear {
            camera.check()
        }
    }
}

// Camera Model
class ProfileCameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    
    // preview...
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @StateObject var uploadProfileImageVM = UploadProfileImageViewModel()
    
    // Picture Data...
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    @AppStorage("userID") var userID = ""
    
    func check() {
        
        //first checking camera has got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // retrusting for permission....
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUp() {
        // setting up camera....
        
        do {
            
            // setting configs...
            self.session.beginConfiguration()
            
            // change for your own...
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            // same for output
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // take and retake function...
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.async { Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                self.session.stopRunning()
            }}
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func retake() {
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
                
                // clearing...
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil {
            return
        }
        
        print("사진 촬영!!!")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.picData = imageData

    }
    
    func savePic() {
        let image = UIImage(data: self.picData)!
        
        // saving Image ....
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        
        print("저장 완료!!!")
        
        var fileid = UUID().uuidString
        
        // MARK : 서버에 업로드 하기
        uploadProfileImageVM.uploadRequest(urlPath: "http://131.186.28.79/imageupload/name=profile_\(userID)_\(fileid)&userid=\(userID)", image: image, imageName: "profile_\(userID)_\(fileid).png")
    }
    
}

// setting view for preview....
struct ProfileCameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: ProfileCameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // Starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
