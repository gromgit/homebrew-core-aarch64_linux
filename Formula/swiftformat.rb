class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.3.tar.gz"
  sha256 "66970daf2b67e5880888e34ede0ab5c783d7d99afffed6357452c5ebe9c297a3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "bd07c9f5a18c0e26d8d7d3b500cc8f026e54bb735462d08f71f9d62c590ec44f" => :catalina
    sha256 "f257487fdd954b9bb8802212a40a188a256204fae0eca9e2510a5b5f411c3253" => :mojave
    sha256 "4330358413a23d81f9bb1263cf6306ccd0c5829111da7f433a0563b615741ccd" => :high_sierra
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
