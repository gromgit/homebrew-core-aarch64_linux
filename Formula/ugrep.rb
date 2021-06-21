class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.3.tar.gz"
  sha256 "ac9a1a7c4f3b7933c70e7a1cf363e43a38cf2acad2acb0d67770b9603009b77b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "aeb73378e235f39c7b11c39bb5a58ac8d5bba4f260df7102274f1243b5a61e82"
    sha256 big_sur:       "76106593f765df918bba65995d847016f17fecb23256a31a97c3b9b049c5053e"
    sha256 catalina:      "2eeeaf546bd0e1d57d6068018b34824897f0a5aa6e2a60ed5576378660b4b744"
    sha256 mojave:        "3bf2fd2db59c9d798358157047f322ca0f9f04db158dc339e7bf86859f9a0a0a"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
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
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
