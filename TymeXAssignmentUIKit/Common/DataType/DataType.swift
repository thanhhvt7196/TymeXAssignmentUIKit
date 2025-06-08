//
//  DataType.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

public enum DataType<T: Codable>: Codable {
    case value(T)
    case null
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            guard !container.decodeNil() else {
                self = .null
                return
            }
            do {
                let value = try container.decode(T.self)
                self = .value(value)
            } catch {
                self = .null
            }
        } catch {
            self = .null
        }
    }
    
    public init(_ value: T?) {
        self = value.map(DataType.value) ?? .null
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .value(value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
    
    var value: T? {
        if case let .value(v) = self {
            return v
        }
        return nil
    }
}
