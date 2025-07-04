import Combine

extension Publisher where Self.Failure == Never {
    public func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Self.Output>, on object: T) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    
    public func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Optional<Self.Output>>, on object: T) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

extension Publisher {
    public func loading<T: AnyObject>(_ isLoading: ReferenceWritableKeyPath<T, Bool>, on object: T) -> Publishers.HandleEvents<Self> {
        handleEvents(
            receiveSubscription: { [weak object] _ in
                object?[keyPath: isLoading] = true
            },
            receiveCompletion: { [weak object] _ in
                object?[keyPath: isLoading] = false
            },
            receiveCancel: { [weak object] in
                object?[keyPath: isLoading] = false
            }
        )
    }
    
    public func error<T: AnyObject>(_ error: ReferenceWritableKeyPath<T, Failure?>, on object: T) -> AnyPublisher<Output, Never> {
        self
            .catch { [weak object] in
                object?[keyPath: error] = $0
                return Empty<Output, Never>().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func ignore<T: Error>(_ type: T.Type) -> AnyPublisher<Output, Failure> {
        self
            .catch {
                if $0 is T {
                    return Empty<Output, Failure>().eraseToAnyPublisher()
                }
                else {
                    return Fail<Output, Failure>(error: $0).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func with<Root: AnyObject, T>(_ value: KeyPath<Root, T>, on object: Root) -> AnyPublisher<(Output, T), Failure> {
        compactMap { [weak object] output in
            guard let object else {
                return nil
            }
            return (output, object[keyPath: value])
        }
        .eraseToAnyPublisher()
    }
}
