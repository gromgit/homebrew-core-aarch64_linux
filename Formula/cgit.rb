class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https://git.zx2c4.com/cgit/"
  url "https://git.zx2c4.com/cgit/snapshot/cgit-1.2.3.tar.xz"
  sha256 "5a5f12d2f66bd3629c8bc103ec8ec2301b292e97155d30a9a61884ea414a6da4"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "7a87dcf5cb65728d597942a23bca28ae960a54023b08728408adc099460661cb"
    sha256 big_sur:       "50e62177e147660e5a1c94892208381903a96f4b0b2771f05d63025ac83ec8a5"
    sha256 catalina:      "6ddf371689a429df59b81cc75ef3c491c58fa1536aeafb41eef0df89196405c6"
    sha256 mojave:        "0a8124c41a3e891d8ac8a9dc9391a1048deecb3b82a785d604bbf1d59125b010"
    sha256 high_sierra:   "b5dd8fcf3e81b7d320ea39d9de0b7a3b20b6522978e01f2527e14845d80454c4"
    sha256 sierra:        "7b21a1dd7536c3354280089b4521fa64e36c2d177303bf5f9ea7994b77a25f2d"
  end

  depends_on "gettext"
  depends_on "openssl@1.1"

  # git version is mandated by cgit: see GIT_VER variable in Makefile
  # https://git.zx2c4.com/cgit/tree/Makefile?h=v1.2#n17
  resource "git" do
    url "https://www.kernel.org/pub/software/scm/git/git-2.25.1.tar.gz"
    sha256 "4999ae0ee6cc7dfb280d7051e39a82a5630b00c1d8cd54890f07b4b7193d25aa"
  end

  # cgit 1.2.2+ needs memrchr, for which macOS provides no implementation
  # https://lists.zx2c4.com/pipermail/cgit/2020-August/004510.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5decb544ec505d0868ef79f03707fafb0e85e47c/cgit/memrchr-impl.patch"
    sha256 "3ab5044db3001b411b58309d70f00b0dee54df991ebc66da9406711ed4007f0f"
  end

  def install
    resource("git").stage(buildpath/"git")
    system "make", "prefix=#{prefix}",
                   "CGIT_SCRIPT_PATH=#{pkgshare}",
                   "CGIT_DATA_PATH=#{var}/www/htdocs/cgit",
                   "CGIT_CONFIG=#{etc}/cgitrc",
                   "CACHE_ROOT=#{var}/cache/cgit",
                   "install"
  end

  test do
    (testpath/"cgitrc").write <<~EOS
      repo.url=test
      repo.path=#{testpath}
      repo.desc=the master foo repository
      repo.owner=fooman@example.com
    EOS

    ENV["CGIT_CONFIG"] = testpath/"cgitrc"
    # no "Status" line means 200
    refute_match(/Status: .+/, shell_output("#{pkgshare}/cgit.cgi"))
  end
end
