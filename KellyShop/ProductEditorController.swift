//
//  ProductEditorController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/23/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import RealmSwift

class CategoryCollectionCell : UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
}

class ProductEditorController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var stepperPrice: UIStepper!
    
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    var categories: Results<JSCategory>?
    var selectedCategory: JSCategory!
    
    var realm: Realm!
    
    override func viewDidLoad() {
        txtDescription.layer.cornerRadius = 4
        
        realm = try! Realm()
        categories = realm.objects(JSCategory)
        selectedCategory = categories?.first
        
        collectionCategory.dataSource = self
        collectionCategory.delegate = self
        
        updatePlaceHolder()
    }
    
    func updatePlaceHolder() {
        let categoryName = selectedCategory.name.lowercaseString
        txtDescription.placeholder = "mô tả thêm về \(categoryName)"
        txtName.placeholder = "tên \(categoryName)"
        txtPrice.placeholder = "giá \(categoryName)"
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryCollectionCell
        let index = indexPath.row
        if let category = categories?[index] {
            Logger.log("category \(category.name) icon \(category.icon)")
            if !category.icon.isEmpty {
                let image = ImageHelper.imageWithImage(UIImage(named: category.icon)!, scaledToSize: CGSize(width: cell.frame.width, height: cell.frame.height)).imageWithRenderingMode(.AlwaysTemplate)
                cell.imageView.image = image
                if category.id == selectedCategory.id {
                    cell.imageView.backgroundColor = UIColor.whiteColor()
                    cell.imageView.layer.cornerRadius = cell.imageView.frame.width / 2
                    cell.imageView.tintColor = ColorHelper.APP_DEFAULT
                } else {
                    cell.imageView.backgroundColor = UIColor.clearColor()
                    cell.imageView.layer.cornerRadius = 0
                    cell.imageView.tintColor = ColorHelper.APP_DEFAULT_GRAY
                }
                cell.imageView.clipsToBounds = true
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        Logger.log("select category at index \(indexPath.row)")
        let index = indexPath.row
        selectedCategory = categories?[index]
        collectionView.reloadData()
        updatePlaceHolder()
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width
        let cellCount = CGFloat(collectionView.numberOfItemsInSection(section))
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        let totalCellWidth = cellCount * cellWidth
        let totalCellSpacing = cellSpacing * (cellCount - 1)
        
        let totalCellsWidth = totalCellWidth + totalCellSpacing
        
        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
        
        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
    }
}
