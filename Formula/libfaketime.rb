class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.10.tar.gz"
  sha256 "729ad33b9c750a50d9c68e97b90499680a74afd1568d859c574c0fe56fe7947f"
  license "GPL-2.0-only"
  head "https://github.com/wolfcw/libfaketime.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libfaketime"
    sha256 aarch64_linux: "14b86e2871bf3adda2afdf3513034eb253e0bb021c0889684b34899781a50b9d"
  end

  on_macos do
    # The `faketime` command needs GNU `gdate` not BSD `date`.
    # See https://github.com/wolfcw/libfaketime/issues/158 and
    # https://github.com/Homebrew/homebrew-core/issues/26568
    depends_on "coreutils"
    depends_on macos: :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    cp "/bin/date", testpath/"date" # Work around SIP.
    assert_match "1230106542",
      shell_output(%Q(TZ=UTC #{bin}/faketime -f "2008-12-24 08:15:42" #{testpath}/date +%s)).strip
  end
end
