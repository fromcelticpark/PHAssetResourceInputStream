//
//  Delay.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 25/10/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

func delay(after: Double, queue: DispatchQueue, closure: @escaping ()->()) {
    let delayTime = DispatchTime.now() + Double(Int64(after * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    queue.asyncAfter(deadline: delayTime, execute: closure)
}
