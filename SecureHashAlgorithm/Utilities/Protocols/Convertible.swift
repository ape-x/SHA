//
//  Convertible.swift
//  SecureHashAlgorithm
//
//  Created by Mihnea Stefan on 05/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation

protocol Convertible{
    func transformToBinary(input : [Int])->[[Bool]]
    func transformToAscii(input : String)->[Int]
    func transformBinaryToInt(input m : [Bool])->Int
    func transformBinaryToUInt64(input m : [Bool])->UInt64
}
