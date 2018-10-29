//
//  Http.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

struct Http {
    private static let baseURL = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
    
    public enum Endpoint: String {
        case login = "login"
        case logout = "logout"
        case graphQL = "graphql"
    }
    
    public enum GraphQLQueryName: String {
        case user = "user"
        case users = "users"
        case allEvents = "allEvents"
    }
    
    private enum Either<A, B> {
        case Left(A)
        case Right(B)
    }
    
    static func get<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            URLSession.shared.dataTask(with: URL(string: "\(baseURL)\(endpoint)")!) { data, response, error in
                guard let data = data else {
                    observer.onError(error!)
                    return
                }
                let result = decode(data: data, type: type)
                switch result {
                case .Right(let it):
                    observer.onNext(it)
                    observer.onCompleted()
                case .Left(let err):
                    observer.onError(err)
                }
            }.resume()
            return Disposables.create()
        }
    }
    
    private static func decode<T: Decodable>(data: Data, type: T.Type) -> Either<Error, T> {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(type, from: data)
            return Either.Right(result)
        } catch let e {
            return Either.Left(e)
        }
    }
}
