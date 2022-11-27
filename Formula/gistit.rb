class Gistit < Formula
  desc "Command-line utility for creating Gists"
  homepage "https://gistit.herokuapp.com/"
  url "https://github.com/jrbasso/gistit/archive/v0.1.4.tar.gz"
  sha256 "9d87cfdd6773ebbd3f6217b11d9ebcee862ee4db8be7e18a38ebb09634f76a78"
  license "MIT"
  head "https://github.com/jrbasso/gistit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gistit"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e204aebb46a4845b3838c49a07c43ad92ca5e0acb965a8fdf2fe8848e529699b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello"

    # Gist creation should fail due to lack of authentication token
    assert_match "- code 401", shell_output("#{bin}/gistit -priv test.txt", 1)
  end
end
