//
//  BytesGeneratorFactory.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 09/02/2017.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public protocol BytesGeneratorFactory {
    func buildBytesGenerator(startingFromOffset offset: UInt64) -> BytesGenerator
}
