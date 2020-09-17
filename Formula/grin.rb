class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v4.1.0.tar.gz"
  sha256 "f81a6771fbd3d9cde6cc209eab38a3ad7ef5e6c846728d9a18c2f0097c99f3ad"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "009718ef042a332f022fea46acab90e45366c79454ada1fb5bef550474acbed5" => :catalina
    sha256 "2ec3cc88ae8b05dedc298127d0cec0f50d2730d1aac0a9c23f44c6dd9018d1e6" => :mojave
    sha256 "2fe2f4d486044785212f3e3069d37386a83f5b9f673d5cc2cf5f192c310c2ae9" => :high_sierra
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
