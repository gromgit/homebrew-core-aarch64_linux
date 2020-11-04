class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v2.0.0.tar.gz"
  sha256 "e42150b9405cae267ced10fb4004060485b3dda532802b6bcc15ca59f47ac1fe"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccd6e95f86a6639fd8f098c9a4755c06dd32a90a2a125056edb20f767903b6df" => :catalina
    sha256 "99a8e16cbcef7ae89011182e456f70315ff4c84569a29bc4ff4d2b3db0e6502f" => :mojave
    sha256 "d5433ba927eb10a40c64a8168e26ff6fb28fb5c71a296bc83970647f573a6db3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=vendor", "-ldflags", ldflags, "-o", bin/"tty-share", "."
  end

  test do
    # Running `echo 1 | tty-share` ensures that the tty-share command doesn't have a tty at stdin,
    # no matter the environment where the test runs in.
    output_when_notty = `echo 1 | #{bin}/tty-share`
    assert_equal output_when_notty, "Input not a tty\n"
  end
end
