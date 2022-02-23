//
//  APICaller.swift
//  NewsApp
//
//  Created by Ömer Faruk Meral on 23.02.2022.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    struct Constants{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&category=business&apiKey=2ccbe97c353e4a64907688ef4dd5f9c2")
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data,_, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles ))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//MODELS

struct APIResponse: Codable {
    let articles : [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}


struct Source: Codable {
    let name: String
}
