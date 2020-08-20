class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v2.5.3.tar.gz"
  sha256 "83f2017ba05f7ce7ded74097832df071d2be89d41b357f45c4dce801c2a0cae6"
  license "BSD-3-Clause"

  bottle do
    sha256 "aefdabd9c1e218c9cbf111da4a46b8850d4d43d9d3dadc6d99b3d4350cc9418a" => :catalina
    sha256 "8e0678b1a19be091cb42a2ec431117a60fb0049c36cce4a00c18082a6543c75d" => :mojave
    sha256 "3432bd8ec1fb92fd2d9498058da53845a59eb389ee746c3953712d1409f830a4" => :high_sierra
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    ENV.O2
    ENV.deparallelize
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match /Hello World!/, shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match /Hello World!/, shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
