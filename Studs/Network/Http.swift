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
        case user
        case users
        case allEvents
    }

    private enum Either<A, B> {
        case left(A)
        case right(B)
    }

    static func get<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            URLSession.shared.dataTask(with: URL(string: "\(baseURL)\(endpoint)")!) { data, _, error in
                guard let data = data else {
                    observer.onError(error!)
                    return
                }
                let result = decode(data: data, type: type)
                switch result {
                case .right(let it):
                    observer.onNext(it)
                    observer.onCompleted()
                case .left(let err):
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
            return Either.right(result)
        } catch let err {
            return Either.left(err)
        }
    }
}
