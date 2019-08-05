//
//  Extensions.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/1/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//


import Foundation
import UIKit
public func gymmieOrange()->UIColor{
    return createColor(247, green: 148, blue: 29)
}
public  func createColor(_ red: CGFloat, green: CGFloat, blue: CGFloat)->UIColor{
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
}
class Extensions {
    
}

    extension Array{
       func groupBy(limit: Int)->[[Element]]{
        var sorted = self
            var groupedOptions = [[Element]]()
            for i in 0...count{
                let first = sorted.prefix(limit)
                if !first.isEmpty{
                    groupedOptions.append(first.map({$0}))
                }
                sorted = sorted.dropFirst(limit).map({$0})
                
            }
            return groupedOptions
        }
    }

extension String{
    
    func rectForText(width: CGFloat, textSize: CGFloat)->CGRect{
        let size = CGSize(width: width, height: 1000)
    
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimateRect = NSString(string: self).boundingRect(with: size, options: options, attributes: [.font:UIFont.systemFont(ofSize: textSize)], context: nil)
        return estimateRect
    }
    
    func replace(strings:[String], with words: [String])->String{
        var newWord = self
        for (index,string) in strings.enumerated(){
            newWord = newWord.replacingOccurrences(of: string , with: words[index])
        }
        return newWord
    }
}

extension UIView {
    func left()->NSLayoutXAxisAnchor{
        return leftAnchor
    }
    func right()->NSLayoutXAxisAnchor{
        return rightAnchor
    }
    func top()->NSLayoutYAxisAnchor{
        return topAnchor
    }
    func bottom()->NSLayoutYAxisAnchor{
        return bottomAnchor
    }
    func x()->NSLayoutXAxisAnchor{
        return centerXAnchor
    }
    func y()->NSLayoutYAxisAnchor{
        return centerYAnchor
    }
    func setTopTo(con: NSLayoutYAxisAnchor, by: CGFloat)->NSLayoutConstraint{
       let con = topAnchor.constraint(equalTo: con, constant: by)
        con.isActive = true
        return con
    }
    func setLeftTo(con: NSLayoutXAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = leftAnchor.constraint(equalTo: con, constant: by)
        con.isActive = true
        return con
    }
    func setRightTo(con: NSLayoutXAxisAnchor, by: CGFloat)->NSLayoutConstraint{
     let con = rightAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
        return con
    }
    func setXTo(con: NSLayoutXAxisAnchor, by: CGFloat)->NSLayoutConstraint{
       let con = centerXAnchor.constraint(equalTo: con , constant: by )
        con.isActive = true
        return con
    }
    func setYTo(con: NSLayoutYAxisAnchor, by: CGFloat)->NSLayoutConstraint{
      let con = centerYAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
        return con
    }
    func setBottomTo(con: NSLayoutYAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = bottomAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
        return con
    }
    func setHeightTo(constant: CGFloat)->NSLayoutConstraint{
        let con = heightAnchor.constraint(equalToConstant: constant)
        con.isActive = true
        return con
    }
    func setWidthTo(constant: CGFloat)->NSLayoutConstraint{
        let con = widthAnchor.constraint(equalToConstant: constant)
        con.isActive = true
        return con
    }
    func add(views: UIView...){
        for view in views{
            addSubview(view)
        }
    }
    
    func constrainToViews(top:(UIView,CGFloat),left: (UIView,CGFloat),right:(UIView,CGFloat),bottom: (UIView,CGFloat)){
        topAnchor.constraint(equalTo:bottom.0.layoutMarginsGuide.bottomAnchor, constant: top.1).isActive = true
        leftAnchor.constraint(equalTo: left.0.layoutMarginsGuide.leftAnchor, constant: left.1).isActive = true
        rightAnchor.constraint(equalTo: right.0.layoutMarginsGuide.rightAnchor, constant: right.1).isActive = true
        bottomAnchor.constraint(equalTo: top.0.layoutMarginsGuide.topAnchor, constant: bottom.1).isActive = true
    }
    
