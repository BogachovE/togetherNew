//
//  EventViewController.swift
//  together
//
//  Created by ASda Bogasd on 21.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit
import Firebase
import KCFloatingActionButton
import MessageUI
import Social
import EventKit
import AMGCalendarManager


class EventViewController: UIViewController, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    var fab = KCFloatingActionButton()
    
    @IBOutlet weak var eventPhoto: UIImageView!
    @IBOutlet weak var eventDataStart: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventParticipants: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreIcon: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var wishListIcon: UIImageView!
    @IBOutlet weak var wishListTable: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dellButton: UIButton!
    @IBOutlet weak var editButtonTitle: UILabel!
    @IBOutlet weak var dellButtonTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventListRepo.shared.updateEventList()
            .then{ eventList -> Void in
                EventListRepo.shared.setEventList(newEventList: eventList)
                self.showEventInfo()
                self.wishListTable.reloadData()
        }
        layoutFAB()
        wishListTable.delegate = self
        wishListTable.dataSource = self
        editButtonTitle.text = "Edit".localized
        dellButtonTitle.text = "Dell".localized
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showEventInfo(){
        let event = EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()]
        if(event.isLiked(id: MainUserRepo.shared.getUser().getId())) { self.likeButton.isSelected = true}
        if ( MainUserRepo.shared.getUser().getId() == event.getOwnerId()){
            editButton.isHidden = false
            dellButton.isHidden = false
            editButtonTitle.isHidden = false
            dellButtonTitle.isHidden = false
        }
        
        self.eventPhoto.image = event.getPhoto()
        self.eventDataStart.text! = event.getStartTime()
        self.eventLocation.text! = event.getLocation()
        self.eventParticipants.text! = "\(event.getParticipantsCount())"
        self.eventDescription.text! = event.getDescription()
        self.eventTitle.text! = event.getTitle()
        
        
    }
    
    func layoutFAB() {
        fab.buttonColor = UIColor(red:0.41, green:0.94, blue:0.68, alpha:1.0)
        fab.plusColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        let titles: Array<String> = ["Share to facebook".localized, "Share by email".localized, "Share to instagram".localized, "Share to twiter".localized]
        let types: Array<String> = ["face", "email", "incta", "twiter"]
        let icons: Array<UIImage> = [#imageLiteral(resourceName: "faceBtn"),#imageLiteral(resourceName: "EmailBtn"), #imageLiteral(resourceName: "inctaBtn"), #imageLiteral(resourceName: "twiterBtn")]
        for i in 0...3{
            let item = KCFloatingActionButtonItem()
            item.buttonColor = UIColor(red:0.41, green:0.94, blue:0.68, alpha:1.0)
            item.circleShadowColor = UIColor.red
            item.titleShadowColor = UIColor.blue
            item.icon = icons[i]
            item.title = titles[i]
            item.handler = { item in
                if #available(iOS 10.0, *) {
                    self.share(type: types[i])
                } else {
                }
            }
            fab.addItem(item: item)
        }
        
        fab.sticky = true
        
        
        self.view.addSubview(fab)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0,width: newSize.width,height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
        @available(iOS 10.0, *)
        func share(type: String){
            switch (type) {
            case "face":
                shareFace(event:EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()])
            case "email":
                shareByEmail(event: EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()])
            case "wat":
                SocialShare.whatsappShare(event:EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()])
            case "incta":
                InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram:EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()].photo, instagramCaption: "\(EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()].description)", view: self.view)
                case "twiter":
                shareTwit(event: EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()])
    
            default :
                print("Switch error")
            }
        }
    
    func shareByEmail(event: EventModel){
        let mailComposeViewController = configuredMailComposeViewController(event: event)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController(event: EventModel) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        mailComposerVC.setSubject("Email from Together")
        mailComposerVC.setMessageBody("Hi I want to show you something event://together/\(event.getId())", isHTML: false)
        
        let data = UIImagePNGRepresentation(event.photo) as NSData?
        
        mailComposerVC.addAttachmentData(data as! Data, mimeType: "hz", fileName: "event.jpg")
        
        
        return mailComposerVC
    }
    
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    func shareFace(event: EventModel){
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("Look at this great picture!")
            vc.add(event.photo)
            vc.add(URL(string: "event://together/\(event.getId())"))
            present(vc, animated: true)
        }
        
    }
    func shareTwit(event: EventModel){
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText("Look!" + "event://together/\(event.id!)")
            vc.add(event.photo)
            vc.add(URL(string: "event://together/\(event.id)"))
            present(vc, animated: true)
        }
        
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "eventEdit"){
            let svc = segue.destination as! CreateNewEventViewController
            svc.isItEdit = true
        }
    }
    
    //table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()].getWishCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()]
        let cell = wishListTable.dequeueReusableCell(withIdentifier: "eventTableviewcell", for: indexPath) as! WishListTableViewCell
        cell.link.setTitle(event.getWishList()[indexPath.row].getWishName(), for: .normal)
        cell.checkbox.tag = indexPath.row
        cell.checkbox.addTarget(self, action: #selector(self.checkClicked(sender:)), for: UIControlEvents.touchUpInside)
        cell.link.tag = indexPath.row
        cell.link.addTarget(self, action: #selector(self.linkClicked(sender:)), for: UIControlEvents.touchUpInside)
        let (bool, _) = event.wishList[indexPath.row].isDone()
        if(bool) {
            cell.checkbox.isSelected = true
        } else {
            cell.checkbox.isSelected = false
        }
        
        return cell
    }
    
    func checkClicked(sender: UIButton) {
        let event = EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()]
        event.getWishList()[sender.tag].checkPressed(myId: MainUserRepo.shared.getUser().getId())
        EventRes.updateEvent(event: event)
        wishListTable.reloadData()
    }
    
    func linkClicked(sender: UIButton) {
        let _URL = URL(string: EventListRepo.shared.getEventList()[EventListRepo.shared.getSelectedIndex()].getWishList()[sender.tag].getWishUrl())!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(_URL, options: [:])
        } else {
            UIApplication.shared.openURL(_URL)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func makeNewCalendarMark(date: Date, title: String, notes: String){
        AMGCalendarManager.shared.createEvent(completion: { (event) in
            guard let event = event else { return }
            
            event.startDate = date
            event.endDate = event.startDate.addingTimeInterval(60 * 60 * 1) // 1 hour
            event.title = title
            event.notes = notes
            
            AMGCalendarManager.shared.saveEvent(event: event)
        })
    }
    
    //Actions
    @IBAction func editButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "eventEdit", sender: self)
    }
    @IBAction func dellButtonPressed(_ sender: Any) {
        let index = EventListRepo.shared.getSelectedIndex()
        EventListRepo.shared.removeEvent(eventId:  EventListRepo.shared.getEventList()[index].getId())
            .then{ _ -> Void in
        }
    }
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        if(eventDescription.isHidden){
        likeButton.isHidden = true
        eventDescription.isHidden = false
        wishListIcon.isHidden = true
        wishListTable.isHidden = true
        moreButton.setTitle("Less", for: .normal)
        } else {
            likeButton.isHidden = false
            eventDescription.isHidden = true
            wishListIcon.isHidden = false
            wishListTable.isHidden = false
            moreButton.setTitle("More", for: .normal)
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        let event = EventListRepo.shared.getEventList()[EventListRepo.shared.selectedEventIndex!]
       event.likePressed(id: MainUserRepo.shared.getUser().getId())
        if (event.isLiked(id: MainUserRepo.shared.getUser().getId())) {
            likeButton.isSelected = true
        } else {
            likeButton.isSelected = false
        }
        EventRes.updateEvent(event: event)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
            performSegue(withIdentifier: "fromEventToFeed", sender: self)
    }
    
}
