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
import ImagePicker
import SwiftSpinner
import NYTPhotoViewer

class ProductEditorController: UIViewController, UICollectionViewDelegate, ImagePickerDelegate {
    
    let kCornerRadius:CGFloat = 5
    
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var txtTransferPrice: UITextField!
    
    @IBOutlet weak var txtSellPrice: UITextField!
    
    @IBOutlet weak var stepperPrice: UIStepper!
    
    @IBOutlet weak var stepperTransferPrice: UIStepper!
    
    @IBOutlet weak var stepperSellPrice: UIStepper!
    
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    @IBOutlet weak var collectionPhoto: UICollectionView!
    
    var realm: Realm!
    
    var categoryDataSource: CategoryCollectionDataSource!
    
    var photoDataSource: PhotoCollectionDataSource!
    
    var product: JSProduct?
    
    override func viewDidLoad() {
        initLayout()
        realm = try! Realm()
        initCollectionViews()
        updatePlaceHolder()
        product = JSProduct()
    }
}

/*
 Data section
 */
extension ProductEditorController {
    
}

/**
 Layout section
 */
extension ProductEditorController {
    func initLayout() {
        txtDescription.layer.cornerRadius = kCornerRadius
        collectionPhoto.layer.cornerRadius = kCornerRadius
    }
    func updatePlaceHolder() {
        let categoryName = categoryDataSource.selectedCategory.name.lowercaseString
        txtDescription.placeholder = "mô tả thêm về \(categoryName)"
        txtName.placeholder = "tên \(categoryName)"
    }
}

/**
 Price section
 */
extension ProductEditorController {
    
    func getTextFieldValue(textField: UITextField) -> Int {
        if textField.text != nil && !(textField.text?.isEmpty)! {
            return Int(textField.text!)!
        } else {
            return 0
        }
    }
    
    func validatePrice() {
        product?.basePrice = getTextFieldValue(txtPrice)
        product?.transferPrice = getTextFieldValue(txtTransferPrice)
        product?.sellPrice = getTextFieldValue(txtSellPrice)
        if product?.transferPrice < product?.basePrice {
            product?.transferPrice = (product?.basePrice)!
            txtTransferPrice.text = String(product!.transferPrice)
            stepperTransferPrice.value = Double(product!.transferPrice)
        }
        if product?.sellPrice < product?.transferPrice {
            product?.sellPrice = (product?.transferPrice)!
            txtSellPrice.text = String(product!.sellPrice)
            stepperSellPrice.value = Double(product!.sellPrice)
        }
    }
    
    @IBAction func txtPriceValueChanged(sender: UITextField) {
        stepperPrice.value = Double(getTextFieldValue(sender))
        validatePrice()
    }
    
    @IBAction func txtTransferPriceValueChanged(sender: UITextField) {
        stepperTransferPrice.value = Double(getTextFieldValue(sender))
        validatePrice()
    }
    
    @IBAction func txtSellPriceValueChanged(sender: UITextField) {
        stepperSellPrice.value = Double(getTextFieldValue(sender))
        validatePrice()
    }
    
    @IBAction func stPriceValueChanged(sender: UIStepper) {
        self.txtPrice.text = String(Int(sender.value))
        validatePrice()
    }
    
    @IBAction func stTransferValueChanged(sender: UIStepper) {
        self.txtTransferPrice.text = String(Int(sender.value))
        validatePrice()
    }
    
    @IBAction func stSellPriceValueChanged(sender: UIStepper) {
        self.txtSellPrice.text = String(Int(sender.value))
        validatePrice()
    }
}
/**
 Collection view section
 */

class CategoryCollectionCell : UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
}

class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
}

enum CollectionType {
    case Category
    case Photo
}

class PhotoPreview: NSObject, NYTPhoto {
    var image: UIImage?
    var imageData: NSData?
    var placeholderImage: UIImage?
    var attributedCaptionTitle: NSAttributedString?
    var attributedCaptionSummary: NSAttributedString?
    var attributedCaptionCredit: NSAttributedString?
}

extension ProductEditorController {
    
