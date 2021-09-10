//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by DoHyeong on 2021/09/10.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    private var list = [
        Memo(content: "Dummy 1", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Dummy 2", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        list.insert(memo, at: 0)
        
        store.onNext(list)
        
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> Observable<[Memo]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updatedMemo = Memo(original: memo, updatedContent: content)
        
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updatedMemo, at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(updatedMemo)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(memo)
    }
}
