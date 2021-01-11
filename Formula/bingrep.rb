class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.4.tar.gz"
  sha256 "4853c88dd35db334090e3d0846b72627ca13492ad459bedb8835982591159073"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef4cf4c58851cc931c11a0bdb3686c4527b6f1dff1c7a8f3decf0125cef8ae56" => :big_sur
    sha256 "3006a4b60bb139967b5df41ebf5b0c249e555f67d7cbca687f71c44a689c9a39" => :arm64_big_sur
    sha256 "f7f25ab475eb4401fcc7a117236e0fa9d50d210d470dd21678cc45e38cc87abe" => :catalina
    sha256 "32512bb7405dd8006668cef6c5f837c8d65d4877e4a0e7a0ad51120d0cdc070b" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
