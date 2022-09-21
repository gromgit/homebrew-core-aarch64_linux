class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://cdecl.org/"
  url "https://cdecl.org/files/cdecl-blocks-2.5.tar.gz"
  sha256 "9ee6402be7e4f5bb5e6ee60c6b9ea3862935bf070e6cecd0ab0842305406f3ac"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cdecl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1820a04f75091632830cf50df74f7944ef68fec9c02bdd9c1bf96cd83cbc9116"
  end


  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    # Fix namespace clash with Lion's getline
    inreplace "cdecl.c", "getline", "cdecl_getline"

    bin.mkpath
    man1.mkpath

    ENV.append "CFLAGS", "-DBSD -DUSE_READLINE -std=gnu89"

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LIBS=-lreadline",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    assert_equal "declare a as pointer to int",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
