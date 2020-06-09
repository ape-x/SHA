//
//  Int+Extensions.swift
//  PRNG
//
//  Created by Mihnea Stefan on 05/06/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation


extension Int{
  var binary32 : [Bool]{
        get{
            var array = [Bool]()
            var number = self
            while true{
                if number%2==0{
                    array.append(false)
                }else{
                    array.append(true)
                }
                if number/2 == 0{
                    break
                }
                number = number/2
            }
            while array.count<32{
                array.append(false)
            }
            if array.count>32{
                while array.count>64{
                    array.remove(at: 0)
                }
            }
            array = array.reversed()
            return array
        }
    }

    
    var binary : [Bool]{
           get{
               var array = [Bool]()
               var number = self
               while true{
                   if number%2==0{
                       array.append(false)
                   }else{
                       array.append(true)
                   }
                   if number/2 == 0{
                       break
                   }
                   number = number/2
               }
               while array.count<8{
                   array.append(false)
               }
               array = array.reversed()
               return array
           }
       }
    var hex : String{
        get{
            var value = ""
            var number = self
            var array = [Int]()
            
            while true{
                let D = Double(number)/16
                let R = Int((D-Double((number/16)))*16)
                number = Int(D)
                array.append(R)
                if number/16 == 0{
                    array.append(Int(D))
                    break
                }
            }
            while array.count<8{
                array.append(0)
            }
            array = array.reversed()
            for i in 0..<array.count{
                if array[i]>=10{
                    value.append(String(UnicodeScalar(array[i]+55)!))
                }else{
                    value.append(String(UnicodeScalar(array[i]+48)!))
                }
            }
            
            return value
        }
    }
}
