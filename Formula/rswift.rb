class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.4.0/rswift-v5.4.0-source.tar.gz"
  sha256 "5153e7d122412ced4f04b6fc92c10dad0a861900858543a77ce1bf11850d4184"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    assert_match "[R.swift] Failed to write out", shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
