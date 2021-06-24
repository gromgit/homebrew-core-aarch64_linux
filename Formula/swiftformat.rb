class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.6.tar.gz"
  sha256 "08ced137f57593fe3820a62e3c65868450a12d0e026da1de3533db1c2c0f3f8a"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78c5f4a349071a849e9f9eb0368907e5b8414e16e321fa4b17e821ab93d08f4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdb2f3d905c2bbad7fff6cef0be18760ebf1a6595149eac5504df7c575154015"
    sha256 cellar: :any_skip_relocation, catalina:      "ae2a296fb9e96b6024226e2e71538e93c8ac29e80f162a29fc1530b341084593"
    sha256 cellar: :any_skip_relocation, mojave:        "6ba32395078693bc518d290d523090932b266fba89f82a792a465b476226f0c5"
  end

  depends_on xcode: ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
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
