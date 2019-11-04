class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz"
  sha256 "b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e69fa7fa3b1ff2e85209b6719ad17192942c9d2954321f30b7e039745e4e9ffb" => :mojave
    sha256 "291e7d5f7f5ecace41fc8d9a402f8bb630004700f264339ad013df713f9b33eb" => :high_sierra
    sha256 "fba7bbbc5efe8f09f7a23b93e5d168134703f3ce14bf2a5b8b7473cad0f7826f" => :sierra
  end

  def install
    ENV["DESTDIR"] = prefix

    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    system "make"
    system "make", "test_standalone"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
