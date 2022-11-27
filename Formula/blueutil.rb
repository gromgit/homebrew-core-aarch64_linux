class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.9.0.tar.gz"
  sha256 "cbd66abe0c4044b0d62095e340abf3e63925d4380e0dce710a550764a1f62352"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "master"

  depends_on xcode: :build
  depends_on :macos

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "-arch", Hardware::CPU.arch, "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
