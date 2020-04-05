class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.7.tar.gz"
  sha256 "5bb1e773b5b279c290845f8f7e7de04f86d1bd978a9068f23b385651fd0b4d38"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "279acad5c3add211ea79dd7931e0157e4c423f9bafeb4c8737555bafd98ed324" => :catalina
    sha256 "53d82866cd08befaec7e5a2e93461ad4693bae07e42ec4617d3fc4ef04bfe230" => :mojave
    sha256 "846c3e44701ce830a0310f67c928a2f670ee6c40c1ef2c514e25745756990bef" => :high_sierra
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
