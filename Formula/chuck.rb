class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.0.1.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.4.0.1.tgz"
  sha256 "11a20c34b385e132bf43d5ae6a562c652f631828cc6b1562a4c029bc9a850ed4"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "92dca7513ce71a4d1a99a912fd03cd3341c2bc90a4e69deda124d2900bf6c80c" => :big_sur
    sha256 "0cf4564e0cbf9ee5b0bfeafe2dd694aeae5207b551474ad17d926cf71f05863a" => :catalina
    sha256 "674cbb7904d4ec9f09d1949b3bd8b3034835fcd183c0bd768291c1f7fbc12b69" => :mojave
  end

  depends_on xcode: :build

  # Big Sur compile fix https://github.com/ccrma/chuck/pull/158
  patch do
    url "https://github.com/ccrma/chuck/commit/51f8dfa2a6d0cf2fc8f39760cae8a754ccdaaee5.patch?full_index=1"
    sha256 "f3853d6d107fe7ccd235ef5e02eb396f58ce55bb9e7ac7bd4043146af9d08536"
  end

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
