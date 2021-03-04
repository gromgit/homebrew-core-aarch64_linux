class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.12.tar.gz"
  sha256 "ddf93325c320f7b3dbcaa19a713ca740b909d229cd855d813575a3ca0cac8c61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e91f7c5ca5c8562b0c5f21a611387a4c84d0231268e2fb02d9dcab5c5a0028cf"
    sha256 cellar: :any_skip_relocation, catalina: "566aa80fa3b9b54144ebd2d95e9c8392c23324a061c4d1c443c9b85e9e8ddd5b"
    sha256 cellar: :any_skip_relocation, mojave:   "e5abb77d1e7ae165e9007926c8df655351259c9130ecab421c25a8ed9db3522d"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
