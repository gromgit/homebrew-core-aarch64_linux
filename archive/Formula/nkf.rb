class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://osdn.net/projects/nkf/"
  # Canonical: https://osdn.net/dl/nkf/nkf-2.1.4.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nkf/70406/nkf-2.1.5.tar.gz"
  sha256 "d1a7df435847a79f2f33a92388bca1d90d1b837b1b56523dcafc4695165bad44"

  livecheck do
    url "https://osdn.net/projects/nkf/releases/"
    regex(%r{=.*?rel/nkf/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nkf"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "01d1ebb6e03bed3f5ae36b05d545454b4ad37715e8b5e0c87f93b82964dbc9d8"
  end

  def install
    inreplace "Makefile", "$(prefix)/man", "$(prefix)/share/man"
    system "make", "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end

  test do
    system "#{bin}/nkf", "--version"
  end
end
