//
//  InputStream+PHAssetResourceInputStream.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos
import POSInputStreamLibrary

extension InputStream {
    @available(iOS 9.0, *)
    public static func inputStream(withAssetResource assetResource: PHAssetResource) -> InputStream {
        let factory = AssetBytesGeneratorFactory(assetResource: assetResource)
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)
        let stream = POSBlobInputStream(dataSource: dataSource)
        return stream!
    }
}
