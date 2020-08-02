class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.40.tar.gz"
  sha256 "7fa2652c65dff5164a2fb27294ad1097b580d0a8093b75c1851bb8c19e6a5bbd"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git"

  bottle do
    cellar :any
    sha256 "a8647325d4a99e221622eb1d9162c15128be0739c94e6df12c89b872ecb0f307" => :catalina
    sha256 "171f9aa9f7e9b18d7cd5c688b0ae8a1ffd457f70dd48294f04f5fd94912295cc" => :mojave
    sha256 "e001224c65e70b520a8e8aae2763a2c2c9d4348244ecd645af156197cf6b022c" => :high_sierra
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b1dbde5b1d7c/liblinear/patch-Makefile.diff"
    sha256 "b7cd43329264ed0568f27e305841aa24817dccc71e5ff3c384eef9ac6aa6620a"
  end

  def install
    system "make", "all"
    bin.install "predict", "train"
    lib.install "liblinear.dylib"
    lib.install_symlink "liblinear.dylib" => "liblinear.1.dylib"
    include.install "linear.h"
  end

  test do
    (testpath/"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    system "#{bin}/train", "train_classification.txt"
  end
end
