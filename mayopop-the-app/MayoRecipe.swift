//
//  MayoRecipe.swift
//  mayopop-the-app
//
//  Created by Brian Anderson on 8/13/15.
//  Copyright (c) 2015 Brian Anderson. All rights reserved.
//

import Foundation

class MayoRecipe {
  var onStep = 0
  
  init() {
    onStep = 0
  }

  func onStepChange(newNumber: Int){
    onStep = newNumber
    println("Step changed \(onStep)")
  }
  func onStepChange(newNumber: String){
//    onStep = newNumber
    println("Step changed \(newNumber)")
  }
}
