import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var imgUser = UIImageView()
    var labUerName = UILabel()
    var labMessage = UILabel()
    var labTime = UILabel()
    
    
    func toggle(){
        println("CELL CUSTOM")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.backgroundColor = UIColor.blueColor()
        
        imgUser.setTranslatesAutoresizingMaskIntoConstraints(false)
        labUerName.setTranslatesAutoresizingMaskIntoConstraints(false)
        labMessage.setTranslatesAutoresizingMaskIntoConstraints(false)
        labTime.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(imgUser)
        contentView.addSubview(labUerName)
        contentView.addSubview(labMessage)
        contentView.addSubview(labTime)
        
        var viewsDict = [
            "image" : imgUser,
            "username" : labUerName,
            "message" : labMessage,
            "labTime" : labTime,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image(10)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[labTime]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username]-[message]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[username]-[image(10)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[message]-[labTime]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
    }
    
    /*
    override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    //fatalError("init(coder:) has not been implemented")
    }
    */
    
}