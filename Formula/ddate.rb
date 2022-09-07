class Ddate < Formula
  desc "Converts boring normal dates to fun Discordian Date"
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/v0.2.2.tar.gz"
  sha256 "d53c3f0af845045f39d6d633d295fd4efbe2a792fd0d04d25d44725d11c678ad"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ddate"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fa348260c512ecb075a2dcaf638008a05ee607fa7a9c52e757a6e07d6bd855c4"
  end

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install "ddate"
    man1.install "ddate.1"
  end

  test do
    output = shell_output("#{bin}/ddate 20 6 2014").strip
    assert_equal "Sweetmorn, Confusion 25, 3180 YOLD", output
  end
end
