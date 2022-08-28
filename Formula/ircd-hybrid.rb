class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.42/ircd-hybrid-8.2.42.tgz"
  sha256 "692d217bfc7ea37c4e4391fb86b0a92780bc32eb144f69623349721755b81f6a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "bc1082345514784eafae874e118a3aff0fc5b0669b3ab69b215131462a20d459"
    sha256 arm64_big_sur:  "0847773f47674d9f00933e7eb1b0a9cc63c9a073af509bfa16622c5c067023d4"
    sha256 monterey:       "fda21a2a7afec87bf4dbd463e9f9a560a50fca9fc73841f129485445d9ad7941"
    sha256 big_sur:        "661750c01fc31c696d5999912d051edae7f9bad6e56a2ae10f7a6adfeff5c8cd"
    sha256 catalina:       "db175e65833d8b0b4eb9c9245128f0435f35e70299b2f58cd684a313e25936aa"
    sha256 x86_64_linux:   "9cd7af7a3f61430e947d9d0e55b4e169ace7e166bd2cf6b6a974a9fdd69aa1f8"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  conflicts_with "expect", because: "both install an `mkpasswd` binary"
  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats
    <<~EOS
      You'll more than likely need to edit the default settings in the config file:
        #{etc}/ircd.conf
    EOS
  end

  service do
    run opt_bin/"ircd"
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{bin}/ircd", "-version"
  end
end
