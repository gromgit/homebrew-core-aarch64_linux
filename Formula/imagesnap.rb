class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://github.com/rharder/imagesnap/archive/0.2.7.tar.gz"
  sha256 "94832e7ec1e690046c71358cdd460106405b7bc333eba42960a3a5c5d47129d3"
  license :public_domain

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d5eddf9c53f7dab46ab883f3961cef4f78cdc7b488c500106b4a30fa12930a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec9348dab5dc28d80e546b7e6acd8c8b6413ce0e4be46e33d4a33d9676f05a7a"
    sha256 cellar: :any_skip_relocation, catalina:      "eb2508bd4f64b4c7de5e3f7e356ecd93e916a0578486e64a7049bcfbadab5823"
    sha256 cellar: :any_skip_relocation, mojave:        "f42749a98de36c1f8e803024ed7e59cab3ea14ac639ced0695eed661e6a546ba"
  end

  depends_on xcode: :build

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
