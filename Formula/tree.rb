class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.0.2.tgz"
  sha256 "7d693a1d88d3c4e70a73e03b8dbbdc12c2945d482647494f2f5bd83a479eeeaf"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tree"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b4500e45e8461b7f09bbad25e3f784484ab8e08e3daf9a6b874e1428d635e7a0"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o list.o hash.o color.o file.o filter.o info.o unix.o xml.o json.o html.o strverscmp.o"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
