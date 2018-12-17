//
//  GaugeView.swift
//  Custom Gauge Control
//
//  Created by Lekkas, Chris (Hillsboro) on 12/17/18.
//  Copyright © 2018 Lekkas, Chris (Hillsboro). All rights reserved.
//

import UIKit

class GaugeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var outerBezelColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
    var outerBezelWidth: CGFloat = 10
    
    var innerBezelColor = UIColor.yellow
    var innerBezelWidth : CGFloat = 5
    
    var insideColor = UIColor.white
    
    var segmentWidth : CGFloat = 20
    var segmentColors = [UIColor(red: 0.7, green: 0, blue: 0, alpha: 1), UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(red: 0.7, green: 0, blue: 0, alpha: 1)]
    
    var totalAngle: CGFloat = 270
    var rotation: CGFloat = -135
    
    var majorTickColor = UIColor.black
    var majorTickWidth : CGFloat = 2
    var majorTickLength : CGFloat = 25
    
    var minorTickColor = UIColor.black
    var minorTickWidth : CGFloat = 1
    var minorTickLength : CGFloat = 20
    var minorTickCount = 3
    
    var outerCenterDiscColor = UIColor(white: 0.9, alpha: 1)
    var outerCenterDiscWidth : CGFloat = 35
    var innerCenterDiscColor = UIColor(white: 0.7, alpha: 1)
    var innterCenterDiscWidth : CGFloat = 25
    
    var needColor = UIColor(white: 0.7, alpha: 1)
    var needleWidth : CGFloat = 4
    let needle = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func drawBackground(in rect: CGRect, context ctx: CGContext){
        //draw the outer bezel as the largest circle
        outerBezelColor.set()
        ctx.fillEllipse(in: rect)
        
        //move in a little on each edge, then draw the inner bezel
        let innerBezelRect = rect.insetBy(dx: outerBezelWidth, dy: outerBezelWidth)
        innerBezelColor.set()
        ctx.fillEllipse(in: innerBezelRect)
        
        //finally, move in some more and draw the inside of our gauge
        let insideRect = innerBezelRect.insetBy(dx: innerBezelWidth, dy: innerBezelWidth)
        insideColor.set()
        ctx.fillEllipse(in: insideRect)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return}
        drawBackground(in: rect, context: ctx)
        drawSegments(in: rect, context: ctx)
        drawTicks(in: rect, context: ctx)
        drawCenterDisc(in: rect, context: ctx)
    }
    
    //1. Save the current configuration of our drawing context. We're about to make changes, and we dont want to pollute what comes next
    //2. Move our drawing context into the center of our draw rectangle, then rotate it so we're pointing toward the start of the first segment. Moving
    //  like this means we will draw relative to the center of our rectangle, which make rotations more natural
    //3. Tell Core Graphics that we want to draw arcs using the size specified in our segmentWidth property
    //4. Calculate the size fo each segment by dividing the total angle of our gauge by the number of segments
    //5. Calculate the radius of our segment arc. This should be equal to the width of the draw rectangle minus our segment width, then halved. We halve the rectangle width we want radius not diameter, and we halve the segment width because Core Graphics draw half the line over the radius and half under, we want it all under. Finally, we take away the outer and inner bezel widths.
    //6. Loop over each segment color, drawing one piece of the arc at a time
    //7. Reset the graphics state to its earlier configuration
    func drawSegments(in rect: CGRect, context ctx: CGContext){
        //1: Save the current drawing configuration
        ctx.saveGState()
        
        //2: Move to the center of our drawing rectangle and rotate so that we're pointing at the start of the first segment
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation) - (.pi / 2)) // we need to subtrace .pi / 2 from the rotation because Core Graphics measures its angles where zero degress is directly to the right.
        
        //3: Set up  the user's line width
        ctx.setLineWidth(segmentWidth)
        
        //4: Calculate the size of each segment in the total guage
        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))
        
        //5: Calculate how wide the segment arcs shouls be
        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth
        
        //6: Draw each segment
        for(index, segment) in segmentColors.enumerated() {
            //figure out where the segment starts in our arc
            let start = CGFloat(index) * segmentAngle
            
            //active its color
            segment.set()
            
            //add a path for the segment
            ctx.addArc(center: .zero, radius: segmentRadius, startAngle: start, endAngle: start + segmentAngle, clockwise: false)
            
            // and stroke it using the activate color
            ctx.drawPath(using: .stroke)
        }
        
        // 7: reset the graphics state
        ctx.restoreGState()
    }

    func drawTicks (in rect: CGRect, context ctx: CGContext){
        //save our clean graphics state
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation) - (.pi / 2))
        
        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))
        
        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth
        
        //save the graphics state where we've moved to the center and rotated towards the start fo the first segment
        ctx.saveGState()
        
        //draw major ticks
        
        ctx.setLineWidth(majorTickWidth)
        majorTickColor.set()
        let majorEnd = segmentRadius + (segmentWidth / 2)
        let majorStart = majorEnd - majorTickLength
        
        for _ in 0 ... segmentColors.count {
            ctx.move(to: CGPoint(x: majorStart, y: 0))
            ctx.addLine(to: CGPoint(x: majorEnd, y: 0))
            ctx.drawPath(using: .stroke)
            ctx.rotate(by: segmentAngle)
        }
        
        //go back to the state we had before we drew the major ticks
        ctx.restoreGState()
        //save it again, because we're about to draw the minor ticks
        ctx.saveGState()
        
        //draw minor ticks
        ctx.setLineWidth(minorTickWidth)
        minorTickColor.set()
        let minorEnd = segmentRadius + (segmentWidth / 2)
        let minorStart = minorEnd - minorTickLength

        let minorTickSize = segmentAngle / CGFloat(minorTickCount + 1) // The “plus one” part is important, because we draw the ticks inside the segments rather than at the ages. For example, if we had a segment angle of 100 and wanted three ticks, dividing 100 by three would place ticks at 33, 66, and 99 – there would be a tick right next to the major tick line at 100.
        for _ in 0 ..< segmentColors.count {
            ctx.rotate(by: minorTickSize)
            
            for _ in 0 ..< minorTickCount{
                ctx.move(to: CGPoint(x: minorStart, y: 0))
                ctx.addLine(to: CGPoint(x: minorEnd, y: 0))
                ctx.drawPath(using: .stroke)
                ctx.rotate(by: minorTickSize)
            }
        }
        
        // go back to the graphics state where we've moved to the center and rotated towards the start of the first segement
        ctx.restoreGState()
        //go back to the original graphics state
        ctx.restoreGState()
    }
    
    func drawCenterDisc(in rect: CGRect, context ctx: CGContext){
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        
        let outerCenterRect = CGRect(x: -outerCenterDiscWidth / 2, y: -outerCenterDiscWidth / 2, width: outerCenterDiscWidth, height: outerCenterDiscWidth)
        outerCenterDiscColor.set()
        ctx.fillEllipse(in: outerCenterRect)
        
        let innerCenterRect = CGRect(x: -innterCenterDiscWidth / 2, y: -innterCenterDiscWidth / 2 , width: innterCenterDiscWidth, height: innterCenterDiscWidth)
        innerCenterDiscColor.set()
        ctx.fillEllipse(in: innerCenterRect)
        
        ctx.restoreGState()
    }
    
    func setUp() {
        needle.backgroundColor = needColor
        needle.translatesAutoresizingMaskIntoConstraints = false
        
        //make the needle a third of our height
        needle.bounds = CGRect(x: 0, y: 0, width: needleWidth, height: bounds.height / 3 )
        
        // align it so that it is positioned and rotated from the bottom center
        needle.layer.anchorPoint = CGPoint(x:0.5, y:1)
        
        // now center the needle over our center point
        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(needle)
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
}
