class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.27.tar.gz"
  sha256 "0b6e86e9d2e05663fcd4130f41befb176ad4d2c953c8f7346402e0dd05a072a8"

  bottle do
    cellar :any
    sha256 "0192a46b91f28d89d61618b0d54ebf00b0edcd0e588a3fd4b24e02a2ccb39460" => :catalina
    sha256 "cc3475e1afc9dbf17081bd9ba3f6912396ad91eccb6033205f7ab46c0fccc3bc" => :mojave
    sha256 "0349b47109618dce84895f6a6230065bdd4ae0ee08c950bbb2560060ef2fa650" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
