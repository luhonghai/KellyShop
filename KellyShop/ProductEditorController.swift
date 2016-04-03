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
import RAReorderableLayout
import SCLAlertView_Objective_C
import BSImagePicker
import BSGridCollectionViewLayout
import Photos


class ProductEditorController: UIViewController, UICollectionViewDelegate, ImagePickerDelegate, RAReorderableLayoutDelegate, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var imgChooseImage: UIImageView!
    
    @IBOutlet weak var imgChooseImageGallery: UIImageView!
    
    @IBOutlet weak var viewActionContainer: UIView!
    
    @IBOutlet weak var btnSaveShare: UIView!
    
    @IBOutlet weak var btnRefresh: UIView!
    
    var categoryDataSource: CategoryCollectionDataSource!
    
    var photoDataSource: PhotoCollectionDataSource!
    
    var product: JSProduct?
    
    override func viewDidLoad() {
        initLayout()
        initCollectionViews()
        product = JSProduct()
        updatePlaceHolder()
    }
}

/*
 Data section
 */
extension ProductEditorController {
    
    func changeCategory() {
        product?.creator = AccountManager.current()!.user
        let category = categoryDataSource.selectedCategory
        let counter = category.counter + 1
        product?.id = "\(category.code)\(counter)"
        Logger.log("product id \(product?.id)")
    }
    
    func refreshForm() {
        product = JSProduct()
        txtName.text = ""
        txtDescription.text = ""
        txtPrice.text = ""
        txtTransferPrice.text = ""
        txtSellPrice.text = ""
        stepperPrice.value = 0
        stepperSellPrice.value = 0
        stepperTransferPrice.value = 0
        photoDataSource.photos = []
        collectionPhoto.reloadData()
        changeCategory()
    }
    
    func saveAndShare() {
        weak var weakSelf = self
        weakSelf!.saveProduct()
        weakSelf!.refreshForm()
    }
    
    func saveProduct() {
        product?.name = txtName.text!
        product?.detail = txtDescription.text!
        FileHelper.getFilePath("photos", directory: true)
        if photoDataSource.photos?.count > 0 {
            for photo in photoDataSource.photos! {
                let destPath = "photos/\(NSUUID().UUIDString)"
                FileHelper.copyFile(photo.localPath, toPath: FileHelper.getFilePath(destPath))
                photo.localPath = destPath
                product?.photos.append(photo)
            }
        }
        product?.search = "\(product?.name), \(product?.basePrice)k, \(product?.sellPrice)k, \(product?.transferPrice)k, \(product?.id), \(product?.detail), \(product?.category?.code), \(product?.category?.name), \(product?.category?.name), \(AccountManager.current()?.user.name)"
        let realm = try! Realm()
        try! realm.write({
            categoryDataSource.selectedCategory.counter += 1
            product?.category = categoryDataSource.selectedCategory
            realm.add(product!)
        })
    }
    
