//
//  KVOListener.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 10/02/2017.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

class KVOListener: NSObject {
    private let object: NSObject
    private let keyPath: String
    var numberOfCalls = 0
    var wasTriggered: Bool {
        return numberOfCalls > 0
    }

    init(object: NSObject, keyPath: String) {
        self.object = object
        self.keyPath = keyPath
        super.init()
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    private func subscribe() {
        object.addObserver(self,
                           forKeyPath: keyPath,
                           options: .new,
                           context: nil)
    }

    func unsubscribe() {
        object.removeObserver(self, forKeyPath: keyPath)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        numberOfCalls += 1
    }
}
