// Copyright © 2022 Brian Drelling. All rights reserved.

extension String {
    // Returns a copy of this string without trailing slashes.
    func trimmingTrailingSlashes() -> Self {
        self.replacingOccurrences(of: "/*$", with: "", options: .regularExpression)
    }

    // Appends a string with a leading slash.
    func appendingPath(_ path: String) -> Self {
        self.appending("/\(path)")
    }
}
