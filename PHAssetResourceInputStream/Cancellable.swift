//
//  Cancellable.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public final class CancellationToken: Cancellable {
    private var cancellationClosure: (Void -> Void)

    public init(cancellationClosure: (Void -> Void)) {
        self.cancellationClosure = cancellationClosure
    }

    public func cancel() {
        cancellationClosure()
    }

    static let empty = CancellationToken.init(cancellationClosure: {})
}