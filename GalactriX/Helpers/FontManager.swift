import UIKit

enum FontManager {
    case light(size: CGFloat)
    case ultraLight(size: CGFloat)
    case thin(size: CGFloat)
    case regular(size: CGFloat)
    case heavy(size: CGFloat)
    case semibold(size: CGFloat)
    case medium(size: CGFloat)
    case bold(size: CGFloat)
    case black(size: CGFloat)
    
    var uiFont: UIFont {
        switch self {
        case .light(let size):
            return UIFont.systemFont(ofSize: size, weight: .light)
        case .ultraLight(let size):
            return UIFont.systemFont(ofSize: size, weight: .ultraLight)
        case .thin(let size):
            return UIFont.systemFont(ofSize: size, weight: .thin)
        case .regular(let size):
            return UIFont.systemFont(ofSize: size, weight: .regular)
        case .heavy(let size):
            return UIFont.systemFont(ofSize: size, weight: .heavy)
        case .medium(let size):
            return UIFont.systemFont(ofSize: size, weight: .medium)
        case .semibold(let size):
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        case .bold(let size):
            return UIFont.systemFont(ofSize: size, weight: .bold)
        case .black(let size):
            return UIFont.systemFont(ofSize: size, weight: .black)
        }
    }
}
