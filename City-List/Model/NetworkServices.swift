//
//  NetworkServices.swift
//  city-list
//
//  Created by ahmed osama on 29/08/2022.
//

import Foundation
import UIKit

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
    func fetchMap(coord:Coord,complation:@escaping(Result<UIImage?,Error>)->Void) {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/staticmap?center=\(coord.lat),\(coord.lon)&zoom=12&size=150x150&key=AIzaSyChlfJDKyo_A6V-ZVMSVGBwzOkYM_gw_d4")else{
            return
        }
        let request = URLRequest(url: url)
                  let task = URLSession.shared.dataTask(with: request) { (data, _, erorr) in
                      if let data = data{
                          let result = UIImage(data: data)
                          complation(.success(result))
                      } else{
                          return
                      }
                      if let erorr = erorr {
                          complation(.failure(erorr))
                      }
              }
                 task.resume()
    }
}
