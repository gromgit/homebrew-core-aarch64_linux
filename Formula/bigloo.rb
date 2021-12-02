class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo-4.4c.tar.gz"
  sha256 "6646b76382f56d320135a4f6b8eba3e2133d53256f9ff3646b97866a2576062c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download.html"
    regex(/bigloo-latest\.t.+?\(([^)]+?)\)/i)
  end

  bottle do
    sha256 monterey: "065f60592a082b1eee01474e340c8c0f0e37ae8d15924c7b55af77b19fa43e96"
    sha256 big_sur:  "5936c6ee277a018c104dc82e23517229725df62e960135ad93429d18d5bdbbdd"
    sha256 catalina: "76981333f401b289c59e90f44b107f0b799511a790b5af4cf962763781c09e2b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  depends_on "openjdk"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    # Force bigloo not to use vendored libraries
    inreplace "configure", /(^\s+custom\w+)=yes$/, "\\1=no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man1}
      --infodir=#{info}
      --os-macosx
      --customgc=no
      --customlibuv=no
      --native=yes
      --disable-alsa
      --disable-mpg123
      --disable-flac
      --disable-srfi27
      --jvm=yes
    ]

    system "./configure", *args

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
