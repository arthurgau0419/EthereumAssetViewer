//
//  OpenSealAssetProvider.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import Foundation
import RxSwift
import Alamofire

private struct Response<T: Decodable>: Decodable {
    let assets: [Asset]
}

class OpenSeaAssetProvider: AssetProvider {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func fetch(owner: String, offset: Int) -> Single<[Asset]> {
        var components = URLComponents(string: "https://api.opensea.io/api/v1/assets")!
        components.queryItems = [
            "format": "json",
            "owner": owner,
            "offset": "\(offset)",
            "limit": "\(20)"
        ]
            .map { key, value in URLQueryItem(name: key, value: value) }
        
        return Observable.just(Result { try components.asURL() })
            .map {
                try $0.flatMap { url in
                    Result {
                        try URLRequest(
                            url: components.url!,
                            method: .get,
                            headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                .get()
            }
            .flatMap { request in
                URLSession.shared.rx.data(request: request)
            }
            .withUnretained(decoder)
            .map { decoder, data in
                try decoder.decode(Response<[Asset]>.self, from: data)
            }
            .map(\.assets)
            .asSingle()
    }
}
