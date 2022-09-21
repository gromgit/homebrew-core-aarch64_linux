class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/intltool"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a40c6a3adb88e7f99c1d2279f588e4013770da9be7f6586bdb774088055094fb"
  end


  on_linux do
    depends_on "expat"
    depends_on "perl"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
