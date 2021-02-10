class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/8bf1cae2e1803aefab9e5331550e5d5d/sane-backends-1.0.31.tar.gz"
  sha256 "4a3b10fcb398ed854777d979498645edfe66fcac2f2fd2b9117a79ff45e2a5aa"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "8f2a4b8bc690ef88a070e474e014b36ff9237fc90e7e888c549d0bb391d51129"
    sha256 big_sur:       "14dff0d10d2763cea28bf86e5ada50bc6d966ce94ece64dd4026bc88815d2885"
    sha256 catalina:      "4343d5c9db23d58387e2646d73a5d9b07f2dcebb90fb142fd5d21d802a358c16"
    sha256 mojave:        "206176cb89375cedd1b93bf07b4611186c358604bbce31bbbf43637b2e225e1f"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
