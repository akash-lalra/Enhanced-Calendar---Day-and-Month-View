//
//  CalendarVC.swift
//  Apni Kitty
//
//  Created by Pradeep singh on 26/07/16.
//  Copyright © 2016 NetSet. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController ,FSCalendarDataSource, FSCalendarDelegate ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var btnMonthView: UIButton!
    @IBOutlet weak var btnDayView: UIButton!
    @IBOutlet weak var lblMemberCount: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnArrangeEvent: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dateSelected = NSString()
    
    
    var items: [String] = ["Viper", "X-Man", "Games","Vip", "john" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="Calendar"
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Noteworthy-Bold", size: 15)! , NSForegroundColorAttributeName : constantVC.GlobalConstants.kColor_light_black]
        self.navigationController!.navigationBar.barTintColor=UIColor.whiteColor()
        
        lblDate.layer.cornerRadius=6
        lblDate.clipsToBounds=true
        btnArrangeEvent.layer.cornerRadius=16
        btnArrangeEvent.clipsToBounds=true
        dateSelectforEvent(NSDate())
        
        self.automaticallyAdjustsScrollViewInsets=false
        
        tableView.frame=CGRectMake(-tableView.frame.width, tableView.frame.origin.y, tableView.frame.width,tableView.frame.height)
        
        setCalendar()
        
        self.ViewBar.frame=CGRectMake(self.btnMonthView.frame.origin.x, self.btnDayView.frame.size.height-4, self.btnDayView.frame.size.width, 4)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden=false
        arrangeButtonDisable()
    }
    
    
    
    // Pragma Mark ------- Table view Delegate And DataSource For Day View ----------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    @IBAction func btnDayViewAction(sender: AnyObject) {
        animationForView("left")
    }
    
    @IBAction func btnMonthViewAction(sender: AnyObject) {
        
        animationForView("right")
    }
    
    //Animation for change the view(calandar to list View and list View to Calandar)
    
    func animationForView(direction: String)   {
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping:0.0, initialSpringVelocity: 0.0, options:[], animations: {
            if direction == "left"{
                self.ViewBar.frame=CGRectMake(0, self.btnDayView.frame.size.height-4, self.btnDayView.frame.size.width, 4)
                self.tableView.frame=CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.width,self.tableView.frame.height)
                self.viewMonth.frame=CGRectMake(self.view.frame.width, self.viewMonth.frame.origin.y, self.viewMonth.frame.width,self.viewMonth.frame.height)
                
            }else
            {
                self.ViewBar.frame=CGRectMake(self.btnMonthView.frame.origin.x, self.btnDayView.frame.size.height-4, self.btnDayView.frame.size.width, 4)
                self.tableView.frame=CGRectMake(-self.tableView.frame.width, self.tableView.frame.origin.y, self.tableView.frame.width,self.tableView.frame.height)
                self.viewMonth.frame=CGRectMake(0, self.viewMonth.frame.origin.y, self.viewMonth.frame.width,self.viewMonth.frame.height)
            }
            }, completion: nil)
    }
    
    // Pragma Mark ------- Calender view for Month ----------
    
    
    func setCalendar(){
        
        let previousButton: UIButton = UIButton(type: .Custom)
        previousButton.frame = CGRectMake(10, 8, 30, 30)
        previousButton.layer.cornerRadius=15
        previousButton.clipsToBounds=true
        previousButton.backgroundColor = constantVC.GlobalConstants.kColor_lightGrayColor
        previousButton.setImage(UIImage(named: "arrow-1")!, forState: .Normal)
        previousButton.addTarget(self, action: #selector(btnPreviousMonthAction), forControlEvents: .TouchUpInside)
        self.calendar!.addSubview(previousButton)
        
        
        let nextButton: UIButton = UIButton(type: .Custom)
        nextButton.frame = CGRectMake(CGRectGetWidth(calendar.frame) - 40, 8, 30, 30)
        nextButton.layer.cornerRadius=15
        nextButton.clipsToBounds=true
        nextButton.backgroundColor = constantVC.GlobalConstants.kColor_lightGrayColor
        nextButton.setImage(UIImage(named: "arrowSetting")!, forState: .Normal)
        nextButton.addTarget(self, action: #selector(btnNextMonthAction), forControlEvents: .TouchUpInside)
        self.calendar!.addSubview(nextButton)
        
        calendar.scrollDirection = .Horizontal
        
        calendar.appearance.caseOptions = [.HeaderUsesDefaultCase]
        //calendar.selectDate(calendar.dateWithYear(2015, month: 10, day: 10))
        calendar.selectDate(NSDate())
        // calendar.allowsMultipleSelection = true
        
        // Uncomment this to test month->week and week->month transition
        /*
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         self.calendar.setScope(.Week, animated: true)
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         self.calendar.setScope(.Month, animated: true)
         }
         }
         */
        
    }
    
    // change Month Pressing Left Right Button
    
    func btnPreviousMonthAction(){
        let currentMonth: NSDate = self.calendar.currentPage
        let previousMonth: NSDate = self.calendar.dateBySubstractingMonths(1, fromDate: currentMonth)
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    func btnNextMonthAction(){
        let currentMonth: NSDate = self.calendar.currentPage
        let previousMonth: NSDate = self.calendar.dateByAddingMonths(1, toDate: currentMonth)
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    
    //set Minimum date for calendar
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 1, day: 1)
    }
    
    //set Maximim date for calendar
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2020, month: 12, day: 31)
    }
    
    //func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
    //    let day = calendar.dayOfDate(date)
    //    return day % 5 == 0 ? day/5 : 0;
    //}
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
    
    
    // Pick Selected  Date
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
        
        arrangeButtonDisable()
        dateSelectforEvent(date)
        
        let  order = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: date, toUnitGranularity: .Hour)
        
        switch order {
        case .OrderedDescending:
            arrangeButtonDisable()
            print("DESCENDING")
        case .OrderedAscending:
            arrangeButtonEnable(date)
            print("ASCENDING")
        case .OrderedSame:
            arrangeButtonEnable(date)
            print("SAME")
        }
    }
    
    
    
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        view.layoutIfNeeded()
    }
    
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        return [13,24].containsObject(calendar.dayOfDate(date)) ? UIImage(named: "icon_cat") : nil
    }
    
    
    //button Enable Or disable
    
    func arrangeButtonDisable()  {
        btnArrangeEvent.enabled=false
        btnArrangeEvent.backgroundColor=UIColor(red: 243.0/255.0, green: 167.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        btnArrangeEvent.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
    }
    func arrangeButtonEnable(date:NSDate )  {
        btnArrangeEvent.enabled=true
        btnArrangeEvent.backgroundColor=constantVC.GlobalConstants.kColor_line_AppColor
        btnArrangeEvent.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" ///this is you want to convert format
        dateSelected = dateFormatter.stringFromDate(date)
        
    }
    
    //Date Selected Fot the Event
    
    func dateSelectforEvent(selectedDate: NSDate)  {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        let finalString: String = dateFormatter.stringFromDate(selectedDate)
        let attributedString = NSMutableAttributedString(string: finalString as String)
        
        // 2
        let firstAttributes = [NSForegroundColorAttributeName:constantVC.GlobalConstants.kColor_line_AppColor, NSBackgroundColorAttributeName: UIColor.clearColor(),NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 35.0)!]
        
        let thirdAttributes = [NSForegroundColorAttributeName:constantVC.GlobalConstants.kColor_line_AppColor,NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 14.0)!]
        
        // 3
        let strLength = finalString.characters.count
        
        attributedString.addAttributes(firstAttributes, range: NSMakeRange(0,2))
        attributedString.addAttributes(thirdAttributes, range: NSMakeRange(3, strLength-3))
        
        // 4
        lblDate.attributedText = attributedString
        lblDate.textAlignment=NSTextAlignment.Center
        lblDate.setNeedsLayout()
    }
    
    
    @IBAction func btnArrangeEventAction(sender: AnyObject) {
        self.performSegueWithIdentifier("arrangeEventIdentifier", sender:nil )
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "arrangeEventIdentifier" {
            let viewController:AddEvent = segue.destinationViewController as! AddEvent
            viewController.selectDate = dateSelected
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
