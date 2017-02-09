//
//  DataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public protocol DataProducer {
    func requestData(withCallback callback: @escaping (Data) -> Void, completion: @escaping (Error?) -> Void) -> Cancellable
}
