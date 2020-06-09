////
//  SHA512.swift
//  SecureHashAlgorithm
//
//  Created by Mihnea Stefan on 07/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation


class SHA512 : Convertible {
    
    var K : [UInt64] = [ 0x428a2f98d728ae22 ,0x7137449123ef65cd ,0xb5c0fbcfec4d3b2f  ,0xe9b5dba58189dbbc  ,0x3956c25bf348b538  ,0x59f111f1b605d019  ,0x923f82a4af194f9b  ,0xab1c5ed5da6d8118  ,0xd807aa98a3030242  ,0x12835b0145706fbe  ,0x243185be4ee4b28c  ,0x550c7dc3d5ffb4e2
         ,0x72be5d74f27b896f  ,0x80deb1fe3b1696b1  ,0x9bdc06a725c71235  ,0xc19bf174cf692694  ,0xe49b69c19ef14ad2  ,0xefbe4786384f25e3  ,0x0fc19dc68b8cd5b5  ,0x240ca1cc77ac9c65  ,0x2de92c6f592b0275  ,0x4a7484aa6ea6e483  ,0x5cb0a9dcbd41fbd4  ,0x76f988da831153b5  ,0x983e5152ee66dfab  ,0xa831c66d2db43210  ,0xb00327c898fb213f  ,0xbf597fc7beef0ee4  ,0xc6e00bf33da88fc2  ,0xd5a79147930aa725  ,0x06ca6351e003826f  ,0x142929670a0e6e70  ,0x27b70a8546d22ffc  ,0x2e1b21385c26c926  ,0x4d2c6dfc5ac42aed  ,0x53380d139d95b3df  ,0x650a73548baf63de  ,0x766a0abb3c77b2a8  ,0x81c2c92e47edaee6  ,0x92722c851482353b  ,0xa2bfe8a14cf10364  ,0xa81a664bbc423001  ,0xc24b8b70d0f89791  ,0xc76c51a30654be30  ,0xd192e819d6ef5218  ,0xd69906245565a910  ,0xf40e35855771202a  ,0x106aa07032bbd1b8 ,0x19a4c116b8d2d0c8  ,0x1e376c085141ab53  ,0x2748774cdf8eeb99  ,0x34b0bcb5e19b48a8  ,0x391c0cb3c5c95a63  ,0x4ed8aa4ae3418acb  ,0x5b9cca4f7763e373  ,0x682e6ff3d6b2b8a3  ,0x748f82ee5defb2fc  ,0x78a5636f43172f60  ,0x84c87814a1f0ab72  ,0x8cc702081a6439ec  ,0x90befffa23631e28  ,0xa4506cebde82bde9 ,0xbef9a3f7b2c67915  ,0xc67178f2e372532b  ,0xca273eceea26619c  ,0xd186b8c721c0c207  ,0xeada7dd6cde0eb1e  ,0xf57d4f7fee6ed178  ,0x06f067aa72176fba  ,0x0a637dc5a2c898a6  ,0x113f9804bef90dae  ,0x1b710b35131c471b  ,0x28db77f523047d84 ,0x32caab7b40c72493  ,0x3c9ebe0a15c9bebc  ,0x431d67c49c100d4c  ,0x4cc5d4becb3e42b6  ,0x597f299cfc657e2a  ,0x5fcb6fab3ad6faec  ,0x6c44198c4a475817]
 
    var H : [UInt64] = [ 0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1, 0x510e527fade682d1, 0x9b05688c2b3e6c1f, 0x1f83d9abfb41bd6b, 0x5be0cd19137e2179]
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
     
    //Class Methods
    
