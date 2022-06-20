class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"

  # TODO: Upstream deletes old downloads, so we need a mirror
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.25.tar.gz"
  sha256 "52350e8aa740b176e1d773e9dc08f1340218c37e01bec37ab90db0127e4bb5e5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libsvm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f2e8cb07313618801d3d9292f2ad75c91a5a970a9acd8f53ee0897baeb9219b4"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.2" => shared_library("libsvm", 2)
    lib.install_symlink shared_library("libsvm", 2) => shared_library("libsvm")
    MachO::Tools.change_dylib_id("#{lib}/libsvm.2.dylib", "#{lib}/libsvm.2.dylib") if OS.mac?
    include.install "svm.h"
  end

  test do
    (testpath/"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train_regression.txt").write <<~EOS
      0.23 201:1.2 3148:1.8 3983:1 4882:1
      0.33 874:0.3 3652:1.1 3963:1 6179:1
      -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system "#{bin}/svm-train", "-s", "0", "train_classification.txt"
    system "#{bin}/svm-train", "-s", "3", "train_regression.txt"
  end
end
