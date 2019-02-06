//
//  Extensions.swift
//  Mortar
//
//  Created by Abraham Isaac Durán on 2/6/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

extension CGFloat {
    func rounded(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
