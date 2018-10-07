//
//  DataExtension.swift
//  Xplaces
//
//  Created by Danielle Glazer on 20/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
