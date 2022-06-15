class Dsocks < Formula
  desc "SOCKS client wrapper for *BSD/macOS"
  homepage "https://monkey.org/~dugsong/dsocks/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/dsocks/dsocks-1.8.tar.gz"
  sha256 "2b57fb487633f6d8b002f7fe1755480ae864c5e854e88b619329d9f51c980f1d"
  license "BSD-2-Clause"
  head "https://github.com/dugsong/dsocks.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dsocks"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e131334039ff9229820e3c9d247bf30856bbb8c33d85475529fccc46bc44bf14"
  end

  def install
    system ENV.cc, "-fPIC", "-shared", "-o", shared_library("libdsocks"), "dsocks.c",
                   "atomicio.c", "-lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install shared_library("libdsocks")
    bin.install "dsocks.sh"
  end
end
