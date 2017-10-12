//
//  FeesViewController.swift
//  together
//
//  Created by ASda Bogasd on 17.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate{
    
    @IBOutlet weak var filtersPiker: UIPickerView!
    @IBOutlet var avatarImage: UIButton!
    @IBOutlet weak var myColectionView: UICollectionView!
    @IBOutlet weak var loginView: UILabel!
    @IBOutlet weak var mySerchBar: UISearchBar!
    @IBOutlet weak var myColectionViewHeight: NSLayoutConstraint!
   
    var pickerData: [String] = [String] ()
    var buttonState: Array<Bool> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        MainUserRepo.shared.getCurrentUser(userId: MainUserRepo.shared.getUser().getId())
            .then{ user -> Void in
                self.avatarImage.setImage(user.getPhoto(), for: .normal)
                self.loginView.text = user.name
        }
        
        EventListRepo.shared.updateEventList()
            .then{eventList -> Void in
                self.myColectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mySerchBar.isHidden = true
        //self.myColectionViewHeight.constant = 489
        self.myColectionView.layoutIfNeeded()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = pickerData[row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightRegular)])
        
        label?.attributedText = title
        label?.textAlignment = .center
        label?.textColor = UIColor.white
        return label!
    }
    
    
    //Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let eventList = EventListRepo.shared.getEventList()
        
        if (eventList[indexPath.row].isLiked(id: MainUserRepo.shared.getUser().getId())){
            cell.likeButton.isSelected = true
        } else {
            cell.likeButton.isSelected = false
        }
        
        cell.eventPhoto.image = eventList[indexPath.row].getPhoto()
        cell.eventTitle.text =  eventList[indexPath.row].getTitle()
        cell.eventDescription.text = eventList[indexPath.row].getDescription()
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func updateCollection() {
        EventListRepo.shared.updateEventList()
            .then{_ in 
                self.myColectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellInRow : Int = 3
        let padding : Int = 2
        let collectionCellWidth : CGFloat = ((self.view.frame.size.width)/CGFloat(numberOfCellInRow)) - CGFloat(padding)
        return CGSize(width: collectionCellWidth , height: (collectionCellWidth/100*25) + collectionCellWidth)
    }
    
    func buttonClicked(sender: UIButton) {
        EventListRepo.shared.likePressed(index: sender.tag, id: MainUserRepo.shared.getUser().getId())
        updateCollection()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EventListRepo.shared.getEventCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EventListRepo.shared.setSelectedIndex(newIndex: indexPath.row)
       self.performSegue(withIdentifier: "fromFeedToEvent", sender: self)
    }
    
    //Mark Action
    @IBAction func createButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "fromFeedToCreateEvent", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromFeedToProfile") {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.userId = MainUserRepo.shared.getUser().getId()
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    
    func setUpView(){
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2;
        self.avatarImage.clipsToBounds = true;
        self.avatarImage.layer.borderWidth = 1.0
        self.avatarImage.layer.borderColor = UIColor.white.cgColor
        pickerData = ["Category".localized,"Celebretion".localized, "Helping".localized]
        self.filtersPiker.delegate = self
        self.filtersPiker.dataSource = self
        self.mySerchBar.delegate = self
        mySerchBar.isHidden = true
    }
    
}
