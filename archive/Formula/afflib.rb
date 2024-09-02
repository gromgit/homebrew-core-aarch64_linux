class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/afflib"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6207c3ad579811c00c16c7630a36e3fa522bb07254423ac210020396758c5a40"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "curl"
  uses_from_macos "expat"

  # Fix for Python 3.9, remove in next version
  patch do
    url "https://github.com/sshock/AFFLIBv3/commit/aeb444da.patch?full_index=1"
    sha256 "90cbb0b55a6e273df986b306d20e0cfb77a263cb85e272e01f1b0d8ee8bd37a0"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"

    args = %w[
      --enable-s3
      --enable-python
      --disable-fuse
    ]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
