class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.46.3.tar.gz"
  sha256 "2367dc0c786ebc412dfe0f3b8ccb95d6a3fe2e5bf4df40b717faaff73a6a462c"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "dd48846d67b9a57ca17d756078b9458e88918e2823ca925b48a286d6715cdf17" => :catalina
    sha256 "1bd0dd5883def1da395ae75f04268e221eae5a106f70e394c3d9e677f683cfeb" => :mojave
    sha256 "80291b96d495b2c743298dda1026606aa86d58e6a39a99d0f3c4081e36de302d" => :high_sierra
  end

  depends_on xcode: ["10.1", :build]

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
