//
//  SHA.swift
//  PRNG
//
//  Created by Mihnea Stefan on 05/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation


class SHA1 : Convertible {
  
    var H = [0x67452301 , 0xEFCDAB89 , 0x98BADCFE, 0x10325476, 0xC3D2E1F0]
    var messageDigest : String?
    var input : String
    var converter : Converter
    
    init(seed : String){
        input = seed
        converter = Converter()
    }
    
    //Protocol methods
    
    func transformToBinary(input: [Int]) -> [[Bool]] {
        return converter.transformToBinary(input: input)
      }
      
      func transformToAscii(input: String) -> [Int] {
        return converter.transformToAscii(input: input)
      }
      
      func transformBinaryToInt(input m: [Bool]) -> Int {
        return converter.transformBinaryToInt(input: m)
      }
    func transformBinaryToUInt64(input m : [Bool])->UInt64{
        return converter.transformBinaryToUInt64(input: m)
    }
    
    //Class methods
    func preprocessing()->[Bool]{
        var binary = [Bool]()
        for c in input{
            binary+=Int(c.asciiValue!).binary
        }
        let l = binary.count
        var k = 448-((l%512)+1)
        binary.append(true)
        if k<0{
            k = k*(-1)
            k = 512-k
        }
        for _ in 0..<k{
            binary.append(false)
        }
        for _ in 0..<64-l.binary.count{
            binary.append(false)
        }
        binary+=l.binary
        return binary
    }
    
    func hashComputation(){
        messageDigest = ""
        var m = preprocessing()
        var M = [[Bool]]() //
        var array = [Bool]()
        var W = [Int]() // Words array
        while m.isEmpty == false{ // We use a while rather than a for to optimize memory usage. This way, the maximum amount of memory we will be using is inputLength+512, rather than inputLength x 2
            array.append(m[0])
            m.remove(at: 0)
            if array.count == 512{
                M.append(array)
                array.removeAll()
            }
        }
        for ch in 0..<M.count{
            array = []
            while M[ch].isEmpty == false{
                array.append(M[ch][0])
                M[ch].remove(at: 0)
                if array.count == 32{
                    W.append(transformBinaryToInt(input: array))
                    array.removeAll()
                }
            }
        
            for i in 16...79{
                let number = W[i-3]^W[i-8]^W[i-14]^W[i-16]
                W.append(leftrotate(input: number, times: 1))
            }
            
            var a : Int = H[0]
            var b : Int = H[1]
            var c : Int = H[2]
            var d : Int = H[3]
            var e : Int = H[4]
            
            for i in 0...79{
                var k = 0x0
                var t = 0
                switch i {
                case 0...19:
                    k = 0x5a827999
                    t = leftrotate(input: a, times: 5)+((b&c)|(~b&d))+W[i]+e+k
                case 20...39:
                    k = 0x6ed9eba1
                    t = leftrotate(input: a, times: 5)+(b^c^d)+W[i]+e+k
                case 40...59:
                    k = 0x8f1bbcdc
                    t = leftrotate(input : a, times : 5)+(b&c|(b&d)|(c&d))+W[i]+e+k
                case 60...79:
                    k = 0xca62c1d6
                    t = leftrotate(input: a, times: 5)+(b^c^d)+W[i]+e+k
                default :
                    break
                }
                if t>UInt32.max{
                    var tm = t.binary
                    while tm.count>32{
                        tm.remove(at: 0)
                        }
                    t = transformBinaryToInt(input: tm)
                }
                e = d
                d = c
                c = leftrotate(input: b, times: 30)
                b = a
                a = t
            }
            W.removeAll()
            H[0]+=a
            H[1]+=b
            H[2]+=c
            H[3]+=d
            H[4]+=e
            for s in 0..<H.count{
                if H[s].binary.count>32{
                    var tm = H[s].binary
                    while tm.count>32{
                        tm.remove(at : 0)
                    }
                    H[s] = transformBinaryToInt(input: tm)
                }
            }
        }
        for i in H{
            messageDigest! += "\(i.hex)"
        }
        print(messageDigest!)
    }
    func leftrotate(input : Int, times : Int)->Int{
        let nr : UInt32 = UInt32(input)
        return Int((nr<<times)|(nr>>(32-times)))
    }
    
}