    func constrainInView(view: UIView,top: CGFloat?,left:CGFloat?,right: CGFloat?,bottom:CGFloat?){
        let margins = view.layoutMarginsGuide
        if let topCon = top{
            topAnchor.constraint(equalTo:margins.topAnchor, constant: topCon).isActive = true
        }
        if let leftCon = left{
            leftAnchor.constraint(equalTo: margins.leftAnchor, constant: leftCon).isActive = true
        }
        if let rightCon = right{
            rightAnchor.constraint(equalTo: margins.rightAnchor, constant: rightCon).isActive = true
        }
        if let bottomCon = bottom{
            bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: bottomCon).isActive = true
        }
    }
    
    func constrainWithMultiplier(view: UIView,width:CGFloat,height: CGFloat){
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: height).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: width).isActive = true 
    }
    func addConstraintForViews(_ type:NSLayoutConstraint.Attribute,withView: UIView, toView:UIView?,plusMinus: CGFloat){
        addConstraint(NSLayoutConstraint(item: withView, attribute: type, relatedBy: .equal, toItem: toView , attribute: type, multiplier: 1, constant: plusMinus))
    }
    func joinViewsWithConstraint(_ type:NSLayoutConstraint.Attribute,type2:NSLayoutConstraint.Attribute,withView: UIView,toView: UIView){
        addConstraint(NSLayoutConstraint(item: withView, attribute: type, relatedBy: .equal, toItem: toView , attribute: type2, multiplier: 1, constant:0))
        
    }
    func addVisualConstraints(_ constraint: String, views: UIView...){
        var constraintDictionary = [String: UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            constraintDictionary.updateValue(view, forKey: key)
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: constraintDictionary))
        
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}
extension UIImage{
    class func scaleImageToSize(image: UIImage,size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        image.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
extension UIImageView{
    func session()-> URLSession{
        
        let sessDefined = Foundation.URLSession.shared
        
        return sessDefined
    }
    func getImageHandler(data: Data?,response: URLResponse?,error: Error?){
        
        if error == nil{
            if let dataImage = UIImage(data: data!){
            
                imageCache.setObject(dataImage, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = dataImage
                    if let loader = self.viewWithTag(33) as? UIActivityIndicatorView{
                        loader.stopAnimating()
                        loader.removeFromSuperview()
                    }
                }
            }
        }else{
            print(error?.localizedDescription)
        }
    }

    func loadImageWithURL(url: String){
        
        if let image = imageCache.object(forKey: url as AnyObject){
            DispatchQueue.main.async {
                self.image = image as UIImage
            }
            
        }else{
            let url = URL(string:url)
            if url != nil{
                var task = session().dataTask(with: url!, completionHandler: getImageHandler)
                task.resume()
            }
        }
        
    }
}


extension UIViewController{
    func withIdentifier(id: String)->UIViewController{
        return storyboard!.instantiateViewController(withIdentifier: id)
    }
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func showAlert(style: UIAlertController.Style, alertTitle: String, alertMessage: String, actionTitles: [String], actions: [((UIAlertAction)-> Void)?], completion: (()-> Void)?){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: style)
        for (index,title) in actionTitles.enumerated(){
            let handler = actions[index]
            let action = UIAlertAction(title: title, style: .default, handler:handler)
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: completion)
    }
}

extension UIView {
    
    func addGradientScreen(frame: CGRect, start: CGPoint, end: CGPoint, locations: [NSNumber], colors: [CGColor])-> CAGradientLayer{
        let gradient = CAGradientLayer()
            gradient.bounds = self.frame
            gradient.frame = frame
            gradient.startPoint = start
            gradient.endPoint = end
            gradient.locations = locations
            gradient.colors = colors
        
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}

extension UIButton{
    convenience init(title: String, color: UIColor, target: AnyObject?,selector: Selector){
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.addTarget(target, action: selector, for: .touchUpInside)
        
    }
}
extension UIFont{
    static func gymmieProfileFont()->UIFont{
        let font = UIFont.systemFont(ofSize: 14, weight: .light)
        return font
    }
}
