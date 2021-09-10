//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by DoHyeong on 2021/09/10.
//

import Foundation
import RxCocoa
import RxSwift

class CommonViewModel: NSObject {
    let title: Driver<String>
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String,
         sceneCoordinator: SceneCoordinatorType,
         storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
