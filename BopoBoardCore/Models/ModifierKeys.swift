import CoreGraphics

struct ModifierKeys: Equatable {
    var shift: Bool = false
    var control: Bool = false
    var option: Bool = false
    var command: Bool = false

    init(shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
    }

    init(from flags: CGEventFlags) {
        self.shift = flags.contains(.maskShift)
        self.control = flags.contains(.maskControl)
        self.option = flags.contains(.maskAlternate)
        self.command = flags.contains(.maskCommand)
    }

    var hasAnyModifier: Bool {
        return shift || control || option || command
    }

    var description: String {
        var parts: [String] = []
        if control { parts.append("⌃") }
        if option { parts.append("⌥") }
        if shift { parts.append("⇧") }
        if command { parts.append("⌘") }
        return parts.joined(separator: " ")
    }
}
