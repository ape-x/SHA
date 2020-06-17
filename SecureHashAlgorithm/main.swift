//
//  main.swift
//  SecureHashAlgorithm
//
//  Created by Mihnea Stefan on 05/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation


let x = false
let s = MemoryLayout.size(ofValue: x)


@discardableResult func preprocessing(input : String)->[Int]{
    var binary = [Int]()
    var array = [Int]()
    for c in input{
        binary.append(Int(c.asciiValue!))
    }
    let l = binary.count*8
    var k = 112-(((l/8)%128)+1)
    if k<0{
        k = k*(-1)
        k = 128-k
    }
    if l<256{ // l is 8 bits long
        array.append(l)
        for _ in 0..<15{
        array.append(0)
        }
        for _ in 0..<k{
            array.append(0)
        }
        array.append(128)
    }else{//l is longer than 8 bits
        var buffer = l/256
        array.append(l%256)
        while true{
            array.append(buffer%256)
            buffer = buffer/256
            if buffer<256{
                if array.count>15{
                    array.append(buffer+128)
                    for _ in 0..<k{
                        array.append(0)
                    }
                    break
                }else{
                array.append(buffer)
                while array.count<16{
                    array.append(0)
                    }
                    for _ in 0..<k{
                        array.append(0)
                    }
                    array.append(128)
                break
                }
            }
        }
    }
    binary+=array.reversed()
    return binary
}

var converter = Converter()
var qq = "abcmalkdmlskmaldmalksmlfsmkflmlmk"

var q = SHA1(seed: "abc")
var t = SHA256(seed: "abc")
var timer = Timer()

print(Date.init())
print(preprocessing(input: qq))
print(preprocessing(input: qq).count)
print(Date.init())

var r = SHA512(seed: qq)
//print(Date.init())
var qrt = r.preprocessing()
//print(qrt.count)

var arr = [Bool]()
var ar = [Int]()
for i in 0..<qrt.count{
    arr.append(qrt[i])
    if arr.count == 8{
        ar.append(converter.transformBinaryToInt(input: arr))
        arr = []
    }
}
print(ar)
print(ar.count)

//print(Date.init())
print("\n")

//print(r.messageDigest!)




/*
 if q>1 && q%8 == 0{
     for _ in 0..<k/8{
         array.append(0)
     }
     for _ in 0..<64-q{
         array.append(0)
     }
 }else if q>1 && q%8 != 0{
     for _ in 0..<k/8{
     array.append(0)
     }
     for _ in 0..<64-q-1{
         array.append(0)
     }
 }

 */
