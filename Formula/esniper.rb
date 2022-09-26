class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.35.0/esniper-2-35-0.tgz"
  version "2.35.0"
  sha256 "a93d4533e31640554f2e430ac76b43e73a50ed6d721511066020712ac8923c12"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/esniper"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5316ea6eaa4a86a492c3fd97cd84afd3299e2d7af6e08844d5dfd3a95914be92"
  end

  uses_from_macos "curl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
