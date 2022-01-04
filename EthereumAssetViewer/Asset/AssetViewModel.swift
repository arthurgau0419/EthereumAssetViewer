//
//  AssetViewModel.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import Foundation
import RxSwift
import RxCocoa

class AssetViewModel {
    
    struct Input {
        let reload: ControlEvent<Void>
        let itemSelected: ControlEvent<String>
    }
    
    struct Output {
        let collections: Driver<[String]>
        let openCollection: Signal<String>
    }
    
    let address: String
    
    init(address: String) {
        self.address = address
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            collections: .just(["foo", "bar"]),
            openCollection: input.itemSelected.asSignal()
        )
    }
}
