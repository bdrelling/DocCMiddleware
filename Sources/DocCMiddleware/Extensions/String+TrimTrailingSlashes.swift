// Copyright © 2022 Brian Drelling. All rights reserved.

extension String {
    // Returns a copy of this string without leading slashes.
    func trimmingLeadingSlashes() -> Self {
        self.replacingOccurrences(of: "^/*", with: "", options: .regularExpression)
    }

    // Returns a copy of this string without trailing slashes.
    func trimmingTrailingSlashes() -> Self {
        self.replacingOccurrences(of: "/*$", with: "", options: .regularExpression)
    }

    // Returns a copy of this string without leading or trailing slashes.
    func trimmingSlashes() -> Self {
        self.trimmingLeadingSlashes().trimmingTrailingSlashes()
    }

    // Appends a string with a leading slash.
    func appendingPath(_ path: String) -> Self {
        self.appending("/\(path)")
    }
}
