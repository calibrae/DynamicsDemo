//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by Greg Heo on 2014-07-11.
//  Modified and toyed with by Nicolas Bousquet on 2015-04-21
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    var square: UIView!
    var snap: UISnapBehavior!
    let manager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testALotOfSquare()
        return;
        
        // keeping this as a reference
        
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.grayColor()
        view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.redColor()
        view.addSubview(barrier)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
        // add a boundary that has the same frame as the barrier
        collision.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    func randomInt(max:Int) -> Int{
        return Int(arc4random_uniform(UInt32(max + 1)))
    }
    func randomCGFloat(max:CGFloat) -> CGFloat{
        return CGFloat(randomInt(Int(max)))
    }
    func randomUIColor() -> UIColor{
        let hue  = CGFloat( Double(arc4random() % 256) / 256.0 );  //  0.0 to 1.0
        let saturation  = CGFloat( (Double( arc4random() % 128) / 256.0 ) + 0.5);  //  0.5 to 1.0, away from white
        let brightness = CGFloat( (Double(arc4random() % 128 ) / 256.0 ) + 0.5);  //  0.5 to 1.0, away from black
        // UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    
    func testALotOfSquare() {
        var squares = Array<UIView>()
        for var i = 0; i < 100; i++ {
            let square = UIView(frame: CGRect(x: randomCGFloat(view.bounds.width), y: randomCGFloat(view.bounds.height), width: 10, height: 10))
            square.backgroundColor = randomUIColor()
            view.addSubview(square)
            squares.append(square)
        }
        
        gravity = UIGravityBehavior(items: squares)
        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: squares)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: squares)
        itemBehaviour.elasticity = 1.0
        animator.addBehavior(itemBehaviour)
        
        
        if (manager.deviceMotionAvailable){
            println("accel available")
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion!, error: NSError!) in
                println("Data: \(data)")
                println("Error: \(error)")
                //let rotation = atan2(data.gravity.x, data.gravity.y) - M_PI
                //self?.gravity.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                let vector = CGVector(dx: data.gravity.x, dy: -data.gravity.y)
                
                self?.gravity.gravityDirection = vector
            }
        } else {
            println("accelerometer not available")
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        println("Boundary contact occurred - \(item2)")
        
        let collidingView = item1 as! UIView
        collidingView.backgroundColor = UIColor.yellowColor()
        UIView.animateWithDuration(0.3) {
            collidingView.backgroundColor = UIColor.grayColor()
        }
        
    }
    /*
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    if (snap != nil) {
    animator.removeBehavior(snap)
    }
    
    
    let touch = touches.first as! UITouch
    snap = UISnapBehavior(item: square, snapToPoint: touch.locationInView(view))
    animator.addBehavior(snap)
    }*/
    
    
}