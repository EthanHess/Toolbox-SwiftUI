//
//  CustomSlider.swift
//  Toolbox-SwiftUI
//
//  Created by Ethan Hess on 2/21/23.
//

import SwiftUI

struct CustomSlider: View {
    
    @State private var isDragging = false
    @State private var parentAlpha = 0.0 //in this example we'll change the alpha of the parent
    
    //Will be used to size subcircles / determine alpha
    @State private var currentPointY : Double = 0.0
    
//    init(currentPontY: Binding<Double> = .constant(0)) {
//      _currentPointY = currentPontY
//    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged({ gesture in
                self.isDragging = true
                self.currentPointY = gesture.location.y
            })
            .onEnded { _ in self.isDragging = false }
    }
    
    //Goal is to make an animation similar to Apple's lock screen brightness slider but with some custom touches
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    //Bar
                    let yOperand = currentPointY > 0 ? currentPointY : 0
                    let newHeight = geo.size.height - CGFloat(yOperand)
                    let heightParam = newHeight > 0 ? newHeight : 0
                    VStack {
                        Spacer()
                        //Look out for "Invalid frame dimension (negative or non-finite)."
                        RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.cyan).frame(width: geo.size.width, height: heightParam)
                    }
                    VStack {
                        Spacer()
                        CircleDisplay(currentPointY: $currentPointY).frame(width: geo.size.width - 20, height: geo.size.width - 20)
                        Spacer()
                    }
                }
            }
        }
        .gesture(drag)
        .ignoresSafeArea(edges: .bottom).onAppear(perform: {
            //self.currentPointY = 0.0 //Binding vars don't have initial value, should do here or pass from parent (preview provider)?
        })
    }
}

//To go on top / display small animating circles
struct CircleDisplay: View {
    
    @Binding var currentPointY : Double
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    //Background container w / orbiting, dynamically resizing circles
                    Circle().fill(Color.red).frame(width: geo.size.width, height: geo.size.height, alignment: .center).overlay { GeometryReader { childGeo in
                        
                        //Place around the smaller circle like a clock
                        ForEach(0..<8, id: \.self) { index in
                                let dimensions = childGeo.size.width / 8
                                let point = calculatePointFromIndex(index, parentWidth: childGeo.size.width, parentHeight: childGeo.size.width, circleDimension: dimensions)
                                
                                //Circle().frame(width: dimensions, height: dimensions).position(x: point.x, y: point.y)
                                
                            //"offset" works better for defining relation to parent view (in this context) than "position"
                            
                            Circle().frame(width: dimensions, height: dimensions).scaleEffect(scaleEffectSize(currentPointY, originalWidth: dimensions)).offset(x: point.x, y: point.y)
                                
                                //.animation(Animation.easeInOut, value: true).edgesIgnoringSafeArea(.all)
                        }
                        
                        //Center circle
                        Circle().fill(Color.white).frame(width: childGeo.size.width / 2, height: childGeo.size.height / 2).offset(x: childGeo.size.width / 4, y: childGeo.size.width / 4).opacity(alphaFromYCoord(currentPointY))
                    }
                    }
                }
            }
        }.ignoresSafeArea(edges: .top)
    }
    
    private func scaleEffectSize(_ yCoord: Double, originalWidth: CGFloat) -> Double {
        if yCoord == 0.0 { return 1.0 }
        return yCoord / fullScreenHeight()
    }
    
    //For subcricle from yCoord (x, y)
    private func calculateScaleEffect(_ yCoord: Double, originalWidth: CGFloat) -> CGSize {
        if yCoord == 0.0 { return CGSize(width: 1, height: 1) }
        let originalDistanceFromCenter = CGFloat(originalWidth / 2)
        let screenHeightOperand = yCoord / fullScreenHeight()
        let newCoord = originalDistanceFromCenter / screenHeightOperand //Will scale proportionally to yCoord, if yCoord is at bottom, circle is small, if at top, it's at full scale.
        print("yCoord \(yCoord) screenHeightOperand \(screenHeightOperand) newCoord \(newCoord) originalWidth \(originalWidth)")
        let scaleEffect = CGSize(width: newCoord, height: newCoord)
        print("Scale effect \(scaleEffect)")
        return scaleEffect
        
        //Test
        // return CGSize(width: 10, height: 10)
    }
    
    //Double is more percise than float
    private func alphaFromYCoord(_ yCoord: Double) -> Double {
        if yCoord == 0.0 { return 1 }
        return yCoord / fullScreenHeight() //Adjust this, but just see how it works
    }
    
    private func fullScreenHeight() -> CGFloat {
        return UIScreen.screenHeight
    }
    
    //TODO would be cool to make into clok, timer
    
    //Clean code = happy computer :)
    //NOTE: can DRY / make less ugly, clean this up but just a test
    private func calculatePointFromIndex(_ index: Int, parentWidth: CGFloat, parentHeight: CGFloat, circleDimension: CGFloat) -> CGPoint {
        //Start w / 4 just for test
        
        let half = parentWidth / 2
        let fourth = parentWidth / 4
        let halfCircle = circleDimension / 2
        
        let xOne = half - halfCircle
        let xTwo = ((fourth * 3) - halfCircle) + 10
        let xThree = ((parentWidth) - circleDimension) - 10
        let xFour = ((fourth * 3) - halfCircle) + 10 //same as two, reuse
        let xFive = half - halfCircle //same as one, can reuse
        let xSix = (fourth - halfCircle) - 10
        let xSeven = CGFloat(10)
        let xEight = (fourth - halfCircle) - 10 //same as six
        
        let yOne = CGFloat(10)
        let yTwo = (fourth - halfCircle) - 10
        let yThree = (half - halfCircle)
        let yFour = ((fourth * 3) - halfCircle) + 10
        let yFive = ((parentWidth) - circleDimension) - 10
        let ySix = ((fourth * 3) - halfCircle) + 10 //same as four / reuse
        let ySeven = (half - halfCircle)
        let yEight = (fourth - halfCircle) - 10
        
        let pointOne = CGPoint(x: xOne, y: yOne)
        let pointTwo = CGPoint(x: xTwo, y: yTwo)
        let pointThree = CGPoint(x: xThree, y: yThree)
        let pointFour = CGPoint(x: xFour, y: yFour)
        let pointFive = CGPoint(x: xFive, y: yFive)
        let pointSix = CGPoint(x: xSix, y: ySix)
        let pointSeven = CGPoint(x: xSeven, y: ySeven)
        let pointEight = CGPoint(x: xEight, y: yEight)
        
        
        let frameMap : [Int: CGPoint] = [0: pointOne,
                                         1: pointTwo,
                                         2: pointThree,
                                         3: pointFour,
                                         4: pointFive,
                                         5: pointSix,
                                         6: pointSeven,
                                         7: pointEight]
        
        return frameMap[index] ?? .zero
    }
}
