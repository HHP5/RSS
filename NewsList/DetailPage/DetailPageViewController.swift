//
//  DetailPageViewController.swift
//  NewsList
//
//  Created by Екатерина Григорьева on 14.01.2021.
//

import UIKit

class DetailPageViewController: UIViewController, NewsDetailPageView {
   
    var configurator: DetailPagePresenter!
    var presenter: NewsDetailsPresenterImplementation!
    
    @IBOutlet weak var imageDetailPage: UIImageView!
    @IBOutlet weak var titleDetailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(viewController: self)
        presenter.viewDidLoad()
        
    }
    
    func display(title: String) {
        titleDetailLabel.text = title
    }
    
    func display(image: UIImage) {
        imageDetailPage.image = image
    }
}
