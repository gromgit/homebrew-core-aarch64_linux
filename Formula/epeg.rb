class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.2.tar.gz"
  sha256 "f8285b94dd87fdc67aca119da9fc7322ed6902961086142f345a39eb6e0c4e29"
  license "MIT-enna"
  revision 1
  head "https://github.com/mattes/epeg.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/epeg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cebee1c40ac75e1ee1433027d8685e3b4b067bb66a68b749ac4f26d67572b9c4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libexif"

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epeg", "--width=1", "--height=1", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
