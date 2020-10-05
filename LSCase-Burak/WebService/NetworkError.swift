//
//  NetworkError.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 5.10.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case network
    case decoding

    var errorMessage: String {
        switch self {
        case .network:
            return "Fetching Error Occured."
        case .decoding:
            return "Decoding Error Occured."
        }
    }
}
