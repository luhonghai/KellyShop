//
//  ProviderEditorController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/26/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import RAReorderableLayout
import NYTPhotoViewer
import ImagePicker
import ImageLoader
import SCLAlertView_Objective_C
import BSImagePicker
import BSGridCollectionViewLayout
import SwiftSpinner
import Photos
import UITextView_Placeholder

class ProviderEditorController : UIViewController, UICollectionViewDelegate, ImagePickerDelegate, RAReorderableLayoutDelegate{
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var imgChooseImage: UIImageView!
    
    @IBOutlet weak var imgChooseGallery: UIImageView!
    
    @IBOutlet weak var collectionPhoto: UICollectionView!
    
    @IBOutlet weak var btnSave: UIView!
    
    @IBOutlet weak var btnRefresh: UIView!
    
    @IBOutlet weak var viewActionContainer: UIView!
    
    var photoDataSource: PhotoCollectionDataSource!
    
    override func viewDidLoad() {
        self.initLayout()
        self.initCollectionViews()
    }
}

extension ProviderEditorController {
    func initLayout() {
        self.imgChooseImage.layer.cornerRadius = kCornerRadius
        self.imgChooseGallery.layer.cornerRadius = kCornerRadius
        self.txtAddress.placeholder = "địa chỉ nhà cung cấp"
        self.txtAddress.layer.cornerRadius = kCornerRadius
        self.txtDetail.placeholder = "mô tả thêm về nhà cung cấp"
        self.txtDetail.layer.cornerRadius = kCornerRadius
        self.viewActionContainer.layer.cornerRadius = kCornerRadius
        self.btnRefresh.layer.cornerRadius = kCornerRadius
        self.btnSave.layer.cornerRadius = kCornerRadius
    }
}
// Data section
extension ProviderEditorController {
    
    @IBAction func tapSaveProvider(sender: UITapGestureRecognizer) {
        let provider = JSProvider()
        provider.id = NSUUID().UUIDString
        provider.name = txtName.text!
        provider.address = txtAddress.text!
        provider.detail = txtDetail.text!
        provider.phone = txtPhone.text!
        provider.search = "\(provider.name), \(provider.address), \(provider.detail), \(provider.phone)"
        provider.isEnable = true
        if photoDataSource.photos?.count > 0 {
            for photo in photoDataSource.photos! {
                let destPath = "photos/\(NSUUID().UUIDString)"
                FileHelper.copyFile(photo.localPath, toPath: FileHelper.getFilePath(destPath))
                photo.localPath = destPath
                provider.photos.append(photo)
            }
        }
        let realm = try! Realm()
        try! realm.write({ 
            realm.add(provider)
        })
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    @IBAction func tapButtonBack(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}

extension ProviderEditorController {
    
    func initCollectionViews() {
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

extension ProviderEditorController {
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
            ImageHelper.processImages(images, pid: "") { (imagePaths) in
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