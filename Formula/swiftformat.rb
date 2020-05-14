class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.10.tar.gz"
  sha256 "82c740a426571fcef52f0f46f9bff5460442f78cedccc929e0a87dbab4933c8a"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "2c64a5a79d32d477a9e5f9bc2720d36c64541d527edea47c7b8dc48111d5f356" => :catalina
    sha256 "e1f2a970e8ab85e0cb3c8f90b512b3dd4e27c928ba2fdecd66a17d105dccc6c3" => :mojave
    sha256 "e08586cbbf484269065eb74c2a79674498799ceb1b1c3f34d30492946d5b5efd" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