    func preprocessing()->[Bool]{
        var binary = [Bool]()
        for c in input{
            binary+=UInt64(c.asciiValue!).binary
            }
        let l = binary.count
        var k = 896-((l%1024)+1)
        binary.append(true)
        if k<0{
            k = k*(-1)
            k = 1024-k
            }
        for _ in 0..<k{
            binary.append(false)
        }
        for _ in 0..<128-l.binary.count{
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
        var W = [UInt64]() // Words array
        while m.isEmpty == false{ // We use a while rather than a for to optimize memory usage. This way, the maximum amount of memory we will be using is inputLength+512, rather than inputLength x 2
                array.append(m[0])
                m.remove(at: 0)
                if array.count == 1024{
                    M.append(array)
                    array.removeAll()
                }
        }
        for ch in 0..<M.count{
            while M[ch].isEmpty == false{
            array.append(M[ch][0])
            M[ch].remove(at : 0)
            if array.count == 64{
                W.append(converter.transformBinaryToUInt64(input: array))
                array.removeAll()
                }
            }
        for i in 16...79{
            var number = lowerSigma1(number: W[i-2])
            number>UInt64.max-W[i-7] ? (number-=UInt64.max-W[i-7]+1) : (number+=W[i-7])
            number>UInt64.max-lowerSigma0(number : W[i-15]) ? (number-=UInt64.max-lowerSigma0(number: W[i-15])+1) : (number+=lowerSigma0(number: W[i-15]))
            number>UInt64.max-W[i-16] ? (number-=UInt64.max-W[i-16]+1) : (number+=W[i-16])
            W.append(number)
            }
            var a = H[0]
            var b = H[1]
            var c = H[2]
            var d = H[3]
            var e = H[4]
            var f = H[5]
            var g = H[6]
            var h = H[7]
            
            for t in 0...79{
            var T1 = h
            T1>UInt64.max-sigma1(number : e) ? (T1-=UInt64.max-sigma1(number : e)+1) : (T1+=sigma1(number : e))
            T1>UInt64.max-((e&f)^(~e&g)) ? (T1-=UInt64.max-((e&f)^(~e&g))+1) : (T1+=((e&f)^(~e&g)))
            T1>UInt64.max-K[t] ? (T1-=UInt64.max-K[t]+1) : (T1+=K[t])
            T1>UInt64.max-W[t] ? (T1-=UInt64.max-W[t]+1) : (T1+=W[t])
            var T2 = sigma0(number: a)
            T2>UInt64.max-((a&b)^(a&c)^(b&c)) ? (T2-=UInt64.max-(a&b)^(a&c)^(b&c)+1) : (T2+=(a&b)^(a&c)^(b&c))
            h=g
            g=f
            f=e
            d>UInt64.max-T1 ? (e=d-(UInt64.max-T1+1)) : (e = d+T1)
            d=c
            c=b
            b=a
            T1>UInt64.max-T2 ? (a=T1-(UInt64.max-T2+1)) : (a=T1+T2)
            }
            W.removeAll()
            let arr = [a,b,c,d,e,f,g,h]
            for s in 0..<H.count{
                H[s]>UInt64.max-arr[s] ? (H[s]-=UInt64.max-arr[s]+1) : (H[s]+=arr[s])
            }
        }

        var str = ""
        for i in 0..<H.count{
            str = String(format : "%llX",H[i])
        if str.count<16{
            str.insert("0", at: str.index(str.startIndex, offsetBy: 0))
            }
            messageDigest!+="\(str)"
            }
            print(messageDigest!)
    }
     
    func lowerSigma0(number : UInt64)->UInt64{
         let x = rightrotate(input: number, times: 1)
         let y = rightrotate(input: number, times: 8)
         let z = number>>7
         return x^y^z
     }
    
     func lowerSigma1(number : UInt64)->UInt64{
        let x = rightrotate(input: number, times: 19)
        let y = rightrotate(input: number, times: 61)
        let z = number>>6
         return x^y^z
     }
     func sigma0(number : UInt64)->UInt64{
         let x = rightrotate(input: number, times: 28)
         let y = rightrotate(input: number, times: 34)
         let z = rightrotate(input: number, times: 39)
         return x^y^z
     }
     func sigma1(number : UInt64)->UInt64{
         let x = rightrotate(input: number, times: 14)
         let y = rightrotate(input: number, times: 18)
         let z = rightrotate(input: number, times: 41)
         return x^y^z
     }
     
     func rightrotate(input : UInt64, times : Int)->UInt64{
         let nr = input
         return (nr>>times)|(nr<<(64-UInt64(times)))
     }
}