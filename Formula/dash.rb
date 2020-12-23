class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.11.3.tar.gz"
  sha256 "62b9f1676ba6a7e8eaec541a39ea037b325253240d1f378c72360baa1cbcbc2a"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d022e122b657eb7061bda5f1058cabc96186a45a1f3d80bc2dc075048ed0da19" => :big_sur
    sha256 "84809dee8711c0522781b11a57e21566c1d4e35aeb5441446c44367f29083342" => :catalina
    sha256 "80e428b76b588a656de5a6c135ff920b7a86b9489a31f987a7d63ff278180151" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
