class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.7.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.7.tar.gz"
  sha256 "4c21a791b610b9519b9d0e12b8097bf2f359b12f8dd92647611a929e6bfd7d64"
  license all_of: [
    { any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"] }, # lib
    { all_of: ["Unicode-TOU", "Unicode-DFS-2016"] }, # matching COPYING.unicode
    "GPL-3.0-or-later", # bin
    "LGPL-2.1-or-later", # parts of gnulib
    "FSFAP-no-warranty-disclaimer", # man3
  ]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libidn2-2.3.7"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8f11ec5a9830450304ac0acc601b93a4b8ddd926953906ef1bdf297e584f50aa"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build

    uses_from_macos "gperf" => :build

    on_macos do
      depends_on "coreutils" => :build
    end

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = ["--disable-silent-rules", "--with-packager=Homebrew"]
    args << "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}" if OS.mac?

    if build.head?
      ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
      system "./bootstrap", "--skip-po"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    ENV["CHARSET"] = "UTF-8"
    output = shell_output("#{bin}/idn2 räksmörgås.se")
    assert_equal "xn--rksmrgs-5wao1o.se", output.chomp
    output = shell_output("#{bin}/idn2 blåbærgrød.no")
    assert_equal "xn--blbrgrd-fxak7p.no", output.chomp
  end
end
