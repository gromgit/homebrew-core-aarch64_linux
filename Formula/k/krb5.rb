class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.21/krb5-1.21.3.tar.gz"
  sha256 "b7a4cd5ead67fb08b980b21abd150ff7217e85ea320c9ed0c6dadd304840ad35"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/krb5-1.21.3"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "986fc99f8ab1c293697f36af2432237c2e13fe501814919098978731218bae9b"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    cd "src" do
      system "./configure", *std_configure_args,
                            "--disable-nls",
                            "--disable-silent-rules",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
