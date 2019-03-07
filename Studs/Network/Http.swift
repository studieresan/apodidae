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
            URLSession.shared.dataTask(with: URL(string: "\(baseURL)/\(endpoint)")!) { data, _, error in
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

    static func post<Payload: Encodable, Response: Decodable>
        (endpoint: Endpoint, body: Payload, type: Response.Type) -> Observable<Response> {

        let jsonEncoder = JSONEncoder()
        var jsonPayload: Data

        do {
            jsonPayload = try jsonEncoder.encode(body)
        } catch let error {
            print(error)
            fatalError("Couldn't format body to JSON")
        }

        return Observable.create { observer in
            var request = URLRequest(url: URL(string: "\(baseURL)/\(endpoint)")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonPayload

            URLSession.shared.dataTask(with: request) { data, _, error in
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

    static func graphQL<T: Decodable>(query: String, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            guard let formatedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                print(query)
                fatalError("Couldn't create query string")
            }

            var request = URLRequest(url: URL(string: "\(baseURL)/\(Endpoint.graphQL)?query=\(formatedQuery)")!)
            request.httpMethod = "POST"
            request.setValue("application/graphql", forHTTPHeaderField: "Content-Type")

            if let userToken = UserManager.getToken() {
                request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
            }

            URLSession.shared.dataTask(with: request) { data, _, error in
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

    static func login(email: String, password: String) -> Observable<LoginResponse> {
        let loginPayload = LoginPayload(email: email, password: password)
        return Http.post(endpoint: Endpoint.login, body: loginPayload, type: LoginResponse.self)
    }

    static func fetchAllEvents() -> Observable<AllEventsResponse> {
        let query = """
        {
            allEvents {
                id
                companyName
                schedule
                privateDescription
                publicDescription
                date
                beforeSurveys
                afterSurveys
                location
                pictures
                published
                responsible
            }
        }
        """
        return graphQL(query: query, type: AllEventsResponse.self)
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
