
import UIKit

protocol NewsDetailPageView{
    func display(title: String )
    func display(image: UIImage)
}

class DetailPagePresenter {
    
    let item: RSSItem?
    
    init(news: RSSItem) {
        self.item = news
    }
    
    func configure(viewController: DetailPageViewController){
        if let oneItem = item{
            print(oneItem)
            let newPresenter = NewsDetailsPresenterImplementation(viewController: viewController, news: oneItem)
            print("NewsDetailsPresenterImplementation isn't nil")
            viewController.presenter = newPresenter
        }
    }
}

class NewsDetailsPresenterImplementation {

    let news: RSSItem?
    let newsDetailViewController: DetailPageViewController

    init(viewController: DetailPageViewController, news: RSSItem) {
        self.newsDetailViewController = viewController
        self.news = news
    }

    func viewDidLoad() {

        newsDetailViewController.display(title: news!.title)
        
        if news!.imageURL != "" {
            do {
                let url = URL(string: news!.imageURL)
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async { [self] in
                    newsDetailViewController.display(image: UIImage(data: data)!)
                }
            } catch {
                print(error)
            }
        } else {
            DispatchQueue.main.async { [self] in
                newsDetailViewController.display(image: UIImage(systemName: "paperclip")!)
            }
        }
    
    }
}



