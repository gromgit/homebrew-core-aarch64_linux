class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"
  revision 1
  head "https://github.com/c9s/cpansearch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cpansearch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cc71fdad6c398228715b6224a8286b767a11c6827e86b656afa92be78884e672"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "curl"

  def install
    unless OS.mac?
      # Help find some ncursesw headers
      ENV.append "CPPFLAGS", "-I#{Formula["ncurses"].include}/ncursesw"
      # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
      # Remove after migration to 18.04.
      inreplace "Makefile", "$(LDFLAGS) $(OBJS)", "$(OBJS) $(LDFLAGS)"
    end
    system "make"
    bin.install "cpans"
  end

  test do
    output = shell_output("#{bin}/cpans --fetch https://cpan.metacpan.org/")
    assert_match "packages recorded", output
  end
end
