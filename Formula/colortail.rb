class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail.git",
      revision: "f44fce0dbfd6bd38cba03400db26a99b489505b5"
  version "0.3.4"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/colortail"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d1d813ce766e018f9090e9e0410bebea1c9d64d842d97b1021fe41793c13f564"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Upstream PR to fix the build on ML
  patch do
    url "https://github.com/joakim666/colortail/commit/36dd0437bb364fd1493934bdb618cc102a29d0a5.patch?full_index=1"
    sha256 "d799ddadeb652321f2bc443a885ad549fa0fe6e6cfc5d0104da5156305859dd3"
  end

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello\nWorld!\n"
    assert_match(/World!/, shell_output("#{bin}/colortail -n 1 test.txt"))
  end
end
