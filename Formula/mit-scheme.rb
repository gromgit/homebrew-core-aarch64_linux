class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/11.2/mit-scheme-11.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/mit-scheme/stable.pkg/11.2/mit-scheme-11.2.tar.gz"
  sha256 "0859cb03a7c841d2dbc67e374cfee2b3ae1f95f6a1ee846d8f5bad39c7e566a1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/?C=M&O=D"
    strategy :page_match
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 big_sur:  "575c4d509b9718b21324f135fd9945a6906d5d09c72da10c3f48915ab21976f8"
    sha256 catalina: "02fa401eabf3c3b2c382e257b64e15b13f5e3a27cf97a7a1c13f629242fd0061"
    sha256 mojave:   "02ddca7dbe1b6bb1e0e69496dde10ee3e4de49a623c7a6ec2ee2d43f5dfda2bb"
  end

  # Has a hardcoded compile check for /Applications/Xcode.app
  # Dies on "configure: error: SIZEOF_CHAR is not 1" without Xcode.
  # https://github.com/Homebrew/homebrew-x11/issues/103#issuecomment-125014423
  depends_on xcode: :build
  depends_on "openssl@1.1"

  resource "bootstrap" do
    if Hardware::CPU.intel?
      url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/11.2/mit-scheme-11.2-x86-64.tar.gz"
      sha256 "7ca848cccf29f2058ab489b41c5b3a101fb5c73dc129b1e366fb009f3414029d"
    else
      url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/11.2/mit-scheme-11.2-aarch64le.tar.gz"
      sha256 "49679bcf76c8b5896fda8998239c4dff0721708de4162dcbc21c88d9688faa86"
    end
  end

  def install
    # Setting -march=native, which is what --build-from-source does, can fail
    # with the error "the object ..., passed as the second argument to apply, is
    # not the correct type." Only Haswell and above appear to be impacted.
    # Reported 23rd Apr 2016: https://savannah.gnu.org/bugs/index.php?47767
    # NOTE: `unless build.bottle?` avoids overriding --bottle-arch=[...].
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    resource("bootstrap").stage do
      cd "src"
      system "./configure", "--prefix=#{buildpath}/staging", "--without-x"
      system "make"
      system "make", "install"
    end

    # Liarc builds must launch within the src dir, not using the top-level
    # Makefile
    cd "src"

    # Take care of some hard-coded paths
    %w[
      6001/edextra.scm
      6001/floppy.scm
      compiler/etc/disload.scm
      edwin/techinfo.scm
      edwin/unix.scm
    ].each do |f|
      inreplace f, "/usr/local", prefix
    end

    inreplace "microcode/configure" do |s|
      s.gsub! "/usr/local", prefix
      # Fixes "configure: error: No MacOSX SDK for version: 10.10"
      # Reported 23rd Apr 2016: https://savannah.gnu.org/bugs/index.php?47769
      s.gsub!(/SDK=MacOSX\$\{MACOS\}$/, "SDK=MacOSX#{MacOS.sdk.version}")
    end

    inreplace "edwin/compile.sh" do |s|
      s.gsub! "mit-scheme", "#{bin}/mit-scheme"
    end

    ENV.prepend_path "PATH", buildpath/"staging/bin"

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    # https://www.cs.indiana.edu/pub/scheme-repository/code/num/primes.scm
    (testpath/"primes.scm").write <<~EOS
      ;
      ; primes
      ; By Ozan Yigit
      ;
      (define  (interval-list m n)
        (if (> m n)
            '()
            (cons m (interval-list (+ 1 m) n))))

      (define (sieve l)
        (define (remove-multiples n l)
          (if (null? l)
        '()
        (if  (= (modulo (car l) n) 0)      ; division test
             (remove-multiples n (cdr l))
             (cons (car l)
             (remove-multiples n (cdr l))))))

        (if (null? l)
            '()
            (cons (car l)
            (sieve (remove-multiples (car l) (cdr l))))))

      (define (primes<= n)
        (sieve (interval-list 2 n)))

      ; (primes<= 300)
    EOS

    output = shell_output(
      "#{bin}/mit-scheme --load primes.scm --eval '(primes<= 72)' < /dev/null",
    )
    assert_match(
      /;Value: \(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71\)/,
      output,
    )
  end
end
