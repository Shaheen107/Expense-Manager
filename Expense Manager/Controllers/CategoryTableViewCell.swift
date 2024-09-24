import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel(label: label1)
        setupLabel(label: label2)
    }

    private func setupLabel(label: UILabel) {
        label.textColor = .gray
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 30
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 0.6
    }
}
