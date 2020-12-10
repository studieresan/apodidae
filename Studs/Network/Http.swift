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

    static func get<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            URLSession.shared.dataTask(with: URL(string: "\(baseURL)/\(endpoint)")!) { data, _, error in
                guard let data = data else {
                    observer.onError(error!)
                    return
                }
                let result = decode(data: data, type: type)
                switch result {
                case .success(let it):
                    observer.onNext(it)
                    observer.onCompleted()
                case .failure(let err):
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
                case .success(let it):
                    observer.onNext(it)
                    observer.onCompleted()
                case .failure(let err):
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

//				print("Data: \(String(bytes: data, encoding: .utf8))")

                let result = decode(data: data, type: type)
                switch result {
                case .success(let it):
					print("Success with GraphQL for \(type)")
                    observer.onNext(it)
                    observer.onCompleted()
                case .failure(let err):
					print("Failiure with GraphQL for \(type), ", err)
                    observer.onError(err)
                }
            }.resume()

            return Disposables.create()
        }
    }

    static func login(email: String, password: String) -> Observable<UserData> {
        let loginPayload = LoginPayload(email: email, password: password)
        return Http.post(endpoint: Endpoint.login, body: loginPayload, type: UserData.self)
    }

	static func fetchEvents(studsYear: Int?) -> Observable<EventsResponse> {
        let query =
"""
{
	events(studsYear: \(studsYear?.description ?? "null")) {
        id
        date
        location
        publicDescription
        privateDescription
        beforeSurvey
        afterSurvey
        pictures
        published
	    responsible {
             firstName
             lastName
        }
	    company {
		    name
		    id
	    }
        studsYear
	}
}
"""
        return graphQL(query: query, type: EventsResponse.self)
    }

    private static func decode<T: Decodable>(data: Data, type: T.Type) -> Result<T, Error> {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(type, from: data)
            return .success(result)
        } catch let err {
            return .failure(err)
        }
    }
}
