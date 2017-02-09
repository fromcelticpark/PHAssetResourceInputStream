//
//  PHAssetResourceDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos

@available(iOS 9.0, *)
public final class PHAssetResourceDataProducer: DataProducer {
    private let assetResource: PHAssetResource

    public init(assetResource: PHAssetResource) {
        self.assetResource = assetResource
    }

    public func requestData(withCallback callback: @escaping (Data) -> Void, completion: @escaping (Error?) -> Void) -> Cancellable {
        let assetResourceManager = PHAssetResourceManager.default()

        let request = assetResourceManager
            .requestData(for: assetResource,
                                         options: nil,
                                         dataReceivedHandler: { data in
                                            if data.count > 0 {
                                                // From documentation:
                                                // "The lifetime of the data is not guaranteed beyond that of the handler"
                                                // Therefore we need to make a copy of the data
                                                let copy = data.withUnsafeBytes { bytes in
                                                    return Data(bytes: bytes, count: data.count)
                                                }
                                                callback(copy)
                                            }
                },
                                         completionHandler: { error in
                                            completion(error)
            })

        return CancellationToken(cancellationClosure: {
            assetResourceManager.cancelDataRequest(request)
        })
        
    }
    
}
