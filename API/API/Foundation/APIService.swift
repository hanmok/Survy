
//
//  APIManager.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Alamofire
import Foundation
import Model
import Moya

public class APIService {
    private init() {}
    static public let shared = APIService()
    
    private let provider: MoyaProvider<MultiTarget> = {
        let provider = MoyaProvider<MultiTarget>(endpointClosure: MoyaProvider.defaultEndpointMapping, requestClosure: MoyaProvider<MultiTarget>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: nil, session: DefaultAlamofireManager.shareManager, plugins: [], trackInflights: false)
        return provider
    }()
    
    private let genreProvider = MoyaProvider<GenreAPI>()
    private let surveyProvider = MoyaProvider<SurveyAPI>()
    private let surveyGenreProvider = MoyaProvider<SurveyGenreAPI>()
    private let sectionProvider = MoyaProvider<SectionAPI>()
    private let questionProvider = MoyaProvider<QuestionAPI>()
    private let selectableProvider = MoyaProvider<SelectableOptionAPI>()
    private let userProvider = MoyaProvider<UserAPI>()
    private let responseProvider = MoyaProvider<ResponseAPI>()
}

// MARK: - Genre

extension APIService {
    public func getAllGenres(completion: @escaping ([Genre]?) -> Void) {
        genreProvider.request(.fetchAll) { result in
            switch result {
                case .success(let result):
                    print("fetched result: \(result)")
                    let genresDic = try! JSONDecoder().decode([String: [Genre]].self, from: result.data)
                    let genres = genresDic["genres"]
                    completion(genres)
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    completion(nil)
            }
        }
    }
    
