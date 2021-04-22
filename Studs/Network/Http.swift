//
//  Http.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation
import RxSwift
import Combine

struct FetchError: Error {
	enum ErrorType {
		case noDataKey, noRootFieldKey, noJSONResponse, noJSONContent
	}

	let kind: ErrorType
}

struct Http {
    private static let baseURL = Bundle.main.infoDictionary!["API_BASE_URL"] as? String ?? "https://studs-overlord.herokuapp.com"
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

	static func graphQL<T: Decodable & GraphQLSingleResponse>(query: String, type: T.Type) -> Observable<T> {
        return Observable.create { observer in

            var request = URLRequest(url: URL(string: "\(baseURL)/\(Endpoint.graphQL)")!)
            request.httpMethod = "POST"
            request.setValue("application/graphql", forHTTPHeaderField: "Content-Type")
			request.httpBody = "\(query)".data(using: .utf8)

            if let userToken = UserManager.getToken() {
                request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
			}

            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    observer.onError(error!)
                    return
                }

				guard let responseAsJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else {
					observer.onError(FetchError(kind: .noJSONResponse))
					return
				}
				guard let dataJSONContent = responseAsJSON["data"] as? [String: Any?] else {
					observer.onError(FetchError(kind: .noDataKey))
					return
				}
				guard let rootFieldJSONContent = dataJSONContent[type.rootField] as Any? else {
					observer.onError(FetchError(kind: .noRootFieldKey))
					return
				}
				guard let contentData = try? JSONSerialization.data(withJSONObject: rootFieldJSONContent, options: .fragmentsAllowed) else {
					observer.onError(FetchError(kind: .noJSONContent))
					return
				}

				let decodedData = decode(data: contentData, type: type)

				switch decodedData {
				case .success(let responseData):
					observer.onNext(responseData)
                    observer.onCompleted()
				case .failure(let err):
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

	static func fetchEvents(studsYear: Int?) -> Observable<[Event]> {
        let query = createEventsQuery(year: studsYear)

		return graphQL(query: query, type: [Event].self)
    }

	static func fetchUser() -> Observable<User> {
		let query = createUserQuery()

		return graphQL(query: query, type: User.self)
	}

	static func fetchAllUsers(of role: String? = nil, studsYear: Int? = nil) -> Observable<[User]> {
		let query = createUsersQuery(role: role, year: studsYear)

		return graphQL(query: query, type: [User].self)
	}

	static func fetchHappenings() -> Observable<[Happening]> {
		let query = createHappeningsQuery()

		return graphQL(query: query, type: [Happening].self)
	}

	static func create(happening: NewHappening) -> Observable<CreatedHappening> {
		let query = createHappeningsCreateQuery(newHappening: happening)

		return graphQL(query: query, type: CreatedHappening.self)
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
