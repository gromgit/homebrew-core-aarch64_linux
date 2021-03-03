class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.3.0.tar.gz"
  sha256 "3e35434f604ede2a4e792ccb7d89e4fd25b68d16bc86d48be149fbeb3c373fd6"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "328a5e296643bd6fac05b501cef3e02d0d9c0683446efcf19754945aeeb838af"
    sha256 cellar: :any_skip_relocation, big_sur:       "f47a9baba10d5395c2c5caf764382fd57d15e7761b152ee6bb230fbc32238d96"
    sha256 cellar: :any_skip_relocation, catalina:      "c6a59fef12cb2ba7c12e847dfa311e3f1564d3d72fe6224f74de36fca37642fe"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcery"
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
