class Gengetopt < Formula
  desc "Generate C code to parse command-line arguments via getopt_long"
  homepage "https://www.gnu.org/software/gengetopt/"
  url "https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.23.tar.xz"
  mirror "https://ftpmirror.gnu.org/gengetopt/gengetopt-2.23.tar.xz"
  sha256 "b941aec9011864978dd7fdeb052b1943535824169d2aa2b0e7eae9ab807584ac"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gengetopt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "adcdeec7396b45bf582fe980a0682d8bd1568b719163a026d80e36d9479a013c"
  end

  uses_from_macos "texinfo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ggo = <<~EOS
      package "homebrew"
      version "0.9.5"
      purpose "The missing package manager for macOS"

      option "verbose" v "be verbose"
    EOS

    pipe_output("#{bin}/gengetopt --file-name=test", ggo, 0)
    assert_predicate testpath/"test.h", :exist?
    assert_predicate testpath/"test.c", :exist?
    assert_match(/verbose_given/, File.read("test.h"))
  end
end
