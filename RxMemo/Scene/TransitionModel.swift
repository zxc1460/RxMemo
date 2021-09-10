//
//  TransitionModel.swift
//  RxMemo
//
//  Created by DoHyeong on 2021/09/10.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
