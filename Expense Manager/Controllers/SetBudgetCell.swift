import UIKit

class SetBudgetCell: UITableViewCell {
    
    @IBOutlet weak var budgetNameLbl: PaddedLabel!
    @IBOutlet weak var totalSavedAmountLbl: UILabel!
    @IBOutlet weak var totalBudgetAmountLbl: UILabel!
    
    @IBOutlet weak var uiviewOutlet: UIView!
    @IBOutlet weak var amountProgress: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        budgetNameLbl.layer.cornerRadius = 20
        budgetNameLbl.layer.masksToBounds = true
       
        uiviewOutlet.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
