//
//  DailyPictureViewController.swift
//  NASADailyPic
//
//  Created by Raphael Araújo on 2018-04-12.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import UIKit
import SDWebImage
class DailyPictureViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var fullScreenDetails: UIView!
    @IBOutlet weak var explanationTextView: UITextView!
    
    var originalImage: UIImage!
    
    lazy var dailyPictureViewModel: DailyPictureViewModel = {
        return DailyPictureViewModel()
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureFullScreen()
    }
    
    //MARK: ViewModel Configuration
    func configureViewModel() {
        self.dailyPictureViewModel.updateLoading = { [weak self] () in
            performOnMainQueue {
                if (self?.dailyPictureViewModel.loading)! {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        self.dailyPictureViewModel.updatePicture = { [weak self] () in
            self?.loadImage()
            self?.loadTitle()
        }
        
        self.dailyPictureViewModel.displayError = { [weak self] (errrorMessage) in
            self?.showAlert(message: errrorMessage)
        }
        
        dailyPictureViewModel.fetchPicture()
    }
    
    //MARK: UI Configuration Methods
    func loadImage() {
        if let urlStr = self.dailyPictureViewModel.pictureViewModel?.url {
            self.imageView.sd_setImage(with: URL(string: urlStr),
                                       completed: { (image, error, cacheType, url) in
                                        if error == nil && image != nil {
                                            self.originalImage = image
                                            self.imageView.image = self.fixedImageAspectRatio(image: image!,
                                                                                              imageView: self.imageView)
                                            performOnMainQueue {
                                                UIView.animate(withDuration: 0.35,
                                                               animations: {
                                                                self.imageView.alpha = 1.0
                                                }, completion: { (completion) in
                                                    self.imageView.isUserInteractionEnabled = true
                                                    self.activityIndicator.stopAnimating()
                                                })
                                            }
                                        }
            })
        }
    }
    
    func loadTitle() {
        if let title = self.dailyPictureViewModel.pictureViewModel?.title {
            performOnMainQueue {
                self.titleLabel.text = title
                UIView.animate(withDuration: 0.35, animations: {
                    self.titleLabel.alpha = 1.0
                })
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        performOnMainQueue {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func fixedImageAspectRatio(image: UIImage, imageView: UIView) -> UIImage {
        let aspectRatio = image.size.width/image.size.height
        let newImage = image.resizeImage(imageView.frame
            .size.height, aspectRatio: aspectRatio, opaque: true)
        
        return newImage
    }
    
    func configureFullScreen() {
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(DailyPictureViewController.imageTapped))
        self.imageView.addGestureRecognizer(tapImage)
        
        if self.originalImage != nil {
            self.fullScreenImageView.image = fixedImageAspectRatio(image: self.originalImage,
                                                                   imageView: self.fullScreenImageView)
        }
        
        let tapFullScreenImage = UITapGestureRecognizer(target: self,
                                                        action: #selector(DailyPictureViewController.fullScreenImageTapped))
        let tapFullDetails = UITapGestureRecognizer(target: self,
                                                    action: #selector(DailyPictureViewController.fullScreenImageTapped))
        
        self.fullScreenImageView.addGestureRecognizer(tapFullScreenImage)
        self.fullScreenDetails.addGestureRecognizer(tapFullDetails)
    }
}
//MARK: Gesture actions
extension DailyPictureViewController {
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        self.showFullScreenView()
    }
    
    @objc func fullScreenImageTapped(sender: UITapGestureRecognizer) {
        self.showFullScreenImageDetails()
    }
}

//MARK: Full Screen
extension DailyPictureViewController {
    func showFullScreenView() {
        if self.fullScreenImageView.image == nil {
            performOnMainQueue {
                self.fullScreenImageView.image = self.fixedImageAspectRatio(image: self.originalImage,
                                                                            imageView: self.fullScreenView)
                guard let pictureViewModel = self.dailyPictureViewModel.pictureViewModel else {
                    return
                }
                
                let explanation = pictureViewModel.explanation ?? ""
                self.explanationTextView.text = "\(pictureViewModel.title)\n\n" +
                "\(explanation)"
            }
        }
        
        performOnMainQueue {
            UIView.animate(withDuration: 0.35, animations: {
                self.fullScreenView.alpha = 1.0
            })
        }
    }
    
    func showFullScreenImageDetails() {
        let alpha: CGFloat = self.fullScreenDetails.alpha == 1.0 ? 0.0 : 1.0
        performOnMainQueue {
            UIView.animate(withDuration: 0.35, animations: {
                self.fullScreenDetails.alpha = alpha
            })
        }
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        performOnMainQueue {
            UIView.animate(withDuration: 0.35, animations: {
                self.fullScreenView.alpha = 0.0
            }, completion: { (completion) in
                self.fullScreenDetails.alpha = 0.0
            })
        }
    }
}

