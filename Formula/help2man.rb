class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.48.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.48.1.tar.xz"
  sha256 "de8a74740bd058646567b92ab4ecdeb9da9f1a07cc7c4f607a3c14dd38d10799"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7bc46236d8916519b432020f2d51df5c6006c7000b67835ff7e1276c58ec208c"
    sha256 cellar: :any, big_sur:       "ee60622e70903c293171ea78097544d796a5454b29e8c1494529aa537901e460"
    sha256 cellar: :any, catalina:      "603b604aaf17770dd4f4a0f9b45c266848d8c005228c64773fdec2d94e3d45dd"
    sha256 cellar: :any, mojave:        "f57b3269934c79434b70ac7807ea364af47ae8a3b6096364c0615b2789d4a0a9"
  end

  depends_on "gettext" if Hardware::CPU.intel?

  uses_from_macos "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    if Hardware::CPU.intel?
      resource("Locale::gettext").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    args = []
    args << "--enable-nls" if Hardware::CPU.intel?

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
    (libexec/"bin").install "#{bin}/help2man"
    (bin/"help2man").write_env_script("#{libexec}/bin/help2man", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = if Hardware::CPU.intel?
      shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")
    else
      shell_output("#{bin}/help2man #{bin}/help2man")
    end

    assert_match "help2man #{version}", out
  end
end
