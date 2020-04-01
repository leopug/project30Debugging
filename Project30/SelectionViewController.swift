//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false
    var itemsImages : [UIImage]!
    
    override func loadView() {
        super.loadView()
        
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath else {return}

        if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                }
            }
        }
        
        itemsImages = [UIImage]()
        
        for i in 0..<items.count{
            let currentImage = items[i]
            let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
            
            
            if let path = Bundle.main.path(forResource: imageRootName, ofType: nil) {
                if let original = UIImage(contentsOfFile: path) {
                    
                    let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
                    let renderer = UIGraphicsImageRenderer(size: renderRect.size)
                    
                    let rounded = renderer.image { ctx in
                        
                        ctx.cgContext.addEllipse(in: renderRect)
                        ctx.cgContext.clip()
                        
                        original.draw(in: renderRect)
                    }
                    itemsImages.append(rounded)
                }
                
            }
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeMiniImageCache()
		title = "Reactionist"
        
		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			tableView.reloadData()
		}
	}


	override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func makeMiniImageCache() {
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentImage = items[indexPath.row]
        
        cell.imageView?.image = itemsImages[indexPath.row]
        
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"
        
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
        let vc = ImageViewController()
		vc.image = items[indexPath.row]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false
        if let navControll = navigationController {
            navControll.pushViewController(vc, animated: true)
        }
		
	}
}
