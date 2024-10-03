import SwiftUI

extension GeometryProxy {
    var width: CGFloat {
        max(0, size.width)
    }
    
    var firstColumnWidth: CGFloat {
        width * 0.3
    }
    
    var secondColumnWidth: CGFloat {
        width * 0.5    }
}
