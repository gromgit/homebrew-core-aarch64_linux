class Rc < Formula
  desc "Implementation of the AT&T Plan 9 shell"
  homepage "http://doc.cat-v.org/plan_9/4th_edition/papers/rc"
  url "https://web.archive.org/web/20200227085442/static.tobold.org/rc/rc-1.7.4.tar.gz"
  mirror "https://src.fedoraproject.org/repo/extras/rc/rc-1.7.4.tar.gz/f99732d7a8be3f15f81e99c3af46dc95/rc-1.7.4.tar.gz"
  sha256 "5ed26334dd0c1a616248b15ad7c90ca678ae3066fa02c5ddd0e6936f9af9bfd8"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "236e9e03dd35f3bc9c32f8d2c8f0b926ee55cff2646d45c21d92d78061a2334b"
  end

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-edit=edit"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello!", shell_output("#{bin}/rc -c 'echo Hello!'").chomp
  end
end
