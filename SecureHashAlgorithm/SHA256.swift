//
//  SHA256.swift
//  SecureHashAlgorithm
//
//  Created by Mihnea Stefan on 06/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation


class SHA256 : Convertible {
 
    var K = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85 , 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,  0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]
    
    var H : [Int] = [0x6a09e667 , 0xbb67ae85 , 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
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
                M[ch].remove(at : 0)
                if array.count == 32{
                    W.append(transformBinaryToInt(input: array))
                    array.removeAll()
                }
            }
            for i in 16...63{
                let number = lowerSigma1(number: W[i-2])+W[i-7]+lowerSigma0(number: W[i-15])+W[i-16]
                W.append((number)%4294967296) 
            }
            var a = H[0]
            var b = H[1]
            var c = H[2]
            var d = H[3]
            var e = H[4]
            var f = H[5]
            var g = H[6]
            var h = H[7]
            
            for t in 0...63{
                let T1 = (h+sigma1(number: e)+((e&f)^(~e&g))+K[t]+W[t])%4294967296
                let T2 = (sigma0(number: a)+((a&b)^(a&c)^(b&c)))%4294967296
                h = g
                g = f
                f = e
                e = (d+T1)%4294967296
                d = c
                c = b
                b = a
                a = (T1+T2)%4294967296
            }
            H[0]+=a
            H[1]+=b
            H[2]+=c
            H[3]+=d
            H[4]+=e
            H[5]+=f
            H[6]+=g
            H[7]+=h
            for i in 0..<H.count{
                if H[i]>4294967296{
                    H[i] = H[i]%4294967296
                }
            }
            W.removeAll()
        }
        for nr in H{
            messageDigest!+="\((nr%4294967296).hex)"
        }
        print(messageDigest!)
    }
    
    
    func lowerSigma0(number : Int)->Int{
        let x = rightrotate(input: number, times: 7)
        let y = rightrotate(input: number, times: 18)
        let z = number>>3
        return x^y^z
    }
   
    func lowerSigma1(number : Int)->Int{
       let x = rightrotate(input: number, times: 17)
       let y = rightrotate(input: number, times: 19)
       let z = number>>10
        return x^y^z
    }
    func sigma0(number : Int)->Int{
        let x = rightrotate(input: number, times: 2)
        let y = rightrotate(input: number, times: 13)
        let z = rightrotate(input: number, times: 22)
        return x^y^z
    }
    func sigma1(number : Int)->Int{
        let x = rightrotate(input: number, times: 6)
        let y = rightrotate(input: number, times: 11)
        let z = rightrotate(input: number, times: 25)
        return x^y^z
    }
    
    func rightrotate(input : Int, times : Int)->Int{
        let nr : UInt32 = UInt32(input)
        return Int((nr>>times)|(nr<<(32-times)))
    }
    
}

