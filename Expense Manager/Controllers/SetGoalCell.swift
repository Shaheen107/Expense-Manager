

import UIKit

class SetGoalCell: UITableViewCell {
    
    @IBOutlet weak var GoalNameLbl: PaddedLabel!
    @IBOutlet weak var totalsavedAmountLbl: UILabel!
    @IBOutlet weak var totalgoalAmountLbl: UILabel!
    
    @IBOutlet weak var uiviewOutlet: UIView!
    @IBOutlet weak var amountProcess: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        GoalNameLbl.layer.cornerRadius = 20
        GoalNameLbl.layer.masksToBounds = true
       
        uiviewOutlet.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
