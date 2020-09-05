class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.46.2.tar.gz"
  sha256 "cde87c93daba36e7c660412440f5775cf04d2c306bd716cafa0e52f085be4686"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "fb29575ebc4d367b58cc4e6725081956a4689936633c1cb22840c9f2f296e3e9" => :catalina
    sha256 "b36e163b4a5efe118996a246b6ecece31d4113e10f87f87aad3d79e3cc564b61" => :mojave
    sha256 "814cf678efdef9adbfd20130446039b2c87c7ed3ab680d2b884a19d293eb5b8a" => :high_sierra
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
