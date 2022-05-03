class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.8.tar.gz"
  sha256 "36c78ebe82cf0e1135d3b48a92be1d65d575833455b042b414f7817112ee6eae"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b2d8ff8f3a1d6c8e1aded5fb48ea638a9c6f7e3e0c24a8365a90a66b8c2c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ce097e10e1598798db0362ce5df40070f47943a34881e128b5f75f75c122105"
    sha256 cellar: :any_skip_relocation, monterey:       "45f50e61598935c7f39ac4cd62a26258bc62766e97f68709b436fad0576c2910"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6749cbf272acd6ccebf4644180215bb710f30cb29b2c10c06b05e75abd24a00"
    sha256 cellar: :any_skip_relocation, catalina:       "b51010bc91a76ca90fc94abe6989db3a977d881aba9043b330e34a5b630b3198"
  end

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
        "-project", "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
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
