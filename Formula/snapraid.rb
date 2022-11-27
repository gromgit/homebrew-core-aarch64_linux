class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.2/snapraid-12.2.tar.gz"
  sha256 "9d30993aef7fd390369dcaf422ac35f3990e8c91f0fb26151f5b84ccb73d3e01"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/snapraid"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8aac3eaf9d4fd7efb2acf09c52403fa98074b49719f61c8ecd11ae22262f5793"
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
