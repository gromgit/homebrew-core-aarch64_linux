class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.30.2.tar.gz"
  sha256 "66db7df8a91979eb576fac91743644da878244cf8ee152f02cd6f5cd7a731689"
  revision 1
  head "https://github.com/perl/perl5.git", :branch => "blead"

  bottle do
    sha256 "8a9d19e3d6f308b5976318d644ba11ec95b2c2be502cee4c8514060690ddb923" => :catalina
    sha256 "632cbd8c42fd270ae4e1458e5dbb7927dbf69d5bd6ef36bb0dc981c0b2eb6759" => :mojave
    sha256 "302bcddce16aa19d9009b63daad9d4e7d128c9df8f0973daa96e7de80a430266" => :high_sierra
  end

  uses_from_macos "expat"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
      -Dsed=/usr/bin/sed
    ]

    args << "-Dusedevel" if build.head?

    system "./Configure", *args

    system "make"

    system "make", "install"
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
        echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