    public func postGenre(requestingGenreName: String, completion: @escaping ((String)?) -> Void) {
            
        // TODO: - StatusCode 500 이면 에러 처리.
        genreProvider.request(.create(requestingGenreName)) { result in
            switch result {
            case .success(let response):
                    // 이게 무슨코드야? json 으로 만드는 코드.
                    let responseDic = try! JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    print("someDic: \(responseDic)")
                    completion("hi")
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

// MARK: - Survey

extension APIService {
    // TODO: 본인이 올린 Survey는 올리지 않아야 함.
    public func getAllSurveys(completion: @escaping ([Survey]?) -> Void ) {
        surveyProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
                    let surveysResponse = try! JSONDecoder().decode(SurveyResponse.self, from: response.data)
                    
                    print("surveysResponse: \(surveysResponse)")
                    completion(surveysResponse.surveys)
                    
                case .failure(let error):
                    completion(nil)
            }
        }
    }
    
    public func postSurvey(title: String, participationGoal: Int, userId: Int, completion: @escaping (SurveyId?, String) -> Void) {
        surveyProvider.request(.create(title, participationGoal, userId)) { result in
            switch result {
                case .success(let response):
                    let postResponse = try! JSONDecoder().decode(PostResponse.self, from: response.data)
                    let (id, message) = (postResponse.id, postResponse.message)
                    completion(id, message)
                    
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
}

// MARK: - Section

extension APIService {
    public func postSection(title: String, sequence: Int, surveyId: Int,  completion: @escaping (SectionId?, String) -> Void) {
        sectionProvider.request(.create(title, sequence, surveyId)) { result in
            switch result {
                case .success(let response):
                    let postResponse = try! JSONDecoder().decode(PostResponse.self, from: response.data)
                    let (id, message) = (postResponse.id, postResponse.message)
                    completion(id, message)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    public func getSections(completion: @escaping ([Section]?, String) -> Void) {
        sectionProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
                    let sectionResponse = try! JSONDecoder().decode(SectionResponse.self, from: response.data)
                    completion(sectionResponse.sections, "success")
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
}


extension APIService {
    public func postQuestion(questionPosition: Int, text: String, sectionId: Int, questionTypeId: Int, expectedTimeInSec: Int, completion: @escaping (QuestionId?, String) -> Void) {
        questionProvider.request(.create(questionPosition, text, sectionId, questionTypeId, expectedTimeInSec)) { result in
            switch result {
                case .success(let response):
                    let postResponse = try! JSONDecoder().decode(PostResponse.self, from: response.data)
                    let (id, message) = (postResponse.id, postResponse.message)
                    completion(id, message)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    public func getQuestions(completion: @escaping ([Question]?, String) -> Void) {
        questionProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
                    let questionResponse = try! JSONDecoder().decode(QuestionResponse.self, from: response.data)
                    completion(questionResponse.questions, "success")
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
}

// FIXME: 음.. Result<Success, Fail> 로 하는게 더 좋을 수 있지 않을까 ??

extension APIService {
    public func postSelectableOption(value: String, position: Int, questionId: Int, completion: @escaping (Void?, String) -> Void) {
        selectableProvider.request(.create(value, position, questionId)) { result in
            switch result {
                case .success(let response):
                    let postResponse = try! JSONDecoder().decode(PostResponse.self, from: response.data)
                    
                    completion((), postResponse.message)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    public func getAllSelectableOptions(completion: @escaping ([SelectableOption]?, String?) -> Void ) {
        //        surveyProvider.request(.fetchAll) { result in
        selectableProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
                    let selectableOptionResponse = try! JSONDecoder().decode(SelectableOptionResponse.self, from: response.data)
                    print("surveysResponse: \(selectableOptionResponse)")
                    completion(selectableOptionResponse.selectableOptions, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
}

// MARK: - SurveyGenres

extension APIService {
    public func getAllSurveyGenres(completion: @escaping ([SurveyGenre]?) -> Void) {
        surveyGenreProvider.request(.fetchAll) { result in
            switch result {
                case .success(let response):
                    let surveyGenresDic = try! JSONDecoder().decode([String: [SurveyGenre]].self, from: response.data)
                    guard let surveyGenres = surveyGenresDic["survey_genres"] else { completion(nil)
                        return
                    }
                    completion(surveyGenres)
                case .failure(let moyaError):
                    completion(nil)
            }
        }
    }
    
    public func connectSurveyGenres(surveyId: SurveyId,
                                    genreId: GenreId,
                                    completion: @escaping (Void?, String) -> Void) {
        surveyGenreProvider.request(.connectToGenre(surveyId, genreId)) { result in
            switch result {
                case .success(let response):
                    completion((), "success")
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
}

// MARK: - User
extension APIService {
    public func postSurveyUser(userId: UserId, surveyId: SurveyId, completion: @escaping (Void?, String) -> Void) {
        userProvider.request(.connectToSurvey(userId, surveyId)) { result in
            switch result {
                case .success(let response):
                    completion((), "success")
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    public func postUser(username: Username, password: Password, completion: @escaping (User?, String?) -> Void) {
        userProvider.request(.create(username, password)) { result in
            switch result {
                case .success(let response):
//                    let userResponse = try! JSONDecoder().decode(UserResponse.self, from: response.data)
                    if let userResponse = try? JSONDecoder().decode(UserResponse.self, from: response.data) {
                        let createdUser = userResponse.user
                        completion(createdUser, nil)
                    } else {
                        completion(nil, "error!")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    // 로그인 실패시 -> 음.. Error Code 에 따라 달라질 것 같은데?
    public func login(username: Username, password: Password, completion: @escaping (User?, String?) -> Void) {
        userProvider.request(.login(username, password)) { result in
            switch result {
                case .success(let response):
                    // Error -> Auth Error;
                    if let userResponse = try? JSONDecoder().decode(UserResponse.self, from: response.data) {
                        if let accessToken = userResponse.accessToken {
                            KeychainManager.shared.saveAccessToken(accessToken)
                        }
                        if let refreshToken = userResponse.refreshToken {
                            KeychainManager.shared.saveRefreshToken(refreshToken)
                        }
                        print("result: \(userResponse)")
                        completion(userResponse.user, nil)
                    } else {
                        // 갖고있는 refreshToken 으로 로그인!
                        if let refreshToken = KeychainManager.shared.loadRefreshToken() {
                            APIService.shared.autoLogin(username: username, refreshToken: refreshToken) { [weak self] user, message in
                                guard let self = self else { return }
                                guard let user = user else {
                                    return
                                }
                                completion(user, nil)
                            }
                        } else{
                            completion(nil, "error")
                        }
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    public func logout(username: Username, completion: @escaping (Result<String, CustomError>) -> Void) {
        userProvider.request(.logout(username)) { result in
            switch result {
                case .success(let response):
                    let messageResponse = try! JSONDecoder().decode(MessageResponse.self, from: response.data)
                    if response.statusCode != 200 {
                        completion(.failure(.logout(nil)))
                    } else {
                        KeychainManager.shared.saveRefreshToken(nil)
                        completion(.success(messageResponse.message))
                    }
                case .failure(let error):
                    completion(.failure(.logout(error.localizedDescription)))
            }
        }
    }
    
    public func autoLogin(username: Username, refreshToken: RefreshToken, completion: @escaping (User?, String?) -> Void) {
        userProvider.request(.regenerateAccessToken(username, refreshToken)) { result in
            switch result {
                case .success(let response):
                    print("username: \(username), refreshToken: \(refreshToken)")
                    let userResponse = try! JSONDecoder().decode(UserResponse.self, from: response.data)
                    if let accessToken = userResponse.accessToken {
                        KeychainManager.shared.saveAccessToken(accessToken)
                    }
                    completion(userResponse.user, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
}

extension APIService {
    public func participate(surveyId: SurveyId, userId: UserId, completion: @escaping (Result<String, Error>) -> Void ) {
        surveyProvider.request(.participate(surveyId, userId)) { result in
            print("surveyId: \(surveyId), userId: \(userId)")
            switch result {
                case .success(let response):
                    let participateResponse = try! JSONDecoder().decode(ParticipateResponse.self, from: response.data)
                    if 200 ..< 300 ~= response.statusCode {
                        completion(.success(participateResponse.message))
                    } else {
                        completion(.failure(CustomError.response(participateResponse.message)))
                    }
                    
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

extension APIService {
    public func createResponse(questionId: QuestionId, selectableOptionId: SelectableOptionId, userId: UserId, surveyId: SurveyId, completion: @escaping (Result<String, Error>) -> Void) {
        print("questionId: \(questionId), selectableOptionId: \(selectableOptionId), userId: \(userId), surveyId: \(surveyId) ")
        responseProvider.request(.create(questionId, selectableOptionId, userId, surveyId)) { result in
            switch result {
                case .success(let response):
                    let responseResponse = try! JSONDecoder().decode(MessageResponse.self, from: response.data)
                    if 200 ..< 300 ~= response.statusCode {
                        print("createResponse message: \(responseResponse.message)")
                        completion(.success(responseResponse.message))
                    } else {
                        completion(.failure(CustomError.response(responseResponse.message)))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
