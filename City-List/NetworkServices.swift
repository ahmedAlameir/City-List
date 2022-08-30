//
//  NetworkServices.swift
//  city-list
//
//  Created by ahmed osama on 29/08/2022.
//

import Foundation

class NetworkServices{
    func fetchCities(pageNum:Int,complation:@escaping(Result<[Cities]?,Error>)->Void) {
        let pageNum = String(pageNum)
        guard let url = URL(string: "http://assignment.pharos-solutions.de/cities.json?page=\(pageNum)")else{
            return
        }
        let request = URLRequest(url: url)
                  let task = URLSession.shared.dataTask(with: request) { (data, _, erorr) in
                      guard let data = data else{
                          return
                  }
                      do{
                        let result = try JSONDecoder().decode([Cities].self, from: data)
                          
                        complation(.success(result))
                          
                      }catch{
                        complation(.failure(error))
                          print(error.localizedDescription)
                      }
              }
                 task.resume()
    }
}
