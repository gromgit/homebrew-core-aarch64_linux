class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.20/krb5-1.20.tar.gz"
  sha256 "7e022bdd3c851830173f9faaa006a230a0e0fdad4c953e85bff4bf0da036e12f"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/krb5"
    sha256 aarch64_linux: "1f4471619ec317806f815a4e69cad0bf7c76e65eaa108cd32dd5cc00b66f9fb8"
  end


  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

  def install
    cd "src" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-nls",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