    func initCollectionViews() {
        categoryDataSource = CategoryCollectionDataSource()
        categoryDataSource.categories = realm.objects(JSCategory)
        categoryDataSource.setSelected(0)
        collectionCategory.dataSource = categoryDataSource
        collectionCategory.delegate = self
        collectionCategory.tag = CollectionType.Category.hashValue
        
        photoDataSource = PhotoCollectionDataSource()
        photoDataSource.kCornerRadius = kCornerRadius
        
        collectionPhoto.dataSource = photoDataSource
        collectionPhoto.delegate = self
        collectionPhoto.tag = CollectionType.Photo.hashValue
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let row = indexPath.row
        Logger.log("select collection view tag \(collectionView.tag) at index \(row)")
        switch collectionView.tag {
        case CollectionType.Category.hashValue:
            categoryDataSource.setSelected(row)
            collectionView.reloadData()
            updatePlaceHolder()
            break
        case CollectionType.Photo.hashValue:
            if row == 0 {
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                presentViewController(imagePickerController, animated: true, completion: nil)
            } else {
                var nytPhotos = Array<NYTPhoto>()
                for index in 0...(photoDataSource.photos!.count - 1) {
                    let photo = photoDataSource.photos![index]
                    let photoPreview = PhotoPreview()
                    photoPreview.image = UIImage(contentsOfFile: photo.localPath)
                    nytPhotos.append(photoPreview)
                }
                let photoViewer = NYTPhotosViewController(photos: nytPhotos)
//                let padding:CGFloat = 10
//                let rect = self.view.frame
//                photoViewer.view.frame = CGRectMake(rect.origin.x + padding, rect.origin.y + padding, rect.width - padding * 2, rect.height - padding * 2)
//                self.presentpopupViewController(photoViewer, animationType: .Fade, completion: {
//                    
//                })
                self.presentViewController(photoViewer, animated: true, completion: {
                    
                })
                photoViewer.displayPhoto(nytPhotos[row - 1], animated: false)
            }
            break
        default:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case CollectionType.Category.hashValue:
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
        default:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

}

extension ProductEditorController {
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress() {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        if images.count > 0 {
            SwiftSpinner.show("đang xử lý ảnh ...", animated: true)
            weak var weakSelf = self
            ImageHelper.processImages(images) { (imagePaths) in
                weakSelf!.photoDataSource.photos = []
                if imagePaths.count > 0 {
                    for imagePath in imagePaths {
                        let photo = JSProductPhoto()
                        photo.localPath = imagePath
                        weakSelf!.photoDataSource.photos?.append(photo)
                    }
                }
                weakSelf!.collectionPhoto.reloadData()
                SwiftSpinner.hide()
            }
        } else {
            self.drawEmptyPhotos()
        }
    }
    
    func drawEmptyPhotos() {
        photoDataSource.photos = []
        collectionPhoto.reloadData()
    }
}

class PhotoCollectionDataSource: NSObject, UICollectionViewDataSource {
    var photos: Array<JSProductPhoto>?
    var kCornerRadius:CGFloat = 0
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos == nil {
            return 1
        } else {
            return (photos?.count)! + 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCollectionCell
        let index = indexPath.row
        cell.imageView.layer.cornerRadius = kCornerRadius
        cell.imageView.clipsToBounds = true
        if index == 0 {
            cell.imageView.backgroundColor = ColorHelper.APP_DEFAULT
            cell.imageView.image = UIImage(named: "icon_camera.png")
        } else if let photo = photos?[index - 1] {
            cell.imageView.backgroundColor = UIColor.whiteColor()
            Logger.log("Load photo index \(index - 1) path \(photo.localPath)")
            cell.imageView.image = UIImage(contentsOfFile: photo.localPath)
        }
        
        return cell
    }
}

class CategoryCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var categories: Results<JSCategory>?
    
    var selectedCategory: JSCategory!
    
    func setSelected(index: Int) {
        selectedCategory = categories?[index]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryCollectionCell
        let index = indexPath.row
        if let category = categories?[index] {
            //Logger.log("category \(category.name) icon \(category.icon)")
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
    
}
