

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()
//    @ObservedObject var modelData

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .onAppear{
                    modelData.landmarks = load("landmarkData.json")
                }
                .task {
                    
                    /* With async-await
                    do{
                        modelData.landmarks = try await getLandmarksAsync()
                    }
                    catch{
                        fatalError()
                    }
                     */
                    
                    
                    
                    /* Without async-await
                    LandmarkFetcher.getLandmarks{ result in
                        switch result{
                        case .success(let landmarks):
                            DispatchQueue.main.async {
                                modelData.landmarks = landmarks
                            }
                        case .failure(let error):
                            print("Error : \(error)")
                        }
                    }
                    */
                    
    
                }
                .onDisappear {
                    save(landmarks: modelData.landmarks, filename: "landmarkData.json")
                }
        }
    }
}
