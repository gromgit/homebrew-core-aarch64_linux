class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.41.2.tar.gz"
  sha256 "50514ba39cb6bd8a206f3d88032fe4491d02bd5cdad9ffa7077b59bcb30a7ce2"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "50f8b073be59248151472808cae24ba533e250a93fe32576d5124b7de690cc44" => :catalina
    sha256 "e52062c8ed242d331013e6adbab76b7087802214b47cb539b86e015d328a4db3" => :mojave
    sha256 "3603a831193cde5aef3a45026d701e62e9bd49976c63c0b332147a996eca1636" => :high_sierra
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
