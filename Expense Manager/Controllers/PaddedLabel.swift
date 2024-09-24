import UIKit

class PaddedLabel: UILabel {
    
    var textInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        return size
    }
}
