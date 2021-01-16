
import UIKit
import CoreImage

protocol NewsCellView {
    func display(title: String)
    func display(image: UIImage?)
}

class MainPagePresenter {
    
    private var rssItem: [RSSItem]?
    var rssItemToCell = [RSSItem]()
    var filter: CIFilter?
    let urlString = "https://habr.com/ru/rss/hubs/all/"
    var context = CIContext()
    var imageToCell: UIImage?
    private let newsMainPageTableViewController: UITableViewController
    let router: FromMainPageToDetailRouter
    var limit: Int = 5
    var index = 0
    
    init(newsTableViewController: MainPageTableViewController) {
        self.newsMainPageTableViewController = newsTableViewController
        self.router = FromMainPageToDetailRouter(newsMainPageViewController: newsTableViewController)
    }
    
    var numberOfNews: Int {
        
        guard let rssItem = rssItem else {
            return 0
        }
        return rssItem.count
    }
    
    func viewDidLoad() {
        newsMainPageTableViewController.tableView.rowHeight = 150
        fetchData()
    }
        
    private func fetchData() {
        let feedParser = FeedParser()
        
        feedParser.parseFeed(url: urlString) { [self] (rssItem) in
            self.rssItem = rssItem
            if (index < numberOfNews){
                print("LOADING MORE DATA")
                newsMainPageTableViewController.tableView.tableFooterView = createSpinerFooter()
            }else{
                newsMainPageTableViewController.tableView.tableFooterView = stopSpinerFooter()
            }
            while index < limit {
                rssItemToCell.append(rssItem[index])
                index += 1
            }
            
            OperationQueue.main.addOperation {
                self.newsMainPageTableViewController.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    func loadMoreData(){
        
        if (index < numberOfNews){
            print("LOADING MORE DATA")
            newsMainPageTableViewController.tableView.tableFooterView = createSpinerFooter()
            if rssItemToCell.count < numberOfNews-1{
                index = rssItemToCell.count
                limit += 5
                
                let feedParser = FeedParser()
                feedParser.parseFeed(url: urlString) { [self] (rssItem) in
                    self.rssItem = rssItem
                }
                
                while index < limit {
                    rssItemToCell.append(rssItem![index])
                    index += 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.newsMainPageTableViewController.tableView.reloadData()
            }
        } else{
            newsMainPageTableViewController.tableView.tableFooterView = stopSpinerFooter()
        }
    }
    
    func configure(cell: NewsCellView, forRow row: Int) {
       

        let column = rssItemToCell[row]
        
        cell.display(title: column.title)
        
        if column.imageURL != "" {
            print(column.imageURL)
            let url = URL(string: column.imageURL)
            if let url = url{
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async { [self] in
                        imageToCell = doFilter(image: UIImage(data: data)!, filter: self.filter)
                        cell.display(image: imageToCell)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            DispatchQueue.main.async { [self] in
                imageToCell = doFilter(image: UIImage(systemName: "paperclip")!, filter: self.filter)
                cell.display(image: imageToCell)
            }
        }
    }
    
    func doFilter(image: UIImage, filter: CIFilter?) -> UIImage {
        var result: UIImage = image
        
        if let currentFilter = filter {
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            guard let outputImage = currentFilter.outputImage else { fatalError("Error Changing color") }
            
            currentFilter.setValue(100, forKey: kCIInputImageKey)
            
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
            
            result = UIImage(cgImage: cgImage)
        }
        return result
    }
    
    
    func didSelect(row: Int) {
        let item = rssItemToCell[row]
        router.presentDetailsView(for: item)
    }
    
    func filterButtonPressed(chosenFilter: String) {
        switch chosenFilter {
        case ColorFilter.Noir.effect:
            filter = CIFilter(name: ColorFilter.Noir.filter)
        case ColorFilter.Blur.effect:
            filter = CIFilter(name: ColorFilter.Blur.filter)
        case ColorFilter.Invert.effect:
            filter = CIFilter(name: ColorFilter.Invert.filter)
        case ColorFilter.Sepia.effect:
            filter = CIFilter(name: ColorFilter.Sepia.filter)
        case ColorFilter.Fade.effect:
            filter = CIFilter(name: ColorFilter.Fade.filter)
        case ColorFilter.Chrome.effect:
            filter = CIFilter(name: ColorFilter.Chrome.filter)
        case "none":
            filter = nil
        default:
            print("Problem with buttons")
        }
        
        DispatchQueue.main.async {
            self.newsMainPageTableViewController.tableView.reloadData()
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y > (newsMainPageTableViewController.tableView.contentSize.height - 200 - scrollView.frame.size.height) {
            loadMoreData()
        }
    }

    func createSpinerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: newsMainPageTableViewController.view.frame.size.width, height: 100))
        
        let spiner = UIActivityIndicatorView()
        spiner.center = footerView.center
        footerView.addSubview(spiner)
        spiner.startAnimating()
        
        return footerView
    }
    
    func stopSpinerFooter() -> UIView?{
        return nil
    }

    
}



