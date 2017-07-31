//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by Kelvin Leung on 30/07/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import UIKit

class FlickrPhotosViewController: UICollectionViewController {
    
    fileprivate let cellId = "FlickrCell"
    fileprivate let cellHeaderId = "FlickrCellHeader"
    fileprivate let sectionInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    fileprivate var searches = [FlickrSearchResults]()
    fileprivate let flickr = Flickr()
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(FlickrCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FlickrPhotoHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeaderId)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        let searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        searchTextField.placeholder = "Search"
        searchTextField.delegate = self
        self.navigationItem.titleView = searchTextField
    }
}

// Mark: Helper func
private extension FlickrPhotosViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}

// Mark: Fetch Data
extension FlickrPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        if let spinnerContainer = collectionView {
            spinnerContainer.addSubview(spinner)
            spinner.widthAnchor.constraint(equalToConstant: 40).isActive = true
            spinner.heightAnchor.constraint(equalToConstant: 40).isActive = true
            spinner.centerXAnchor.constraint(equalTo: spinnerContainer.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: spinnerContainer.centerYAnchor).isActive = true
        }
        spinner.startAnimating()
        
        if let text = textField.text {
            flickr.searchFlickrForTerm(text) { (results, error) in
                spinner.removeFromSuperview()
                
                if let error = error {
                    // debug
                    print("Error searching: \(error)")
                    return
                }
                if let results = results {
                    // debug
                    print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                    self.searches.insert(results, at: 0)
                    self.collectionView?.reloadData()
                }
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

// Mark: UICollectionViewDataSource
extension FlickrPhotosViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if let flickrCell = cell as? FlickrCell {
            flickrCell.photo.image = photoForIndexPath(indexPath: indexPath).thumbnail
        }
        return cell
    }
}

// Mark: Cell Header
extension FlickrPhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeaderId, for: indexPath)
            if let cellHeader = header as? FlickrPhotoHeaderView {
                cellHeader.sectionLabel.text = searches[indexPath.section].searchTerm
            }
            return header
        default:
            assert(false)
        }
    }
}

// Mark: UICollectionViewDelegateFlowLayout
extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddings = sectionInsets.left * (itemsPerRow + 1)
        let cellWidth = (view.frame.width - paddings) / itemsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 36)
    }
}
