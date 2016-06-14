//
//  RaiseMetricsViewController.swift
//  raisemetrics
//
//  Created by Stanislav Rastvorov on 10.06.16.
//  Copyright © 2016 Stanislav Rastvorov. All rights reserved.
//

import UIKit

class RaiseMetricsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        loadNotes()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTheResponse(dict : Dictionary<String, AnyObject>) {
        if let card = dict["card"] as? Dictionary<String, AnyObject> {
            print(card)
            
            // Load the font
            var cardFont = "HelveticaNeue"
            if let loadedFont = card["font"] as? String {
                if loadedFont != "system" {
                    cardFont = loadedFont
                }
            }
            
            // Creating the card view
            let cardView = UIView(frame: CGRectMake(20.0, 20.0, UIScreen.mainScreen().bounds.size.width - 40.0, UIScreen.mainScreen().bounds.size.height - 40.0))
            cardView.backgroundColor = UIColor.whiteColor()
            view.addSubview(cardView)
            
            // Setting the card view border radius
            if let borderRadius = card["border_radius"] as? CGFloat {
                cardView.layer.cornerRadius = borderRadius
                cardView.layer.masksToBounds = true
            }
            
            // Setting the header
            if let header = card["header"] as? Dictionary<String, AnyObject> {
                let headerView = UIView(frame: CGRectMake(0, 0, cardView.frame.width, 132.0))
                cardView.addSubview(headerView)
                
                // Setting the header background color
                if let headerBGColor = header["bg_color"] as? String {
                    headerView.backgroundColor = hexStringToUIColor(headerBGColor)
                }
                
                // Load header image
                if let imgURL = header["bg_img"] as? String {
                    if let checkedUrl = NSURL(string: imgURL) {
                        // you can use checkedUrl here
                        print(checkedUrl)
                        
                        let data = NSData(contentsOfURL:checkedUrl)
                        if data != nil {
                            print(UIImage(data:data!))
                            
                            let headerImage = UIImageView(frame: CGRectMake(0, 0, cardView.frame.width, 132.0))
                            headerImage.image = UIImage(data:data!)
                            cardView.addSubview(headerImage)
                        }
                    }
                }
                
                // Setting the header text and it's color
                if let headerText = header["txt"] as? String {
                    let headerTextLabel = UILabel(frame: CGRectMake(20.0, 20.0, headerView.frame.width - 40.0, headerView.frame.height - 40.0))
                    headerTextLabel.text = headerText
                    headerTextLabel.textAlignment = NSTextAlignment.Center
                    headerTextLabel.font = UIFont(name: cardFont, size: 27.0)
                    cardView.addSubview(headerTextLabel)
                    
                    // Header label color
                    if let labelColor = header["txt_color"] as? String {
                        headerTextLabel.textColor = hexStringToUIColor(labelColor)
                    }
                }
            }
            
            // Setting the close button
            if let button = card["btn"] as? Dictionary<String, AnyObject> {
                let closeButton = UIButton(frame: CGRectMake(20.0, cardView.frame.height - 64.0, cardView.frame.width - 40.0, 44.0))
                closeButton.addTarget(self, action: #selector(RaiseMetricsViewController.closeTheView), forControlEvents: UIControlEvents.TouchUpInside)
                cardView.addSubview(closeButton)
                
                // Setting close button title
                if let title = button["txt"] as? String {
                    closeButton.setTitle(title, forState: UIControlState.Normal)
                }
                
                // Setting close button background
                if let bgColor = button["bg_color"] as? String {
                    closeButton.backgroundColor = hexStringToUIColor(bgColor)
                }
                
                // Setting close button text color
                if let textColor = button["txt_color"] as? String {
                    closeButton.setTitleColor(hexStringToUIColor(textColor), forState: UIControlState.Normal)
                }
                
                // Setting close button border radius
                if let borderRadius = button["border_radius"] as? CGFloat {
                    if borderRadius > 22 {
                        closeButton.layer.cornerRadius = 22
                    }
                    else {
                        closeButton.layer.cornerRadius = borderRadius
                    }
                }
                
                // Setting the line
                let lineView = UIView(frame: CGRectMake(0, cardView.frame.height - 20.0 - 44.0 - 20.0, cardView.frame.width, 1))
                lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
                cardView.addSubview(lineView)
            }
            
            // Creating the features
            if let features = card["features"] as? [Dictionary<String, AnyObject>] {
                if features.count > 0 {
                    // Creating a scroll view for features
                    let scrollView = UIScrollView(frame: CGRectMake(0, 132, cardView.frame.width, cardView.frame.height - 132.0 - 67 - 22))
                    scrollView.contentSize = CGSize(width: cardView.frame.width, height: 20.0 + 70.0 * CGFloat(features.count) + 60.0)
                    cardView.addSubview(scrollView)
                    
                    for i in 0..<features.count {
                        var description = ""
                        var icon = ""
                        var iconColor = ""
                        var title = ""
                        
                        // Getting feature description
                        if let descriptionText = features[i]["description"] as? String {
                            description = descriptionText
                        }
                        
                        // Getting feature icon
                        if let iconText = features[i]["icon"] as? String {
                            icon = iconText
                        }
                        
                        // Getting feature icon color
                        if let iconColorText = features[i]["icon_color"] as? String {
                            iconColor = iconColorText
                        }
                        
                        // Getting feature title
                        if let titleText = features[i]["title"] as? String {
                            title = titleText
                        }
                        
                        // Checking parameters and creating the feature view
                        if description != "" && icon != "" && iconColor != "" && title != "" {
                            scrollView.addSubview(createFeature(CGRectMake(20.0, 20.0 + 70.0 * CGFloat(i), cardView.frame.width - 40.0, 60.0), description: description, icon: icon, iconColor: iconColor, title: title, font: cardFont))
                        }
                    }
                }
            }
        }
    }
    
