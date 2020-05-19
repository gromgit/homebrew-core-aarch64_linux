class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  head "https://gitlab.com/sane-project/backends.git"

  stable do
    url "https://gitlab.com/sane-project/backends/uploads/c3dd60c9e054b5dee1e7b01a7edc98b0/sane-backends-1.0.30.tar.gz"
    sha256 "3f5d96a9c47f6124a46bb577c776bbc4896dd17b9203d8bfbc7fe8cbbcf279a3"

    # Fixes build error "error: use of undeclared identifier 'HOST_NAME_MAX'"
    # Commit is already included upstream in versions > 1.0.30
    patch do
      url "https://gitlab.com/sane-project/backends/-/commit/011d0f9bacab126fb2ae09d29abdd6eb88f1333d.diff"
      sha256 "2fb2366d8e53397237f4beda1f51000b0ae5beb2683387fb2a779d3a43ef1c9d"
    end
  end

  bottle do
    sha256 "07216e961a590f3d9a00b43cae10b132ed5008309a410db93d68aa4dca824888" => :catalina
    sha256 "132822ae224a20672067f3c5017abe7d7b00af43bea92dbe051cc62a94f03a72" => :mojave
    sha256 "99eabfb87281a6a88c00d9b9c52da3bcbfe430b0f66088c6ea5a5d4e0caad170" => :high_sierra
    sha256 "1c8dd4cbc1bec193f3bca14d19d79a513b7336f276ce0f373088391d38621173" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

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
