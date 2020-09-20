class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v2.5.5.tar.gz"
  sha256 "45b7b48d9c0239bad17faf3bfef80458d1ab5f4e2bb74c058616d802b171e4d4"
  license "BSD-3-Clause"

  bottle do
    sha256 "fcfbac9e0b82960b71a72ea46e7db8009eed47f351b11ec5a8fc6845d5b1ced7" => :catalina
    sha256 "1dee70407852c7a5447b6fdb88e157cd7beb6979264465d675dd22130508bdd3" => :mojave
    sha256 "acb3877819169ad94d059e8694e741c85e14696029f09c357fb8d90dd2d43b23" => :high_sierra
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
