//
//  RaiseMetricsViewController.swift
//  raisemetrics
//
//  Created by Stanislav Rastvorov on 10.06.16.
//  Copyright © 2016 Stanislav Rastvorov. All rights reserved.
//

import UIKit

class RaiseMetricsViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    var buttonTitles = [String]()
    var continueButton = UIButton()
    var parallaxImageView = UIImageView()
    var isAnimating = false
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 50.0)/2, (UIScreen.mainScreen().bounds.size.height - 50.0)/2, 50.0, 50.0))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        loadNotes()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTheResponse(dict : Dictionary<String, AnyObject>) {
        print(dict)
        
        // It's a card view with features list
        if let card = dict["card"] as? Dictionary<String, AnyObject> {
            createCard(card)
        }
        // It's an Onboarding view
        if let pages = dict["pages"] as? [Dictionary<String, AnyObject>] {
            if let settings = dict["settings"] as? Dictionary<String, AnyObject> {
                createOnboarding(pages, settings: settings)
            }
        }
    }
    
    func createOnboarding(pages : [Dictionary<String, AnyObject>], settings : Dictionary<String, AnyObject>) {
        if pages.count > 0 {
            // Creating the horizontal scroll view and setting the number of pages on it
            scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width * CGFloat(pages.count), height: UIScreen.mainScreen().bounds.size.height)
            scrollView.pagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            scrollView.bounces = false
            view.addSubview(scrollView)
            activityIndicator.alpha = 0.0
            
            // Checking the parallax and setting the view background
            var isParallax = false
            
            // FOR TESTING PURPOSES
            if version == "onboardingWithParallax" {
                let parallaxString = "https://dl.dropboxusercontent.com/u/20225495/775.jpg"
                isParallax = true
                //
                if let checkedUrl = NSURL(string: parallaxString) {
                    // you can use checkedUrl here
                    let data = NSData(contentsOfURL:checkedUrl)
                    if data != nil {
                        let width = UIImage(data:data!)?.size.width
                        let height = UIImage(data:data!)?.size.height
                        print("Widht - \(width), height - \(height)")
                        
                        parallaxImageView = UIImageView(frame: CGRectMake(0, 0, width! / height! * UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.height))
                        parallaxImageView.image = UIImage(data:data!)
                        scrollView.addSubview(parallaxImageView)
                    }
                }//
            }
            else {
                if let parallaxString = settings["parallaxBackgroundImage"] as? String {
                    isParallax = true
                    //
                    if let checkedUrl = NSURL(string: parallaxString) {
                        // you can use checkedUrl here
                        let data = NSData(contentsOfURL:checkedUrl)
                        if data != nil {
                            let width = UIImage(data:data!)?.size.width
                            let height = UIImage(data:data!)?.size.height
                            print("Widht - \(width), height - \(height)")
                            
                            parallaxImageView = UIImageView(frame: CGRectMake(0, 0, width! / height! * UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.height))
                            parallaxImageView.image = UIImage(data:data!)
                            scrollView.addSubview(parallaxImageView)
                        }
                    }
                    //
                }
            }
            
            for i in 0..<pages.count {
                // Creating the view for the current page
                let pageView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width * CGFloat(i), 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
                scrollView.addSubview(pageView)
                
                // Save button titles
                // The standard title is the one from the Page 1
                if let continueButtonTitle = pages[i]["buttonTitle"] as? String {
                    buttonTitles.append(continueButtonTitle)
                }
                
                // Load background image
                if let backgroundImageString = pages[i]["backgroundImage"] as? String {
                    if let checkedUrl = NSURL(string: backgroundImageString) {
                        // you can use checkedUrl here
                        let data = NSData(contentsOfURL:checkedUrl)
                        if data != nil {
                            let backgroundImage = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
                            if !isParallax {
                                backgroundImage.image = UIImage(data:data!)
                            }
                            pageView.addSubview(backgroundImage)
                        }
                    }
                }
                    // Background gradient - if we don't have a background image
                else if let bottomGradient = pages[i]["backgroundStartColor"] as? String {
                    if let topGradient = pages[i]["backgroundEndColor"] as? String {
                        if !isParallax {
                            pageView.layer.insertSublayer(createGradientViewWithColors(hexStringToUIColor(topGradient), bottomColor: hexStringToUIColor(bottomGradient)), atIndex: 0)
                        }
                    }
                }
                
                var imageBottom: CGFloat = 0.0
                // Image
                if let imageString = pages[i]["image"] as? String {
                    if let checkedUrl = NSURL(string: imageString) {
                        // you can use checkedUrl here
                        let data = NSData(contentsOfURL:checkedUrl)
                        if data != nil {
                            let image = UIImageView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 300.0)/2, (UIScreen.mainScreen().bounds.size.height - 300.0 - 80.0)/2, 300.0, 300.0))
                            
                            imageBottom = (UIScreen.mainScreen().bounds.size.height - 300.0 - 80.0)/2 + 310.0
                            
                            if !isParallax {
                                image.image = UIImage(data:data!)
                            }
                            pageView.addSubview(image)
                        }
                    }
                }
                
                // Calculating the top coordinate of title depending on if we have an image to show
                var titleTop: CGFloat = 0
                if imageBottom != 0 {
                    titleTop = imageBottom
                }
                else {
                    titleTop = (UIScreen.mainScreen().bounds.size.height - 30.0 - 80.0)/2
                }
                
                // Placing a page title
                if let pageTitle = pages[i]["title"] as? String {
                    if let pageTitleColor = pages[i]["titleColor"] as? String {
                        let pageTitleLabel = UILabel(frame: CGRectMake(32.0, titleTop, UIScreen.mainScreen().bounds.size.width - 64.0, 30.0))
                        pageTitleLabel.textColor = hexStringToUIColor(pageTitleColor)
                        pageTitleLabel.text = pageTitle
                        pageTitleLabel.textAlignment = NSTextAlignment.Center
                        pageTitleLabel.font = UIFont.systemFontOfSize(18.0)
                        pageView.addSubview(pageTitleLabel)
                        
                        // Placing a page description
                        if let description = pages[i]["description"] as? String {
                            if let descriptionColor = pages[i]["descriptionColor"] as? String {
                                let descriptionLabel = UILabel(frame: CGRectMake(32.0, titleTop + 30.0, UIScreen.mainScreen().bounds.size.width - 64.0, 44.0))
                                descriptionLabel.textColor = hexStringToUIColor(descriptionColor)
                                descriptionLabel.text = description
                                descriptionLabel.textAlignment = NSTextAlignment.Center
                                descriptionLabel.font = UIFont.systemFontOfSize(14.0)
                                descriptionLabel.numberOfLines = 2
                                pageView.addSubview(descriptionLabel)
                            }
                        }
                    }
                }
                
            }
            
            // Skip button - top right
            if let skipButtonColorString = settings["skipButtonColor"] as? String {
                if let skipButtonColorHighlightedString = settings["skipButtonColorHighlighted"] as? String {
                    if let skipButtonTitleString = settings["skipButtonTitle"] as? String {
                        let skipButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - 40.0 - 8.0, 24.0, 40.0, 22.0))
                        skipButton.setTitleColor(hexStringToUIColor(skipButtonColorString), forState: UIControlState.Normal)
                        skipButton.setTitleColor(hexStringToUIColor(skipButtonColorHighlightedString), forState: UIControlState.Highlighted)
                        skipButton.setTitle(skipButtonTitleString, forState: UIControlState.Normal)
                        skipButton.addTarget(self, action: #selector(RaiseMetricsViewController.closeTheView), forControlEvents: UIControlEvents.TouchUpInside)
                        view.addSubview(skipButton)
                        
                        // Check if Skip button is visible
                        if let showSkipButton = settings["showSkipButton"] as? Int {
                            if showSkipButton != 1 {
                                skipButton.alpha = 0.0
                            }
                        }
                    }
                }
            }
            
            // Continue button - bottom
            if let staticContinueButtonBackgroundColorString = settings["staticContinueButtonBackgroundColor"] as? String {
                if let staticContinueButtonCornerRadiusNumber = settings["staticContinueButtonCornerRadius"] as? Int {
                    if let staticContinueButtonTitleColorString = settings["staticContinueButtonTitleColor"] as? String {
                        continueButton = UIButton(frame: CGRectMake(32.0, UIScreen.mainScreen().bounds.size.height - 80.0, UIScreen.mainScreen().bounds.size.width - 64.0, 60.0))
                        // The standard title is the one from the Page 1
                        if buttonTitles.count > 0 {
                            continueButton.setTitle(buttonTitles[0], forState: UIControlState.Normal)
                        }
                        //
                        continueButton.backgroundColor = hexStringToUIColor(staticContinueButtonBackgroundColorString)
                        continueButton.layer.cornerRadius = CGFloat(staticContinueButtonCornerRadiusNumber)
                        continueButton.setTitleColor(hexStringToUIColor(staticContinueButtonTitleColorString), forState: UIControlState.Normal)
                        continueButton.addTarget(self, action: #selector(RaiseMetricsViewController.continueButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
                        view.addSubview(continueButton)
                    }
                }
            }
            
            // Page Control
            var pageControlY:CGFloat = 24.0
            // Check if page control is on the bottom
            if let pageIndicatorsPosition = settings["pageIndicatorsPosition"] as? String {
                if pageIndicatorsPosition == "bottom" {
                    pageControlY = UIScreen.mainScreen().bounds.size.height - 100.0
                }
            }
            
            pageControl = UIPageControl(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 40.0)/2, pageControlY, 40.0, 16.0))
            pageControl.numberOfPages = pages.count
            pageControl.currentPage = 0
            if let pageIndicatorColor = settings["pageIndicatorColor"] as? String {
                pageControl.pageIndicatorTintColor = hexStringToUIColor(pageIndicatorColor)
            }
            if let pageIndicatorColorSelected = settings["pageIndicatorColorSelected"] as? String {
                pageControl.currentPageIndicatorTintColor = hexStringToUIColor(pageIndicatorColorSelected)
            }
            
            view.addSubview(pageControl)
            
            // Check if we should display page indicators
            if let showPageIndicators = settings["showPageIndicators"] as? Int {
                if showPageIndicators != 1 {
                    pageControl.alpha = 0.0
                }
            }
            
        }
    }
    
    func continueButtonPressed() {
        // Checkig the current page and scrolling the view to the next, if the last page is opened we close the view
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        
        if pageNumber == buttonTitles.count - 1 {
            closeTheView()
        }
        else {
            scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.size.width * CGFloat(pageNumber + 1), 0), animated: true)
            
            pageControl.currentPage = pageNumber+1
            if buttonTitles.count > 0 {
                continueButton.setTitle(buttonTitles[pageNumber+1], forState: UIControlState.Normal)
            }
        }
        
        parallaxAnimation()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageChanged()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        parallaxAnimation()
    }
    
    func pageChanged() {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        if buttonTitles.count > 0 {
            continueButton.setTitle(buttonTitles[Int(pageNumber)], forState: UIControlState.Normal)
        }
        
        parallaxAnimation()
    }
    
    func parallaxAnimation() {
        if !isAnimating {
            isAnimating = true
            
            // Move animation to change the parallax background position
            UIView.animateWithDuration(0.2, animations: {
                let width = self.parallaxImageView.frame.size.width
                let height = self.parallaxImageView.frame.size.height
                
                if self.pageControl.currentPage == 0 {
                    self.parallaxImageView.frame = CGRectMake(0, 0, width, height)
                }
                else if self.pageControl.currentPage == self.buttonTitles.count - 1 {
                    self.parallaxImageView.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width * CGFloat(self.buttonTitles.count) - width, 0, width, height)
                }
                else {
                    var offset = 0
                    if self.buttonTitles.count > 3 {
                        offset = self.buttonTitles.count - 3
                    }
                    
                    if self.parallaxImageView.frame != CGRectMake((UIScreen.mainScreen().bounds.size.width * 3.0 - width)/2 + CGFloat(offset) * UIScreen.mainScreen().bounds.size.width, 0, width, height) {

                        self.parallaxImageView.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width * 3.0 - width)/2 + CGFloat(offset) * UIScreen.mainScreen().bounds.size.width, 0, width, height)
                    }
                }
            }) { (true) in
                self.isAnimating = false
            }
        }
    }
    
    func createGradientViewWithColors(topColor : UIColor, bottomColor : UIColor) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [topColor.CGColor, bottomColor.CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        return gradient
    }
    
    func createCard(card : Dictionary<String, AnyObject>) {
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
        // Checking the version and creating the request string, now we have 3 options: 1.0.2 version, 1.0.3 version and onboarding
        var requestString = "http://api.raisemetrics.com/v1/release-notes/com.fliptrendy.fliptrendy?client_id=7e13cc7680ee242bbe722d3fcbe872e&app_version=\(version)"
        if version == "onboarding" || version == "onboardingWithParallax" {
            requestString = "http://api.raisemetrics.com/v1/onboarding/com.fliptrendy.fliptrendy?client_id=7e13cc7680ee242bbe722d3fcbe872e"
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
        
        let session = NSURLSession.sharedSession()
        
        /*
         let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
         urlconfig.timeoutIntervalForRequest = 3
         urlconfig.timeoutIntervalForResource = 3
         session = NSURLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
         */
        
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
