//
//  PHAssetResourceDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos

public final class PHAssetResourceDataProducer: DataProducer {
    private let assetResource: PHAssetResource

    public init(assetResource: PHAssetResource) {
        self.assetResource = assetResource
    }

    public func requestData(withCallback callback: NSData -> Void, completion: NSError? -> Void) -> Cancellable {
        let assetResourceManager = PHAssetResourceManager.defaultManager()

        let request = assetResourceManager
            .requestDataForAssetResource(assetResource,
                                         options: nil,
                                         dataReceivedHandler: { data in
                                            if data.length > 0 {
                                                let copy = NSData.init(data: data)
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