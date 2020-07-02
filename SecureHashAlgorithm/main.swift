//
//  main.swift
//  SecureHashAlgorithm
//
//  Created by Mihnea Stefan on 05/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation

var qq = "abc"

var q = SHA1(seed: "abc")
var t = SHA256(seed: "abc")
var r = SHA512(seed: qq)
print(Date.init())
r.hashComputation()
print(r.messageDigest!)
print(Date.init())

