class Parrot < Formula
  desc "Open source virtual machine (for Perl6, et al.)"
  homepage "http://www.parrot.org/"
  license "Artistic-2.0"
  head "https://github.com/parrot/parrot.git", branch: "master"

  stable do
    url "http://ftp.parrot.org/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    mirror "https://ftp.osuosl.org/pub/parrot/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    sha256 "caf356acab64f4ea50595a846808e81d0be8ada8267afbbeb66ddb3c93cb81d3"

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/7524bf5384ddebbb3ba06a040f8acf972aa0a3ba.patch?full_index=1"
      sha256 "1357090247b856416b23792a2859ae4860ed1336b05dddc1ee00793b6dc3d78a"
    end

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/854aec65d6de8eaf5282995ab92100a2446f0cde.patch?full_index=1"
      sha256 "4e068c3a9243f350a3e862991a1042a06a03a625361f9f01cc445a31df906c6e"
    end
  end

  livecheck do
    url "http://ftp.parrot.org/releases/supported/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/parrot"
    sha256 aarch64_linux: "4c190354354a907b2177e7984e0f3abccca3fda36d554f4bd3d3400d1820c00a"
  end

  uses_from_macos "zlib"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--mandir=#{man}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make", "install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_rf lib/"VERSION"
  end

  test do
    path = testpath/"test.pir"
    path.write <<~EOS
      .sub _main
        .local int i
        i = 0
      loop:
        print i
        inc i
        if i < 10 goto loop
      .end
    EOS

    out = `#{bin}/parrot #{path}`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
