class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.90.tar.bz2"
  sha256 "5557c3458275e8c43e1d0cfa5dad4e71dd39e091e2029a293891ad54098a40e8"
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "f86423c5d193de1df53de7264ec5c2955bf589f878943ebbdf28c718bfea2a6e" => :catalina
    sha256 "fe5709980a63192317186cf994b2522ae401b1c37fa74e5eb497f2587a20e959" => :mojave
    sha256 "371113f240b24105a46bbe7b7b5db504656cd33bb1c5299cbc110c872610825d" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
