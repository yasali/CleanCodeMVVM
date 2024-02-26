import Foundation

public extension NSObject {
    func retain(object: Any, key: inout String) {
        objc_setAssociatedObject(self, &key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
