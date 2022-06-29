class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.6/pgloader-bundle-3.6.6.tgz"
  sha256 "1837565d8fcedb132c68885a40893ec3c590b7da9ebcef1c0e580b19f353544d"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d7f926192e26b7e8a0e5d269370590d23a1d1c28e2323b6c2001e71088b2b8cd"
    sha256 cellar: :any_skip_relocation, catalina: "89145353b5e7cd483e99f88f9db350f678ee7281ebf06d2e02263d8ffa5a626c"
    sha256 cellar: :any_skip_relocation, mojave:   "d380bc8ea035e70afaaa5c913cf0ee4e4aedce19d7b29a6545297b59e512d0a8"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
