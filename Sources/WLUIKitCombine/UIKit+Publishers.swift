import Combine
import UIKit

extension Publisher where Self.Failure == Never {
    public func dismiss(on vc: UIViewController, animated: Bool = true) -> AnyCancellable {
        sink { [weak vc] _ in
            vc?.dismiss(animated: animated)
        }
    }
    
    public func reload(on view: UICollectionView) -> AnyCancellable {
        sink { [weak view] _ in
            guard let view else {
                return
            }
            view.reloadData()
        }
    }
    
    public func reload(on view: UITableView) -> AnyCancellable {
        sink { [weak view] _ in
            guard let view else {
                return
            }
            view.reloadData()
        }
    }
}

extension Publisher where Output == UIViewController, Failure == Never {
    public func push(on object: UIViewController, animated: Bool = true) -> AnyCancellable {
        sink { [weak object] vc in
            object?.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    public func present(on object: UIViewController, animated: Bool = true) -> AnyCancellable {
        sink { [weak object] vc in
            object?.present(vc, animated: animated)
        }
    }
}