    @IBAction func tapRefresh(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let builder = SCLAlertViewBuilder().addButtonWithActionBlock("đồng ý", {
//                self.refreshForm()
//            }).shouldDismissOnTapOutside(true)
//        let showBuilder = SCLAlertViewShowBuilder()
//            .style(.Custom)
//            .title("làm lại")
//            .subTitle("xóa toàn bộ thông tin đã nhập")
//            .color(ColorHelper.APP_RED)
//            .image(UIImage(named: "icon_refresh_large.png"))
//            .closeButtonTitle("không")
//        
//        showBuilder.showAlertView(builder.alertView, onViewController: self)
    }
    
    
    @IBAction func tapSaveShare(sender: UITapGestureRecognizer) {
        let builder = SCLAlertViewBuilder()
            .addButtonWithActionBlock("lưu và chia sẻ", {
                 self.saveAndShare()
            })
            .addButtonWithActionBlock("chỉ lưu", {
                weak var weakSelf = self
                weakSelf!.saveProduct()
                weakSelf!.refreshForm()
            })
            .shouldDismissOnTapOutside(true)
        let showBuilder = SCLAlertViewShowBuilder()
            .style(.Custom)
            .title("lưu \(self.categoryDataSource.selectedCategory.name.lowercaseString)")
            .subTitle("tùy chọn lưu lại và chia sẻ hoặc chia sẻ sau")
            .color(ColorHelper.APP_BLUE)
            .image(UIImage(named: "icon_check_large.png"))
            .closeButtonTitle("không")
        
        showBuilder.showAlertView(builder.alertView, onViewController: self)
    }
}

/**
 Layout section
 */
extension ProductEditorController {
    func initLayout() {
        txtDescription.layer.cornerRadius = kCornerRadius
        collectionPhoto.layer.cornerRadius = kCornerRadius
        btnRefresh.layer.cornerRadius = kCornerRadius
        btnSaveShare.layer.cornerRadius = kCornerRadius
        viewActionContainer.layer.cornerRadius = kCornerRadius
        imgChooseImage.layer.cornerRadius = kCornerRadius
        imgChooseImage.userInteractionEnabled = true
        imgChooseImageGallery.layer.cornerRadius = kCornerRadius
        imgChooseImageGallery.userInteractionEnabled = true
        txtName.delegate = self
        txtPrice.delegate = self
        txtSellPrice.delegate = self
        txtTransferPrice.delegate = self
        
    }
    func updatePlaceHolder() {
        let categoryName = categoryDataSource.selectedCategory.name.lowercaseString
        txtDescription.placeholder = "mô tả thêm về \(categoryName)"
        txtName.placeholder = "tên \(categoryName)"
        changeCategory()
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
        let realm = try! Realm()
        categoryDataSource.categories = realm.objects(JSCategory)
        categoryDataSource.setSelected(0)
        collectionCategory.dataSource = categoryDataSource
        collectionCategory.delegate = self
        collectionCategory.tag = CollectionType.Category.hashValue
        
        photoDataSource = PhotoCollectionDataSource()
        
        collectionPhoto.dataSource = photoDataSource
        collectionPhoto.delegate = self
        collectionPhoto.tag = CollectionType.Photo.hashValue
        (self.collectionPhoto.collectionViewLayout as! RAReorderableLayout).scrollDirection = .Horizontal
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
                var nytPhotos = Array<NYTPhoto>()
                for index in 0...(photoDataSource.photos!.count - 1) {
                    let photo = photoDataSource.photos![index]
                    let photoPreview = PhotoPreview()
                    photoPreview.image = UIImage(contentsOfFile: photo.localPath)
                    nytPhotos.append(photoPreview)
                }
                let photoViewer = NYTPhotosViewController(photos: nytPhotos)
                self.presentViewController(photoViewer, animated: true, completion: {
                    
                })
                photoViewer.displayPhoto(nytPhotos[row], animated: false)
            
            break
        default:
            break
        }
    }
    
    @IBAction func tapChooseImage(sender: UITapGestureRecognizer) {
        Logger.log("choose images")
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tapChooseImageGallery(sender: UITapGestureRecognizer) {
        Logger.log("choose image gallery")
        let imagePickerController = BSImagePickerViewController()
        weak var weakSelf = self
        bs_presentImagePickerController(imagePickerController, animated: true, select: { (asset: PHAsset) -> Void in
            
            }, deselect: { (asset: PHAsset) -> Void in
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                Logger.log("cancel image picker")
            }, finish: { (assets: [PHAsset]) -> Void in
                Logger.log("finish image picker. Image count \(assets.count)")
                var images = Array<UIImage>()
                if assets.count > 0 {
                    let manager = PHImageManager.defaultManager()
                    let option = PHImageRequestOptions()
                    option.deliveryMode = PHImageRequestOptionsDeliveryMode.FastFormat
                    for asset in assets {manager.requestImageDataForAsset(asset, options: option, resultHandler: { (data, string, orentation, _:[NSObject : AnyObject]?) in
                            images.append(UIImage(data: data!)!)
                            if images.count == assets.count {
                                weakSelf!.chooseImages(images)
                            }
                        })
                    }
                }
                
                
            }) { 
                
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
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        let photo = self.photoDataSource.photos?.removeAtIndex(atIndexPath.item)
        self.photoDataSource.photos?.insert(photo!, atIndex: toIndexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch collectionView.tag {
        case CollectionType.Photo.hashValue:
            let height = collectionView.frame.height
            let width = height * 62 / 88
            return CGSizeMake(width, height)
        default:
            
            return (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
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
        chooseImages(images)
    }
    
    func chooseImages(images: [UIImage]) {
        if images.count > 0 {
            SwiftSpinner.show("đang xử lý ảnh ...", animated: true)
            weak var weakSelf = self
            ImageHelper.processImages(images, pid: (product?.id)!) { (imagePaths) in
                weakSelf!.photoDataSource.photos = []
                if imagePaths.count > 0 {
                    for imagePath in imagePaths {
                        let photo = JSPhoto()
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
/**
 keyboard control
 */
extension ProductEditorController {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtPrice.becomeFirstResponder()
            return true
        case txtPrice:
            txtDescription.becomeFirstResponder()
            return true
        default:
            return true
        }
    }
}

class PhotoCollectionDataSource: NSObject, RAReorderableLayoutDataSource {
    var photos: Array<JSPhoto>?
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos == nil {
            return 0
        } else {
            return (photos?.count)!
        }
    }
    
    func collectionView(collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        return 0.9
    }
    
    func scrollSpeedValueInCollectionView(collectionView: UICollectionView) -> CGFloat {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCollectionCell
        let index = indexPath.row
        cell.imageView.layer.cornerRadius = kCornerRadius
        cell.imageView.clipsToBounds = true
        if let photo = photos?[index] {
            cell.imageView.backgroundColor = UIColor.whiteColor()
            Logger.log("Load photo index \(index) path \(photo.localPath)")
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
