//
//  main.swift
//  SecureHashAlgorithm
//
//  Created by Mihnea Stefan on 05/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation


var q = SHA1(seed: "abc")
var t = SHA256(seed: "abc")
var r = SHA512(seed: "abc")

//q.hashComputation()
//t.hashComputation()
r.hashComputation()


