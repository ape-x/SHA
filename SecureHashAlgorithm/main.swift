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

var ls : UInt8 = 255

@discardableResult func preprocessing(input : String)->[Int]{
    var binary = [Int]()
    var array = [Int]()
    for c in input{
        binary.append(Int(c.asciiValue!))
    }
    let l = binary.count*8
    var k = 448-((l%512)+1)
    if k<0{
        k = k*(-1)
        k = 512-k
    }
    for _ in 0...k/8{
        binary.append(0)
    }
    if l/255==0{ // l is 8 bits long
        for _ in 0..<7{
        binary.append(0)
        }
        binary.append(l)
    }else{//l is longer than 8 bits

        var buffer = l/256
        array.append(l%256)
        while true{
            array.append(buffer%256)
            print(buffer)
            buffer = buffer/256
            if buffer<256{
                array.append(buffer)
                break
            }
        }
            while array.count<8{
                array.append(0)
            }
        for i in (0..<array.count).reversed(){
            binary.append(array[i])
        }
    }
    print(binary.count)
    return binary
}

var converter = Converter()
var qq = "F56ADAA9F1F2C4D03ADAC1212F3C8FDB7752EEE1139FB4FD0C4411C633C602F1E1B1ED10F59EFE27BB1F16C21E4E5C75F7432D1D553C7BBE5A1B6C43EF4AE64F"

var q = SHA1(seed: "abc")
var t = SHA256(seed: "abc")
var timer = Timer()

print(Date.init())
preprocessing(input: qq)
print(Date.init())

var r = SHA512(seed: qq)
print(Date.init())
r.preprocessing()
print(Date.init())

print(Date.init())
r.hashComputation()
print(Date.init())
print(r.messageDigest!)




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
