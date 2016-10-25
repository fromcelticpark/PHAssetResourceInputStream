//
//  Delay.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 25/10/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

func delay(after after: Double, queue: dispatch_queue_t, closure: ()->()) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(after * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, queue, closure)
}