    func createFeature(rect : CGRect, description : String, icon : String, iconColor : String, title : String, font : String) -> UIView {
        let featureView = UIView(frame: rect)
        
        // Icon image from the Awesome Font code
        let label = UILabel(frame: CGRectMake(0, 8, 44, 44))
        label.font = UIFont.fontAwesomeOfSize(40)
        label.text = String.fontAwesomeIconWithCode(icon)
        label.textColor = hexStringToUIColor(iconColor)
        label.textAlignment = NSTextAlignment.Center
        featureView.addSubview(label)
        
        // Title label
        let titleLabel = UILabel(frame: CGRectMake(60, 0, featureView.frame.width - 60, 22))
        titleLabel.text = title
        titleLabel.font = UIFont(name: font, size: 16.0)
        titleLabel.textColor = UIColor(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        featureView.addSubview(titleLabel)
        
        // Description label
        let descriptionLabel = UILabel(frame: CGRectMake(60, 22, featureView.frame.width - 60, 38))
        descriptionLabel.text = description
        descriptionLabel.font = UIFont(name: font, size: 14.0)
        descriptionLabel.textColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
        descriptionLabel.numberOfLines = 2
        featureView.addSubview(descriptionLabel)
        
        return featureView
    }
    
    func closeTheView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadNotes() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.raisemetrics.com/v1/release-notes/com.fliptrendy.fliptrendy?client_id=7e13cc7680ee242bbe722d3fcbe872e&app_version=\(version)")!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let urlContent = data {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    if let error = jsonResult["error"] as? String {
                        print("Error: \(error)")
                        dispatch_async(dispatch_get_main_queue()) {
                            () -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                    else {
                        if let json = jsonResult as? Dictionary<String, AnyObject> {
                            dispatch_async(dispatch_get_main_queue()) {
                                () -> Void in
                                self.checkTheResponse(json)
                            }
                        }
                    }
                } catch {
                    print("JSON Serialization failed")
                    dispatch_async(dispatch_get_main_queue()) {
                        () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
