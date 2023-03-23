//
//  ClockView.swift
//  Toolbox-SwiftUI
//
//  Created by Ethan Hess on 3/23/23.
//

//import Foundation
import SwiftUI

struct ClockView: View {
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    Circle() //Background
                    
                    //clock lines (seconds) //Use .rotationEffect(degrees: )
                    
                    //overlay circle (for counter)
                }
            }
            Text("60")
        }
    }
    
    private func angleAtIndex(_ index: Int) -> Double {
        return Double(360 / index) * 5
    }
}
