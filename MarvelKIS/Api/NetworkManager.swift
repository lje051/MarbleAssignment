//
//  NetworkManager.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import Alamofire
import RxAlamofire
import RxSwift
import CommonCrypto
import UIKit

struct MarvelAPIClientConfig {
    static let host = "https://gateway.marvel.com/v1/public/characters"
    static let defaultHeaders = ["Accept": "application/json", "Content-Type": "application/json"]
}

final class MarvelAPIClient {

    var hash: String {
        let combined = "\(ts)\(privateKey)\(publicKey)"
        let md5Data = MD5(string: combined)
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }

    func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }

    static let shared = MarvelAPIClient()
    let ts = 1
    let publicKey = "acfb9ee7ed1b413377089a4e1bb5a6af"
    let privateKey = "a9bc7d9aac79eec9f6951b14e6abca0ef65e7654"

    func urlParameters() -> String {
        return "&apikey=\(publicKey)&hash=\(hash)"
    }

    static func request(_ strUrl: String,
                        method: Alamofire.HTTPMethod = .get,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = MarvelAPIClientConfig.defaultHeaders,
                        encoding: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        guard let url = URL(string: strUrl + MarvelAPIClient.shared.urlParameters()) else {
            return .error(APIError.badURL)
        }

        let encode: ParameterEncoding = encoding ? JSONEncoding.default : URLEncoding.default
        return self.requestData(url, method: method, parameters: parameters, headers: headers, encoding: encode)
    }

    static func requestData(_ url: URL,
                            method: Alamofire.HTTPMethod = .get,
                            parameters: [String: Any]? = nil,
                            headers: [String: String]? = [:],
                            encoding: ParameterEncoding = URLEncoding.default) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.just(.init(headers ?? [:]))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap {
                RxAlamofire
                    .requestData(method, url, parameters: parameters, encoding: encoding, headers: $0)
                
            }
    }

}

extension Observable where Element == (HTTPURLResponse, Data) {
    func expectType<T: Decodable>(_ type: T.Type) -> Observable<T> {
        return self.observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { response, data -> T in
                do {
                    return try JSONDecoder().decode(type, from: data)
                } catch let error {
                    throw error
                }
            }
    }
}


enum APIError: Int, Error, LocalizedError {
    case invalidRequest             = 400
    case unAuthorized               = 401
    case forbidden                  = 403
    case notFound                   = 404
    case badFormat                  = 422
    case refreshTokenFail           = 495
    case internalError              = 500
    case badURL                     = 902
    case unknown                    = 903
    case unconnectedInternet        = 904

    var errorDescription: String? {
        switch self {
        case .invalidRequest: return "잘못된 요청입니다."
        case .unAuthorized: return "권한이 없습니다."
        case .forbidden: return "요청이 거절됐습니다."
        case .notFound: return "찾을 수 없습니다."
        case .refreshTokenFail: return "만료된 요청입니다."
        case .unconnectedInternet: return "네트워크 연결이 유실되었습니다."
        default: return "서비스를 이용하는데 불편을 드려 죄송합니다."
        }
    }
}
