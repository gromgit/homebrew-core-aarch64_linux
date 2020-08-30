class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.46.1.tar.gz"
  sha256 "4829c6e961c894ee1ab99e0085818b09f98d011c2a310efa7258b222b143cf0f"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "276f47a5dcd738cecf73f0ba0962afdd8c34b1b56d24f7ae9f01865652146fce" => :catalina
    sha256 "7de78e31e59dfcf30e28eb513e710ec100d66f698466fefd4264ffb3bd6c934c" => :mojave
    sha256 "e83ef17d3d9ae1b4a1922f64b0912de2284f88c35c7ab1cb215fd0d58c4c7a60" => :high_sierra
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
