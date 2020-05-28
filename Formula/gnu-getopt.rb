class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-2.35.2.tar.xz"
  sha256 "21b7431e82f6bcd9441a01beeec3d57ed33ee948f8a5b41da577073c372eb58a"

  bottle do
    cellar :any_skip_relocation
    sha256 "057a54871793ac9c455872ea65f5dc4a4391d842a0b887f7761c17aa62f3e9b2" => :catalina
    sha256 "af7e6ff9fce7d0286ca4cb0c0ce01d385ba3ea4cfc6735f97165272f97f18a81" => :mojave
    sha256 "3114f75086a792b8a40259056a95875f77fefae73e43d8fd39d7818436f6b8bf" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
