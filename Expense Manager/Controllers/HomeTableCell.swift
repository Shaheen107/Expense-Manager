import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var catagaryLbl: PaddedLabel!
    @IBOutlet weak var expencePrice: UILabel!
    
    @IBOutlet weak var uiView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        catagaryLbl.layer.cornerRadius = 20
        catagaryLbl.layer.masksToBounds = true
        uiView.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
