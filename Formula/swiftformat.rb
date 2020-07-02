class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.15.tar.gz"
  sha256 "e4a4f1a781fc623af8d76848c2cd59c4b93a909df74ccd30396537f1230c3f01"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "6dcbcb2fe8b38daff70d10e45f547df32b185a34ac63a380a88bb53e5007f1f8" => :catalina
    sha256 "3a6c988d69a1b7d386d6999a6777b900c7f640bc15e1814ccd8b9cc4cc5abd93" => :mojave
    sha256 "7717d97fdd2fe2f0ec87f8f26a8562dff83d5128a4794def66ae660deadc5bae" => :high_sierra
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
