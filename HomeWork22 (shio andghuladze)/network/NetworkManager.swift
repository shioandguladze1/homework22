//
//  NetworkManager.swift
//  HomeWork22 (shio andghuladze)
//
//  Created by shio andghuladze on 13.08.22.
//

import Foundation
import UIKit

let apiKey = "4d3ec680a0d9e9167e276f5571bae754"
let imagePath = "https://image.tmdb.org/t/p/w500/"
let baseUrl = "https://api.themoviedb.org/3"
let tvShowsPath = "/tv/top_rated"
let tvShowDetailsPath = "/tv/" // need to add id
let setTvShowRatingPath = "/rating" // should be followed with tvShowDetailsPath
let createGuestSessionPath = "/authentication/guest_session/new"

private let config = URLSessionConfiguration.default
private let session = URLSession(configuration: config)
private let decoder = JSONDecoder()
let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)

func postData(url: String, queryItems: [URLQueryItem] = [apiKeyQueryItem], body: [String: Any], onResult: @escaping (Result)-> Void){
    guard var components = URLComponents(string: url) else {
        onResult(ErrorResult(errorMessage: "Invalid url \(url)"))
        return
    }
    
    components.queryItems = queryItems
    
    
    guard let componentsUrl = components.url else {
        onResult(ErrorResult(errorMessage: "Invalid url \(String(describing: components.url?.absoluteString))"))
        return
    }
    
    var request = URLRequest(url: componentsUrl)
    request.httpMethod = "POST"
    request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    
    session.dataTask(with: request) { data, response, error in
        guard let error = error else{
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 999
            if (200...299).contains(statusCode){
                onResult(SuccessResult(data: data))
                return
            }else{
                onResult(ErrorResult(errorMessage: "status code \(statusCode)"))
                return
            }
        }

        onResult(ErrorResult(errorMessage: error.localizedDescription))
    }.resume()
    
}

func fetchData<T: Codable>(url: String, dataType: T.Type, queryItems: [URLQueryItem] = [apiKeyQueryItem], onResult: @escaping (Result)-> Void){
    
    guard var components = URLComponents(string: url) else {
        onResult(ErrorResult(errorMessage: "Invalid url \(url)"))
        return
    }
    
    components.queryItems = queryItems
    
    guard let componentsUrl = components.url else {
        onResult(ErrorResult(errorMessage: "Invalid url \(String(describing: components.url?.absoluteString))"))
        return
    }
    
    session.dataTask(with: URLRequest(url: componentsUrl)) { data, response, error in

        generateResult(dataType: dataType, data: data, error: error, onResult: onResult)
        
    }.resume()
    
}

func getImage(imageUrl: String, onResult: @escaping (Result)-> Void){
    
    guard let url = URL(string: imageUrl) else {
        onResult(ErrorResult(errorMessage: "invalid url \(imageUrl)"))
        return
    }
    
    session.dataTask(with: URLRequest(url: url)) { data, response, error in
        if let error = error {
            onResult(ErrorResult(errorMessage: error.localizedDescription))
            return
        }
        
        guard let data = data else {
            onResult(ErrorResult(errorMessage: "Invalid data \(String(describing: data))"))
            return
        }
        
        if let image = UIImage(data: data) {
            onResult(SuccessResult(data: image))
            return
        }
        
        onResult(ErrorResult(errorMessage: "Unknown Error"))
        
    }.resume()
    
}

func generateResult<T: Codable>(dataType: T.Type, data: Data?, error: Error?, onResult: (Result)-> Void){
    
    if let e = error {
        let result = ErrorResult(errorMessage: e.localizedDescription)
        onResult(result)
        return
    }
    
    if let d = data {
        guard let decodedData = try? decoder.decode(dataType, from: d) else {
            print(dataType)
            let result = ErrorResult(errorMessage: "Could not parse data)" + d.toString())
            onResult(result)
            return
        }
        let result = SuccessResult(data: decodedData)
        onResult(result)
        return
    }
    
    let result = ErrorResult(errorMessage: "Unknown error")
    onResult(result)
    
}

func parseResult<T>(result: Result, onError: (String)-> Void = { print($0) }, onSuccess: (T)-> Void){
    
    if let successResult = result as? SuccessResult<T> {
        onSuccess(successResult.data)
        return
    }
    
    if let errorResult = result as? ErrorResult {
        onError(errorResult.errorMessage)
    }
    
}

protocol Result { }

struct SuccessResult<T>: Result{
    let data: T
}

struct ErrorResult: Result{
    let errorMessage: String
}
