//
//  Cancellable.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public final class CancellationToken: Cancellable {
    private var cancellationClosure: (() -> Void)

    public init(cancellationClosure: @escaping (() -> Void)) {
        self.cancellationClosure = cancellationClosure
    }

    public func cancel() {
        cancellationClosure()
    }

    public static let empty = CancellationToken(cancellationClosure: {})
}
