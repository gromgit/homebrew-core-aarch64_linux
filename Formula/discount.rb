class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.7.tar.bz2"
  sha256 "b1262be5d7b04f3c4e2cee3a0937369b12786af18f65f599f334eefbc0ee9508"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  # We check the upstream GitHub repository because the homepage doesn't always
  # update to list the latest version in a timely manner. As of writing, the
  # homepage has been showing an older version for months, so it doesn't seem
  # like a reliable source for the latest version information, unfortunately.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/discount"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6270be8279ca491edfd3705549f37fbf0f5d70c5732a74675a3ce67032074f11"
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
    ]
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
