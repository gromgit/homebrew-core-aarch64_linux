class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.3.tar.gz"
  sha256 "ad709a2c92c763d54088ae3f3002276a962ea25b5aa29ae16dd57e10f51b66f9"
  license "PostgreSQL"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pgformatter"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e4f545f0abc62df2f753b149862f3e4681ef7e1d2a7eb0dd20b42c5cc225afd9"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    if OS.linux?
      # Move man pages to share directory so they will be linked correctly on Linux
      mkdir "usr/local/share"
      mv "usr/local/man", "usr/local/share"
    end

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
