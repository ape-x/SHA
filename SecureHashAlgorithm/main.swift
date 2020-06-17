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
var qq = "abc"

var q = SHA1(seed: "abc")
var t = SHA256(seed: "abc")
var timer = Timer()

print(Date.init())
var aes = preprocessing(input: qq)
print(Date.init())

var r = SHA512(seed: qq)
print(Date.init())
print(Date.init())
print("\n")

//print(r.messageDigest!)

//00011010 10111100 00111100 01100101 11010101 10101001


//1234567891011234134
//137 16  135 165 150 159 74  22
//1895837225040000
var aerr = [UInt64]()
for i in 0..<aes.count{
    if (i+1)%8==0{
        var nr = (aes[i-7]<<56|aes[i-6]<<48)
        nr+=(aes[i-5]<<40|aes[i-4]<<32)
        nr+=(aes[i-3]<<24|aes[i-2]<<16)
        nr+=(aes[i-1]<<8|aes[i]<<0)
        aerr.append(UInt64(nr))
    }
}

print(aerr)
print(aerr.count)
