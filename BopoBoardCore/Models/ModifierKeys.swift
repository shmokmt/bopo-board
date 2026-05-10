import CoreGraphics

public struct ModifierKeys: Equatable {
    public var shift: Bool = false
    public var control: Bool = false
    public var option: Bool = false
    public var command: Bool = false

    public init(shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
    }

    public init(from flags: CGEventFlags) {
        self.shift = flags.contains(.maskShift)
        self.control = flags.contains(.maskControl)
        self.option = flags.contains(.maskAlternate)
        self.command = flags.contains(.maskCommand)
    }

    public var hasAnyModifier: Bool {
        return shift || control || option || command
    }

    public var description: String {
        var parts: [String] = []
        if control { parts.append("⌃") }
        if option { parts.append("⌥") }
        if shift { parts.append("⇧") }
        if command { parts.append("⌘") }
        return parts.joined(separator: " ")
    }
}
