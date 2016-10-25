//
//  PHAssetResourceDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos

@available(iOS 9.0, *)
public final class PHAssetResourceDataProducer: DataProducer {
    fileprivate let assetResource: PHAssetResource

    public init(assetResource: PHAssetResource) {
        self.assetResource = assetResource
    }

    public func requestData(withCallback callback: @escaping (Data) -> Void, completion: @escaping (NSError?) -> Void) -> Cancellable {
        let assetResourceManager = PHAssetResourceManager.default()

        let request = assetResourceManager
            .requestData(for: assetResource,
                                         options: nil,
                                         dataReceivedHandler: { data in
                                            if data.count > 0 {
                                                let copy = NSData.init(data: data) as Data
                                                callback(copy)
                                            }
                },
                                         completionHandler: { error in
                                            completion(error as NSError?)
            })

        return CancellationToken(cancellationClosure: {
            assetResourceManager.cancelDataRequest(request)
        })
        
    }
    
}
