//
//  NSInputStream+PHAssetResourceInputStream.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos
import POSInputStreamLibrary

extension NSInputStream {
    public static func inputStreamWithAssetResource(assetResource: PHAssetResource) -> NSInputStream {
        let dataSource = PHAssetResourceInputStreamDataSource(assetResource: assetResource)
        let stream = POSBlobInputStream(dataSource: dataSource)
        return stream
    }
}