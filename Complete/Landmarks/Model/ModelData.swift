/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var landmarks: [Landmark] = []
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func save(landmarks: [Landmark], filename: String){
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do{
        let data = try JSONEncoder().encode(landmarks)
        try data.write(to: file)
    }
    catch{
        fatalError("Couldn't write into \(filename)")
    }
}




// API Call without async-await

struct LandmarkFetcher{
    enum LandmarkError: Error{
        case invalidURL
        case missingData
    }
    
    static func getLandmarks(completion: @escaping(Result<[Landmark], Error>) -> Void){
        guard let resourceURL = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            completion(.failure(LandmarkError.invalidURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, URLresponse, error in
            guard let jsonData = data else{
                completion(.failure(LandmarkError.missingData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let returnData = try decoder.decode([Landmark].self, from: jsonData)
                completion(.success(returnData))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
}



// API call async
func getLandmarksAsync() async throws -> [Landmark]{
    guard let resourceURL = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
        fatalError()
    }
    
    let (data, URLResponse) = try await URLSession.shared.data(from: resourceURL)
    
    let returnValue = try JSONDecoder().decode([Landmark].self, from: data)
    
    return returnValue
}






