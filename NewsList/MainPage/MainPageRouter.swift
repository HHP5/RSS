
import Foundation
import UIKit

class FromMainPageToDetailRouter {

    fileprivate var newsMainPageTableViewController: MainPageTableViewController
    fileprivate var item: RSSItem!

    init(newsMainPageViewController: MainPageTableViewController) {
        self.newsMainPageTableViewController = newsMainPageViewController
    }

    func presentDetailsView(for new: RSSItem) {
        self.item = new
        newsMainPageTableViewController.performSegue(withIdentifier: "FromMainPageToDetail", sender: nil)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController = segue.destination as? DetailPageViewController {
            detailsViewController.configurator = DetailPagePresenter(news: item)
        }

    }
}
