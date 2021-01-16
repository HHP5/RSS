
import UIKit

class MainPageTableViewController: UITableViewController, UINavigationBarDelegate{
    
    private var presenter: MainPagePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = .white
        presenter = MainPagePresenter(newsTableViewController: self)
        presenter.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rssItemToCell.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MainPageReusableCell", for: indexPath) as? MainPageTableViewCell
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "MainPageReusableCell") as? MainPageTableViewCell
        }
        presenter.configure(cell: cell!, forRow: indexPath.row)
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(row: indexPath.row)
    }

    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        presenter.filterButtonPressed(chosenFilter: sender.title!)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        presenter.scrollViewDidEndDragging(scrollView: scrollView, willDecelerate: true)
    }
 
}
