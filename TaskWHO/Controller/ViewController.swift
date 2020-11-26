//
//  ViewController.swift
//  TaskWHO
//
//  Created by Gayathri on 25/11/20.
//  Copyright © 2020 Gayathri. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate{
    @IBOutlet weak var collecList : UICollectionView!
    @IBOutlet weak var lblLatestSituation: UILabel!
    @IBOutlet weak var pageControl : UIPageControl!
    var arrMenuList = NSArray()
    var strCountry = String()
    let  displayDataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strCountry = Utils.getPreferenceValue(ForKey: Constant.COUNTRYCODE)
        arrMenuList = ["dashboard1","dashboard2"]
        lblLatestSituation.setTextSpacingBy(value: 0.5)
        displayPageControl()
    }
    //MARK:- Page Control
    func displayPageControl(){
        pageControl.numberOfPages = arrMenuList.count
        pageControl.currentPage = 0
        collecList.isPagingEnabled = true
    }
    //MARK:- ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collecList.contentOffset, size: self.collecList.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collecList.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    //MARK: - Null Value Check
    func isNsnullOrNil(object : AnyObject?) -> Bool{
        if (object is NSNull) || (object == nil){
            return true
        }else{
            return false
        }
    }
    //MARK:- Collection view Delegate Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenuList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let strProfilename:String = (arrMenuList.object(at: indexPath.row) as? String)!
        if(strProfilename == "dashboard1"){
            let menuCell:Dashboard_CollectionViewCell = collecList.dequeueReusableCell(withReuseIdentifier: "MENUCELLID", for: indexPath) as! Dashboard_CollectionViewCell
            menuCell.lblSwipeRight.setTextSpacingBy(value: 0.5)
            return menuCell
        }else{
            let menuCell2:Dashboard2_CollectionViewCell = collecList.dequeueReusableCell(withReuseIdentifier: "MENUCELLID2", for: indexPath) as! Dashboard2_CollectionViewCell
            menuCell2.lblConfirm.setTextSpacingBy(value: 0.5)
            menuCell2.lblSituationNos.text = "\(strCountry)'s Situation in Numbers"
            menuCell2.lblSituationNos.setTextSpacingBy(value: 0.5)
            DataSystem.sharedInstance.get{ (confirmData) in
                self.displayDataModel.confirmedCase = confirmData["CumCase"] as? Int
                self.displayDataModel.confirmDeath = confirmData["CumDeath"] as? Int
                if self.isNsnullOrNil(object: confirmData.value(forKey: "CumCase") as AnyObject?){
                }else{
                    let strConfirmedCase = String(self.displayDataModel.confirmedCase)
                    menuCell2.lblConfirmedCase.text = strConfirmedCase
                    menuCell2.lblConfirmedCase.setTextSpacingBy(value: 0.5)
                }
                if self.isNsnullOrNil(object: confirmData.value(forKey: "CumCase") as AnyObject?){
                }else{
                    menuCell2.lblConfirmedDeath.text = "\(String(self.displayDataModel.confirmDeath)) Total Deaths"
                    menuCell2.lblConfirmedDeath.setTextSpacingBy(value: 0.5)
                }
            }
            return menuCell2
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
}
extension UILabel {
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
