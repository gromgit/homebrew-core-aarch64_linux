class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.9.3.tar.xz"
  sha256 "c2b58b5c2f01021e6766a742d58d4a0321fc4a19929209869f853808c336f343"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff4aaae67b79fba98a9dcff014ced9aac1137df949e1f0ade81104caa0d2d75f" => :catalina
    sha256 "38dae19a118472d03cf3ac9767708a4bb246c13ab0bc3b7b9dde93b2c2be90b3" => :mojave
    sha256 "d74098febf025dc96a887f4297144ef52036d4aea7f88cbbf8ce04cef45d89a6" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
