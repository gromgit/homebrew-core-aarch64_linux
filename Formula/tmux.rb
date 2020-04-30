class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.1a/tmux-3.1a.tar.gz"
  sha256 "10687cbb02082b8b9e076cf122f1b783acc2157be73021b4bedb47e958f4e484"

  bottle do
    cellar :any
    sha256 "62ca6f2c2c7c06ddbcb535daa4c7b163cb10cce51a381cabb8b15d2e756e60f1" => :catalina
    sha256 "1bf482fdb31919d337e652842a40d4622910a70c5c0a8eaa550ae5f2270ce3d8" => :mojave
    sha256 "66a01e075ecdb88908ffc08175b17ee68d185293332ee5f1ebc02da262f08948" => :high_sierra
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-utf8proc
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
