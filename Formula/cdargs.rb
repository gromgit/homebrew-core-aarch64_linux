class Cdargs < Formula
  desc "Directory bookmarking system - Enhanced cd utilities"
  homepage "https://github.com/cbxbiker61/cdargs"
  url "https://github.com/cbxbiker61/cdargs/archive/2.1.tar.gz"
  sha256 "062515c3fbd28c68f9fa54ff6a44b81cf647469592444af0872b5ecd7444df7d"
  license "GPL-2.0"
  head "https://github.com/cbxbiker61/cdargs.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cdargs"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "63522cabd9f173896f4ffacf8eb089bf95c1ef3762b2641f0542fe87a3dc51d4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "ncurses"

  # fixes zsh usage using the patch provided at the cdargs homepage
  # (See https://www.skamphausen.de/cgi-bin/ska/CDargs)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cdargs/1.35.patch"
    sha256 "adb4e73f6c5104432928cd7474a83901fe0f545f1910b51e4e81d67ecef80a96"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    rm Dir["contrib/Makefile*"]
    prefix.install "contrib"
    bash_completion.install_symlink "#{prefix}/contrib/cdargs-bash.sh"
  end

  def caveats
    <<~EOS
      Support files for bash, tcsh, and emacs have been installed to:
        #{prefix}/contrib
    EOS
  end

  test do
    system "#{bin}/cdargs", "--version"
  end
end
