class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/V1_47.tar.gz"
  sha256 "dc4dbe20991cc36bac5e97e99475e2a1522fd88c59ee2e08f813432c04c5fff3"
  license :cannot_represent # Described as 'BSD with advertising' here: https://src.fedoraproject.org/rpms/ngrep/blob/rawhide/f/ngrep.spec#_8

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9748a4ae1ac8cd7fb8284cd40bf6e01ce11dfafea0cdc5f3e50ebf59b80ca076"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e3dd83416ffb0136a2e26ed7f98c8e0243914966791ec259ecdd2d835f73db2"
    sha256 cellar: :any_skip_relocation, catalina:      "b53ca835c8c61966f89d5bb77444182b59353896217e997f038ed95387fa3baf"
    sha256 cellar: :any_skip_relocation, mojave:        "7ac3968d637cc2ae7f6dbc34f0001096a86a3bbc64a2bf79213cf4eac47b41e5"
  end

  uses_from_macos "libpcap"

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

    args = [
      "--enable-ipv6",
      "--prefix=#{prefix}",
      # this line required to avoid segfaults
      # see https://github.com/jpr5/ngrep/commit/e29fc29
      # https://github.com/Homebrew/homebrew/issues/27171
      "--disable-pcap-restart",
    ]

    on_macos do
      # this line required to make configure succeed
      args << "--with-pcap-includes=#{sdk}/usr/include/pcap"
    end

    on_linux do
      # this line required to make configure succeed
      args << "--with-pcap-includes=#{Formula["libpcap"].opt_include}/pcap"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngrep -V")
  end
end
