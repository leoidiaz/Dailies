//
//  FetchFilms.swift
//  movieAppV5
//
//  Created by Leonardo Diaz on 3/5/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

enum FilmRequestError: Error{
    case connectionError
}


struct FetchFilms {
    let url: URL
    let apiKey = movieDBKey
    
    init(){
        // Get the current Date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        // input to URL
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&primary_release_date.gte=\(formattedDate)&primary_release_date.lte=\(formattedDate)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false"
        
        guard let updatedString = URL(string: urlString) else {fatalError()}
     
        url = updatedString
    }
    
    
    func requestFilms(completion: @escaping(Result<[Results], FilmRequestError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let jsonData = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let safeData = try decoder.decode(FilmModel.self, from: jsonData)
                
                // Nil Poster Removal
                var posterFilms: [Results] = []
                for safe in safeData.results{
                    if safe.poster_path != nil {
                        posterFilms.append(safe)
                    }
                }
                
                let results = posterFilms
                completion(.success(results))
            } catch{
                completion(.failure(.connectionError))
            }
        }
        dataTask.resume()
    }
    
}





