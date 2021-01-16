
import UIKit

class MainPageTableViewCell: UITableViewCell, NewsCellView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageForCell: UIImageView!

    func display(title: String) {
        titleLabel.text = title
    }

    func display(image: UIImage?) {
        imageForCell.image = image
    }


}
