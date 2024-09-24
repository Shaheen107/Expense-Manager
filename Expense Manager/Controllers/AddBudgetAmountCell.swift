import UIKit

class AddBudgetAmountCell: UITableViewCell {
    
    @IBOutlet weak var savingTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        savingTitleLbl.layer.cornerRadius = 36
        savingTitleLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
